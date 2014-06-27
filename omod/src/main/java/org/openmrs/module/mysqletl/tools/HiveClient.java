package org.openmrs.module.mysqletl.tools;

import java.sql.Connection;
import java.sql.DriverManager;

import org.openmrs.module.mysqletl.dwr.LoginParams;

public class HiveClient {
	
	private static String host, username, password, port;
	
	public static void HiveParameters(String Host, String Port, String Username, String Password){
		host = Host;
		port = Port;
		username = Username;
		password = Password;
	}
	public static void HiveParameters(LoginParams params){
		host = params.gethost();
		port = params.getport();
		username = params.getuser();
		password = params.getpass();
	}
	
	public static void setuser(String User) { username = User; }
	public static String getuser() { return username; }
	
	public static void setpass(String Pass) { password = Pass; }
	public static String getpass() { return password; }
	
	public static void sethost(String Host) { host = Host; }
	public static String gethost() { return host; }
	
	public static void setport(String Port) { port = Port; }
	public static String getport() { return port; }
	
	  private static String driverName = "org.apache.hive.jdbc.HiveDriver";
	  //ConnectionURL = "jdbc:hive2://192.168.56.102:10000"
	  public static boolean createDatabase(String Host,String Port, String Username, String Password, String DatabaseName){
	      String ConnectionURL = "jdbc:hive2://"+Host+":"+Port;
		  try {
	          Class.forName(driverName);
	        } catch (ClassNotFoundException e) {
	          // TODO Auto-generated catch block
	          e.printStackTrace();
	          return false;
	        }
	      try{
	          Connection con = DriverManager.getConnection(ConnectionURL, Username, Password);
	          try{
	        	  con.createStatement().executeQuery("create database if not exists "+DatabaseName);
	          }
	          catch(Exception e){
	        	  return true;
	          }
	  		}
	  		catch(Exception e){
	  			return false;
	  		}
	          return true;
	  }
}
