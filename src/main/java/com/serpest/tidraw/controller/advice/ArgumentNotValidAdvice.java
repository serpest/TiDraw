package com.serpest.tidraw.controller.advice;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

@ControllerAdvice
public class ArgumentNotValidAdvice {

	@ResponseBody
	@ExceptionHandler(MethodArgumentNotValidException.class)
	public ResponseEntity<Object[]> handleMethodArgumentNotValidException(MethodArgumentNotValidException exc) {
		Object[] invalidFieldMessages = exc.getBindingResult()
				.getAllErrors()
				.stream()
				.map(error -> error.getDefaultMessage())
				.toArray();
		return ResponseEntity.badRequest().body(invalidFieldMessages);
	}

}
