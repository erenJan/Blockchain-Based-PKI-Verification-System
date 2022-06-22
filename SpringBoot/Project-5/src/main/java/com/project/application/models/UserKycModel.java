package com.project.application.models;

import java.io.File;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import com.mongodb.DBObject;

@Document(collection = "kyc")
public class UserKycModel {

	@Id
	private String id;
	
	private String address;
	
	private String birthdate;

	private String photo;
	
	private String idPhotoFront;
	
	private String idPhotoBack;
	
	private String firstName;
	
	private String lastName;
	
	private String identityNumber;
	
	private String gender;
	
	private String phoneNumber;
	
	public UserKycModel() {

	}
	
	
	public String getFirstName() {
		return firstName;
	}


	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}


	public String getLastName() {
		return lastName;
	}


	public void setLastName(String lastName) {
		this.lastName = lastName;
	}


	public String getIdentityNumber() {
		return identityNumber;
	}


	public void setIdentityNumber(String identityNumber) {
		this.identityNumber = identityNumber;
	}


	public String getGender() {
		return gender;
	}


	public void setGender(String gender) {
		this.gender = gender;
	}


	public String getPhoneNumber() {
		return phoneNumber;
	}


	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}


	public String getIdPhotoBack() {
		return idPhotoBack;
	}


	public void setIdPhotoBack(String idPhotoBack) {
		this.idPhotoBack = idPhotoBack;
	}


	public String getIdPhotoFront() {
		return idPhotoFront;
	}


	public void setIdPhotoFront(String idPhotoFront) {
		this.idPhotoFront = idPhotoFront;
	}


	public String getPhoto() {
		return photo;
	}


	public void setPhoto(String photo) {
		this.photo = photo;
	}


	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String adress) {
		this.address = adress;
	}

	public String getBirthdate() {
		return birthdate;
	}

	public void setBirthdate(String birthdate) {
		this.birthdate = birthdate;
	}

	@Override
	public String toString() {
		return "UserKycModel [id=" + id + ", address=" + address + ", birthdate=" + birthdate + ", photo=" + photo
				+ ", idPhotoFront=" + idPhotoFront + ", idPhotoBack=" + idPhotoBack + ", firstName=" + firstName
				+ ", lastName=" + lastName + ", identityNumber=" + identityNumber + ", gender=" + gender
				+ ", phoneNumber=" + phoneNumber + "]";
	}

	
	
	
	
}
