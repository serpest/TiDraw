package com.serpest.tidraw.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.serpest.tidraw.model.Draw;

public interface DrawRepository extends JpaRepository<Draw, Long> {

}
