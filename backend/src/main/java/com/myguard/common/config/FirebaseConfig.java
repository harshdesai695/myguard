package com.myguard.common.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.firestore.Firestore;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.cloud.FirestoreClient;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

@Slf4j
@Configuration
public class FirebaseConfig {

    @Value("${myguard.firebase.credentials-path:}")
    private String credentialsPath;

    @Bean
    public FirebaseApp firebaseApp() throws IOException {
        if (!FirebaseApp.getApps().isEmpty()) {
            return FirebaseApp.getInstance();
        }

        GoogleCredentials credentials;
        if (credentialsPath != null && !credentialsPath.isBlank()) {
            try (InputStream serviceAccount = new FileInputStream(credentialsPath)) {
                credentials = GoogleCredentials.fromStream(serviceAccount);
            }
        } else {
            credentials = GoogleCredentials.getApplicationDefault();
        }

        FirebaseOptions options = FirebaseOptions.builder()
                .setCredentials(credentials)
                .build();

        log.info("[CONFIG] Firebase initialized successfully");
        return FirebaseApp.initializeApp(options);
    }

    @Bean
    public Firestore firestore(FirebaseApp firebaseApp) {
        return FirestoreClient.getFirestore(firebaseApp);
    }

    @Bean
    public FirebaseAuth firebaseAuth(FirebaseApp firebaseApp) {
        return FirebaseAuth.getInstance(firebaseApp);
    }
}
