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
	private Instant drawInstant;

	@Column
	private int winnerElementsSize;

	@ElementCollection
	private Set<String> raffleElements;

	@ElementCollection
	private List<String> winnerElements;

	public long getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Instant getCreationInstant() {
		return creationInstant;
	}

	public void setCreationInstant(Instant creationInstant) {
		this.creationInstant = creationInstant;
	}

	public Instant getDrawInstant() {
		return drawInstant;
	}

	public void setDrawInstant(Instant drawInstant) {
		this.drawInstant = drawInstant;
	}


	public int getWinnerElementsSize() {
		return winnerElementsSize;
	}

	public void setWinnerElementsSize(int winnerElementsSize) {
		if (winnerElementsSize < 1)
			throw new IllegalArgumentException("The number of winner elements must me greater than or equal to 1");
		this.winnerElementsSize = winnerElementsSize;
	}

	public Set<String> getRaffleElements() {
		return raffleElements;
	}

	public void setRaffleElements(Set<String> raffleElements) {
		this.raffleElements = raffleElements;
	}

	public List<String> getWinnerElements() {
		return winnerElements;
	}

	public void setWinnerElements(List<String> winnerElements) {
		this.winnerElements = winnerElements;
	}

}
