package com.project.application.models;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "users")
public class UserModel {

	@Id
	private String id;
	
	private String username;

	private String password;
	
	
//	firstname, lastname, country, phone -> user_data
//	phone verification, email verification, kyc verification
//	

	public String getId() {
		return id;
	}


	public UserModel() {

	}


	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}
}
