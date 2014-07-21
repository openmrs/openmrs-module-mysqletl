package org.openmrs.module.mysqletl.scheduler.tasks;

/**
 * The contents of this file are subject to the OpenMRS Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://license.openmrs.org
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 *
 * Copyright (C) OpenMRS, LLC.  All Rights Reserved.
 */

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.api.context.Daemon;
import org.openmrs.scheduler.Task;
import org.openmrs.scheduler.TaskDefinition;

/**
 * Base class for all other task classes.
 */
public abstract class ETLAbstractTask implements Task {
	// Logger
	private static final Log log = LogFactory.getLog(ETLAbstractTask.class);
	
	// Indicates whether the task is currently running
	protected boolean isExecuting = false;
	
	// The task definition of the running task
	protected TaskDefinition taskDefinition;
	
	/**
	 * Default constructor
	 */
	protected ETLAbstractTask() {
	}
	
	/**
	 * Constructor
	 * 
	 * @param taskDefinition the task definition
	 */
	protected ETLAbstractTask(TaskDefinition taskDefinition) {
		log.debug("Initializing " + taskDefinition.getName());
		initialize(taskDefinition);
	}
	
	/**
	 * @see org.openmrs.scheduler.Task#execute()
	 */
	public abstract void execute();
	
	/**
	 * @see org.openmrs.scheduler.Task#isExecuting()
	 */
	public boolean isExecuting() {
		return isExecuting;
	}
	
	/**
	 * @see org.openmrs.scheduler.Task#initialize(TaskDefinition)
	 */
	public void initialize(final TaskDefinition definition) {
		this.taskDefinition = definition;
	}
	
	/**
	 * @see org.openmrs.scheduler.Task#getTaskDefinition()
	 */
	public TaskDefinition getTaskDefinition() {
		return this.taskDefinition;
	}
	
	/**
	 * @see org.openmrs.scheduler.Task#shutdown()
	 */
	public void shutdown() {
		taskDefinition = null;
	}
	
	/**
	 * Callback method that tells the task that it has started executing.
	 */
	public void startExecuting() {
		this.isExecuting = true;
	}
	
	/**
	 * Callback method that tells the task that it has stopped executing.
	 */
	public void stopExecuting() {
		this.isExecuting = false;
	}
	
	/**
	 * @deprecated this method is not used anymore. All threads are run as the {@link Daemon} user
	 */
	@Deprecated
	protected void authenticate() {
		// do nothing
	}
}