package com.bulletinboard.model;

import javax.persistence.*;
import java.time.LocalDate;

/**
 * 公告欄實體類別
 * 對應資料庫的 bulletin_board 表格
 */
@Entity
@Table(name = "bulletin_board")
public class BulletinBoard {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "title", nullable = false, length = 200)
    private String title;

    @Column(name = "publisher", nullable = false, length = 100)
    private String publisher;

    @Column(name = "publish_date", nullable = false)
    private LocalDate publishDate;

    @Column(name = "end_date", nullable = false)
    private LocalDate endDate;

    @Column(name = "content", columnDefinition = "TEXT")
    private String content;

    @Column(name = "attachment_path", length = 500)
    private String attachmentPath;

    // 預設建構子（Hibernate 需要）
    public BulletinBoard() {
    }

    // 建構子
    public BulletinBoard(String title, String publisher, LocalDate publishDate,
            LocalDate endDate, String content, String attachmentPath) {
        this.title = title;
        this.publisher = publisher;
        this.publishDate = publishDate;
        this.endDate = endDate;
        this.content = content;
        this.attachmentPath = attachmentPath;
    }

    // Getter 和 Setter 方法
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }

    public LocalDate getPublishDate() {
        return publishDate;
    }

    public void setPublishDate(LocalDate publishDate) {
        this.publishDate = publishDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getAttachmentPath() {
        return attachmentPath;
    }

    public void setAttachmentPath(String attachmentPath) {
        this.attachmentPath = attachmentPath;
    }

    @Override
    public String toString() {
        return "BulletinBoard{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", publisher='" + publisher + '\'' +
                ", publishDate=" + publishDate +
                ", endDate=" + endDate +
                ", content='" + content + '\'' +
                ", attachmentPath='" + attachmentPath + '\'' +
                '}';
    }
}