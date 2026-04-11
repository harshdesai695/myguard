package com.myguard.common.config;

import com.myguard.common.filter.FirebaseTokenFilter;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final FirebaseTokenFilter firebaseTokenFilter;

    private static final String[] PUBLIC_ROUTES = {
            "/api/v1/auth/register",
            "/api-docs/**",
            "/swagger-ui/**",
            "/swagger-ui.html",
            "/actuator/health"
    };

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable)
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(PUBLIC_ROUTES).permitAll()
                        .anyRequest().authenticated()
                )
                .addFilterBefore(firebaseTokenFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
