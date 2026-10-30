package com.studymate.model.enums;

public enum NotificationType {
    INFO("bi-info-circle", "text-info"),
    SUCCESS("bi-check-circle", "text-success"),
    WARNING("bi-exclamation-triangle", "text-warning"),
    ALERT("bi-exclamation-octagon", "text-danger"),
    RESOURCE("bi-file-earmark-plus", "text-primary"),
    ANNOUNCEMENT("bi-megaphone", "text-indigo");

    private final String icon;
    private final String colorClass;

    NotificationType(String icon, String colorClass) {
        this.icon = icon;
        this.colorClass = colorClass;
    }

    public String getIcon() {
        return icon;
    }

    public String getColorClass() {
        return colorClass;
    }
}

