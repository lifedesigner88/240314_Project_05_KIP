package com.FINAL.KIP.common.s3;

import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.client.builder.AwsClientBuilder.EndpointConfiguration;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.util.StringUtils;
import org.springframework.web.util.UriUtils;

@Configuration
public class S3Config {

    @Value("${cloud.aws.credentials.access-key}")
    private String accessKey;

    @Value("${cloud.aws.credentials.secret-key}")
    private String secretKey;

    @Value("${cloud.aws.region.static}")
    private String region;

    @Value("${cloud.aws.s3.bucket}")
    private String bucket;

    @Value("${app.storage.endpoint:}")
    private String endpoint;

    @Value("${app.storage.public-base-url:}")
    private String publicBaseUrl;

    @Value("${app.storage.path-style-access:true}")
    private boolean pathStyleAccess;

    @Value("${app.storage.auto-create-bucket:true}")
    private boolean autoCreateBucket;

    @Bean
    public AmazonS3Client amazonS3Client() {
        BasicAWSCredentials awsCredentials = new BasicAWSCredentials(accessKey, secretKey);

        AmazonS3ClientBuilder builder = AmazonS3ClientBuilder.standard()
            .withCredentials(new AWSStaticCredentialsProvider(awsCredentials))
            .withPathStyleAccessEnabled(pathStyleAccess);

        if (StringUtils.hasText(endpoint)) {
            builder.withEndpointConfiguration(new EndpointConfiguration(endpoint, region));
        } else {
            builder.withRegion(region);
        }

        AmazonS3Client amazonS3Client = (AmazonS3Client) builder.build();
        if (autoCreateBucket && !amazonS3Client.doesBucketExistV2(bucket)) {
            amazonS3Client.createBucket(bucket);
        }
        return amazonS3Client;
    }

    public String buildObjectUrl(String objectKey) {
        if (!StringUtils.hasText(publicBaseUrl)) {
            return amazonS3Client().getUrl(bucket, objectKey).toString();
        }

        String normalizedBaseUrl = publicBaseUrl.endsWith("/")
            ? publicBaseUrl.substring(0, publicBaseUrl.length() - 1)
            : publicBaseUrl;

        String encodedKey = Arrays.stream(objectKey.split("/"))
            .map(part -> UriUtils.encodePathSegment(part, StandardCharsets.UTF_8))
            .collect(Collectors.joining("/"));

        return normalizedBaseUrl + "/" + bucket + "/" + encodedKey;
    }
}
