package com.studymate.dto.request;

public class RegisterRequest {
    private String fullName;
    private String email;
    private String rollNumber;
    private String password;
    private String confirmPassword;
    private Long courseId;
    private Long semesterId;
    private boolean agreeTerms;

    public RegisterRequest() {}

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getRollNumber() { return rollNumber; }
    public void setRollNumber(String rollNumber) { this.rollNumber = rollNumber; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getConfirmPassword() { return confirmPassword; }
    public void setConfirmPassword(String confirmPassword) { this.confirmPassword = confirmPassword; }
    public Long getCourseId() { return courseId; }
    public void setCourseId(Long courseId) { this.courseId = courseId; }
    public Long getSemesterId() { return semesterId; }
    public void setSemesterId(Long semesterId) { this.semesterId = semesterId; }
    public boolean isAgreeTerms() { return agreeTerms; }
    public void setAgreeTerms(boolean agreeTerms) { this.agreeTerms = agreeTerms; }
}

