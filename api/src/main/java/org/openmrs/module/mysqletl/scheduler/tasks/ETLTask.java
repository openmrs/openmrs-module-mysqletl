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
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
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
	private static final String SERVER_HIVE = "HIVE";
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
		try{

			//Setting Connection to MySQL
			Class.forName("com.mysql.jdbc.Driver");
			String connectionURL = "jdbc:mysql://"+ETLCredentials.gethost()+":"+ETLCredentials.getport()+"/";
			Connection con = DriverManager.getConnection (connectionURL ,ETLCredentials.getuser(), ETLCredentials.getpass());
			//get table list
			List<String> tableListWithDuplicates = new ArrayList<String>();
			for(String column : ETLCredentials.getcolumnlist()){
				tableListWithDuplicates.add(column.substring(0,column.indexOf('.', column.indexOf('.')+1)));
			}
			List<String> tableList = new ArrayList<String>(new HashSet<String>(tableListWithDuplicates));
			Statement stmt = null;
			stmt = con.createStatement();
			//Create Fresh Temporary database
			String dropFreshQuery = "drop database if exists "+ETLCredentials.getdbname();
			stmt.execute(dropFreshQuery);
			String create_query = "create database if not exists "+ETLCredentials.getdbname();
			stmt.execute(create_query);
			String join_cndtn = ETLCredentials.getjoincondition();
			if(join_cndtn.indexOf('\n')<0){
				join_cndtn = join_cndtn.replace('\n', ' ');
			}
			//Create extracted data in form of table
			String query = "CREATE TABLE "+ETLCredentials.getdbname()+"."+ETLCredentials.gettablename()
							+" AS SELECT "+ETLCredentials.getcolumnlist().toString().substring(1, ETLCredentials.getcolumnlist().toString().length()-1)
							+" FROM "+tableList.toString().substring(1, tableList.toString().length()-1)
							+" "+join_cndtn;
			stmt.execute(query);
			//if MYSQL Selected it will not drop the temporary table
			if(ETLCredentials.getservertype().equalsIgnoreCase(SERVER_HIVE)){
				//Get Own IP Address which where we are client to machine running Hive and SSH
				String grantHost = ETLCredentials.getIpAddress();
				//grant Privileges to client IP to connect to MYSQL DB on remote machine
				stmt.execute(ETLCredentials.grantPrivileges(grantHost));
				//Sqoop Import Data
				ETLCredentials.sqoopImport(grantHost,ETLCredentials.getport(),ETLCredentials.getuser(),"\""+ETLCredentials.getpass()+"\"",ETLCredentials.getdbname(),ETLCredentials.gettablename(),ETLCredentials.getdbname());
				//Drop Temporary created database
				String dropQuery = "drop database "+ETLCredentials.getdbname();
				stmt.execute(dropQuery);
			}
		}
		catch(Exception e){
			log.error(e);
		}		
	}

	@Override
	public void shutdown() {
		log.debug("shutting ETL Task");
		this.stopExecuting();
	}
}