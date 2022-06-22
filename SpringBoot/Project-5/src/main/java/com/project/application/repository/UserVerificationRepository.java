package com.project.application.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import com.project.application.models.UserVerificationModel;

@Repository
public interface UserVerificationRepository extends MongoRepository<UserVerificationModel, String> {

	
}
