package org.openmrs.module.mysqletl.dwr;

/*
 *	Java bean object for a respective JSON Object having same definition. 
 */

public class LoginParams {
	private String user;
	private String pass;
	private String host;
	private String port;
	
	public void setuser(String User) { user = User; }
	public String getuser() { return user; }
	
	public void setpass(String Pass) { pass = Pass; }
	public String getpass() { return pass; }
	
	public void sethost(String Host) { host = Host; }
	public String gethost() { return host; }
	
	public void setport(String Port) { port = Port; }
	public String getport() { return port; }
}