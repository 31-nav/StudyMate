package com.studymate.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Validates and initializes the physical file storage location outside the public web root.
 */
public final class StorageConfig {

    private static final Logger logger = LoggerFactory.getLogger(StorageConfig.class);

    private StorageConfig() {}

    public static Path initStorage() {
        String pathStr = AppConfig.getStoragePath();
        Path storagePath = Paths.get(pathStr);
        try {
            if (!Files.exists(storagePath)) {
                Files.createDirectories(storagePath);
                logger.info("Created physical storage directory: {}", storagePath.toAbsolutePath());
            }
            return storagePath;
        } catch (Exception e) {
            logger.error("Failed to initialize storage directory: {}", pathStr, e);
            throw new RuntimeException("Cannot initialize storage directory: " + pathStr, e);
        }
    }

    public static File getStorageDirectory() {
        return initStorage().toFile();
    }
}

