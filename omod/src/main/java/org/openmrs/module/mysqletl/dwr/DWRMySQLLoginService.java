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

public class DWRMySQLLoginService {
	
	public List<String> loginMySQL(LoginParams params) throws APIException  {
	    List<String> arrayList = new ArrayList<String>();
		try{ 
			Class.forName("com.mysql.jdbc.Driver");
			String connectionURL = "jdbc:mysql://"+params.gethost()+":"+params.getport()+"/";
			Connection con = DriverManager.getConnection (connectionURL , params.getuser(), params.getpass());
			ResultSet rs = con.getMetaData().getCatalogs();
			while (rs.next()) {
			    arrayList.add(rs.getString("TABLE_CAT"));
			}
		    return arrayList;
		}
		catch(Exception e){
		    return null;
	    }
	}
	public List<String> getTables(LoginParams params,String db_name) throws APIException, ClassNotFoundException, SQLException  {
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
	public List<String> getColumns(LoginParams params,String db_name,String table_name) throws APIException, ClassNotFoundException, SQLException  {
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
	public String goTransform(LoginParams params,String serverType,String db_name,String table_name,List<String> column_list) throws APIException  {
		try{ 
			Class.forName("com.mysql.jdbc.Driver");
			String connectionURL = "jdbc:mysql://"+params.gethost()+":"+params.getport()+"/";
			Connection con = DriverManager.getConnection (connectionURL , params.getuser(), params.getpass());

			List<String> tableListWithDuplicates = new ArrayList<String>();
			for(String column : column_list){
				tableListWithDuplicates.add(column.substring(0,column.indexOf('.', column.indexOf('.')+1)));
			}
			List<String> tableList = new ArrayList<String>(new HashSet<String>(tableListWithDuplicates));
			Statement stmt = null;
			stmt = con.createStatement();
			String create_query = "create database if not exists "+db_name;
			stmt.execute(create_query);
			String query = "CREATE TABLE "+db_name+"."+table_name+" AS SELECT "+column_list.toString().substring(1, column_list.toString().length()-1)+" FROM "+tableList.toString().substring(1, tableList.toString().length()-1);
			stmt.execute(query);
		    return "Success";
		}
		catch(Exception e){
		    return "Failed";
	    }
	}
}
