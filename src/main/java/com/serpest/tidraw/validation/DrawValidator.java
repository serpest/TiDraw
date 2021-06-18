package com.serpest.tidraw.validation;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

import com.serpest.tidraw.model.Draw;

public class DrawValidator implements ConstraintValidator<DrawConstraint, Draw> {

	@Override
	public boolean isValid(Draw draw, ConstraintValidatorContext context) {
		return draw.getSelectedElementsSize() <= draw.getRaffleElements().size();
	}

}
