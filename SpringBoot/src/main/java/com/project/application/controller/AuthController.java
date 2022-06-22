package com.project.application.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.security.InvalidAlgorithmParameterException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.gridfs.GridFsOperations;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.mongodb.BasicDBObject;
import com.mongodb.DBObject;
import com.project.application.models.AuthenticationRequest;
import com.project.application.models.AuthenticationResponse;
import com.project.application.models.UserDataModel;
import com.project.application.models.UserKeyPairModel;
import com.project.application.models.UserKycModel;
import com.project.application.models.UserModel;
import com.project.application.models.UserVerificationModel;
import com.project.application.models.WalletModel;
import com.project.application.repository.UserDataRepository;
import com.project.application.repository.UserKeyPairRepository;
import com.project.application.repository.UserKycRepository;
import com.project.application.repository.UserRepository;
import com.project.application.repository.UserVerificationRepository;
import com.project.application.repository.UserWalletRepository;
import com.project.application.service.KeyPairService;
import com.project.application.service.PhotoService;

@RestController
public class AuthController {
	
	@Autowired
	private KeyPairService keypairService;
	
	@Autowired
	private PhotoService photoService;
	
	@Autowired
	private UserKycRepository kycRepository;

	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private UserDataRepository dataRepository;
	
	@Autowired
	private UserVerificationRepository verificationRepository;
	
	@Autowired
	private UserKeyPairRepository keypairRepository;
	
	@Autowired
	private AuthenticationManager authenticationManager;
	
	@Autowired
	private UserWalletRepository walletRepository;
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	

	
	@PostMapping(value = "/subs") //Post mapping for user-name(email) and password. It creates all tables(collections) with same id.
	private ResponseEntity<?> subscribeClient(@RequestBody AuthenticationRequest authenticationRequest){
		
		String username = authenticationRequest.getUsername();
		Optional<UserModel> userModelOptional = userRepository.optionalfindByUsername(username);
		String password = authenticationRequest.getPassword();
		String encodedPassword = passwordEncoder.encode(password);
		if(userModelOptional.isPresent()) {
			return new ResponseEntity<>("Username has been in database", HttpStatus.UNAUTHORIZED);
		}else {
			
			UserModel userModel = new UserModel();
			userModel.setUsername(username);
			userModel.setPassword(encodedPassword);
			userRepository.save(userModel);
			Optional<UserModel> userOptional = Optional.ofNullable(userRepository.findByUsername(username));
			UserModel user = userOptional.get();
			String userId = user.getId();
			UserDataModel dataModel = new UserDataModel();
			UserVerificationModel verificationModel = new UserVerificationModel();
			UserKeyPairModel keypairModel = new UserKeyPairModel();
			UserKycModel kycModel = new UserKycModel();
			WalletModel walletModel = new WalletModel();
			dataModel.setId(userId);
			verificationModel.setId(userId);
			keypairModel.setId(userId);
			kycModel.setId(userId);
			walletModel.setId(userId);
			dataRepository.save(dataModel);
			verificationRepository.save(verificationModel);
			keypairRepository.save(keypairModel);
			kycRepository.save(kycModel);
			walletRepository.save(walletModel);
			subscribeClientVerificationBoolean(userId);
			generateKeyPair(userId);
			
			return new ResponseEntity<>(userId, HttpStatus.OK);
		}
	}
	
	@PostMapping(value = "/data/subs/{id}") //Post mapping to data collection(table) which are the firstname, lastname, country and phone value.
	private ResponseEntity<?> subscribeClientData(@PathVariable("id") String id  ,@RequestBody UserDataModel dataModel){
		
		Optional<UserDataModel> userOptional = dataRepository.findById(id);
		UserDataModel userDataModel = userOptional.get();
		
		String firstname = dataModel.getFirstname();
		String lastname = dataModel.getLastname();
		String country = dataModel.getCountry();
		String phone = dataModel.getPhone();
		
		userDataModel.setFirstname(firstname);
		userDataModel.setLastname(lastname);
		userDataModel.setCountry(country);
		userDataModel.setPhone(phone);
		
		dataRepository.save(userDataModel);

		
		return new ResponseEntity<>(userDataModel, HttpStatus.OK);
	}
	
	@PostMapping(value = "/verification_boolean/subs/{id}") //Post mapping to data collection(table) which are the firstname, lastname, country and phone value.
	private ResponseEntity<?> subscribeClientVerificationBoolean(@PathVariable("id") String id){
		Optional<UserVerificationModel> userOptional = verificationRepository.findById(id);
		UserVerificationModel userVerificationModel = userOptional.get();
		
		userVerificationModel.setEmailVerification(false);
		userVerificationModel.setKycVerification(false);
		userVerificationModel.setPhoneVerification(false);
		
		verificationRepository.save(userVerificationModel);

		
		return new ResponseEntity<>(userVerificationModel, HttpStatus.OK);
	}
	
	@PostMapping(value = "/verification/subs/{id}") //Post mapping to data collection(table) which are the firstname, lastname, country and phone value.
	private ResponseEntity<?> subscribeClientVerification(@PathVariable("id") String id ,@RequestBody UserVerificationModel verificationModel){
		
		Optional<UserVerificationModel> userOptional = verificationRepository.findById(id);
		UserVerificationModel userVerificationModel = userOptional.get();
		
		Boolean phoneVerification = verificationModel.getPhoneVerification();
		Boolean emailVerification = verificationModel.getEmailVerification();
		Boolean kycVerification = verificationModel.getKycVerification();
		
		userVerificationModel.setPhoneVerification(phoneVerification);
		userVerificationModel.setEmailVerification(emailVerification);
		userVerificationModel.setKycVerification(kycVerification);
		
		verificationRepository.save(userVerificationModel);

		
		return new ResponseEntity<>(userVerificationModel, HttpStatus.OK);
	}
	
	@PostMapping(value = "/keypair/subs/{id}") //Post mapping to data collection(table) which are the firstname, lastname, country and phone value.
	private ResponseEntity<?> subscribeKeyPair(@PathVariable("id") String id  ,@RequestBody UserKeyPairModel dataModel){
		
		Optional<UserKeyPairModel> userOptional = keypairRepository.findById(id);
		UserKeyPairModel keypairModel = userOptional.get();
		
		byte[] publickey = dataModel.getPublic_key();
		byte[] privatekey = dataModel.getPrivate_key();
		
		keypairModel.setPublic_key(publickey);
		keypairModel.setPrivate_key(privatekey);
		
		keypairRepository.save(keypairModel);

		
		return new ResponseEntity<>(keypairModel, HttpStatus.OK);
	}
	
	
	@PostMapping(value = "/kyc/subsphoto/{id}") //Post mapping to data collection(table) which are the firstname, lastname, country and phone value.
	private ResponseEntity<?> subscribeKycPhoto(@PathVariable("id") String id, 
			@RequestParam("file") MultipartFile file, @RequestParam("file_2") MultipartFile file_2, 
			@RequestParam("file_3") MultipartFile file_3, @RequestParam("address") String address,
			@RequestParam("birthdate") String birthdate, @RequestParam("firstName") String firstName, @RequestParam("lastName") String lastName,
			@RequestParam("identityNumber") String identityNumber, @RequestParam("gender") String gender, @RequestParam("phoneNumber") String phoneNumber) {

		
		photoService.savePhotoToDB(id ,file, file_2, file_3, address, birthdate, firstName, lastName, identityNumber, gender, phoneNumber);

		Optional<UserKycModel> userOptional_2 = kycRepository.findById(id);
		UserKycModel kycModel = userOptional_2.get();
		
		
		return new ResponseEntity<>(kycModel ,HttpStatus.OK);
	}
	
	@PostMapping(value = "/auth") //Post request to control function for user is valid in database.
	private ResponseEntity<?> authenticateClient(@RequestBody AuthenticationRequest authenticationRequest ){
		
		
		String username = authenticationRequest.getUsername();
		String password = authenticationRequest.getPassword();
		Optional<UserModel> userOptional = userRepository.optionalfindByUsername(username);
		UserModel userModel = userOptional.get();
		String id = userModel.getId();
		try {
			authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(username, password));
		} catch (Exception e) {
			return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
		}
		//id dönecek
		return new ResponseEntity<>(id, HttpStatus.OK);
		
	}
	
	@PostMapping("/users/createsignature/{id}")
	private ResponseEntity<?> postSignature(@PathVariable("id") String id ,@RequestBody WalletModel walletModel){

		Optional<WalletModel> userOptional = walletRepository.findById(id);
		WalletModel userwalletModel = userOptional.get();
		
		if(userOptional.isPresent()) {
			String wallet_id = walletModel.getWallet_id();
			userwalletModel.setWallet_id(wallet_id);
			byte[] signature = keypairService.createSignature(id);
			userwalletModel.setSignature(signature);
			walletRepository.save(userwalletModel);
			return new ResponseEntity<>(userwalletModel, HttpStatus.OK);
		}else {
			return new ResponseEntity<>("No user found. ", HttpStatus.NOT_FOUND);
		}
	}
	
	@GetMapping("/walletverify/{id}")
	private ResponseEntity<?> walletVerify(@PathVariable("id") String id , @RequestParam("address") String address, 
			@RequestParam("birthdate") String birthdate, @RequestParam("firstname") String firstname, 
			@RequestParam("lastname") String lastname, @RequestParam("kyc_id") String kyc_id, @RequestParam("gender") String gender,
			@RequestParam("phonenumber") String phonenumber, @RequestParam("public_address") String public_address) {

			boolean conclusion = keypairService.verifySign(id, address, birthdate, firstname, lastname, kyc_id, gender, phonenumber,
					public_address);
		
			return new ResponseEntity<>(conclusion, HttpStatus.OK);
		
	}
	
	
	@GetMapping("/generate/keypair/{id}")
	private ResponseEntity<?> generateKeyPair(@PathVariable("id") String id) {

			return new ResponseEntity<>(keypairService.CreateKeyPair(id), HttpStatus.OK);
		
	}
	
	@GetMapping("/checkkycwithid/{id}")
	private ResponseEntity<?> checkKYCwithID(@PathVariable("id") String id){
		
		Optional<UserKycModel> userModelOptional = kycRepository.findById(id);
		if(userModelOptional.isPresent()) {
			UserKycModel kycModel = userModelOptional.get();
			String identityNumber = kycModel.getIdentityNumber();
			if(identityNumber != null) {
				return new ResponseEntity<>(true, HttpStatus.OK);
			} else {
				return new ResponseEntity<>(false, HttpStatus.NOT_FOUND);
			}
		}
		
		return new ResponseEntity<>("KYC did not find with " + id + " !", HttpStatus.NOT_FOUND);
	}
	

	@GetMapping("/findbywalletid/{wallet_id}")
	private ResponseEntity<?> findByWalletID(@PathVariable("wallet_id") String wallet_id){
		
		Optional<WalletModel> userModelOptional = walletRepository.optionalfindByWalletID(wallet_id);
		if(userModelOptional.isPresent()) {
			WalletModel wallet = userModelOptional.get();
			byte[] signature = wallet.getSignature();
			return new ResponseEntity<>(true, HttpStatus.OK);
		}
		
		return new ResponseEntity<>(false, HttpStatus.NOT_FOUND);
	}
	
	@GetMapping("/users/kyc/{id}")
	private ResponseEntity<?> getSingleUserKyc(@PathVariable("id") String id){
		Optional<UserKycModel> userModel = kycRepository.findById(id);
		if(userModel.isPresent()) {
			photoService.getPhotoToDB(id);
			return new ResponseEntity<>(userModel, HttpStatus.OK);
		}else {
			return new ResponseEntity<>("No user found. ", HttpStatus.NOT_FOUND);
		}
	}
	
	@GetMapping("/users/data/{id}")
	private ResponseEntity<?> getSingleUserData(@PathVariable("id") String id){
		Optional<UserDataModel> userModel = dataRepository.findById(id);
		if(userModel.isPresent()) {
			return new ResponseEntity<>(userModel, HttpStatus.OK);
		}else {
			return new ResponseEntity<>("No user found. ", HttpStatus.NOT_FOUND);
		}
	}
	
	@GetMapping("/users/verification/{id}")
	private ResponseEntity<?> getSingleUserVerification(@PathVariable("id") String id){
		Optional<UserVerificationModel> userModel = verificationRepository.findById(id);
		if(userModel.isPresent()) {
			return new ResponseEntity<>(userModel, HttpStatus.OK);
		}else {
			return new ResponseEntity<>("No user found. ", HttpStatus.NOT_FOUND);
		}
	}
	
	@GetMapping("/users/keypair/{id}")
	private ResponseEntity<?> getSingleUserKeyPair(@PathVariable("id") String id){
		Optional<UserKeyPairModel> userModel = keypairRepository.findById(id);
		if(userModel.isPresent()) {
			return new ResponseEntity<>(userModel, HttpStatus.OK);
		}else {
			return new ResponseEntity<>("No user found. ", HttpStatus.NOT_FOUND);
		}
	}
	
	@GetMapping("/users") //Get request to get all users in database.
	private ResponseEntity<?> getAllUsers() {
		List<UserModel> users = userRepository.findAll();
		if(users.size() > 0) {
			return new ResponseEntity<List<UserModel>>(users, HttpStatus.OK);
		}else {
			return new ResponseEntity<>("No users avaible. ", HttpStatus.NOT_FOUND);
		}
	}
	
	@GetMapping("/users/{id}") //Get request to only the one user who is the given id.
	private ResponseEntity<?> getSingleUser(@PathVariable("id") String id){
		Optional<UserModel> userOptional = userRepository.findById(id);
		if(userOptional.isPresent()) {
			return new ResponseEntity<>(userOptional, HttpStatus.OK);
		}else {
			return new ResponseEntity<>("No user found. ", HttpStatus.NOT_FOUND);
		}
	}
	
	@PutMapping("/users/{id}") //Put request to only the one user who is the given id for users collection(table).
	private ResponseEntity<?> updateById(@PathVariable("id") String id, @RequestBody UserModel user){
		Optional<UserModel> userOptional = userRepository.findById(id);
		if(userOptional.isPresent()) {
			UserModel userModel = userOptional.get();
			userModel.setUsername(user.getUsername() != null ? user.getUsername() : userModel.getUsername());
			if(user.getPassword() != null) {  
				String password = user.getPassword();
				String encodedPassword = passwordEncoder.encode(password);
				userModel.setPassword(encodedPassword);
			}else { 
				String password = userModel.getPassword();
				String encodedPassword = passwordEncoder.encode(password);
				userModel.setPassword(encodedPassword);	
			}
			
			userRepository.save(userModel);
			return new ResponseEntity<>(userModel, HttpStatus.OK);
		}else {
			return new ResponseEntity<>("User not found with this id: "+ id, HttpStatus.NOT_FOUND);
		}
	}
	
	@PutMapping("/users/data/{id}") //Put request to only the one user who is the given id for data collection(table).
	private ResponseEntity<?> updateDataById(@PathVariable("id") String id, @RequestBody UserDataModel user){
		Optional<UserDataModel> userOptional = dataRepository.findById(id);
		if(userOptional.isPresent()) {
			UserDataModel userDataModel = userOptional.get();
			userDataModel.setFirstname(user.getFirstname() != null ? user.getFirstname() : userDataModel.getFirstname());
			userDataModel.setLastname(user.getLastname() != null ? user.getLastname() : userDataModel.getLastname());
			userDataModel.setCountry(user.getCountry() != null ? user.getCountry() : userDataModel.getCountry());
			userDataModel.setPhone(user.getPhone() != null ? user.getPhone() : userDataModel.getPhone());
			
			dataRepository.save(userDataModel);
			return new ResponseEntity<>(userDataModel, HttpStatus.OK);
		}else {
			return new ResponseEntity<>("User not found with this id: "+ id, HttpStatus.NOT_FOUND);
		}
	}
	
	@PutMapping("/users/verification/{id}") //Put request to only the one user who is the given id for data collection(table).
	private ResponseEntity<?> updateVerificationById(@PathVariable("id") String id, @RequestBody UserVerificationModel user){
		Optional<UserVerificationModel> userOptional = verificationRepository.findById(id);
		if(userOptional.isPresent()) {
			UserVerificationModel userVerificationModel = userOptional.get();
			userVerificationModel.setPhoneVerification(user.getPhoneVerification() != null ? user.getPhoneVerification() : userVerificationModel.getPhoneVerification());
			userVerificationModel.setEmailVerification(user.getEmailVerification() != null ? user.getEmailVerification() : userVerificationModel.getEmailVerification());
			userVerificationModel.setKycVerification(user.getKycVerification() != null ? user.getKycVerification() : userVerificationModel.getKycVerification());
			
			verificationRepository.save(userVerificationModel);
			return new ResponseEntity<>(userVerificationModel, HttpStatus.OK);
		}else {
			return new ResponseEntity<>("User not found with this id: "+ id, HttpStatus.NOT_FOUND);
		}
	}

	@PutMapping(value = "/users/subsphoto/{id}") //Post mapping to data collection(table) which are the firstname, lastname, country and phone value.
	private ResponseEntity<?> updateKycPhoto(@PathVariable("id") String id, 
			@RequestParam("file") MultipartFile file, @RequestParam("file_2") MultipartFile file_2, 
			@RequestParam("file_3") MultipartFile file_3, @RequestParam("address") String address,
			@RequestParam("birthdate") String birthdate, @RequestParam("firstName") String firstName, @RequestParam("lastName") String lastName,
			@RequestParam("identityNumber") String identityNumber, @RequestParam("gender") String gender, @RequestParam("phoneNumber") String phoneNumber) {

		Optional<UserKycModel> userOptional = kycRepository.findById(id);
		if(userOptional.isPresent()) {
			photoService.upatePhotoToDB(id ,file, file_2, file_3, address, birthdate, firstName, lastName, identityNumber, gender, phoneNumber);
			Optional<UserKycModel> userOptional_2 = kycRepository.findById(id);
			UserKycModel kycModel = userOptional_2.get();
			return new ResponseEntity<>(kycModel, HttpStatus.OK);
		}else {
			return new ResponseEntity<>("User not found with this id: "+ id, HttpStatus.NOT_FOUND);
		}
		
	}
	
	
	@PutMapping("/users/keypair/{id}") //Put request to only the one user who is the given id for data collection(table).
	private ResponseEntity<?> updateKeyPairById(@PathVariable("id") String id, @RequestBody UserKeyPairModel user){
		Optional<UserKeyPairModel> userOptional = keypairRepository.findById(id);
		if(userOptional.isPresent()) {
			UserKeyPairModel userKeyPairModel = userOptional.get();
			userKeyPairModel.setPublic_key(user.getPublic_key() != null ? user.getPublic_key() : userKeyPairModel.getPublic_key());
			userKeyPairModel.setPrivate_key(user.getPrivate_key() != null ? user.getPrivate_key() : userKeyPairModel.getPrivate_key());
			
			keypairRepository.save(userKeyPairModel);
			return new ResponseEntity<>(userKeyPairModel, HttpStatus.OK);
		}else {
			return new ResponseEntity<>("User not found with this id: "+ id, HttpStatus.NOT_FOUND);
		}
	}
	
	@DeleteMapping("/users/{id}") // //Delete request to only the one user who is the given id. It deletes all the tables(collections).
	private ResponseEntity<?> deleteById(@PathVariable("id") String id){
		try {
			userRepository.deleteById(id);
			dataRepository.deleteById(id);
			verificationRepository.deleteById(id);
			keypairRepository.deleteById(id);
			kycRepository.deleteById(id);
			walletRepository.deleteById(id);
			return new ResponseEntity<>("Successfully deleted with id: " + id, HttpStatus.OK);
		} catch (Exception e) {
			return new ResponseEntity<>(e.getMessage(), HttpStatus.NOT_FOUND);
		}
	}
	
	
}
