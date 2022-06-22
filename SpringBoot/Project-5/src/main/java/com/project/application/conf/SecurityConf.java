package com.project.application.conf;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.NoOpPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

import com.project.application.service.UserService;

@EnableWebSecurity
public class SecurityConf extends WebSecurityConfigurerAdapter{

	@Autowired
	private UserService userService;

	@Override
	protected void configure(HttpSecurity http) throws Exception {
		http.csrf().disable().authorizeRequests().antMatchers("/subs","/auth", "/users", "/users/{username}", "/users/data/{id}",
				"/data/subs/{id}", "/verification/subs/{id}", "/users/{id}", "/users/data/{id}", "/users/verification/{id}", "/users/{id}"
				, "/users/verification/{id}", "/keypair/subs/{id}", "/users/keypair/{id}", "/users/keypair/{id}", "/kyc/subs/{id}",
				"/kyc/subsphoto/{id}", "/users/kyc/{id}", "/users/subsphoto/{id}", "/verification_boolean/subs/{id}", "/generate/keypair/{id}"
				, "/users/createsignature/{id}", "/findbywalletid/{wallet_id}", "/checkkycwithid/{id}", "/walletverify/{id}")
		.permitAll().anyRequest().authenticated();
	}

	@Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
		auth.userDetailsService(userService);
	}

//	@Bean
//	public PasswordEncoder passwordEncoder() {
//		return NoOpPasswordEncoder.getInstance();
//	}
	
	@Bean
	public BCryptPasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}

	@Override
	@Bean
	public AuthenticationManager authenticationManagerBean() throws Exception {
		return super.authenticationManagerBean();
	}
	
	
	
	
}
