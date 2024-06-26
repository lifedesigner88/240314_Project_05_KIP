package com.FINAL.KIP.attachedfile.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AttachedFileResDto {
    private Long id;
    private Long documentId;
    private String fileName;
    private String fileType;
    private String fileUrl;
}