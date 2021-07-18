package com.serpest.tidraw.controller.exception;

public class EditingTimeLimitExceededException extends RuntimeException {

	private static final long serialVersionUID = -7601423435024823464L;

	public EditingTimeLimitExceededException(String id) {
		super("Draw " + id + " not editable anymore because of time limit exceeded");
	}

}
