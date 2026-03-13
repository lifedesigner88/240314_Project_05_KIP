package com.FINAL.KIP.attachedfile;

import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Component
public class AttachedFileSchemaInitializer implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(AttachedFileSchemaInitializer.class);

    private final JdbcTemplate jdbcTemplate;

    public AttachedFileSchemaInitializer(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public void run(String... args) {
        List<String> uniqueIndexes = jdbcTemplate.queryForList("""
                SELECT INDEX_NAME
                FROM information_schema.statistics
                WHERE table_schema = DATABASE()
                  AND table_name = 'attached_file'
                  AND column_name = 'file_name'
                  AND non_unique = 0
                """, String.class);

        for (String indexName : uniqueIndexes) {
            jdbcTemplate.execute("ALTER TABLE attached_file DROP INDEX `" + indexName.replace("`", "``") + "`");
            log.info("Dropped legacy unique index {} from attached_file.file_name", indexName);
        }
    }
}
