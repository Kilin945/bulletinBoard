package com.bulletinboard.dao;

import com.bulletinboard.model.BulletinBoard;
import java.util.List;

/**
 * 公告欄資料存取介面
 * 定義所有資料庫操作方法
 */
public interface BulletinBoardDAO {

    /**
     * 儲存公告
     * 
     * @param bulletin 公告物件
     * @return 儲存後的公告物件（包含生成的ID）
     */
    BulletinBoard save(BulletinBoard bulletin);

    /**
     * 根據ID查詢公告
     * 
     * @param id 公告ID
     * @return 公告物件，若不存在則返回null
     */
    BulletinBoard findById(Integer id);

    /**
     * 查詢所有公告
     * 
     * @return 公告清單
     */
    List<BulletinBoard> findAll();

    /**
     * 分頁查詢公告
     * 
     * @param page 頁碼（從0開始）
     * @param size 每頁筆數
     * @return 公告清單
     */
    List<BulletinBoard> findAll(int page, int size);

    /**
     * 查詢公告總數
     * 
     * @return 總筆數
     */
    long count();

    /**
     * 根據標題模糊查詢
     * 
     * @param title 標題關鍵字
     * @return 符合條件的公告清單
     */
    List<BulletinBoard> findByTitleContaining(String title);

    /**
     * 查詢有效的公告（未過期）
     * 
     * @return 有效公告清單
     */
    List<BulletinBoard> findValidBulletins();

    /**
     * 更新公告
     * 
     * @param bulletin 要更新的公告物件
     * @return 更新後的公告物件
     */
    BulletinBoard update(BulletinBoard bulletin);

    /**
     * 根據ID刪除公告
     * 
     * @param id 公告ID
     * @return 是否刪除成功
     */
    boolean deleteById(Integer id);

    /**
     * 刪除公告
     * 
     * @param bulletin 要刪除的公告物件
     * @return 是否刪除成功
     */
    boolean delete(BulletinBoard bulletin);
}