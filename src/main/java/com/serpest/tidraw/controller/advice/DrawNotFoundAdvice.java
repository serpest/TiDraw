package com.serpest.tidraw.controller.advice;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

import com.serpest.tidraw.controller.exception.DrawNotFoundException;

@ControllerAdvice
public class DrawNotFoundAdvice {

	@ResponseBody
	@ExceptionHandler(DrawNotFoundException.class)
	@ResponseStatus(code = HttpStatus.NOT_FOUND)
	public String handleDrawNotFoundException(DrawNotFoundException exc) {
		return exc.getMessage();
	}

}
