package com.project.application.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import com.project.application.models.UserKycModel;

@Repository
public interface UserKycRepository extends MongoRepository<UserKycModel, String>{

}
