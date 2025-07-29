
package com.bulletinboard.service;

import com.bulletinboard.model.Bulletin;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface BulletinService {

    /**
     * 創建新公告
     */
    Bulletin createBulletin(Bulletin bulletin, MultipartFile attachmentFile) throws Exception;

    /**
     * 根據ID獲取公告
     */
    Bulletin getBulletinById(Long id);

    /**
     * 獲取所有公告
     */
    List<Bulletin> getAllBulletins();

    /**
     * 分頁獲取公告
     */
    List<Bulletin> getBulletinsByPage(int pageNumber, int pageSize);

    /**
     * 獲取總頁數
     */
    int getTotalPages(int pageSize);

    /**
     * 獲取總記錄數
     */
    long getTotalCount();

    /**
     * 更新公告
     */
    Bulletin updateBulletin(Bulletin bulletin, MultipartFile attachmentFile) throws Exception;

    /**
     * 刪除公告
     */
    void deleteBulletin(Long id);

    /**
     * 根據標題搜索公告
     */
    List<Bulletin> searchBulletinsByTitle(String title);

    /**
     * 獲取有效公告
     */
    List<Bulletin> getValidBulletins();
}