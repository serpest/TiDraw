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

@Entity
public class Draw {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private long id;

	@Column
	private String name;

	@Column
	private Instant creationInstant;

	@Column
	private Instant lastModifiedInstant;

	@Column
	private Instant drawInstant;

	@Column
	private int selectedElementsSize;

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

	/**
	 * @param selectedElementsSize the number of selected elements
	 * @throws IllegalArgumentException if <code>selectedElementsSize</code> is less then 1
	 */
	public void setSelectedElementsSize(int selectedElementsSize) {
		if (selectedElementsSize < 1)
			throw new IllegalArgumentException("The number of selected elements must me greater than or equal to 1");
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
		return selectedElements;
	}

	void setSelectedElements(List<String> selectedElements) {
		this.selectedElements = selectedElements;
		setLastModifiedInstant(Instant.now());
	}

	private void setCreationInstant(Instant creationInstant) {
		this.creationInstant = creationInstant;
		setLastModifiedInstant(Instant.now());
	}

}
