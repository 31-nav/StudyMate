package com.studymate.dto.response;

import com.studymate.model.entity.User;

import java.time.LocalDateTime;
import java.util.Set;
import java.util.stream.Collectors;

public class UserDto {

    private Long id;
    private String email;
    private String fullName;
    private String rollNumber;
    private String courseName;
    private Long courseId;
    private Integer semesterNumber;
    private Long semesterId;
    private boolean active;
    private boolean verified;
    private String avatarUrl;
    private Set<String> roles;
    private LocalDateTime createdAt;
    private LocalDateTime lastLoginAt;

    public UserDto() {}

    public static UserDto fromEntity(User user) {
        if (user == null) return null;
        UserDto dto = new UserDto();
        dto.id = user.getId();
        dto.email = user.getEmail();
        dto.fullName = user.getFullName();
        dto.rollNumber = user.getRollNumber();
        if (user.getCourse() != null) {
            dto.courseName = user.getCourse().getName();
            dto.courseId = user.getCourse().getId();
        }
        if (user.getSemester() != null) {
            dto.semesterNumber = user.getSemester().getSemesterNumber();
            dto.semesterId = user.getSemester().getId();
        }
        dto.active = user.isActive();
        dto.verified = user.isVerified();
        dto.avatarUrl = user.getAvatarUrl();
        if (user.getRoles() != null) {
            dto.roles = user.getRoles().stream().map(r -> r.getName()).collect(Collectors.toSet());
        }
        dto.createdAt = user.getCreatedAt();
        dto.lastLoginAt = user.getLastLoginAt();
        return dto;
    }

    public boolean isStudent() {
        return roles != null && roles.contains("ROLE_STUDENT");
    }

    public boolean isAdmin() {
        return roles != null && (roles.contains("ROLE_ADMIN") || roles.contains("ROLE_SUPER_ADMIN"));
    }

    public boolean isSuperAdmin() {
        return roles != null && roles.contains("ROLE_SUPER_ADMIN");
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getRollNumber() { return rollNumber; }
    public void setRollNumber(String rollNumber) { this.rollNumber = rollNumber; }
    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }
    public Long getCourseId() { return courseId; }
    public void setCourseId(Long courseId) { this.courseId = courseId; }
    public Integer getSemesterNumber() { return semesterNumber; }
    public void setSemesterNumber(Integer semesterNumber) { this.semesterNumber = semesterNumber; }
    public Long getSemesterId() { return semesterId; }
    public void setSemesterId(Long semesterId) { this.semesterId = semesterId; }
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
    public boolean isVerified() { return verified; }
    public void setVerified(boolean verified) { this.verified = verified; }
    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }
    public Set<String> getRoles() { return roles; }
    public void setRoles(Set<String> roles) { this.roles = roles; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getLastLoginAt() { return lastLoginAt; }
    public void setLastLoginAt(LocalDateTime lastLoginAt) { this.lastLoginAt = lastLoginAt; }
}

