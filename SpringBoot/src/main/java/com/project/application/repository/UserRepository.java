package com.project.application.repository;

import java.util.Optional;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

import com.project.application.models.UserModel;

public interface UserRepository extends MongoRepository<UserModel, String> {

	@Query(value = "{ 'username' : ?0 }")
	
	Optional<UserModel> optionalfindByUsername(String username);
	
	UserModel findByUsername(String username);
}
