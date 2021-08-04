package com.serpest.tidraw.validation;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

public class RaffleElementsValidator implements ConstraintValidator<RaffleElementsConstraint, List<String>> {

	@Override
	public boolean isValid(List<String> raffleElementsList, ConstraintValidatorContext context) {
		if (raffleElementsList == null)
			return false;
		Set<String> raffleElementsSet = new HashSet<String>(raffleElementsList);
		return raffleElementsList.size() == raffleElementsSet.size();
	}

}
