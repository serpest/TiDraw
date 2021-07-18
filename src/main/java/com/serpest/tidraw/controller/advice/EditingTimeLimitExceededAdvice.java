package com.serpest.tidraw.controller.advice;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

import com.serpest.tidraw.controller.exception.EditingTimeLimitExceededException;

@ControllerAdvice
public class EditingTimeLimitExceededAdvice {

	@ResponseBody
	@ExceptionHandler(EditingTimeLimitExceededException.class)
	@ResponseStatus(code = HttpStatus.GONE)
	public String handleEditingTimeLimitExceededException(EditingTimeLimitExceededException exc) {
		return exc.getMessage();
	}

}
