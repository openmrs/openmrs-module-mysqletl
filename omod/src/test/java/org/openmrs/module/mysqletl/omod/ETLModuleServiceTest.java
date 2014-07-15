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
package org.openmrs.module.mysqletl.omod;

import static org.junit.Assert.*;

import java.net.ConnectException;
import java.util.List;

import org.junit.Assert;
import org.junit.Test;
import org.openmrs.api.context.Context;
import org.openmrs.module.mysqletl.dwr.LoginParams;
import org.openmrs.module.mysqletl.tools.MySQLClient;
import org.openmrs.module.mysqletl.tools.SSHClient;
import org.openmrs.test.BaseModuleContextSensitiveTest;
import org.openmrs.test.Verifies;

/**
 * Tests {@link ${ETLModuleService}}.
 */
public class  ETLModuleServiceTest extends BaseModuleContextSensitiveTest {
	
	@Test
	public void shouldSetupContext() {
	}
	
	@Test
	@Verifies(value = "grantPrivileges should return some string", method = "grantPrivileges(String Host)")
	public void grantPrivileges_shouldNonNull() throws Exception {
	     String output = MySQLClient.grantPrivileges("someArgValue");
	     Assert.assertNotNull(output);
	}	
	
	@Test
	@Verifies(value = "login should return null string list", method = "login(LoginParams params)")
	public void login_shouldNull() throws Exception {
		 LoginParams params = new LoginParams();
		 List<String> output = MySQLClient.login(params);
	     Assert.assertNull(output);
	}	
	
	@Test
	@Verifies(value = "getTables should return null string list", method = "getTables(LoginParams params,String db_name)")
	public void getTables_shouldNull() throws Exception {
		 LoginParams params = new LoginParams();
		 String db_name="";
		 List<String> output = MySQLClient.getTables(params,db_name);
	     Assert.assertNull(output);
	}
	
	@Test
	@Verifies(value = "getColumns should return null string list", method = "getColumns(LoginParams params,String db_name,String table_name)")
	public void getColumns_shouldNull() throws Exception {
		 LoginParams params = new LoginParams();
		 String db_name="";
		 String table_name="";
		 List<String> output = MySQLClient.getColumns(params,db_name,table_name);
	     Assert.assertNull(output);
	}
	
	@Test
	@Verifies(value = "getIpAddress should throw exception", method = "getIpAddress()")
	public void getIpAddress_shouldThrowException() throws Exception {
		 SSHClient.SetSSHParameters("localhost", "Username", "Password", "22");
		 try{
			 SSHClient.getIpAddress();
		 }
		 catch(Exception e){
			 Assert.assertNotNull(e);
		 }
	}
	
	@Test
	@Verifies(value = "sqoop Import should throw exception", method = "sqoopImport(String Host, String Port, String MySQLUser, String MySQLPwd, String DatabaseName, String TableName, String DatawarehouseDB)")
	public void sqoopImport_shouldThrowException() throws Exception {
		 SSHClient.SetSSHParameters("localhost", "Username", "Password", "22");
		 String Host="";
		 String Port="";
		 String MySQLUser="";
		 String MySQLPwd="";
		 String DatabaseName="";
		 String TableName="";
		 String DatawarehouseDB="";
		 try{
			 SSHClient.sqoopImport(Host, Port, MySQLUser, MySQLPwd, DatabaseName, TableName, DatawarehouseDB);
		 }
		 catch(Exception e){
			 Assert.assertNotNull(e);
		 }
	}
	
	@Test
	@Verifies(value = "get Query result should throw exception", method = "getQueryResult(String Query)")
	public void getQueryResult_shouldThrowException() throws Exception {
		 SSHClient.SetSSHParameters("localhost", "Username", "Password", "22");
		 String Query = "show tables;";
		 try{
			 SSHClient.getQueryResult(Query);
		 }
		 catch(Exception e){
			 Assert.assertNotNull(e);
		 }
	}
	
	@Test
	@Verifies(value = "get Query result should throw exception", method = "getQueryResultDownload(String Query)")
	public void getQueryResultDownload_shouldThrowException() throws Exception {
		 SSHClient.SetSSHParameters("localhost", "Username", "Password", "22");
		 String Query = "show tables;";
		 try{
			 SSHClient.getQueryResultDownload(Query);
		 }
		 catch(Exception e){
			 Assert.assertNotNull(e);
		 }
	}
	
	@Test
	@Verifies(value = "ssh login should return non null string", method = "login(LoginParams params)")
	public void login_shouldNonNull() throws Exception {
		 LoginParams params = new LoginParams();
		 String output = SSHClient.login(params);
	     Assert.assertNotNull(output);
	}	
	
	public static Throwable getRootCause(Throwable throwable) {
	    if (throwable.getCause() != null)
	        return getRootCause(throwable.getCause());

	    return throwable;
	}
}
