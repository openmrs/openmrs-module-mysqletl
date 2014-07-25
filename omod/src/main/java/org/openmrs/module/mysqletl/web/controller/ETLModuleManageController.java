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
package org.openmrs.module.mysqletl.web.controller;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

import javax.swing.JOptionPane;

import net.neoremind.sshxcute.exception.TaskExecFailException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.api.APIException;
import org.openmrs.api.context.Context;
import org.openmrs.module.mysqletl.dwr.LoginParams;
import org.openmrs.module.mysqletl.dwr.ServerType;
import org.openmrs.module.mysqletl.tools.MySQLClient;
import org.openmrs.module.mysqletl.tools.SSHClient;
import org.openmrs.module.mysqletl.tools.SchedulerCredentials;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * The main controller.
 */
@Controller
public class  ETLModuleManageController {
	
	private static final String SAVED_INFO = "Configuration Saved!!";
	protected final Log log = LogFactory.getLog(getClass());
	
	@RequestMapping(value = "/module/mysqletl/manage", method = RequestMethod.GET)
	public void manage(ModelMap model) {
		model.addAttribute("user", Context.getAuthenticatedUser());
	}
	
	@RequestMapping(value = "/module/mysqletl/login_mysql", method = RequestMethod.POST)
	public  @ResponseBody List<String> loginMySQL(@RequestParam(value="user",required=false)String UserName,@RequestParam(value="pass",required=false)String Password,@RequestParam(value="host",required=false)String Host,@RequestParam(value="port",required=false)String Port,ModelMap model) 
	{	
		LoginParams params = new LoginParams(); 
		params.setuser(UserName);
		params.setpass(Password);
		params.sethost(Host);
		params.setport(Port);
		MySQLClient.MySQLParameters(params);
		return MySQLClient.login(params);
	}
		
	@RequestMapping(value = "/module/mysqletl/get_tables", method = RequestMethod.POST)
	public  @ResponseBody List<String> getTables(@RequestParam(value="dbname",required=false)String DatabaseName,ModelMap model) throws APIException, ClassNotFoundException, SQLException 
	{	
		return MySQLClient.getTables(MySQLClient.toLoginParams(), DatabaseName);
	}
	
	@RequestMapping(value = "/module/mysqletl/get_columns", method = RequestMethod.POST)
	public  @ResponseBody List<String> getColumns(@RequestParam(value="dbname",required=false)String DatabaseName,@RequestParam(value="tablename",required=false)String TableName,ModelMap model) throws APIException, ClassNotFoundException, SQLException 
	{	
		return MySQLClient.getColumns(MySQLClient.toLoginParams(), DatabaseName, TableName);
	}
	
	@RequestMapping(value = "/module/mysqletl/sqoop_transform", method = RequestMethod.POST)
	public @ResponseBody String sqoopTransform(@RequestParam(value="user",required=false)String UserName,@RequestParam(value="pass",required=false)String Password,@RequestParam(value="host",required=false)String Host,@RequestParam(value="port",required=false)String Port,@RequestParam(value="servertype",required=false)String serverType,@RequestParam(value="dbname",required=false)String db_name,@RequestParam(value="tablename",required=false)String table_name,@RequestParam(value="columnlist[]",required=false)List<String> column_list, @RequestParam(value="joincndtn",required=false)String join_cndtn,ModelMap model) throws Exception  {
//		try{ 
			//Setting Connection to MySQL
			Class.forName("com.mysql.jdbc.Driver");
			String connectionURL = "jdbc:mysql://"+MySQLClient.toLoginParams().gethost()+":"+MySQLClient.toLoginParams().getport()+"/";
			Connection con = DriverManager.getConnection (connectionURL ,MySQLClient.toLoginParams().getuser(), MySQLClient.toLoginParams().getpass());
			//get table list
			List<String> tableListWithDuplicates = new ArrayList<String>();
			for(String column : column_list){
				tableListWithDuplicates.add(column.substring(0,column.indexOf('.', column.indexOf('.')+1)));
			}
			List<String> tableList = new ArrayList<String>(new HashSet<String>(tableListWithDuplicates));
			Statement stmt = null;
			stmt = con.createStatement();
			//Create Fresh Temporary database
			String dropFreshQuery = "drop database if exists "+db_name;
			stmt.execute(dropFreshQuery);
			String create_query = "create database if not exists "+db_name;
			stmt.execute(create_query);
			if(join_cndtn.indexOf('\n')<0){
				join_cndtn = join_cndtn.replace('\n', ' ');
			}
			//Create extracted data in form of table
			String query = "CREATE TABLE "+db_name+"."+table_name
							+" AS SELECT "+column_list.toString().substring(1, column_list.toString().length()-1)
							+" FROM "+tableList.toString().substring(1, tableList.toString().length()-1)
							+" "+join_cndtn;
			stmt.execute(query);
			//if MYSQL Selected it will not drop the temporary table
			if(serverType.equalsIgnoreCase(ServerType.HIVE.name().toString().trim())){
				//Set SSH Connection Parameters
				SSHClient.SetSSHParameters(Host,UserName,Password,Port);
				//Get Own IP Address which where we are client to machine running Hive and SSH
				String grantHost = SSHClient.getIpAddress();
				//grant Privileges to client IP to connect to MYSQL DB on remote machine
				stmt.execute(MySQLClient.grantPrivileges(grantHost));
				//Sqoop Import Data
				SSHClient.sqoopImport(grantHost,MySQLClient.getport(),MySQLClient.getuser(),"\""+MySQLClient.getpass()+"\"",db_name,table_name,db_name);
				//Drop Temporary created database
				String dropQuery = "drop database "+db_name;
				stmt.execute(dropQuery);
			}
		    return "Success";
//		}
//		catch(Exception e){
//		    return "Failed";
//	    }
	}
	
	@RequestMapping(value = "/module/mysqletl/login_hive", method = RequestMethod.POST)
	public @ResponseBody String loginHive(@RequestParam(value="user",required=false)String UserName,@RequestParam(value="pass",required=false)String Password,@RequestParam(value="host",required=false)String Host,@RequestParam(value="port",required=false)String Port,ModelMap model) throws APIException, TaskExecFailException  {
		LoginParams params = new LoginParams(); 
		params.setuser(UserName);
		params.setpass(Password);
		params.sethost(Host);
		params.setport(Port);
		SSHClient.SetSSHParameters(Host,UserName,Password,Port);
		return SSHClient.login(params);
	}
	
	@RequestMapping(value = "/module/mysqletl/query_hive", method = RequestMethod.POST)
	public @ResponseBody String[][] queryHive(@RequestParam(value="query",required=false)String Query,ModelMap model) throws Exception  {
		return SSHClient.getQueryResult(Query);
	}
	
	@RequestMapping(value = "/module/mysqletl/query_download", method = RequestMethod.POST)
	public @ResponseBody String queryHiveDownload(@RequestParam(value="dquery",required=false)String Query,ModelMap model) throws Exception  {
		return SSHClient.getQueryResultDownload(Query);
	}
	
	@RequestMapping(value = "/module/mysqletl/save_config", method = RequestMethod.POST)
	public @ResponseBody String saveSchedulerConfig(@RequestParam(value="user",required=false)String UserName,@RequestParam(value="pass",required=false)String Password,@RequestParam(value="host",required=false)String Host,@RequestParam(value="port",required=false)String Port,@RequestParam(value="servertype",required=false)String serverType,@RequestParam(value="dbname",required=false)String db_name,@RequestParam(value="tablename",required=false)String table_name,@RequestParam(value="columnlist[]",required=false)List<String> column_list, @RequestParam(value="joincndtn",required=false)String join_cndtn,ModelMap model) throws Exception  {
		SchedulerCredentials.SchedulerParameters(UserName, Password, Host, Port, serverType, db_name, table_name, column_list, join_cndtn);
		return SAVED_INFO;
	}
}
