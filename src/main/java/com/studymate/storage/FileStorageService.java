package com.studymate.storage;

import com.studymate.config.StorageConfig;
import com.studymate.exception.StorageException;
import com.studymate.exception.ValidationException;
import com.studymate.model.entity.ResourceFile;
import com.studymate.util.ValidationUtil;
import org.apache.commons.io.FilenameUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.security.DigestInputStream;
import java.security.MessageDigest;
import java.util.HexFormat;
import java.util.UUID;

/**
 * Handles physical file validation, unique storage name generation,
 * secure storage outside web root, and deletion coordination.
 */
public class FileStorageService {

    private static final Logger logger = LoggerFactory.getLogger(FileStorageService.class);
    private final Path rootStoragePath;

    public FileStorageService() {
        this.rootStoragePath = StorageConfig.initStorage();
    }

    public FileStorageService(Path rootStoragePath) {
        this.rootStoragePath = rootStoragePath;
    }

    /**
     * Validates and stores an uploaded file.
     */
    public ResourceFile storeFile(String originalFilename, String mimeType, long size, InputStream inputStream) {
        if (originalFilename == null || originalFilename.isBlank()) {
            throw new ValidationException("Uploaded filename cannot be empty");
        }

        // Validate allowed file extensions
        if (!ValidationUtil.isAllowedFileExtension(originalFilename)) {
            throw new ValidationException("File type not permitted. Allowed: PDF, Images, Word, PPT, TXT");
        }

        // Clean filename and extract extension
        String cleanOriginalName = ValidationUtil.sanitizeFilename(FilenameUtils.getName(originalFilename));
        String extension = ValidationUtil.getFileExtension(cleanOriginalName).toLowerCase();

        // Generate safe unique stored filename
        String storedFilename = UUID.randomUUID().toString() + "." + extension;
        Path targetPath = rootStoragePath.resolve(storedFilename).normalize();

        // Verify anti-path traversal: targetPath must remain inside rootStoragePath
        if (!targetPath.startsWith(rootStoragePath)) {
            throw new StorageException("Security violation: Path traversal detected in filename");
        }

        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            try (DigestInputStream dis = new DigestInputStream(inputStream, digest)) {
                Files.copy(dis, targetPath, StandardCopyOption.REPLACE_EXISTING);
            }

            String storageHash = HexFormat.of().formatHex(digest.digest());
            long actualSize = Files.size(targetPath);

            logger.info("Stored file '{}' as '{}' (size: {} bytes, hash: {})",
                    cleanOriginalName, storedFilename, actualSize, storageHash);

            return new ResourceFile(
                    cleanOriginalName,
                    storedFilename,
                    targetPath.toAbsolutePath().toString(),
                    extension,
                    mimeType != null ? mimeType : "application/octet-stream",
                    actualSize,
                    storageHash
            );

        } catch (Exception e) {
            // Clean up partial file on failure
            try {
                Files.deleteIfExists(targetPath);
            } catch (Exception ex) {
                logger.warn("Could not delete failed upload at {}", targetPath);
            }
            logger.error("Failed to store uploaded file {}: {}", cleanOriginalName, e.getMessage(), e);
            throw new StorageException("Failed to save uploaded file: " + e.getMessage(), e);
        }
    }

    /**
     * Resolves the physical file for streaming/download.
     */
    public File getFile(String storedFilename) {
        if (storedFilename == null || storedFilename.isBlank()) {
            throw new StorageException("Invalid stored filename");
        }
        Path path = rootStoragePath.resolve(storedFilename).normalize();
        if (!path.startsWith(rootStoragePath)) {
            throw new StorageException("Security violation: Path traversal detected");
        }
        File file = path.toFile();
        if (!file.exists() || !file.canRead()) {
            throw new StorageException("File not found or unreadable on disk: " + storedFilename);
        }
        return file;
    }

    /**
     * Safely deletes a file from physical storage.
     */
    public boolean deletePhysicalFile(String storedFilename) {
        if (storedFilename == null || storedFilename.isBlank()) return false;
        try {
            Path path = rootStoragePath.resolve(storedFilename).normalize();
            if (path.startsWith(rootStoragePath)) {
                return Files.deleteIfExists(path);
            }
        } catch (Exception e) {
            logger.warn("Failed to delete physical file {}: {}", storedFilename, e.getMessage());
        }
        return false;
    }
}

