package com.project.application.repository;

import java.util.Optional;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

import com.project.application.models.WalletModel;

public interface UserWalletRepository extends MongoRepository<WalletModel, String>{
	
	@Query(value = "{ 'wallet_id' : ?0 }")
	
	Optional<WalletModel> optionalfindByWalletID(String username);

}
