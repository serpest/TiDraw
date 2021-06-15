package com.serpest.tidraw.controller;

import java.time.Duration;
import java.time.Instant;
import java.util.List;
import java.util.Optional;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.serpest.tidraw.exception.DrawNotFoundException;
import com.serpest.tidraw.exception.NotYetExecutedException;
import com.serpest.tidraw.exception.TimeLimitExceededException;
import com.serpest.tidraw.model.Draw;
import com.serpest.tidraw.repository.DrawRepository;

@RestController
public class DrawController {

	private final DrawRepository DRAW_REPOSITORY;

	public DrawController(final DrawRepository DRAW_REPOSITORY) {
		this.DRAW_REPOSITORY = DRAW_REPOSITORY;
	}

	@GetMapping("/draws/{id}")
	public Draw getDraw(@PathVariable long id) {
		return DRAW_REPOSITORY.findById(id).orElseThrow(() -> new DrawNotFoundException(id));
	}

	@GetMapping("/draws/{id}/winners")
	public List<String> getDrawWinnerElements(@PathVariable long id) {
		Draw draw = getDraw(id);
		if (draw.getDrawInstant().isAfter(Instant.now()) || draw.getWinnerElements().isEmpty())
			throw new NotYetExecutedException();
		return draw.getWinnerElements();
	}

	@DeleteMapping("/draws/{id}")
	public void deleteDraw(@PathVariable long id) {
		Optional<Draw> optionalDraw = DRAW_REPOSITORY.findById(id);
		if (optionalDraw.isPresent()) {
			Draw draw = optionalDraw.get();
			if (draw.getDrawInstant().isAfter(Instant.now()) && Duration.between(Instant.now(), draw.getDrawInstant()).compareTo(Duration.ofMinutes(2)) <= 0) // There are 2 minutes or less to the draw execution
				throw new TimeLimitExceededException();
		}
		DRAW_REPOSITORY.deleteById(id);
	}

	@PostMapping("/draws")
	public Draw createDraw(@RequestBody Draw draw) {
		// TODO: Implement draw execution schedule
		return DRAW_REPOSITORY.save(draw);
	}

	@PatchMapping("/draws/{id}")
	public Draw editDrawInstant(@PathVariable long id, @RequestBody Instant drawInstant) {
		// TODO: Change draw execution schedule
		Draw draw = getDraw(id);
		if (draw.getDrawInstant().isBefore(Instant.now()))
			throw new TimeLimitExceededException();
		draw.setDrawInstant(drawInstant);
		return DRAW_REPOSITORY.save(draw);
	}

}
