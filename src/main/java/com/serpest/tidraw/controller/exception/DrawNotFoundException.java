package com.serpest.tidraw.controller.exception;

public class DrawNotFoundException extends RuntimeException {

	private static final long serialVersionUID = 8778720373997116580L;

	public DrawNotFoundException(String id) {
		super("Draw " + id + " not found");
	}

}
