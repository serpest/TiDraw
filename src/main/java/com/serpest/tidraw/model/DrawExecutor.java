package com.serpest.tidraw.model;

import java.time.Duration;
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
		List<String> shuffledList = new ArrayList<>(draw.getRaffleElements());
		Collections.shuffle(shuffledList);
		draw.setWinnerElements(shuffledList.subList(0, draw.getWinnerElementsSize()));
	}

	public void scheduleDrawExecution(Draw draw) {
		long millisecondsDelay = Duration.between(draw.getCreationInstant(), draw.getDrawInstant()).toMillis();
		scheduler.schedule(() -> executeDraw(draw), millisecondsDelay, TimeUnit.MILLISECONDS);
	}

}
