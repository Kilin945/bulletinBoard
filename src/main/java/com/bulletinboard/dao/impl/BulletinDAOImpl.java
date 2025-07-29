package com.bulletinboard.dao.impl;

import com.bulletinboard.dao.BulletinDAO;
import com.bulletinboard.model.Bulletin;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public class BulletinDAOImpl implements BulletinDAO {
    
    @Autowired
    private SessionFactory sessionFactory;
    
    private Session getCurrentSession() {
        try {
            return sessionFactory.getCurrentSession();
        } catch (Exception e) {
            return sessionFactory.openSession();
        }
    }
    
    @Override
    public Bulletin save(Bulletin bulletin) {
        Session session = sessionFactory.openSession();
        try {
            session.beginTransaction();
            session.save(bulletin);
            session.getTransaction().commit();
            return bulletin;
        } catch (Exception e) {
            session.getTransaction().rollback();
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
            String hql = "FROM Bulletin b ORDER BY b.publishDate DESC, b.createdAt DESC";
            Query<Bulletin> query = session.createQuery(hql, Bulletin.class);
            return query.list();
        } finally {
            session.close();
        }
    }
    
    @Override
    public List<Bulletin> findByPage(int pageNumber, int pageSize) {
        Session session = sessionFactory.openSession();
        try {
            String hql = "FROM Bulletin b ORDER BY b.publishDate DESC, b.createdAt DESC";
            Query<Bulletin> query = session.createQuery(hql, Bulletin.class);
            query.setFirstResult((pageNumber - 1) * pageSize);
            query.setMaxResults(pageSize);
            return query.list();
        } finally {
            session.close();
        }
    }
    
    @Override
    public long getTotalCount() {
        String hql = "SELECT COUNT(b) FROM Bulletin b";
        Query<Long> query = getCurrentSession().createQuery(hql, Long.class);
        return query.uniqueResult();
    }
    
    @Override
    public Bulletin update(Bulletin bulletin) {
        getCurrentSession().update(bulletin);
        return bulletin;
    }
    
    @Override
    public void delete(Long id) {
        Bulletin bulletin = findById(id);
        if (bulletin != null) {
            getCurrentSession().delete(bulletin);
        }
    }
    
    @Override
    public List<Bulletin> findByTitleContaining(String title) {
        String hql = "FROM Bulletin b WHERE b.title LIKE :title ORDER BY b.publishDate DESC";
        Query<Bulletin> query = getCurrentSession().createQuery(hql, Bulletin.class);
        query.setParameter("title", "%" + title + "%");
        return query.list();
    }
    
    @Override
    public List<Bulletin> findValidBulletins() {
        String hql = "FROM Bulletin b WHERE b.endDate >= :currentDate ORDER BY b.publishDate DESC";
        Query<Bulletin> query = getCurrentSession().createQuery(hql, Bulletin.class);
        query.setParameter("currentDate", LocalDate.now());
        return query.list();
    }
}