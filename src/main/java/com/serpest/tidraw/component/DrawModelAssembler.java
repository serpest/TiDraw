package com.serpest.tidraw.component;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.linkTo;
import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

import org.springframework.hateoas.EntityModel;
import org.springframework.hateoas.server.RepresentationModelAssembler;
import org.springframework.stereotype.Component;

import com.serpest.tidraw.controller.DrawController;
import com.serpest.tidraw.model.Draw;

@Component
public class DrawModelAssembler implements RepresentationModelAssembler<Draw, EntityModel<Draw>> {

	@Override
	public EntityModel<Draw> toModel(Draw draw) {
		EntityModel<Draw> drawModel = EntityModel.of(draw);
		drawModel.add(linkTo(methodOn(DrawController.class).getDraw(draw.getId())).withSelfRel());
		drawModel.add(linkTo(methodOn(DrawController.class).isDrawEditable(draw.getId())).withRel("is-draw-editable"));
		drawModel.add(linkTo(methodOn(DrawController.class).getNoEditableInstant(draw.getId())).withRel("draw-no-editable-instant"));
		if (draw.hasBeenExecuted())
			drawModel.add(linkTo(methodOn(DrawController.class).getDrawSelectedElements(draw.getId())).withRel("draw-selected-elements"));
		drawModel.add(linkTo(methodOn(DrawController.class).editDrawDrawInstant(draw.getId(), null)).withRel("edit-draw-instant"));
		drawModel.add(linkTo(methodOn(DrawController.class).replaceDraw(draw.getId(), null, null)).withRel("replace-draw"));
		drawModel.add(linkTo(methodOn(DrawController.class).deleteDraw(draw.getId())).withRel("delete-draw"));
		drawModel.add(linkTo(methodOn(DrawController.class).createDraw(null, null)).withRel("create-draw"));
		return drawModel;
	}

}
