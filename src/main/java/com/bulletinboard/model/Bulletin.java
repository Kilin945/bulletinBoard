package com.bulletinboard.model;

import javax.persistence.*;
// import javax.validation.constraints.NotBlank;
// import javax.validation.constraints.NotNull;
// import javax.validation.constraints.Size;
import java.time.LocalDate;

@Entity
@Table(name = "bulletin_board")
public class Bulletin {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // @NotBlank(message = "標題不能為空")
    // @Size(max = 200, message = "標題長度不能超過200字")
    @Column(name = "title", nullable = false, length = 200)
    private String title;

    // @NotBlank(message = "公布者不能為空")
    // @Size(max = 100, message = "公布者名稱不能超過100字")
    @Column(name = "publisher", nullable = false, length = 100)
    private String publisher;

    // @NotNull(message = "發佈日期不能為空")
    @Column(name = "publish_date", nullable = false)
    private LocalDate publishDate;

    // @NotNull(message = "截止日期不能為空")
    @Column(name = "end_date", nullable = false)
    private LocalDate endDate;

    // @NotBlank(message = "公布內容不能為空")
    @Column(name = "content", nullable = false, columnDefinition = "TEXT")
    private String content;

    @Column(name = "attachment_path", length = 500)
    private String attachmentPath;

    @Column(name = "attachment_filename", length = 255)
    private String attachmentFilename;

    // Constructors
    public Bulletin() {
    }

    public Bulletin(String title, String publisher, LocalDate publishDate, LocalDate endDate, String content) {
        this();
        this.title = title;
        this.publisher = publisher;
        this.publishDate = publishDate;
        this.endDate = endDate;
        this.content = content;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
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

    public String getAttachmentFilename() {
        return attachmentFilename;
    }

    public void setAttachmentFilename(String attachmentFilename) {
        this.attachmentFilename = attachmentFilename;
    }


    // Helper methods
    public boolean isExpired() {
        return endDate.isBefore(LocalDate.now());
    }

    public boolean hasAttachment() {
        return attachmentFilename != null && !attachmentFilename.trim().isEmpty();
    }

    @Override
    public String toString() {
        return "Bulletin{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", publisher='" + publisher + '\'' +
                ", publishDate=" + publishDate +
                ", endDate=" + endDate +
                '}';
    }
}