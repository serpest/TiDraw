package com.serpest.tidraw.security;

import java.util.Optional;
import java.util.UUID;

import org.springframework.stereotype.Component;

@Component("drawTokenManager")
public class DrawTokenManager {

	private final DrawTokenRepository DRAW_TOKEN_REPOSITORY;

	public DrawTokenManager(DrawTokenRepository DRAW_TOKEN_REPOSITORY) {
		this.DRAW_TOKEN_REPOSITORY = DRAW_TOKEN_REPOSITORY;
	}

	public String createToken(String id) {
		DrawToken token = new DrawToken(id, UUID.randomUUID().toString());
		DRAW_TOKEN_REPOSITORY.save(token);
		return token.getValue();
	}

	public boolean checkToken(DrawToken token) {
		assert token.getId() != null;
		Optional<DrawToken> savedToken = DRAW_TOKEN_REPOSITORY.findById(token.getId());
		if (savedToken.isPresent()) {
			return savedToken.get().getValue().equals(token.getValue());
		}
		return false;
	}

}
