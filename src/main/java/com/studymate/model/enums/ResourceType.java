package com.studymate.model.enums;

public enum ResourceType {
    PDF("PDF Document", "application/pdf", "bi-file-earmark-pdf"),
    IMAGE("Image", "image/png,image/jpeg,image/webp", "bi-file-earmark-image"),
    DOCUMENT("Word Document", "application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document", "bi-file-earmark-word"),
    PRESENTATION("Presentation", "application/vnd.ms-powerpoint,application/vnd.openxmlformats-officedocument.presentationml.presentation", "bi-file-earmark-slides"),
    TEXT("Plain Text / Code", "text/plain", "bi-file-earmark-text"),
    EXTERNAL_URL("External Link", "text/html", "bi-link-45deg");

    private final String label;
    private final String defaultMime;
    private final String iconClass;

    ResourceType(String label, String defaultMime, String iconClass) {
        this.label = label;
        this.defaultMime = defaultMime;
        this.iconClass = iconClass;
    }

    public String getLabel() {
        return label;
    }

    public String getDefaultMime() {
        return defaultMime;
    }

    public String getIconClass() {
        return iconClass;
    }
}

