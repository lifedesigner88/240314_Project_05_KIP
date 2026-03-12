package com.FINAL.KIP.securities;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Optional;
import org.springframework.http.HttpHeaders;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.web.authentication.WebAuthenticationDetails;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

@Component
public class JwtAuthFilter extends OncePerRequestFilter {

    private final JwtTokenProvider jwtTokenProvider;

    public JwtAuthFilter(JwtTokenProvider jwtTokenProvider) {
        this.jwtTokenProvider = jwtTokenProvider;
    }

    @Override
    protected void doFilterInternal(
        HttpServletRequest request,
        HttpServletResponse response,
        FilterChain filterChain
    ) throws ServletException, IOException {
        try {
            String token = parseBearerToken(request, HttpHeaders.AUTHORIZATION);
            if (token != null) {
                User user = parseUserSpecification(token);
                UsernamePasswordAuthenticationToken authenticated =
                    UsernamePasswordAuthenticationToken.authenticated(
                        user,
                        token,
                        user.getAuthorities()
                    );
                authenticated.setDetails(new WebAuthenticationDetails(request));
                SecurityContextHolder.getContext().setAuthentication(authenticated);
            }
        } catch (Exception e) {
            request.setAttribute("exception", e);
        }

        filterChain.doFilter(request, response);
    }

    private String parseBearerToken(HttpServletRequest request, String headerName) {
        return Optional.ofNullable(request.getHeader(headerName))
            .filter(token -> token.regionMatches(true, 0, "Bearer ", 0, 7))
            .map(token -> token.substring(7))
            .orElse(null);
    }

    private User parseUserSpecification(String token) {
        String[] split = jwtTokenProvider.validateTokenAndGetSubject(token).split(":");
        return new User(split[0], "", List.of(new SimpleGrantedAuthority(split[1])));
    }
}
