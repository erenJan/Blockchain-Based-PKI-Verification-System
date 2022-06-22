package com.project.application.models;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "keypair")
public class UserKeyPairModel {

	@Id
	private String id;
	
	private byte[] public_key;
	
	private byte[] private_key;
	
public UserKeyPairModel() {
		
	}

public String getId() {
	return id;
}

public void setId(String id) {
	this.id = id;
}

public byte[] getPublic_key() {
	return public_key;
}

public void setPublic_key(byte[] public_key) {
	this.public_key = public_key;
}

public byte[] getPrivate_key() {
	return private_key;
}

public void setPrivate_key(byte[] private_key) {
	this.private_key = private_key;
}

@Override
public String toString() {
	return "UserKeyPairModel [id=" + id + ", public_key=" + public_key + ", private_key=" + private_key + "]";
}


}
