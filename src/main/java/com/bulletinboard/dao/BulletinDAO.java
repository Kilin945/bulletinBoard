package com.bulletinboard.dao;

import com.bulletinboard.model.Bulletin;
import java.util.List;

public interface BulletinDAO {
    
    /**
     * 保存公告
     */
    Bulletin save(Bulletin bulletin);
    
    /**
     * 根據ID查找公告
     */
    Bulletin findById(Long id);
    
    /**
     * 查找所有公告（按發佈日期倒序）
     */
    List<Bulletin> findAll();
    
    /**
     * 分頁查詢公告
     */
    List<Bulletin> findByPage(int pageNumber, int pageSize);
    
    /**
     * 獲取總記錄數
     */
    long getTotalCount();
    
    /**
     * 更新公告
     */
    Bulletin update(Bulletin bulletin);
    
    /**
     * 刪除公告
     */
    void delete(Long id);
    
    /**
     * 根據標題搜索公告
     */
    List<Bulletin> findByTitleContaining(String title);
    
    /**
     * 查找有效公告（未過期）
     */
    List<Bulletin> findValidBulletins();
}