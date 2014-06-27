package org.openmrs.module.mysqletl.tools;

import org.openmrs.module.mysqletl.dwr.LoginParams;

public class MySQLClient {
	private static String host, username, password, port;
	
	public static void MySQLParameters(String Host, String Port, String Username, String Password){
		host = Host;
		port = Port;
		username = Username;
		password = Password;
	}
	public static void MySQLParameters(LoginParams params){
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
}
