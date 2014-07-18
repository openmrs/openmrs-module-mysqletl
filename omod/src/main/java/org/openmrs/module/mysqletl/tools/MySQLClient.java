package org.openmrs.module.mysqletl.tools;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.openmrs.api.APIException;
import org.openmrs.module.mysqletl.dwr.LoginParams;

/*
 * MySQLClient contains functions for access MySQL DB using JDBC
 */
public class MySQLClient {
	private static String host, username, password, port;
	
	/*
	 * MySQLParameters sets mysql jdbc connections parameters
	 */
	public static void MySQLParameters(String Host, String Port, String Username, String Password){
		host = Host;
		port = Port;
		username = Username;
		password = Password;
	}
	
	
	/*
	 * MySQLParameters sets mysql jdbc connections parameters using LoginParams class
	 */
	public static void MySQLParameters(LoginParams params){
		host = params.gethost();
		port = params.getport();
		username = params.getuser();
		password = params.getpass();
	}
	
	
	/*
	 * Converting MySQLParameters to LoginParams Object
	 */
	public static LoginParams toLoginParams(){
		LoginParams params = new LoginParams(); 
		params.setuser(username);
		params.setpass(password);
		params.sethost(host);
		params.setport(port);
		return params;
	}
	
	/*
	 * Setter and getter for user
	 */
	public static void setuser(String User) { username = User; }
	public static String getuser() { return username; }

	/*
	 * Setter and getter for password
	 */
	public static void setpass(String Pass) { password = Pass; }
	public static String getpass() { return password; }
	
	/*
	 * Setter and getter for host
	 */
	public static void sethost(String Host) { host = Host; }
	public static String gethost() { return host; }
	
	/*
	 * Setter and getter for port
	 */
	public static void setport(String Port) { port = Port; }
	public static String getport() { return port; }

	/*
	 * Grant Privileges to all Host, with MySQL db username and password
	 */
	public static String grantPrivileges(String Host) throws APIException  {
		String Query = "grant all privileges on *.* to "+username+"@'%' identified by '"+password+"'";
		return Query;
	}
	
	/*
	 * Execute User Defined Raw MySQL Queries
	 */
	public static void executeMySQLQuery(String Query) throws APIException  {
		try{ 
			Class.forName("com.mysql.jdbc.Driver");
			String connectionURL = "jdbc:mysql://"+host+":"+port+"/";
			Connection con = DriverManager.getConnection (connectionURL , username, password);
			con.createStatement().executeQuery(Query);
			return;
		}
		catch(Exception e){
		    return;
	    }
	}	
	
	/*
	 * MySQL Login return backs all database list
	 */
	public static List<String> login(LoginParams params) throws APIException  {
		List<String> arrayList = new ArrayList<String>();
		try{ 
			Class.forName("com.mysql.jdbc.Driver");
			String connectionURL = "jdbc:mysql://"+params.gethost()+":"+params.getport()+"/";
			Connection con = DriverManager.getConnection (connectionURL , params.getuser(), params.getpass());
			ResultSet rs = con.getMetaData().getCatalogs();
			while (rs.next()) {
			    arrayList.add(rs.getString("TABLE_CAT"));
			}
			MySQLClient.MySQLParameters(params); //Setting MySQL Parameters for Later Use
			return arrayList;
		}
		catch(Exception e){
		    return null;
	    }
	}
	
	/*
	 * MySQL login with specified database returns all tables name of that database
	 */
	public static List<String> getTables(LoginParams params,String db_name) throws APIException, ClassNotFoundException, SQLException  {
	    List<String> arrayList = new ArrayList<String>();
		try{ 
			Class.forName("com.mysql.jdbc.Driver");
			String connectionURL = "jdbc:mysql://"+params.gethost()+":"+params.getport()+"/"+db_name;
			Connection con = DriverManager.getConnection (connectionURL , params.getuser(), params.getpass());
			DatabaseMetaData md = con.getMetaData();
			ResultSet rsTable = md.getTables(null, null, "%", null);
			while (rsTable.next()) {
				arrayList.add(rsTable.getString(3));
			}
		    return arrayList;
		}
		catch(Exception e){
		    return null;
	    }
	}
	
	/*
	 * MySQL login with specified database, tables returns all columns name of that database, tables
	 */
	public static List<String> getColumns(LoginParams params,String db_name,String table_name) throws APIException, ClassNotFoundException, SQLException  {
	    List<String> arrayList = new ArrayList<String>();
		try{ 
			Class.forName("com.mysql.jdbc.Driver");
			String connectionURL = "jdbc:mysql://"+params.gethost()+":"+params.getport()+"/"+db_name;
			Connection con = DriverManager.getConnection (connectionURL , params.getuser(), params.getpass());
			Statement stmt = null;
			stmt = con.createStatement();
			ResultSet rs = stmt.executeQuery("SELECT * FROM "+table_name);
			ResultSetMetaData rsmd = rs.getMetaData();
			int columnCount = rsmd.getColumnCount();

			for (int i = 1; i < columnCount + 1; i++ ) {
				arrayList.add(rsmd.getColumnName(i));
			}

		    return arrayList;
		}
		catch(Exception e){
		    return null;
	    }
	}
}
