package org.openmrs.module.mysqletl.dwr;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.api.APIException;
import org.openmrs.module.mysqletl.tools.HiveClient;
import org.openmrs.module.mysqletl.tools.MySQLClient;
import org.openmrs.module.mysqletl.tools.SSHClient;

public class DWRMySQLLoginService {
	
	public List<String> loginMySQL(LoginParams params) throws APIException  {
		return MySQLClient.login(params);
	}
	public String loginHive(LoginParams params) throws APIException  {
		return SSHClient.login(params);
	}
	public String[][] queryHive(String Query) throws Exception  {
		return SSHClient.getQueryResult(Query);
	}
	public List<String> getTables(LoginParams params,String db_name) throws APIException, ClassNotFoundException, SQLException  {
		return MySQLClient.getTables(params, db_name);
	}
	public List<String> getColumns(LoginParams params,String db_name,String table_name) throws APIException, ClassNotFoundException, SQLException  {
		return MySQLClient.getColumns(params, db_name, table_name);
	}
	public String sqoopTransform(LoginParams params,String serverType,String db_name,String table_name,List<String> column_list, String join_cndtn) throws APIException  {
		try{ 
			//Setting Connection to MySQL
			Class.forName("com.mysql.jdbc.Driver");
			String connectionURL = "jdbc:mysql://"+MySQLClient.gethost()+":"+MySQLClient.getport()+"/";
			Connection con = DriverManager.getConnection (connectionURL , MySQLClient.getuser(), MySQLClient.getpass());
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
			//Create extracted data in form of table
			String query = "CREATE TABLE "+db_name+"."+table_name
							+" AS SELECT "+column_list.toString().substring(1, column_list.toString().length()-1)
							+" FROM "+tableList.toString().substring(1, tableList.toString().length()-1)
							+" "+join_cndtn.replace('\n', ' ');
			stmt.execute(query);
			//if MYSQL Selected it will not drop the temporary table
			if(serverType.equalsIgnoreCase(ServerType.HIVE.name().toString().trim())){
				//Set SSH Connection Parameters
				SSHClient.SetSSHParameters(params.gethost(),params.getuser(),params.getpass(),params.getport());
				//Get Own IP Address which where we are client to machine running Hive and SSH
				String Host = SSHClient.getIpAddress();
				//grant Privileges to client IP to connect to MYSQL DB on remote machine
				stmt.execute(MySQLClient.grantPrivileges(Host));
				//Sqoop Import Data
				SSHClient.sqoopImport(Host,MySQLClient.getport(),MySQLClient.getuser(),"\""+MySQLClient.getpass()+"\"",db_name,table_name,db_name);
				//Drop Temporary created database
				String dropQuery = "drop database "+db_name;
				stmt.execute(dropQuery);
			}
		    return "Success";
		}
		catch(Exception e){
		    return "Failed";
	    }
	}	
}
