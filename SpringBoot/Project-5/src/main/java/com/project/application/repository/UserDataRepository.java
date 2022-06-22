package com.project.application.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import com.project.application.models.UserDataModel;


@Repository
public interface UserDataRepository extends MongoRepository<UserDataModel, String> {

	
}
