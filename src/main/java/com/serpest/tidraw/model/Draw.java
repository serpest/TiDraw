package com.serpest.tidraw.model;

import java.time.Instant;
import java.util.List;

import javax.validation.constraints.Future;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonProperty.Access;
import com.serpest.tidraw.validation.DrawConstraint;
import com.serpest.tidraw.validation.RaffleElementsConstraint;

@DrawConstraint(message="The number of selected elements must be less then or equal to the number of the raffle elements")
public class Draw {

	private String id;

	@NotBlank(message="The draw's name must not be null and must contain at least one non-whitespace character")
	@Size(min=1, max=280, message="The draw's name length must be between 1 and 280 characters")
	private String name;

	@JsonProperty(access = Access.READ_ONLY)
	private Instant creationInstant;

	@JsonProperty(access = Access.READ_ONLY)
	private Instant lastModifiedInstant;

	@Future(message="The draw instant must be in the future")
	private Instant drawInstant;

	@NotNull(message="The number of selected elements cannot be null")
	@Min(value=1, message="The number of selected elements must be higher or equal to 1") 
	private int selectedElementsSize;

	// raffleElements is a list and not a set for performance reasons in DrawExecutor
	@RaffleElementsConstraint(message="The raffle elements list cannot contain duplicates")
	@NotEmpty(message="The raffle elements list cannot be null")
	private List<String> raffleElements;

	private List<String> selectedElements;

	public Draw() {
		setCreationInstant(Instant.now());
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
		setLastModifiedInstant(Instant.now());
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
		setLastModifiedInstant(Instant.now());
	}

	public Instant getCreationInstant() {
		return creationInstant;
	}

	public Instant getLastModifiedInstant() {
		return lastModifiedInstant;
	}

	public void setLastModifiedInstant(Instant lastModifiedInstant) {
		this.lastModifiedInstant = lastModifiedInstant;
	}

	public Instant getDrawInstant() {
		return drawInstant;
	}

	public void setDrawInstant(Instant drawInstant) {
		this.drawInstant = drawInstant;
		setLastModifiedInstant(Instant.now());
	}

	public int getSelectedElementsSize() {
		return selectedElementsSize;
	}

	public void setSelectedElementsSize(int selectedElementsSize) {
		this.selectedElementsSize = selectedElementsSize;
		setLastModifiedInstant(Instant.now());
	}

	public List<String> getRaffleElements() {
		return raffleElements;
	}

	public void setRaffleElements(List<String> raffleElements) {
		this.raffleElements = raffleElements;
		setLastModifiedInstant(Instant.now());
	}

	public List<String> getSelectedElements() {
		/*
		 * The draw could be executed before the specified draw instant,
		 * so it's important to hide the draw's selected elements before the specified draw instant
		 */
		if (hasBeenExecuted())
			return selectedElements;
		return null;
	}

	public void setSelectedElements(List<String> selectedElements) {
		this.selectedElements = selectedElements;
		setLastModifiedInstant(Instant.now());
	}

	public boolean hasBeenExecuted() {
		if (drawInstant == null)
			return true;
		return !drawInstant.isAfter(Instant.now());
	}

	private void setCreationInstant(Instant creationInstant) {
		this.creationInstant = creationInstant;
		setLastModifiedInstant(Instant.now());
	}

}
