package com.bulletinboard.service;

import com.bulletinboard.model.BulletinBoard;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

/**
 * 公告欄業務邏輯介面
 * 定義所有業務操作方法
 */
public interface BulletinBoardService {

    /**
     * 建立新公告
     * 
     * @param bulletin       公告物件
     * @param attachmentFile 附件檔案（可為空）
     * @return 建立後的公告物件
     * @throws Exception 建立失敗時拋出例外
     */
    BulletinBoard createBulletin(BulletinBoard bulletin, MultipartFile attachmentFile) throws Exception;

    /**
     * 根據ID查詢公告
     * 
     * @param id 公告ID
     * @return 公告物件，若不存在則返回null
     */
    BulletinBoard getBulletinById(Integer id);

    /**
     * 查詢所有公告
     * 
     * @return 公告清單（按發布日期降序排列）
     */
    List<BulletinBoard> getAllBulletins();

    /**
     * 分頁查詢公告
     * 
     * @param page 頁碼（從0開始）
     * @param size 每頁筆數
     * @return 公告清單
     */
    List<BulletinBoard> getBulletins(int page, int size);

    /**
     * 計算總頁數
     * 
     * @param size 每頁筆數
     * @return 總頁數
     */
    int getTotalPages(int size);

    /**
     * 查詢公告總數
     * 
     * @return 總筆數
     */
    long getTotalBulletins();

    /**
     * 根據標題搜尋公告
     * 
     * @param title 標題關鍵字
     * @return 符合條件的公告清單
     */
    List<BulletinBoard> searchBulletinsByTitle(String title);

    /**
     * 查詢有效公告（未過期）
     * 
     * @return 有效公告清單
     */
    List<BulletinBoard> getValidBulletins();

    /**
     * 更新公告
     * 
     * @param bulletin       要更新的公告物件
     * @param attachmentFile 新的附件檔案（可為空）
     * @return 更新後的公告物件
     * @throws Exception 更新失敗時拋出例外
     */
    BulletinBoard updateBulletin(BulletinBoard bulletin, MultipartFile attachmentFile) throws Exception;

    /**
     * 刪除公告
     * 
     * @param id 公告ID
     * @return 是否刪除成功
     */
    boolean deleteBulletin(Integer id);

    /**
     * 驗證公告資料
     * 
     * @param bulletin 公告物件
     * @return 驗證錯誤訊息清單，若無錯誤則返回空清單
     */
    List<String> validateBulletin(BulletinBoard bulletin);

}