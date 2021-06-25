package com.serpest.tidraw.repository;

import org.springframework.data.repository.CrudRepository;

import com.serpest.tidraw.model.Draw;

public interface DrawRepository extends CrudRepository<Draw, Long> {
	
}
