package com.serpest.tidraw.controller;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.linkTo;
import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

import java.time.Duration;
import java.time.Instant;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import javax.validation.constraints.Future;

import org.springframework.hateoas.CollectionModel;
import org.springframework.hateoas.EntityModel;
import org.springframework.hateoas.IanaLinkRelations;
import org.springframework.hateoas.LinkRelation;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.serpest.tidraw.component.DrawModelAssembler;
import com.serpest.tidraw.controller.exception.DrawNotFoundException;
import com.serpest.tidraw.controller.exception.DrawNotYetExecutedException;
import com.serpest.tidraw.controller.exception.EditingTimeLimitExceededException;
import com.serpest.tidraw.model.Draw;
import com.serpest.tidraw.model.DrawExecutor;
import com.serpest.tidraw.repository.DrawRepository;
import com.serpest.tidraw.security.DrawTokenManager;

@RestController
@CrossOrigin
@RequestMapping("/api")
public class DrawController {

	private static final Duration DRAW_NO_EDITABLE_DURATION_BEFORE_EXECUTION = Duration.ofMinutes(5);

	// This class is used to simplify the method editDrawDrawInstant()
	private static class DrawDrawInstantPatch {

		@Future(message="The draw instant must be in the future")
		private Instant drawInstant;

		private DrawDrawInstantPatch(String text) {
			drawInstant = Instant.parse(text);
		}

	}

	// Used in EntityModel
	private static class BooleanWrapper {

		private boolean bool;

		private BooleanWrapper(boolean bool) {
			this.bool = bool;
		}

		@SuppressWarnings("unused")
		public boolean isBool() {
			return bool;
		}

	}

	// Used in EntityModel
	private static class InstantWrapper {

		private Instant instant;

		private InstantWrapper(Instant instant) {
			this.instant = instant;
		}

		@SuppressWarnings("unused")
		public Instant getInstant() {
			return instant;
		}

	}

	private final DrawRepository DRAW_REPOSITORY;

	private final DrawModelAssembler DRAW_MODEL_ASSEMBLER;

	private final DrawTokenManager DRAW_TOKEN_MANAGER;

	private final DrawExecutor DRAW_EXECUTOR;

	public DrawController(final DrawRepository DRAW_REPOSITORY, final DrawModelAssembler DRAW_MODEL_ASSEMBLER, final DrawTokenManager DRAW_TOKEN_MANAGER) {
		this.DRAW_REPOSITORY = DRAW_REPOSITORY;
		this.DRAW_MODEL_ASSEMBLER = DRAW_MODEL_ASSEMBLER;
		this.DRAW_TOKEN_MANAGER = DRAW_TOKEN_MANAGER;
		DRAW_EXECUTOR = new DrawExecutor();
	}

	@GetMapping("/draws/{id}")
	public EntityModel<Draw> getDraw(@PathVariable String id) {
		Draw draw = DRAW_REPOSITORY.findById(id).orElseThrow(() -> new DrawNotFoundException(id));
		return DRAW_MODEL_ASSEMBLER.toModel(draw);
	}

	@GetMapping("/draws/{id}/editable")
	public EntityModel<BooleanWrapper> isDrawEditable(@PathVariable String id) {
		Draw draw = DRAW_REPOSITORY.findById(id).orElseThrow(() -> new DrawNotFoundException(id));
		boolean editableBool = isThereEnoughTimeToEditDrawBeforeDrawExecution(draw);
		EntityModel<BooleanWrapper> editableBoolModel = EntityModel.of(new BooleanWrapper(editableBool),
				DRAW_MODEL_ASSEMBLER.toModel(draw).getLinks().without(IanaLinkRelations.SELF).without(LinkRelation.of("is-draw-editable")));
		editableBoolModel.add(linkTo(methodOn(DrawController.class).isDrawEditable(id)).withSelfRel());
		editableBoolModel.add(linkTo(methodOn(DrawController.class).getDraw(id)).withRel("draw"));
		return editableBoolModel;
	}

	@GetMapping("/draws/{id}/no-editable-instant")
	public EntityModel<InstantWrapper> getNoEditableInstant(@PathVariable String id) {
		Draw draw = DRAW_REPOSITORY.findById(id).orElseThrow(() -> new DrawNotFoundException(id));
		Instant noEditableInstant = getNoEditableInstant(draw);
		EntityModel<InstantWrapper> noEditableInstantModel = EntityModel.of(new InstantWrapper(noEditableInstant),
				DRAW_MODEL_ASSEMBLER.toModel(draw).getLinks().without(IanaLinkRelations.SELF).without(LinkRelation.of("draw-no-editable-instant")));
		noEditableInstantModel.add(linkTo(methodOn(DrawController.class).getNoEditableInstant(id)).withSelfRel());
		noEditableInstantModel.add(linkTo(methodOn(DrawController.class).getDraw(id)).withRel("draw"));
		return noEditableInstantModel;
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
	@PreAuthorize("@drawTokenManager.checkToken(new com.serpest.tidraw.security.DrawToken(#id, #token))")
	public ResponseEntity<Object> deleteDraw(@RequestHeader(value="token", required=false) String token, @PathVariable String id) {
		Draw draw = DRAW_REPOSITORY.findById(id).orElseThrow(() -> new DrawNotFoundException(id));
		if (!isThereEnoughTimeToEditDrawBeforeDrawExecution(draw)) { // The draw has been already executed or the execution instant is near
			throw new EditingTimeLimitExceededException(id);
		}
		DRAW_REPOSITORY.deleteById(id);
		return ResponseEntity.noContent().build();
	}

	@PostMapping("/draws")
	public ResponseEntity<EntityModel<Draw>> createDraw(@RequestBody @Valid Draw draw, HttpServletResponse response) {
		DRAW_EXECUTOR.executeDraw(draw); // The draw is executed immediately after receiving the draw and not at the specified draw instant
		Draw savedDraw = DRAW_REPOSITORY.save(draw);

		String token = DRAW_TOKEN_MANAGER.createToken(savedDraw.getId());
		Cookie cookie = new Cookie("creator-token", token);
		cookie.setPath("/api/draws/" + savedDraw.getId());
		cookie.setMaxAge(Integer.MAX_VALUE); // An alternative to "Integer.MAX_VALUE" could be "(int) Duration.between(Instant.now(), getNoEditableInstant(savedDraw)).getSeconds()", but than the cookie should be edited if the draw is updated
		cookie.setSecure(true);
		cookie.setHttpOnly(true);
		response.addCookie(cookie);

		EntityModel<Draw> drawModel = DRAW_MODEL_ASSEMBLER.toModel(savedDraw);
		return ResponseEntity
				.created(drawModel.getRequiredLink(IanaLinkRelations.SELF).toUri())
				.body(drawModel);
	}

	@PutMapping("/draws/{id}")
	@PreAuthorize("@DrawTokenManager.checkToken(new com.serpest.tidraw.security.DrawToken(#id, #token))")
	public ResponseEntity<EntityModel<Draw>> replaceDraw(@RequestHeader(value="token", required=false) String token, @PathVariable String id, @RequestBody @Valid Draw newDraw, HttpServletResponse response) {
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
					return createDraw(newDraw, response);
				});
	}

	@PatchMapping("/draws/{id}/draw-instant")
	@PreAuthorize("@DrawTokenManager.checkToken(new com.serpest.tidraw.security.DrawToken(#id, #token))")
	public ResponseEntity<EntityModel<Draw>> editDrawDrawInstant(@RequestHeader(value="token", required=false) String token, @PathVariable String id, @RequestBody @Valid DrawDrawInstantPatch drawDrawInstantPatch) {
		Draw draw = getDraw(id).getContent();
		draw.setDrawInstant(drawDrawInstantPatch.drawInstant);
		EntityModel<Draw> drawModel = DRAW_MODEL_ASSEMBLER.toModel(DRAW_REPOSITORY.save(draw));
		return ResponseEntity
				.created(drawModel.getRequiredLink(IanaLinkRelations.SELF).toUri())
				.body(drawModel);
	}

	private boolean isThereEnoughTimeToEditDrawBeforeDrawExecution(Draw draw) {
		if (draw.getDrawInstant() == null)
			return false;
		return Duration.between(Instant.now(), draw.getDrawInstant()).compareTo(DRAW_NO_EDITABLE_DURATION_BEFORE_EXECUTION) > 0;
	}

	private Instant getNoEditableInstant(Draw draw) {
		if (draw.getDrawInstant() == null)
			return draw.getCreationInstant();
		return draw.getDrawInstant().minus(DRAW_NO_EDITABLE_DURATION_BEFORE_EXECUTION);
	}

}
