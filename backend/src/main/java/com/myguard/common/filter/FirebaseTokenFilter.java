package com.myguard.common.filter;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.util.AntPathMatcher;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class FirebaseTokenFilter extends OncePerRequestFilter {

    private final FirebaseAuth firebaseAuth;

    private static final String AUTHORIZATION_HEADER = "Authorization";
    private static final String BEARER_PREFIX = "Bearer ";
    private static final AntPathMatcher PATH_MATCHER = new AntPathMatcher();

    private static final String[] PUBLIC_ROUTES = {
            "/api/v1/auth/register",
            "/api-docs/**",
            "/swagger-ui/**",
            "/swagger-ui.html",
            "/actuator/health"
    };

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getRequestURI();
        for (String publicRoute : PUBLIC_ROUTES) {
            if (PATH_MATCHER.match(publicRoute, path)) {
                return true;
            }
        }
        return false;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {
        String authHeader = request.getHeader(AUTHORIZATION_HEADER);

        if (authHeader == null || !authHeader.startsWith(BEARER_PREFIX)) {
            log.debug("[AUTH] No bearer token found in request");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"code\":\"UNAUTHORIZED\",\"message\":\"Missing or invalid Authorization header\"}");
            response.setContentType("application/json");
            return;
        }

        String token = authHeader.substring(BEARER_PREFIX.length());

        try {
            FirebaseToken decodedToken = firebaseAuth.verifyIdToken(token);
            String uid = decodedToken.getUid();

            String role = "ROLE_RESIDENT";
            Object roleClaim = decodedToken.getClaims().get("role");
            if (roleClaim != null) {
                role = roleClaim.toString();
                if (!role.startsWith("ROLE_")) {
                    role = "ROLE_" + role;
                }
            }

            UsernamePasswordAuthenticationToken authentication =
                    new UsernamePasswordAuthenticationToken(
                            uid,
                            null,
                            List.of(new SimpleGrantedAuthority(role))
                    );

            SecurityContextHolder.getContext().setAuthentication(authentication);
            log.debug("[AUTH] Token verified for user: {}", uid);

        } catch (FirebaseAuthException e) {
            log.warn("[AUTH] Invalid Firebase token");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"code\":\"UNAUTHORIZED\",\"message\":\"Invalid or expired token\"}");
            response.setContentType("application/json");
            return;
        }

        filterChain.doFilter(request, response);
    }
}
