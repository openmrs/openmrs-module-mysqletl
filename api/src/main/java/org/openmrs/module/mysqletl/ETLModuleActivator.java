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
package org.openmrs.module.mysqletl;


import java.util.Date;
import java.util.UUID;

import javax.swing.JOptionPane;

import org.apache.commons.logging.Log; 
import org.apache.commons.logging.LogFactory;
import org.openmrs.api.context.Context;
import org.openmrs.module.ModuleActivator;
import org.openmrs.module.mysqletl.scheduler.tasks.ETLTask;
import org.openmrs.scheduler.SchedulerException;
import org.openmrs.scheduler.Task;
import org.openmrs.scheduler.TaskDefinition;
import org.openmrs.util.OpenmrsConstants;

/**
 * This class contains the logic that is run every time this module is either started or stopped.
 */
public class ETLModuleActivator implements ModuleActivator {
	
	protected static Log log = LogFactory.getLog(ETLModuleActivator.class);
		
	/**
	 * @see ModuleActivator#willRefreshContext()
	 */
	public void willRefreshContext() {
		log.info("Refreshing ETL Module");
	}
	
	/**
	 * @see ModuleActivator#contextRefreshed()
	 */
	public void contextRefreshed() {
		log.info("ETL Module refreshed");
	}
	
	/**
	 * @see ModuleActivator#willStart()
	 */
	public void willStart() {
		log.info("Starting ETL Module");
	}
	
	/**
	 * @see ModuleActivator#started()
	 */
	public void started() {
		log.info("ETL Module started");
		
		//Configuring ETL Task in the scheduler at Module Startup
		if(Context.isSessionOpen()){			
			TaskDefinition def = Context.getSchedulerService().getTaskByName(ETLTask.NAME);
			if (def == null) {
				def = new TaskDefinition();
				def.setName(ETLTask.NAME);
				def.setDescription(ETLTask.DESCRIPTION);
				def.setTaskClass(ETLTask.class.getName());
				def.setStartOnStartup(false);
				def.setStarted(false);
				def.setRepeatInterval(1999999999l);
			}
			try {
				if (def.getUuid() == null) {
					// manual workaround for a bug in 1.6.x
					def.setUuid(UUID.randomUUID().toString());
				}
				Context.getSchedulerService().scheduleTask(def);
			}
			catch (SchedulerException ex) {
				log.error("Error scheduling ETL initialization task at startup", ex);
			}
		}
	}
	
	/**
	 * @see ModuleActivator#willStop()
	 */
	public void willStop() {
		log.info("Stopping ETL Module");
	}
	
	/**
	 * @see ModuleActivator#stopped()
	 */
	public void stopped() {
		log.info("ETL Module stopped");
		//Removing ETL Task in the scheduler at Module Stopping
		if(Context.isSessionOpen()){			
			TaskDefinition def = Context.getSchedulerService().getTaskByName(ETLTask.NAME);
			if (def != null) {
				Context.getSchedulerService().deleteTask(def.getId());
			}
		}
	}
	
}
