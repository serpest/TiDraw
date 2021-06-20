package com.serpest.tidraw.controller;

import java.time.Duration;
import java.time.Instant;
import java.util.List;
import java.util.Optional;

import javax.validation.Valid;
import javax.validation.constraints.FutureOrPresent;
import javax.validation.constraints.NotNull;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.serpest.tidraw.controller.exception.DrawNotFoundException;
import com.serpest.tidraw.controller.exception.DrawNotYetExecutedException;
import com.serpest.tidraw.controller.exception.EditingTimeLimitExceededException;
import com.serpest.tidraw.model.Draw;
import com.serpest.tidraw.model.DrawExecutor;
import com.serpest.tidraw.repository.DrawRepository;

@RestController
public class DrawController {

	/*
	 * This class is used to simplify the method editDrawDrawInstant()
	 */
	private static class DrawDrawInstantPatch {

		private DrawDrawInstantPatch(String text) {
			drawInstant = Instant.parse(text);
		}

		@NotNull(message="The draw instant cannot be null")
		@FutureOrPresent(message="The draw instant must be in the present or in the future")
		private Instant drawInstant;

	}

	private final DrawRepository DRAW_REPOSITORY;

	private final DrawExecutor DRAW_EXECUTOR;

	public DrawController(final DrawRepository DRAW_REPOSITORY) {
		this.DRAW_REPOSITORY = DRAW_REPOSITORY;
		DRAW_EXECUTOR = new DrawExecutor();
	}

	@GetMapping("/draws/{id}")
	public Draw getDraw(@PathVariable long id) {
		return DRAW_REPOSITORY.findById(id).orElseThrow(() -> new DrawNotFoundException(id));
	}

	@GetMapping("/draws/{id}/selected-elements")
	public List<String> getDrawSelectedElements(@PathVariable long id) {
		Draw draw = getDraw(id);
		if (draw.getSelectedElements() == null)
			throw new DrawNotYetExecutedException(id);
		return draw.getSelectedElements();
	}

	@DeleteMapping("/draws/{id}")
	public void deleteDraw(@PathVariable long id) {
		Optional<Draw> optionalDraw = DRAW_REPOSITORY.findById(id);
		if (optionalDraw.isPresent() &&
			!isThereEnoughTimeToEditDrawBeforeDrawExecution(optionalDraw.get())) { // The draw has been already executed or the execution instant is near
				throw new EditingTimeLimitExceededException(id);
		}
		DRAW_REPOSITORY.deleteById(id);
	}

	@PostMapping("/draws")
	public Draw createDraw(@RequestBody @Valid Draw draw) {
		DRAW_EXECUTOR.executeDraw(draw); // The draw is executed immediately after receiving the draw and not at the specified draw instant
		return DRAW_REPOSITORY.save(draw);
	}

	@PutMapping("/draws/{id}")
	public Draw replaceDraw(@PathVariable long id, @RequestBody @Valid Draw newDraw) {
		return DRAW_REPOSITORY.findById(id).map(originalDraw -> {
					if (!isThereEnoughTimeToEditDrawBeforeDrawExecution(originalDraw))
						throw new EditingTimeLimitExceededException(id);
					originalDraw.setName(newDraw.getName());
					originalDraw.setDrawInstant(newDraw.getDrawInstant());
					originalDraw.setSelectedElementsSize(newDraw.getSelectedElementsSize());
					originalDraw.setRaffleElements(newDraw.getRaffleElements());
					DRAW_EXECUTOR.executeDraw(originalDraw);
					return DRAW_REPOSITORY.save(originalDraw);
				})
				.orElseGet(() -> {
					return createDraw(newDraw);
				});
	}

	@PatchMapping("/draws/{id}/draw-instant")
	public Draw editDrawDrawInstant(@PathVariable long id, @RequestBody @Valid DrawDrawInstantPatch drawDrawInstantPatch) {
		Draw draw = getDraw(id);
		draw.setDrawInstant(drawDrawInstantPatch.drawInstant);
		return DRAW_REPOSITORY.save(draw);
	}

	private boolean isThereEnoughTimeToEditDrawBeforeDrawExecution(Draw draw) {
		// Are there more then 2 minutes to the draw execution?
		return Duration.between(Instant.now(), draw.getDrawInstant()).compareTo(Duration.ofMinutes(2)) > 0;
	}

}
