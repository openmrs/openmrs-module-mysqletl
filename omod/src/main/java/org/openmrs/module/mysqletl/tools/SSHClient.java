package org.openmrs.module.mysqletl.tools;

import net.neoremind.sshxcute.core.ConnBean;
import net.neoremind.sshxcute.core.SSHExec;
import net.neoremind.sshxcute.exception.TaskExecFailException;
import net.neoremind.sshxcute.task.CustomTask;
import net.neoremind.sshxcute.task.impl.ExecCommand;

public class SSHClient {
	private static String host, username, password;
	
	public static void SetSSHParameters(String Host, String Username, String Password){
		host = Host;
		username = Username;
		password = Password;
	}
	public static String getIpAddress() throws TaskExecFailException{
		ConnBean cb = new ConnBean(host, username, password);
		SSHExec ssh = SSHExec.getInstance(cb);
		ssh.connect();
		CustomTask sampleTask = new ExecCommand("echo $SSH_CLIENT");
		String Result = ssh.exec(sampleTask).sysout;
		ssh.disconnect();	
		return Result.substring(0,Result.indexOf(" ")).trim();
	}
	public static void sqoopImport(String Host, String Port, String MySQLUser, String MySQLPwd, String DatabaseName, String TableName, String DatawarehouseDB) throws Exception{
		String ConnectionURL = "jdbc:mysql://"+Host+":"+Port+"/"+DatabaseName;
		// Initialize a ConnBean object, parameter list is ip, username, password
		ConnBean cb = new ConnBean(host, username,password);
		SSHExec ssh = SSHExec.getInstance(cb);          
		ssh.connect();
		CustomTask sampleTask = new ExecCommand("sqoop import --connect "+ConnectionURL+" --username="+MySQLUser+" --password="+MySQLPwd+" --table "+TableName+" --hive-import -m 1 -- --schema "+DatawarehouseDB);
		ssh.exec(sampleTask);
		ssh.disconnect();	
	}
}
