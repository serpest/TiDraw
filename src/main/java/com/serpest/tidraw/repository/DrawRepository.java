package com.serpest.tidraw.repository;

import org.springframework.data.mongodb.repository.MongoRepository;

import com.serpest.tidraw.model.Draw;

public interface DrawRepository extends MongoRepository<Draw, String> {
	
}
