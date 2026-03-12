package com.FINAL.KIP;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.data.elasticsearch.ElasticsearchDataAutoConfiguration;
import org.springframework.boot.autoconfigure.data.elasticsearch.ElasticsearchRepositoriesAutoConfiguration;
import org.springframework.boot.autoconfigure.data.redis.RedisRepositoriesAutoConfiguration;
import org.springframework.boot.autoconfigure.elasticsearch.ElasticsearchRestClientAutoConfiguration;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication(exclude = {
	ElasticsearchDataAutoConfiguration.class,
	ElasticsearchRestClientAutoConfiguration.class,
	ElasticsearchRepositoriesAutoConfiguration.class,
	RedisRepositoriesAutoConfiguration.class
})
@EnableScheduling
public class KipApplication {

	public static void main(String[] args) {
		SpringApplication.run(KipApplication.class, args);
	}

}
