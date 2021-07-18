package com.serpest.tidraw.model;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class DrawExecutor {

	public void executeDraw(Draw draw) {
		/* TODO: Find the intersection point (if it exists) in the time complexity chart
		 * between this approach and the one that runs in linear time and determine the
		 * best one for this case based on the global input size limits
		 */
		List<String> shuffledList = new ArrayList<>(draw.getRaffleElements());
		Collections.shuffle(shuffledList);
		draw.setSelectedElements(shuffledList.subList(0, draw.getSelectedElementsSize()));
	}

}
