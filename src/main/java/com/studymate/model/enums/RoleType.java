package com.studymate.model.enums;

public enum RoleType {
    ROLE_STUDENT("Student", "Enrolled Student with course and resource access"),
    ROLE_ADMIN("Administrator", "Academic Administrator managing subjects, resources and students"),
    ROLE_SUPER_ADMIN("Super Administrator", "System Administrator with global privileges and governance");

    private final String displayName;
    private final String description;

    RoleType(String displayName, String description) {
        this.displayName = displayName;
        this.description = description;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getDescription() {
        return description;
    }
}

