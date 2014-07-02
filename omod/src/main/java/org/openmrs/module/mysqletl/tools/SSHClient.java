package org.openmrs.module.mysqletl.tools;

import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

import org.openmrs.module.mysqletl.dwr.LoginParams;

import net.neoremind.sshxcute.core.ConnBean;
import net.neoremind.sshxcute.core.Result;
import net.neoremind.sshxcute.core.SSHExec;
import net.neoremind.sshxcute.exception.TaskExecFailException;
import net.neoremind.sshxcute.task.CustomTask;
import net.neoremind.sshxcute.task.impl.ExecCommand;

public class SSHClient {
	private static String host, username, password, port;
	
	public static void SetSSHParameters(String Host, String Username, String Password){
		host = Host;
		username = Username;
		password = Password;
		port = "22"; // Should change to dynamic later, it is default in many case
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
	//This will recieve the results in a 2-D array for the HiveQueries made in the module
	public static String[][] getQueryResult(String Query) throws Exception{
		ConnBean cb = new ConnBean(host, username,password);
		SSHExec ssh = SSHExec.getInstance(cb);          
		ssh.connect();
		//Resultant 2-D array will include column name with row data
		//Query trimming for executing batch statement
		CustomTask sampleTask = new ExecCommand("hive -e 'set hive.cli.print.header=true; "+Query.trim().replace('\n', ' ')+"' -S");
		Result res = ssh.exec(sampleTask);
		if(res.isSuccess){
	        System.out.println("Return code: " + res.rc);
	        //System.out.println("sysout: " + res.sysout);
	        //simply outputting text
	        PrintWriter out = new PrintWriter("hivedata.tsv");
	        //write String to it, just like you would to any output stream:
	        out.println(res.sysout);
	        out.close();
	        // Create Array From the tsv data
	        String[][] resultArray;
	        List<String> lines = Files.readAllLines(Paths.get("hivedata.tsv"), StandardCharsets.UTF_8);
	        //lines.removeAll(Arrays.asList("", null)); // <- remove empty lines

	        resultArray = new String[lines.size()][]; 

	        for(int i =0; i<lines.size(); i++){
	          resultArray[i] = lines.get(i).split("\t"); //tab-separated
	        }
			ssh.disconnect();
			return resultArray;
		}
	    else
	    {
	        System.out.println("Return code: " + res.rc);
	        System.out.println("error message: " + res.error_msg);
			ssh.disconnect();	
	        return null;
	    }

	}
	public static String login(LoginParams params) {
		try{
			SetSSHParameters(params.gethost(),params.getuser(),params.getpass());
			ConnBean cb = new ConnBean(params.gethost(),params.getuser(),params.getpass());
			SSHExec ssh = SSHExec.getInstance(cb);
			ssh.connect();
			CustomTask sampleTask = new ExecCommand("echo test");
			Result res = ssh.exec(sampleTask);
			if(res.isSuccess){
				ssh.disconnect();
				return String.valueOf(res.rc);
			}
			else {
					try{ssh.disconnect();}
					catch(Exception e){	return e.getMessage();};
					return res.error_msg;
				}
		}
		catch(Exception e){
			return e.getMessage();
		}
		// TODO Auto-generated method stub
	}
}
