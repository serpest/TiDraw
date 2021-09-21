package com.serpest.tidraw.security;

import org.springframework.data.mongodb.repository.MongoRepository;

interface DrawTokenRepository extends MongoRepository<DrawToken, String> {
	
}
