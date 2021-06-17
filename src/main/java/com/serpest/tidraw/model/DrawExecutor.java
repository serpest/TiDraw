package com.serpest.tidraw.model;

import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class DrawExecutor {

	private ScheduledExecutorService scheduler;

	public DrawExecutor()  {
		scheduler = Executors.newScheduledThreadPool(4); // The number of threads is fixed, so it doesn't scale based on the number of scheduled draws. This could cause lags
	}

	public void executeDraw(Draw draw) {
		/* TODO: Find the intersection point (if it exists) in the time complexity chart
		 * between this approach and the one that runs in linear time and determine the
		 * best one for this case based on the global input size limits
		 */
		List<String> shuffledList = new ArrayList<>(draw.getRaffleElements());
		Collections.shuffle(shuffledList);
		draw.setSelectedElements(shuffledList.subList(0, draw.getSelectedElementsSize()));
	}

	/**
	 * Schedules the draw execution.
	 * 
	 * @param draw the draw to schedule
	 * @throws NullPointerException if <code>draw</code> or <code>draw.getDrawInstant()</code> are null
	 * @throws IllegalArgumentException if the draw instant is not in the future
	 */
	public void scheduleDrawExecution(Draw draw) {
		if (draw.getDrawInstant().compareTo(Instant.now()) <= 0)
			throw new IllegalArgumentException("The draw instant must be in the future");
		long millisecondsDelay = Duration.between(Instant.now(), draw.getDrawInstant()).toMillis();
		scheduler.schedule(() -> executeDraw(draw), millisecondsDelay, TimeUnit.MILLISECONDS);
	}

}
