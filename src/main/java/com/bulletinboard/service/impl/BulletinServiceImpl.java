package com.bulletinboard.service.impl;

import com.bulletinboard.dao.BulletinDAO;
import com.bulletinboard.model.Bulletin;
import com.bulletinboard.service.BulletinService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

@Service
// @Transactional
public class BulletinServiceImpl implements BulletinService {

    @Autowired
    @Qualifier("simpleBulletinDAO")
    private BulletinDAO bulletinDAO;

    // 附件上傳目錄
    private static final String UPLOAD_DIR = System.getProperty("user.home") + "/bulletin-uploads/";

    @Override
    public Bulletin createBulletin(Bulletin bulletin, MultipartFile attachmentFile) throws Exception {
        // 處理附件上傳
        if (attachmentFile != null && !attachmentFile.isEmpty()) {
            saveAttachment(bulletin, attachmentFile);
        }

        return bulletinDAO.save(bulletin);
    }

    @Override
    @Transactional(readOnly = true)
    public Bulletin getBulletinById(Long id) {
        return bulletinDAO.findById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Bulletin> getAllBulletins() {
        return bulletinDAO.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Bulletin> getBulletinsByPage(int pageNumber, int pageSize) {
        return bulletinDAO.findByPage(pageNumber, pageSize);
    }

    @Override
    @Transactional(readOnly = true)
    public int getTotalPages(int pageSize) {
        long totalCount = bulletinDAO.getTotalCount();
        return (int) Math.ceil((double) totalCount / pageSize);
    }

    @Override
    @Transactional(readOnly = true)
    public long getTotalCount() {
        return bulletinDAO.getTotalCount();
    }

    @Override
    public Bulletin updateBulletin(Bulletin bulletin, MultipartFile attachmentFile) throws Exception {
        // 處理附件上傳
        if (attachmentFile != null && !attachmentFile.isEmpty()) {
            // 刪除舊附件
            Bulletin existingBulletin = bulletinDAO.findById(bulletin.getId());
            if (existingBulletin != null && existingBulletin.getAttachmentPath() != null) {
                deleteAttachmentFile(existingBulletin.getAttachmentPath());
            }

            // 保存新附件
            saveAttachment(bulletin, attachmentFile);
        }

        return bulletinDAO.update(bulletin);
    }

    @Override
    public void deleteBulletin(Long id) {
        // 刪除附件文件
        Bulletin bulletin = bulletinDAO.findById(id);
        if (bulletin != null && bulletin.getAttachmentPath() != null) {
            deleteAttachmentFile(bulletin.getAttachmentPath());
        }

        bulletinDAO.delete(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Bulletin> searchBulletinsByTitle(String title) {
        return bulletinDAO.findByTitleContaining(title);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Bulletin> getValidBulletins() {
        return bulletinDAO.findValidBulletins();
    }

    /**
     * 保存附件文件
     */
    private void saveAttachment(Bulletin bulletin, MultipartFile file) throws IOException {
        // 創建上傳目錄
        File uploadDir = new File(UPLOAD_DIR);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // 生成唯一文件名
        String originalFilename = file.getOriginalFilename();
        String fileExtension = "";
        if (originalFilename != null && originalFilename.contains(".")) {
            fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }

        String uniqueFilename = UUID.randomUUID().toString() + fileExtension;
        String filePath = UPLOAD_DIR + uniqueFilename;

        // 保存文件
        Path path = Paths.get(filePath);
        Files.copy(file.getInputStream(), path);

        // 設置附件信息
        bulletin.setAttachmentFilename(originalFilename);
        bulletin.setAttachmentPath(filePath);
    }

    /**
     * 刪除附件文件
     */
    private void deleteAttachmentFile(String filePath) {
        try {
            File file = new File(filePath);
            if (file.exists()) {
                file.delete();
            }
        } catch (Exception e) {
            // 記錄日誌但不拋出異常
            System.err.println("Failed to delete attachment file: " + filePath + ", error: " + e.getMessage());
        }
    }
}