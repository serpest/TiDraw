package com.serpest.tidraw.security;

public class DrawToken {

	// The DrawToken ID is equal to the corresponding Draw ID
	private String id;

	private String value;

	public DrawToken() {}

	public DrawToken(String id, String value) {
		this.id = id;
		this.value = value;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

}
