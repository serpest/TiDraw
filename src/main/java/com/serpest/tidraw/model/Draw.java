package com.serpest.tidraw.model;

import java.time.Instant;
import java.util.List;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.ElementCollection;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.validation.constraints.FutureOrPresent;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import com.serpest.tidraw.validation.DrawConstraint;

@DrawConstraint(message="The number of selected elements must be less then or equal to the number of the raffle elements")
@Entity
public class Draw {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private long id;

	@Column
	@NotBlank(message="The draw's name must not be null and must contain at least one non-whitespace character")
	@Size(min=1, max=280, message="The draw's name length must be between 1 and 280 characters")
	private String name;

	@Column
	private Instant creationInstant;

	@Column
	private Instant lastModifiedInstant;

	@NotNull(message="The draw instant cannot be null")
	@FutureOrPresent(message="The draw instant must be in the present or in the future")
	@Column
	private Instant drawInstant;

	@NotNull(message="The number of selected elements cannot be null")
	@Min(value=1, message="The number of selected elements must be higher or equal to 1") 
	@Column
	private int selectedElementsSize;

	@NotEmpty(message="The raffle elements set cannot be null")
	@ElementCollection
	private Set<String> raffleElements;

	@ElementCollection
	private List<String> selectedElements;

	public Draw() {
		setCreationInstant(Instant.now());
	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
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

	public Set<String> getRaffleElements() {
		return raffleElements;
	}

	public void setRaffleElements(Set<String> raffleElements) {
		this.raffleElements = raffleElements;
		setLastModifiedInstant(Instant.now());
	}

	public List<String> getSelectedElements() {
		if (drawInstant.isAfter(Instant.now()))
			return null;
		return selectedElements;
	}

	public void setSelectedElements(List<String> selectedElements) {
		this.selectedElements = selectedElements;
		setLastModifiedInstant(Instant.now());
	}

	private void setCreationInstant(Instant creationInstant) {
		this.creationInstant = creationInstant;
		setLastModifiedInstant(Instant.now());
	}

}
