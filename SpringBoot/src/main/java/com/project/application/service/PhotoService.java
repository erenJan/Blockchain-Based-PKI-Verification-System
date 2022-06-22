package com.project.application.service;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.Optional;

import org.apache.tomcat.util.http.fileupload.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import com.project.application.models.UserDataModel;
import com.project.application.models.UserKycModel;
import com.project.application.repository.UserKycRepository;

@Service
public class PhotoService {

	@Autowired
	private UserKycRepository kycRepository;
	
	public void savePhotoToDB(String id ,MultipartFile file, MultipartFile file_2, MultipartFile file_3, String address, String birthdate,
			String firstName, String lastName, String identityNumber, String gender, String phoneNumber) {
		
		Optional<UserKycModel> userOptional = kycRepository.findById(id);
		UserKycModel kycModel = userOptional.get();
		//String fileName = StringUtils.cleanPath(file.getOriginalFilename());
		try {
			kycModel.setPhoto(Base64.getEncoder().encodeToString(file.getBytes()));
			kycModel.setIdPhotoFront(Base64.getEncoder().encodeToString(file_2.getBytes()));
			kycModel.setIdPhotoBack(Base64.getEncoder().encodeToString(file_3.getBytes()));
		} catch (IOException e) {
			e.printStackTrace();
		}
		kycModel.setAddress(address);
		kycModel.setBirthdate(birthdate);
		kycModel.setFirstName(firstName);
		kycModel.setLastName(lastName);
		kycModel.setIdentityNumber(identityNumber);
		kycModel.setGender(gender);
		kycModel.setPhoneNumber(phoneNumber);
		
		kycRepository.save(kycModel);
		
	}
	
	public byte[] getPhotoToDB(String id) {
		String savePath = "C:\\Users\\ADMIN\\Desktop\\Dersler\\Ceng_495\\Eclipse_Graduation_Project_Save\\Project-5.5\\Project-5\\target";
		Optional<UserKycModel> userOptional = kycRepository.findById(id);
		UserKycModel kycModel = userOptional.get();
		byte[] decode = Base64.getDecoder().decode(kycModel.getPhoto());
		try {
			
			FileOutputStream fileOutputStream = new FileOutputStream(savePath);
			fileOutputStream.write(decode);
			fileOutputStream.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return decode;
		
	}
	

	public void upatePhotoToDB(String id ,MultipartFile file, MultipartFile file_2, MultipartFile file_3, String address, String birthdate,
			String firstName, String lastName, String identityNumber, String gender, String phoneNumber) {
		
		Optional<UserKycModel> userOptional = kycRepository.findById(id);
		UserKycModel kycModel = userOptional.get();
		
		try {
			if(file != null) {
				kycModel.setPhoto(Base64.getEncoder().encodeToString(file.getBytes()));
			}else {
				kycModel.getPhoto();
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		try {
			if(file_2 != null) {
				kycModel.setPhoto(Base64.getEncoder().encodeToString(file_2.getBytes()));
			}else {
				kycModel.getPhoto();
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		try {
			if(file_3 != null) {
				kycModel.setPhoto(Base64.getEncoder().encodeToString(file_3.getBytes()));
			}else {
				kycModel.getPhoto();
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		if(address != null) {
			kycModel.setAddress(address);
		} else {
			kycModel.setAddress(kycModel.getAddress());
		}
		
		if(birthdate != null) {
			kycModel.setBirthdate(birthdate);
		} else {
			kycModel.setBirthdate(kycModel.getBirthdate());
		}
		
		if(firstName != null) {
			kycModel.setFirstName(firstName);
		} else {
			kycModel.setFirstName(kycModel.getFirstName());
		}
		
		if(lastName != null) {
			kycModel.setLastName(lastName);
		}else {
			kycModel.setLastName(kycModel.getLastName());
		}
		
		if(identityNumber != null) {
			kycModel.setIdentityNumber(identityNumber);
		}else {
			kycModel.setIdentityNumber(kycModel.getIdentityNumber());;
		}
		
		if(gender != null) {
			kycModel.setGender(gender);
		}else {
			kycModel.setGender(kycModel.getGender());
		}
		
		if(phoneNumber != null) {
			kycModel.setPhoneNumber(phoneNumber);
		}else {
			kycModel.setPhoneNumber(kycModel.getPhoneNumber());
		}
		
		kycRepository.save(kycModel);
	}
	
	
	
	
	
}
