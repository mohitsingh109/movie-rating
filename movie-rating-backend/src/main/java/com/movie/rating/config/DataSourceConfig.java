package com.movie.rating.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.util.FileCopyUtils;

import javax.sql.DataSource;
import java.io.FileReader;
import java.io.IOException;

@Configuration
public class DataSourceConfig {

    @Value("${spring.datasource.url}")
    private String url;

    @Value("${spring.datasource.username}")
    private String username;

    @Value("${spring.datasource.password-file:/run/secrets/db_password}")
    private String passwordFile;

    @Bean
    public DataSource dataSource() throws IOException {
        String password = FileCopyUtils.copyToString(new FileReader(passwordFile)).trim();

        return DataSourceBuilder.create()
                .url(url)
                .username(username)
                .password(password)
                .build();
    }
}
