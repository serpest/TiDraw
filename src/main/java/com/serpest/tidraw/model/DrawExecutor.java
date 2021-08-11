package com.serpest.tidraw.model;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class DrawExecutor {

	/*
	 * This method runs in O(n), where n is the number of raffle elements.
	 * 
	 * There is an algorithm that runs in O(k), where k is the number of selected elements,
	 * but it has a bigger constant factor and, considering that, presumably,
	 * this program won't deal with big inputs, that approach is not preferable
	 * over the implemented one. It would work selecting randomly an element from
	 * the raffle elements list and storing its index in an hash table to check
	 * if the index obtained randomly has been already selected in the previous steps.
	 * 
	 * For example, the implemented method performs about 40% faster then the other one,
	 * when n=30 and k=5 and the methods are executed 10,000 times, but
	 * they have similar performance when n=30 and k=3 and, generally,
	 * the implemented method performs slower then the other one when n-k is big.
	 */
	public void executeDraw(Draw draw) {
		List<String> shuffledList = new ArrayList<>(draw.getRaffleElements());
		Collections.shuffle(shuffledList);
		draw.setSelectedElements(shuffledList.subList(0, draw.getSelectedElementsSize()));
	}

}
