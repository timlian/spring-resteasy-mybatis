package com.orange.magic;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@MapperScan("com.orange.magic.mapper")
@ComponentScan(basePackages = {"com.orange.magic"})
public class WebAppConfig {
	
}
