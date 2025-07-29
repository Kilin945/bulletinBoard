package com.bulletinboard.service.impl;

import com.bulletinboard.dao.BulletinBoardDAO;
import com.bulletinboard.model.BulletinBoard;
import com.bulletinboard.service.BulletinBoardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * 公告欄業務邏輯實作類別
 * 包含事務管理和業務驗證
 */
@Service
@Transactional
public class BulletinBoardServiceImpl implements BulletinBoardService {

    @Autowired
    private BulletinBoardDAO bulletinBoardDAO;

    // 檔案上傳目錄
    private static final String UPLOAD_DIR = "uploads/";

    @Override
    public BulletinBoard createBulletin(BulletinBoard bulletin, MultipartFile attachmentFile) throws Exception {
        // 驗證公告資料
        List<String> errors = validateBulletin(bulletin);
        if (!errors.isEmpty()) {
            throw new Exception("公告資料驗證失敗: " + String.join(", ", errors));
        }

        // 處理附件上傳
        if (attachmentFile != null && !attachmentFile.isEmpty()) {
            String attachmentPath = saveAttachment(attachmentFile);
            bulletin.setAttachmentPath(attachmentPath);
        }

        // 儲存公告
        return bulletinBoardDAO.save(bulletin);
    }

    @Override
    @Transactional(readOnly = true)
    public BulletinBoard getBulletinById(Integer id) {
        if (id == null || id <= 0) {
            return null;
        }
        return bulletinBoardDAO.findById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<BulletinBoard> getAllBulletins() {
        return bulletinBoardDAO.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public List<BulletinBoard> getBulletins(int page, int size) {
        if (page < 0 || size <= 0) {
            return new ArrayList<>();
        }
        return bulletinBoardDAO.findAll(page, size);
    }

    @Override
    @Transactional(readOnly = true)
    public int getTotalPages(int size) {
        if (size <= 0) {
            return 0;
        }
        long totalBulletins = bulletinBoardDAO.count();
        return (int) Math.ceil((double) totalBulletins / size);
    }

    @Override
    @Transactional(readOnly = true)
    public long getTotalBulletins() {
        return bulletinBoardDAO.count();
    }

    @Override
    @Transactional(readOnly = true)
    public List<BulletinBoard> searchBulletinsByTitle(String title) {
        if (title == null || title.trim().isEmpty()) {
            return getAllBulletins();
        }
        return bulletinBoardDAO.findByTitleContaining(title.trim());
    }

    @Override
    @Transactional(readOnly = true)
    public List<BulletinBoard> getValidBulletins() {
        return bulletinBoardDAO.findValidBulletins();
    }

    @Override
    public BulletinBoard updateBulletin(BulletinBoard bulletin, MultipartFile attachmentFile) throws Exception {
        // 驗證公告資料
        List<String> errors = validateBulletin(bulletin);
        if (!errors.isEmpty()) {
            throw new Exception("公告資料驗證失敗: " + String.join(", ", errors));
        }

        // 檢查公告是否存在
        BulletinBoard existingBulletin = bulletinBoardDAO.findById(bulletin.getId());
        if (existingBulletin == null) {
            throw new Exception("公告不存在，無法更新");
        }

        // 處理新附件上傳
        if (attachmentFile != null && !attachmentFile.isEmpty()) {
            // 刪除舊附件
            if (existingBulletin.getAttachmentPath() != null) {
                deleteAttachment(existingBulletin.getAttachmentPath());
            }

            // 儲存新附件
            String newAttachmentPath = saveAttachment(attachmentFile);
            bulletin.setAttachmentPath(newAttachmentPath);
        } else {
            // 保留原有附件
            bulletin.setAttachmentPath(existingBulletin.getAttachmentPath());
        }

        // 更新公告
        return bulletinBoardDAO.update(bulletin);
    }

    @Override
    public boolean deleteBulletin(Integer id) {
        try {
            // 先查詢公告以取得附件路徑
            BulletinBoard bulletin = bulletinBoardDAO.findById(id);
            if (bulletin == null) {
                return false;
            }

            // 刪除附件檔案
            if (bulletin.getAttachmentPath() != null) {
                deleteAttachment(bulletin.getAttachmentPath());
            }

            // 刪除公告記錄
            return bulletinBoardDAO.deleteById(id);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<String> validateBulletin(BulletinBoard bulletin) {
        List<String> errors = new ArrayList<>();

        if (bulletin == null) {
            errors.add("公告物件不能為空");
            return errors;
        }

        // 驗證標題
        if (bulletin.getTitle() == null || bulletin.getTitle().trim().isEmpty()) {
            errors.add("標題不能為空");
        } else if (bulletin.getTitle().length() > 200) {
            errors.add("標題長度不能超過200字元");
        }

        // 驗證公佈者
        if (bulletin.getPublisher() == null || bulletin.getPublisher().trim().isEmpty()) {
            errors.add("公佈者不能為空");
        } else if (bulletin.getPublisher().length() > 100) {
            errors.add("公佈者長度不能超過100字元");
        }

        // 驗證發佈日期
        if (bulletin.getPublishDate() == null) {
            errors.add("發佈日期不能為空");
        }

        // 驗證截止日期
        if (bulletin.getEndDate() == null) {
            errors.add("截止日期不能為空");
        }

        // 驗證日期邏輯
        if (bulletin.getPublishDate() != null && bulletin.getEndDate() != null) {
            if (bulletin.getEndDate().isBefore(bulletin.getPublishDate())) {
                errors.add("截止日期不能早於發佈日期");
            }
        }

        return errors;
    }


    /**
     * 儲存附件檔案
     * 
     * @param file 上傳的檔案
     * @return 儲存後的檔案路徑
     * @throws IOException 檔案儲存失敗
     */
    private String saveAttachment(MultipartFile file) throws IOException {
        // 建立上傳目錄
        File uploadDir = new File(UPLOAD_DIR);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // 產生唯一檔案名稱
        String originalFilename = file.getOriginalFilename();
        String fileExtension = "";
        if (originalFilename != null && originalFilename.contains(".")) {
            fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }
        String uniqueFilename = UUID.randomUUID().toString() + fileExtension;

        // 儲存檔案
        Path filePath = Paths.get(UPLOAD_DIR + uniqueFilename);
        Files.write(filePath, file.getBytes());

        return uniqueFilename;
    }

    /**
     * 刪除附件檔案
     * 
     * @param filename 檔案名稱
     */
    private void deleteAttachment(String filename) {
        try {
            if (filename != null && !filename.isEmpty()) {
                Path filePath = Paths.get(UPLOAD_DIR + filename);
                Files.deleteIfExists(filePath);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}