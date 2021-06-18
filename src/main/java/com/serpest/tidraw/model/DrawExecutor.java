package com.serpest.tidraw.model;

import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/* TODO: It should work with DrawRepository using id to minimize memory occupied by the draws currently used
 * Currently it's useless because it doesn't save the draws in the repository
 */
public class DrawExecutor {

	private static final int CORE_POOL_SIZE = 2;
	
	private static final Logger log = LoggerFactory.getLogger(DrawExecutor.class);

	private ScheduledExecutorService scheduler;

	public DrawExecutor()  {
		scheduler = Executors.newScheduledThreadPool(CORE_POOL_SIZE); // The number of threads is fixed, so it doesn't scale based on the number of scheduled draws. This could cause lags
	}

	public void executeDraw(Draw draw) {
		/* TODO: Find the intersection point (if it exists) in the time complexity chart
		 * between this approach and the one that runs in linear time and determine the
		 * best one for this case based on the global input size limits
		 */
		List<String> shuffledList = new ArrayList<>(draw.getRaffleElements());
		Collections.shuffle(shuffledList);
		draw.setSelectedElements(shuffledList.subList(0, draw.getSelectedElementsSize()));
		log.info("Draw " + draw.getId() + " executed");
	}

	public void scheduleDrawExecution(Draw draw) {
		long millisecondsDelay = Duration.between(Instant.now(), draw.getDrawInstant()).toMillis();
		scheduler.schedule(() -> executeDraw(draw), millisecondsDelay, TimeUnit.MILLISECONDS);
		log.info("Draw " + draw.getId() + " execution scheduled");
	}

}
