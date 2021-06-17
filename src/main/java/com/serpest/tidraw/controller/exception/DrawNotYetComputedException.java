package com.serpest.tidraw.controller.exception;

public class DrawNotYetComputedException extends RuntimeException {

	private static final long serialVersionUID = 9165601870970447644L;

	public DrawNotYetComputedException(long id) {
		super("Draw " + id + " not yet computed");
	}

}
