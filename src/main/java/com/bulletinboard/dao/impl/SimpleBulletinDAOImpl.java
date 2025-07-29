package com.bulletinboard.dao.impl;

import com.bulletinboard.dao.BulletinDAO;
import com.bulletinboard.model.Bulletin;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Repository("simpleBulletinDAO")
public class SimpleBulletinDAOImpl implements BulletinDAO {
    
    @Autowired
    private SessionFactory sessionFactory;
    
    @Override
    public Bulletin save(Bulletin bulletin) {
        Session session = sessionFactory.openSession();
        try {
            session.beginTransaction();
            session.saveOrUpdate(bulletin);
            session.getTransaction().commit();
            return bulletin;
        } catch (Exception e) {
            if (session.getTransaction() != null) {
                session.getTransaction().rollback();
            }
            throw e;
        } finally {
            session.close();
        }
    }
    
    @Override
    public Bulletin findById(Long id) {
        Session session = sessionFactory.openSession();
        try {
            return session.get(Bulletin.class, id);
        } finally {
            session.close();
        }
    }
    
    @Override
    public List<Bulletin> findAll() {
        Session session = sessionFactory.openSession();
        try {
            String hql = "FROM Bulletin b ORDER BY b.id DESC";
            Query<Bulletin> query = session.createQuery(hql, Bulletin.class);
            return query.list();
        } catch (Exception e) {
            return new ArrayList<>();
        } finally {
            session.close();
        }
    }
    
    @Override
    public List<Bulletin> findByPage(int pageNumber, int pageSize) {
        Session session = sessionFactory.openSession();
        try {
            String hql = "FROM Bulletin b ORDER BY b.id DESC";
            Query<Bulletin> query = session.createQuery(hql, Bulletin.class);
            query.setFirstResult((pageNumber - 1) * pageSize);
            query.setMaxResults(pageSize);
            return query.list();
        } catch (Exception e) {
            return new ArrayList<>();
        } finally {
            session.close();
        }
    }
    
    @Override
    public long getTotalCount() {
        Session session = sessionFactory.openSession();
        try {
            String hql = "SELECT COUNT(b) FROM Bulletin b";
            Query<Long> query = session.createQuery(hql, Long.class);
            return query.uniqueResult();
        } catch (Exception e) {
            return 0;
        } finally {
            session.close();
        }
    }
    
    @Override
    public List<Bulletin> findByTitleContaining(String title) {
        Session session = sessionFactory.openSession();
        try {
            String hql = "FROM Bulletin b WHERE b.title LIKE :title ORDER BY b.id DESC";
            Query<Bulletin> query = session.createQuery(hql, Bulletin.class);
            query.setParameter("title", "%" + title + "%");
            return query.list();
        } catch (Exception e) {
            return new ArrayList<>();
        } finally {
            session.close();
        }
    }
    
    @Override
    public List<Bulletin> findValidBulletins() {
        return findAll(); // 簡化版本，返回所有公告
    }
    
    @Override
    public Bulletin update(Bulletin bulletin) {
        return save(bulletin); // save 方法已經包含 saveOrUpdate
    }
    
    @Override
    public void delete(Long id) {
        Session session = sessionFactory.openSession();
        try {
            session.beginTransaction();
            Bulletin bulletin = session.get(Bulletin.class, id);
            if (bulletin != null) {
                session.delete(bulletin);
            }
            session.getTransaction().commit();
        } catch (Exception e) {
            if (session.getTransaction() != null) {
                session.getTransaction().rollback();
            }
            throw e;
        } finally {
            session.close();
        }
    }
}