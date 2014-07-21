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

import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.scheduler.Task;

/**
 * Implementation of a task that writes "Hello World" to a log file.
 * 
 */
public class HelloWorldTask extends ETLAbstractTask {
	
	private static Log log = LogFactory.getLog(HelloWorldTask.class);
	
	/**
	 * Public constructor.
	 */
	public HelloWorldTask() {
		log.debug("hello world task created at " + new Date());
	}
	
	public void execute() {
		log.debug("executing hello world task");
		super.startExecuting();
	}
	
	public void shutdown() {
		log.debug("shutting down hello world task");
		this.stopExecuting();
	}
}