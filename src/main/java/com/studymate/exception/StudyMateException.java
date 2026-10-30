package com.studymate.exception;

public class StudyMateException extends RuntimeException {
    public StudyMateException(String message) {
        super(message);
    }

    public StudyMateException(String message, Throwable cause) {
        super(message, cause);
    }
}

