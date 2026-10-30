package com.studymate.model.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "download_logs")
public class DownloadLog implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "resource_id", nullable = false)
    private Resource resource;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "file_id")
    private ResourceFile file;

    @Column(name = "ip_address", length = 45)
    private String ipAddress;

    @Column(name = "user_agent", length = 500)
    private String userAgent;

    @Column(name = "downloaded_at", nullable = false, updatable = false)
    private LocalDateTime downloadedAt = LocalDateTime.now();

    public DownloadLog() {}

    public DownloadLog(User user, Resource resource, ResourceFile file, String ipAddress, String userAgent) {
        this.user = user;
        this.resource = resource;
        this.file = file;
        this.ipAddress = ipAddress;
        this.userAgent = userAgent;
        this.downloadedAt = LocalDateTime.now();
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Resource getResource() {
        return resource;
    }

    public void setResource(Resource resource) {
        this.resource = resource;
    }

    public ResourceFile getFile() {
        return file;
    }

    public void setFile(ResourceFile file) {
        this.file = file;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getUserAgent() {
        return userAgent;
    }

    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }

    public LocalDateTime getDownloadedAt() {
        return downloadedAt;
    }

    public void setDownloadedAt(LocalDateTime downloadedAt) {
        this.downloadedAt = downloadedAt;
    }
}

