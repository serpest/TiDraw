package com.serpest.tidraw.model;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class DrawExecutor {

	public void executeDraw(Draw draw) {
		// This method runs in linear time
		List<String> shuffledList = new ArrayList<>(draw.getRaffleElements());
		Collections.shuffle(shuffledList);
		draw.setSelectedElements(shuffledList.subList(0, draw.getSelectedElementsSize()));
	}

}
