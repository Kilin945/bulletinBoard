package com.bulletinboard.dao.impl;

import com.bulletinboard.dao.BulletinBoardDAO;
import com.bulletinboard.model.BulletinBoard;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

/**
 * 公告欄資料存取實作類別
 * 使用 Hibernate 進行資料庫操作
 */
@Repository
public class BulletinBoardDAOImpl implements BulletinBoardDAO {

    @Autowired
    private SessionFactory sessionFactory;

    /**
     * 取得當前 Hibernate Session
     */
    private Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public BulletinBoard save(BulletinBoard bulletin) {
        Session session = getCurrentSession();
        session.save(bulletin);
        return bulletin;
    }

    @Override
    public BulletinBoard findById(Integer id) {
        Session session = getCurrentSession();
        return session.get(BulletinBoard.class, id);
    }

    @Override
    public List<BulletinBoard> findAll() {
        Session session = getCurrentSession();
        Query<BulletinBoard> query = session.createQuery(
                "FROM BulletinBoard ORDER BY publishDate DESC", BulletinBoard.class);
        return query.getResultList();
    }

    @Override
    public List<BulletinBoard> findAll(int page, int size) {
        Session session = getCurrentSession();
        Query<BulletinBoard> query = session.createQuery(
                "FROM BulletinBoard ORDER BY publishDate DESC", BulletinBoard.class);

        // 設定分頁參數
        query.setFirstResult(page * size); // 起始位置
        query.setMaxResults(size); // 每頁筆數

        return query.getResultList();
    }

    @Override
    public long count() {
        Session session = getCurrentSession();
        Query<Long> query = session.createQuery(
                "SELECT COUNT(b) FROM BulletinBoard b", Long.class);
        return query.getSingleResult();
    }

    @Override
    public List<BulletinBoard> findByTitleContaining(String title) {
        Session session = getCurrentSession();
        Query<BulletinBoard> query = session.createQuery(
                "FROM BulletinBoard WHERE title LIKE :title ORDER BY publishDate DESC",
                BulletinBoard.class);
        query.setParameter("title", "%" + title + "%");
        return query.getResultList();
    }

    @Override
    public List<BulletinBoard> findValidBulletins() {
        Session session = getCurrentSession();
        Query<BulletinBoard> query = session.createQuery(
                "FROM BulletinBoard WHERE endDate >= :currentDate ORDER BY publishDate DESC",
                BulletinBoard.class);
        query.setParameter("currentDate", LocalDate.now());
        return query.getResultList();
    }

    @Override
    public BulletinBoard update(BulletinBoard bulletin) {
        Session session = getCurrentSession();
        session.update(bulletin);
        return bulletin;
    }

    @Override
    public boolean deleteById(Integer id) {
        try {
            Session session = getCurrentSession();
            BulletinBoard bulletin = session.get(BulletinBoard.class, id);
            if (bulletin != null) {
                session.delete(bulletin);
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean delete(BulletinBoard bulletin) {
        try {
            Session session = getCurrentSession();
            session.delete(bulletin);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}