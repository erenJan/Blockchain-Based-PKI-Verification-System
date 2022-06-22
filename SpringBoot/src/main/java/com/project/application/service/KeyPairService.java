package com.project.application.service;

import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.security.InvalidAlgorithmParameterException;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.SecureRandom;
import java.security.Signature;
import java.security.Security;
import java.security.spec.ECGenParameterSpec;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;
import java.util.Optional;

import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.openssl.jcajce.JcaPEMKeyConverter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.application.models.UserKeyPairModel;
import com.project.application.models.UserKycModel;
import com.project.application.models.WalletModel;
import com.project.application.repository.UserKeyPairRepository;
import com.project.application.repository.UserKycRepository;
import com.project.application.repository.UserWalletRepository;

import ch.qos.logback.core.recovery.ResilientSyslogOutputStream;

@Service
public class KeyPairService {
	
	@Autowired
	private UserKeyPairRepository userKeyPairRepo;
	
	@Autowired
	private UserKycRepository kycRepository;
	
	@Autowired
	private UserWalletRepository walletRepo;
	
	public String CreateKeyPair(String id) {
		


		Optional<UserKeyPairModel> userOptional = userKeyPairRepo.findById(id);
		UserKeyPairModel pairModel = userOptional.get();
		
		try {
        KeyPairGenerator keyGen = KeyPairGenerator.getInstance("EC");

        keyGen.initialize(new ECGenParameterSpec("secp256r1"), new SecureRandom());

        KeyPair pair = keyGen.generateKeyPair();
        PrivateKey priv = pair.getPrivate();
        PublicKey pub = pair.getPublic();

        
        byte[] privateKeyBytes = priv.getEncoded();
        byte[] publicKeyBytes = pub.getEncoded();
        
        byte[] str = Base64.getEncoder().encode(publicKeyBytes);
        String signatureEncodedString = new String(str);
        
        System.out.println("Public: " + signatureEncodedString + "\n");
        
        //String privateKeyBytestoHex = bytesToHex(privateKeyBytes);
        //String publicKeyBytestoHex = bytesToHex(publicKeyBytes);
        
        pairModel.setPublic_key(publicKeyBytes);
        pairModel.setPrivate_key(privateKeyBytes);   
        userKeyPairRepo.save(pairModel);

        //System.out.println(publicKeyBytes+ " " + privateKeyBytes);
        


        
        	return ("Private: " + privateKeyBytes + "\nPublic: " + publicKeyBytes);
        }catch (Exception e) {
        	return e.getMessage();
        }
			
	}
	

	
	public byte[] createSignature(String id) {
		
		Optional<UserKycModel> userOptional_kyc = kycRepository.findById(id);
		UserKycModel kycModel = userOptional_kyc.get();
		
		Optional<UserKeyPairModel> userOptional = userKeyPairRepo.findById(id);
		UserKeyPairModel pairModel = userOptional.get();
		
		byte[] priv = pairModel.getPrivate_key();
		byte[] pub = pairModel.getPublic_key();
		String address = kycModel.getAddress();
		String birthdate = kycModel.getBirthdate();
		String firstname = kycModel.getFirstName();
		String lastname = kycModel.getLastName();
		String kyc_id = kycModel.getIdentityNumber();
		String gender = kycModel.getGender();
		String phonenumber = kycModel.getPhoneNumber();
        
        try {
        Signature ecdsa = Signature.getInstance("SHA256withECDSA");

        KeyFactory kf = KeyFactory.getInstance("EC");
        PrivateKey privateKey = kf.generatePrivate(new PKCS8EncodedKeySpec(priv));
        PublicKey publicKey = kf.generatePublic(new X509EncodedKeySpec(pub));
        
        ecdsa.initSign(privateKey);
        
//        byte[] signatureBytes = ecdsa.sign();
//        byte[] signatureEncodedBytes = Base64.getEncoder().encode(signatureBytes);
//        String signatureEncodedString = new String(signatureEncodedBytes);
        

        String str = address + birthdate + firstname + lastname + kyc_id + gender + phonenumber; //signature için imza
        byte[] strByte = str.getBytes("UTF-8");
        ecdsa.update(strByte);
        
        //System.out.println(address + birthdate + firstname + lastname + kyc_id + gender + phonenumber);
        
        byte[] signatureBytes_2 = ecdsa.sign();

        
        byte[] signatureEncodedBytes_2 = Base64.getEncoder().encode(signatureBytes_2);
        String signatureEncodedString_2 = new String(signatureEncodedBytes_2);
        //System.out.println("Create " + signatureEncodedString_2);
        
//wallet id geliyor ; signature varsa ok yoksa 404
//id gelecek kyc varsa ok yoksa 404
        
        	return signatureBytes_2;
         }catch(Exception e) {
        	return null;
        }
	}
	

	
	
	public boolean verifySign(String id, String address, String birthdate, String firstname, String lastname, String kyc_id, String gender,
			String phonenumber, String public_address) {
		
		Optional<WalletModel> userOptional_2 = walletRepo.findById(id);
		WalletModel walletModel = userOptional_2.get();
		
		byte[] public_byte = Base64.getDecoder().decode(public_address);
		
		byte[] public_key = public_byte;
		
		//System.out.println(address + birthdate + firstname + lastname + kyc_id + gender + phonenumber + " " + public_byte);
		
		byte[] sigToVerify = walletModel.getSignature();
		
		try {
		
	        KeyFactory kf = KeyFactory.getInstance("EC");
	        PublicKey publicKey = kf.generatePublic(new X509EncodedKeySpec(public_key));
	        Signature sig = Signature.getInstance("SHA256withECDSA");
	        sig.initVerify(publicKey);
	        
	        String str = address + birthdate + firstname + lastname + kyc_id + gender + phonenumber; //signature için imza
	        byte[] strByte = str.getBytes("UTF-8");
	        sig.update(strByte);
	        
	        
	        boolean verifies = sig.verify(sigToVerify);
	        //System.out.println(verifies);
	        return verifies;
		
		}catch(Exception e){
			System.out.println(e);
		}
		return false;
	}
	
	
}
