package org.openmrs.module.mysqletl.scheduler.tasks;

import java.util.List;

import org.openmrs.api.APIException;

import net.neoremind.sshxcute.core.ConnBean;
import net.neoremind.sshxcute.core.SSHExec;
import net.neoremind.sshxcute.exception.TaskExecFailException;
import net.neoremind.sshxcute.task.CustomTask;
import net.neoremind.sshxcute.task.impl.ExecCommand;
/*
 * Contains Scheduler Credential data
 */
public class ETLCredentials {
	
	private static String host, username, password, port;
	
	private static String sshUserName;
	private static String sshPassword;
	private static String sshHost;
	private static String sshPort;
	private static String serverType;
	private static String db_name;
	private static String table_name;
	private static List<String> column_list;
	private static String join_cndtn;
	/*
	 * SchedulerParameters sets schedulers required parameters
	 */
	public static void ETLParameters(String UserName, String Password, String Host, String Port,String SSHUserName, String SSHPassword, String SSHHost, String SSHPort, String ServerType, String DatabaseName, String TableName, List<String> ColumnList, String JoinCndtn){
		host = Host;
		port = Port;
		username = UserName;
		password = Password;
		
		sshHost = SSHHost;
		sshPort = SSHPort;
		sshUserName = SSHUserName;
		sshPassword = SSHPassword;
		
		serverType = ServerType;
		db_name = DatabaseName;
		table_name = TableName;
		column_list = ColumnList;
		join_cndtn = JoinCndtn;
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
	 * Setter and getter for sshuser
	 */
	public static void setsshuser(String SSHUser) { sshUserName = SSHUser; }
	public static String getsshuser() { return sshUserName; }

	/*
	 * Setter and getter for sshpassword
	 */
	public static void setsshpass(String SSHPass) { sshPassword = SSHPass; }
	public static String getsshpass() { return sshPassword; }
	
	/*
	 * Setter and getter for host
	 */
	public static void setsshhost(String SSHHost) { sshHost = SSHHost; }
	public static String getsshhost() { return sshHost; }
	
	/*
	 * Setter and getter for port
	 */
	public static void setsshport(String SSHPort) { sshPort = SSHPort; }
	public static String getsshport() { return sshPort; }
	
	/*
	 * Setter and getter for servertype
	 */
	public static void setservertype(String ServerType) { serverType = ServerType; }
	public static String getservertype() { return serverType; }

	/*
	 * Setter and getter for database table
	 */
	public static void setdbname(String DatabaseName) { db_name = DatabaseName; }
	public static String getdbname() { return db_name; }
	
	/*
	 * Setter and getter for database table
	 */
	public static void settablename(String TableName) { table_name = TableName; }
	public static String gettablename() { return table_name; }
	
	
	/*
	 * Setter and getter for host
	 */
	public static void setjoincondition(String JoinCondition) { join_cndtn = JoinCondition; }
	public static String getjoincondition() { return join_cndtn; }
	
	/*
	 * Setter and getter for port
	 */
	public static void setcolumnlist(List<String> ColumnList) { column_list = ColumnList; }
	public static List<String> getcolumnlist() { return column_list; }
	
	public static String toETLInfo(){
		return 	host + ": MySQLClient.gethost()\n"+
		port + ": MySQLClient.getport()\n"+
		username+ ": MySQLClient.getuser()\n"+
		password+ ": MySQLClient.getpass()\n"+
		
		sshHost+ ": SSHHost\n"+
		sshPort+ ": SSHPort\n"+
		sshUserName+ ": SSHUserName\n"+
		sshPassword+ ": SSHPassword\n"+
		
		serverType+ ": ServerType\n"+
		db_name+ ": DatabaseName\n"+
		table_name+ ": TableName\n"+
		column_list.toArray().toString()+ ": ColumnList\n"+
		join_cndtn+ ": JoinCndtn\n";
	}

	/*
	*Get IP address of SSH Client. Used in sqoop to perform extraction from server.
	*/ 
	public static String getIpAddress() throws TaskExecFailException{
		
		// Initialize a ConnBean object, parameter list is ip, username, password
		ConnBean cb = new ConnBean(sshHost, sshUserName, sshPassword);
		SSHExec ssh = SSHExec.getInstance(cb);
		ssh.connect();
		
		//echo $SSH_CLIENT get IP of the Client
		CustomTask sampleTask = new ExecCommand("echo $SSH_CLIENT");
		
		//Save Result from ssh command execution
		String Result = ssh.exec(sampleTask).sysout;
		ssh.disconnect();	
		
		//Extract IP address only from result
		return Result.substring(0,Result.indexOf(" ")).trim();
	}

	/*
	 * Sqoop Import using SSH requires MySQL & HIVE parameters
	 */
	public static void sqoopImport(String Host, String Port, String MySQLUser, String MySQLPwd, String DatabaseName, String TableName, String DatawarehouseDB) throws Exception{
		String ConnectionURL = "jdbc:mysql://"+Host+":"+Port+"/"+DatabaseName;
		
		// Initialize a ConnBean object, parameter list is ip, username, password
		ConnBean cb = new ConnBean(sshHost,sshUserName,sshPassword);
		SSHExec ssh = SSHExec.getInstance(cb);          
		ssh.connect();
		
		//Execute Sqoop
		CustomTask sampleTask = new ExecCommand("sqoop import --connect "+ConnectionURL+" --username="+MySQLUser+" --password="+MySQLPwd+" --table "+TableName+" --hive-import -m 1 -- --schema "+DatawarehouseDB);
		ssh.exec(sampleTask);
		ssh.disconnect();	
	}

	/*
	 * Grant Privileges to all Host, with MySQL db username and password
	 */
	public static String grantPrivileges(String Host) throws APIException  {
		String Query = "grant all privileges on *.* to "+username+"@'%' identified by '"+password+"'";
		return Query;
	}
	
}
