package com.FINAL.KIP.attachedfile.service;

import com.FINAL.KIP.attachedfile.domain.AttachedFile;
import com.FINAL.KIP.attachedfile.dto.AttachedFileResDto;
import com.FINAL.KIP.attachedfile.repository.AttachedFileRepository;
import com.FINAL.KIP.common.s3.S3Config;
import com.FINAL.KIP.document.repository.DocumentRepository;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.S3Object;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.util.UriUtils;

import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@Transactional(rollbackFor = Exception.class)
public class AttachedFileService {

    private static final long MAX_FILE_SIZE_BYTES = 2L * 1024 * 1024;

    private final AttachedFileRepository attachedFileRepository;
    private final DocumentRepository documentRepository;

    //s3 연결 config
    private final S3Config s3Config;

    // s3 bucket 이름
    @Value("${cloud.aws.s3.bucket}")
    private String bucket;

    @Autowired
    public AttachedFileService(AttachedFileRepository attachedFileRepository, DocumentRepository documentRepository, S3Config s3Config) {
        this.attachedFileRepository = attachedFileRepository;
        this.documentRepository = documentRepository;
        this.s3Config = s3Config;
    }

    //    파일 업로드
    public String uploadFile(MultipartFile file, Long documentId) throws IOException {
        if (file.getSize() > MAX_FILE_SIZE_BYTES) {
            throw new IllegalArgumentException("첨부파일은 2MB 이하만 업로드할 수 있습니다.");
        }

        if (!documentRepository.existsById(documentId)) {
            throw new IllegalArgumentException("대상 문서를 찾을 수 없습니다.");
        }

        String displayFileName = normalizeDisplayFileName(file.getOriginalFilename());
        String storedFileName = buildStoredFileName(displayFileName, documentId);
        String contentType = StringUtils.hasText(file.getContentType())
                ? file.getContentType()
                : MediaType.APPLICATION_OCTET_STREAM_VALUE;

        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentLength(file.getSize());
        metadata.setContentType(contentType);

        try (InputStream inputStream = file.getInputStream()) {
            s3Config.amazonS3Client().putObject(bucket, storedFileName, inputStream, metadata);
        }

        AttachedFile attachedFile = new AttachedFile();
        attachedFile.setFileName(displayFileName);
        attachedFile.setFileType(contentType);
        attachedFile.setFileUrl(s3Config.buildObjectUrl(storedFileName));
        attachedFile.setDocumentId(documentId);

        try {
            attachedFileRepository.save(attachedFile);
        } catch (RuntimeException e) {
            s3Config.amazonS3Client().deleteObject(bucket, storedFileName);
            throw e;
        }

        return attachedFile.getFileUrl();
    }

    //    파일 조회
    public List<AttachedFileResDto> fileList(Long documentId) {
        List<AttachedFile> files = attachedFileRepository.findByDocumentId(documentId);
        return files.stream()
                .map(attachedFile -> AttachedFileResDto.builder()
                        .id(attachedFile.getId())
                        .documentId(attachedFile.getDocumentId())
                        .fileName(attachedFile.getFileName())
                        .fileType(attachedFile.getFileType())
                        .fileUrl(attachedFile.getFileUrl())
                        .build())
                .collect(Collectors.toList());
    }

    //    파일 다운로드
    public ResponseEntity<byte[]> downloadFile(String objectKey) throws IOException {
        return buildDownloadResponse(objectKey, objectKey, MediaType.APPLICATION_OCTET_STREAM_VALUE);
    }

    public ResponseEntity<byte[]> downloadFileById(Long fileId) throws IOException {
        AttachedFile attachedFile = attachedFileRepository.findAttachedFileById(fileId);
        if (attachedFile == null) {
            throw new IllegalArgumentException("첨부파일을 찾을 수 없습니다.");
        }

        String objectKey = resolveObjectKey(attachedFile);
        return buildDownloadResponse(objectKey, attachedFile.getFileName(), attachedFile.getFileType());
    }

    //    파일 삭제
    public void deleteFile(Long fileId)  {
        AttachedFile attachedFile = attachedFileRepository.findAttachedFileById(fileId);
        if (attachedFile == null) {
            throw new IllegalArgumentException("첨부파일을 찾을 수 없습니다.");
        }

        attachedFileRepository.delete(attachedFile);
        s3Config.amazonS3Client().deleteObject(bucket, resolveObjectKey(attachedFile));
    }

    private ResponseEntity<byte[]> buildDownloadResponse(String objectKey, String downloadFileName, String contentType)
            throws IOException {
        if (!StringUtils.hasText(objectKey)) {
            throw new IllegalArgumentException("첨부파일 경로가 올바르지 않습니다.");
        }

        try (S3Object s3Object = s3Config.amazonS3Client().getObject(bucket, objectKey);
             InputStream inputStream = s3Object.getObjectContent()) {
            String encodedFilename = URLEncoder.encode(downloadFileName, StandardCharsets.UTF_8);
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.parseMediaType(
                    StringUtils.hasText(contentType) ? contentType : MediaType.APPLICATION_OCTET_STREAM_VALUE
            ));
            headers.setContentDispositionFormData("attachment", encodedFilename);

            InputStreamResource resource = new InputStreamResource(inputStream);
            return ResponseEntity.ok()
                    .headers(headers)
                    .body(resource.getContentAsByteArray());
        }
    }

    private String normalizeDisplayFileName(String originalFilename) {
        String cleanedFileName = StringUtils.cleanPath(originalFilename == null ? "" : originalFilename);
        if (!StringUtils.hasText(cleanedFileName)) {
            throw new IllegalArgumentException("파일 이름이 올바르지 않습니다.");
        }

        String fileNameOnly = cleanedFileName.substring(cleanedFileName.lastIndexOf('/') + 1);
        String extension = StringUtils.getFilenameExtension(fileNameOnly);
        String baseName = StringUtils.stripFilenameExtension(fileNameOnly);

        if (fileNameOnly.length() <= 255) {
            return fileNameOnly;
        }

        int reservedLength = StringUtils.hasText(extension) ? extension.length() + 1 : 0;
        int maxBaseLength = Math.max(1, 255 - reservedLength);
        String trimmedBaseName = baseName.substring(0, Math.min(baseName.length(), maxBaseLength));
        return StringUtils.hasText(extension) ? trimmedBaseName + "." + extension : trimmedBaseName;
    }

    private String buildStoredFileName(String originalFilename, Long documentId) {
        String extension = StringUtils.getFilenameExtension(originalFilename);
        String suffix = StringUtils.hasText(extension) ? "." + extension : "";
        return "attached-files/" + documentId + "/" + UUID.randomUUID() + suffix;
    }

    private String resolveObjectKey(AttachedFile attachedFile) {
        String objectKeyFromUrl = extractObjectKeyFromUrl(attachedFile.getFileUrl());
        if (StringUtils.hasText(objectKeyFromUrl)) {
            return objectKeyFromUrl;
        }
        return attachedFile.getFileName();
    }

    private String extractObjectKeyFromUrl(String fileUrl) {
        if (!StringUtils.hasText(fileUrl)) {
            return null;
        }

        String path = URI.create(fileUrl).getPath();
        String bucketPathPrefix = "/" + bucket + "/";
        int bucketIndex = path.indexOf(bucketPathPrefix);
        if (bucketIndex < 0) {
            return null;
        }

        String encodedKey = path.substring(bucketIndex + bucketPathPrefix.length());
        return UriUtils.decode(encodedKey, StandardCharsets.UTF_8);
    }
}
