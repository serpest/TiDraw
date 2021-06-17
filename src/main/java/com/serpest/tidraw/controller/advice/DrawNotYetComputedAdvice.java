package com.serpest.tidraw.controller.advice;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

import com.serpest.tidraw.controller.exception.DrawNotYetComputedException;

@ControllerAdvice
public class DrawNotYetComputedAdvice {

	@ResponseBody
	@ExceptionHandler(DrawNotYetComputedException.class)
	@ResponseStatus(code = HttpStatus.LOCKED)
	public String handleDrawNotYetComputedException(DrawNotYetComputedException exc) {
		return exc.getMessage();
	}

}
