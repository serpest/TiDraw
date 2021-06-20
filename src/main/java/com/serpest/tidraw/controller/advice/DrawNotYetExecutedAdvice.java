package com.serpest.tidraw.controller.advice;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

import com.serpest.tidraw.controller.exception.DrawNotYetExecutedException;

@ControllerAdvice
public class DrawNotYetExecutedAdvice {

	@ResponseBody
	@ExceptionHandler(DrawNotYetExecutedException.class)
	@ResponseStatus(code = HttpStatus.LOCKED)
	public String handleDrawNotYetComputedException(DrawNotYetExecutedException exc) {
		return exc.getMessage();
	}

}
