package com.serpest.tidraw.controller.exception;

public class DrawNotYetExecutedException extends RuntimeException {

	private static final long serialVersionUID = 9165601870970447644L;

	public DrawNotYetExecutedException(String id) {
		super("Draw " + id + " not yet executed");
	}

}
