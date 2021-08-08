package com.serpest.tidraw.controller;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.linkTo;
import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

import java.time.Duration;
import java.time.Instant;
import java.util.Optional;

import javax.validation.Valid;
import javax.validation.constraints.Future;

import org.springframework.hateoas.CollectionModel;
import org.springframework.hateoas.EntityModel;
import org.springframework.hateoas.IanaLinkRelations;
import org.springframework.hateoas.LinkRelation;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.serpest.tidraw.component.DrawModelAssembler;
import com.serpest.tidraw.controller.exception.DrawNotFoundException;
import com.serpest.tidraw.controller.exception.DrawNotYetExecutedException;
import com.serpest.tidraw.controller.exception.EditingTimeLimitExceededException;
import com.serpest.tidraw.model.Draw;
import com.serpest.tidraw.model.DrawExecutor;
import com.serpest.tidraw.repository.DrawRepository;

@RestController
@CrossOrigin
@RequestMapping("/api")
public class DrawController {

	// This class is used to simplify the method editDrawDrawInstant()
	private static class DrawDrawInstantPatch {

		private DrawDrawInstantPatch(String text) {
			drawInstant = Instant.parse(text);
		}

		@Future(message="The draw instant must be in the future")
		private Instant drawInstant;

	}

	private final DrawRepository DRAW_REPOSITORY;

	private final DrawModelAssembler DRAW_MODEL_ASSEMBLER;

	private final DrawExecutor DRAW_EXECUTOR;

	public DrawController(final DrawRepository DRAW_REPOSITORY, final DrawModelAssembler DRAW_MODEL_ASSEMBLER) {
		this.DRAW_REPOSITORY = DRAW_REPOSITORY;
		this.DRAW_MODEL_ASSEMBLER = DRAW_MODEL_ASSEMBLER;
		DRAW_EXECUTOR = new DrawExecutor();
	}

	@GetMapping("/draws/{id}")
	public EntityModel<Draw> getDraw(@PathVariable String id) {
		Draw draw = DRAW_REPOSITORY.findById(id).orElseThrow(() -> new DrawNotFoundException(id));
		return DRAW_MODEL_ASSEMBLER.toModel(draw);
	}

	@GetMapping("/draws/{id}/editable")
	public EntityModel<Boolean> isDrawEditable(@PathVariable String id) {
		Draw draw = DRAW_REPOSITORY.findById(id).orElseThrow(() -> new DrawNotFoundException(id));
		EntityModel<Boolean> editableBoolModel = EntityModel.of(isThereEnoughTimeToEditDrawBeforeDrawExecution(draw),
				DRAW_MODEL_ASSEMBLER.toModel(draw).getLinks().without(IanaLinkRelations.SELF).without(LinkRelation.of("is-draw-editable")));
		editableBoolModel.add(linkTo(methodOn(DrawController.class).isDrawEditable(id)).withSelfRel());
		editableBoolModel.add(linkTo(methodOn(DrawController.class).getDraw(id)).withRel("draw"));
		return editableBoolModel;
	}

	@GetMapping("/draws/{id}/selected-elements")
	public CollectionModel<String> getDrawSelectedElements(@PathVariable String id) {
		Draw draw = getDraw(id).getContent();
		if (!draw.hasBeenExecuted())
			throw new DrawNotYetExecutedException(id);
		CollectionModel<String> selectedElementsModel = CollectionModel.of(draw.getSelectedElements(),
				DRAW_MODEL_ASSEMBLER.toModel(draw).getLinks().without(IanaLinkRelations.SELF).without(LinkRelation.of("draw-selected-elements")));
		selectedElementsModel.add(linkTo(methodOn(DrawController.class).getDrawSelectedElements(id)).withSelfRel());
		selectedElementsModel.add(linkTo(methodOn(DrawController.class).getDraw(id)).withRel("draw"));
		return selectedElementsModel;
	}

	@DeleteMapping("/draws/{id}")
	public ResponseEntity<Object> deleteDraw(@PathVariable String id) {
		Optional<Draw> optionalDraw = DRAW_REPOSITORY.findById(id);
		if (optionalDraw.isPresent() &&
			!isThereEnoughTimeToEditDrawBeforeDrawExecution(optionalDraw.get())) { // The draw has been already executed or the execution instant is near
				throw new EditingTimeLimitExceededException(id);
		}
		DRAW_REPOSITORY.deleteById(id);
		return ResponseEntity.noContent().build();
	}

	@PostMapping("/draws")
	public ResponseEntity<EntityModel<Draw>> createDraw(@RequestBody @Valid Draw draw) {
		DRAW_EXECUTOR.executeDraw(draw); // The draw is executed immediately after receiving the draw and not at the specified draw instant
		EntityModel<Draw> drawModel = DRAW_MODEL_ASSEMBLER.toModel(DRAW_REPOSITORY.save(draw));
		return ResponseEntity
				.created(drawModel.getRequiredLink(IanaLinkRelations.SELF).toUri())
				.body(drawModel);
	}

	@PutMapping("/draws/{id}")
	public ResponseEntity<EntityModel<Draw>> replaceDraw(@PathVariable String id, @RequestBody @Valid Draw newDraw) {
		return DRAW_REPOSITORY.findById(id).map(originalDraw -> {
					if (!isThereEnoughTimeToEditDrawBeforeDrawExecution(originalDraw))
						throw new EditingTimeLimitExceededException(id);
					originalDraw.setName(newDraw.getName());
					originalDraw.setDrawInstant(newDraw.getDrawInstant());
					originalDraw.setSelectedElementsSize(newDraw.getSelectedElementsSize());
					originalDraw.setRaffleElements(newDraw.getRaffleElements());
					DRAW_EXECUTOR.executeDraw(originalDraw);
					EntityModel<Draw> originalDrawModel = DRAW_MODEL_ASSEMBLER.toModel(DRAW_REPOSITORY.save(originalDraw));
					return ResponseEntity
							.created(originalDrawModel.getRequiredLink(IanaLinkRelations.SELF).toUri())
							.body(originalDrawModel);
				})
				.orElseGet(() -> {
					return createDraw(newDraw);
				});
	}

	@PatchMapping("/draws/{id}/draw-instant")
	public ResponseEntity<EntityModel<Draw>> editDrawDrawInstant(@PathVariable String id, @RequestBody @Valid DrawDrawInstantPatch drawDrawInstantPatch) {
		Draw draw = getDraw(id).getContent();
		draw.setDrawInstant(drawDrawInstantPatch.drawInstant);
		EntityModel<Draw> drawModel = DRAW_MODEL_ASSEMBLER.toModel(DRAW_REPOSITORY.save(draw));
		return ResponseEntity
				.created(drawModel.getRequiredLink(IanaLinkRelations.SELF).toUri())
				.body(drawModel);
	}

	private boolean isThereEnoughTimeToEditDrawBeforeDrawExecution(Draw draw) {
		// Are there more then 2 minutes to the draw execution?
		if (draw.getDrawInstant() == null)
			return false;
		return Duration.between(Instant.now(), draw.getDrawInstant()).compareTo(Duration.ofMinutes(2)) > 0;
	}

}
