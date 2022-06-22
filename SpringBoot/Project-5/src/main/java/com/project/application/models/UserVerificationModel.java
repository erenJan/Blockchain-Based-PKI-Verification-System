package com.project.application.models;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "verification")
public class UserVerificationModel {

//	phone verification, email verification, kyc verification
	
	@Id
	private String id;
	
	private Boolean phoneVerification;
	
	private Boolean emailVerification;
	
	private Boolean kycVerification;

	public UserVerificationModel() {
		
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Boolean getPhoneVerification() {
		return phoneVerification;
	}

	public void setPhoneVerification(Boolean phoneVerification) {
		this.phoneVerification = phoneVerification;
	}

	public Boolean getEmailVerification() {
		return emailVerification;
	}

	public void setEmailVerification(Boolean emailVerification) {
		this.emailVerification = emailVerification;
	}

	public Boolean getKycVerification() {
		return kycVerification;
	}

	public void setKycVerification(Boolean kycVerification) {
		this.kycVerification = kycVerification;
	}

	
	
	
	
}
