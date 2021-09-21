package com.serpest.tidraw.security;

import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@Configuration
@EnableWebSecurity
public class WebSecurityConfiguration extends WebSecurityConfigurerAdapter {

	@Override
	protected void configure(HttpSecurity http) throws Exception {
		http.authorizeRequests()
				.antMatchers(HttpMethod.DELETE, "/api/draws/*").authenticated()
				.antMatchers(HttpMethod.PUT, "/api/draws/*").authenticated()
				.antMatchers(HttpMethod.PATCH, "/api/draws/*/draw-instant").authenticated()
				.anyRequest().permitAll()
			.and()
				.csrf().disable();
	}

}
