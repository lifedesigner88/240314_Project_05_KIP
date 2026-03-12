package com.FINAL.KIP.securities;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class JwtTokenProvider {

    private final Key signingKey;
    private final Long expirationMinutes;
    private final String issuer;

    public JwtTokenProvider(
        @Value("${app.jwt.secret-key}") String secretKey,
        @Value("${app.jwt.expiration-minutes}") long expirationMinutes,
        @Value("${app.jwt.issuer}") String issuer
    ) {
        this.signingKey = Keys.hmacShaKeyFor(secretKey.getBytes(StandardCharsets.UTF_8));
        this.expirationMinutes = expirationMinutes;
        this.issuer = issuer;
    }

    public String createAccessToken(String userSpecification) {
        return Jwts.builder()
            .signWith(signingKey, SignatureAlgorithm.HS256)
            .setSubject(userSpecification)
            .setIssuer(issuer)
            .setIssuedAt(Timestamp.valueOf(LocalDateTime.now()))
            .setExpiration(Date.from(Instant.now().plus(expirationMinutes, ChronoUnit.MINUTES)))
            .compact();
    }

    public String validateTokenAndGetSubject(String token) {
        return validateAndParseToken(token).getBody().getSubject();
    }

    private Jws<Claims> validateAndParseToken(String token) {
        return Jwts.parserBuilder()
            .setSigningKey(signingKey)
            .build()
            .parseClaimsJws(token);
    }
}
