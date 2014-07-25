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
import java.util.UUID;

import javax.swing.JOptionPane;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.api.context.Context;
import org.openmrs.scheduler.SchedulerException;
import org.openmrs.scheduler.TaskDefinition;
import org.openmrs.scheduler.tasks.AbstractTask;

/**
 * Base class for all other task classes.
 */
public class ETLTask extends AbstractTask{
	public static final String NAME = "ETL Task";
	public static final String DESCRIPTION = "Schedule tasks for performing ETL for ETL Module.";
	// Logger
	private static Log log = LogFactory.getLog(ETLTask.class);

	/**
	 * Public constructor.
	 */
	public ETLTask() {
		log.debug("ETLTask created at " + new Date());
	}

	@Override
	public void execute() {
		performScheduledETL();
		//Changing UUID
		try {
			TaskDefinition def = Context.getSchedulerService().getTaskByName(ETLTask.NAME);
			def.setUuid(UUID.randomUUID().toString());
			Context.getSchedulerService().rescheduleTask(def);
		} catch (SchedulerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		log.info("Executing ETL at "+new Date());
	}

	private void performScheduledETL() {
		// TODO Auto-generated method stub
		JOptionPane.showMessageDialog(null, "Implement Soon");
	}

	@Override
	public void shutdown() {
		log.debug("shutting ETL Task");
		this.stopExecuting();
	}
}