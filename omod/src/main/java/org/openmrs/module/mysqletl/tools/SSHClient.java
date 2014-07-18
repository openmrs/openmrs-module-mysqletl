package org.openmrs.module.mysqletl.tools;

import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

import net.neoremind.sshxcute.core.ConnBean;
import net.neoremind.sshxcute.core.IOptionName;
import net.neoremind.sshxcute.core.Result;
import net.neoremind.sshxcute.core.SSHExec;
import net.neoremind.sshxcute.exception.TaskExecFailException;
import net.neoremind.sshxcute.task.CustomTask;
import net.neoremind.sshxcute.task.impl.ExecCommand;

import org.openmrs.module.mysqletl.dwr.LoginParams;

/*
 * SSHClient contains all then function which execute commands on ssh server using SSHXCUTE Library. 
 */
public class SSHClient {
	
	/*
	*SSH parameters
	*/
	private static String host, username, password, port;
	
	/*
	*Initialize ssh parameters with arguments
	*/
	public static void SetSSHParameters(String Host, String Username, String Password, String Port){
		host = Host;
		username = Username;
		password = Password;
		port = Port;
		SSHExec.setOption(IOptionName.SSH_PORT_NUMBER, Integer.parseInt(port));
	}
	
	/*
	*Get IP address of SSH Client. Used in sqoop to perform extraction from server.
	*/ 
	public static String getIpAddress() throws TaskExecFailException{
		
		// Initialize a ConnBean object, parameter list is ip, username, password
		ConnBean cb = new ConnBean(host, username, password);
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
		ConnBean cb = new ConnBean(host,username,password);
		SSHExec ssh = SSHExec.getInstance(cb);          
		ssh.connect();
		
		//Execute Sqoop
		CustomTask sampleTask = new ExecCommand("sqoop import --connect "+ConnectionURL+" --username="+MySQLUser+" --password="+MySQLPwd+" --table "+TableName+" --hive-import -m 1 -- --schema "+DatawarehouseDB);
		ssh.exec(sampleTask);
		ssh.disconnect();	
	}
	
	/*
	*This will recieve the results in a 2-D array for the HiveQueries made in the module
	*/
	public static String[][] getQueryResult(String Query) throws Exception{
		ConnBean cb = new ConnBean(host, username,password);
		SSHExec ssh = SSHExec.getInstance(cb);          
		ssh.connect();
		
		//Resultant 2-D array will include column name with row data
		
		//Query trimming for executing batch statement
		CustomTask sampleTask = new ExecCommand("hive -e 'set hive.cli.print.header=true; "+Query.trim().replace('\n', ' ')+"' -S");
		Result res = ssh.exec(sampleTask);
		if(res.isSuccess){
			String ModulePath = "tomcat/webapps/openmrs-standalone/WEB-INF/view/module/mysqletl/resources/"; 
	        
			//saving data as tsv & csv
	        PrintWriter out = new PrintWriter(ModulePath+"download.tsv");
	        
	        //write String to it, just like you would to any output stream:
	        out.println(res.sysout);
	        out.close();
	        out = new PrintWriter(ModulePath+"download.csv");
	        
	        //Converting tsv data to csv data
	        out.println(res.sysout.replace('\t', ','));
	        out.close();
	        
	        // Create Array From the tsv data
	        String[][] resultArray;
	        List<String> lines = Files.readAllLines(Paths.get(ModulePath+"download.tsv"), StandardCharsets.UTF_8);
	        
	        //lines.removeAll(Arrays.asList("", null)); // <- remove empty lines
	        resultArray = new String[lines.size()][]; 

	        for(int i =0; i<lines.size(); i++){
	          resultArray[i] = lines.get(i).split("\t");	//tab-separated
	        }
			ssh.disconnect();
			return resultArray;
		}
	    else
	    {
	    	//Get Error code and message from ssh in case of error.
	        System.out.println("Return code: " + res.rc);
	        System.out.println("error message: " + res.error_msg);
			ssh.disconnect();	
	        return null;
	    }

	}
	
	/*
	 * SSH Login Test
	 */
	public static String login(LoginParams params) {
		try{
			SetSSHParameters(params.gethost(),params.getuser(),params.getpass(),params.getport());
			ConnBean cb = new ConnBean(host,username,password);
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
	
	/*
	 * Execute user defined command using ssh
	 */
	public static void execCommand(String Command) throws TaskExecFailException{
		ConnBean cb = new ConnBean(host, username,password);
		SSHExec ssh = SSHExec.getInstance(cb);          
		ssh.connect();
		CustomTask sampleTask = new ExecCommand(Command);
		Result res = ssh.exec(sampleTask);
		if(res.isSuccess){
	        System.out.println("Return code: " + res.rc);
	        System.out.println("sysout: " + res.sysout);
		}
	    else
	    {
	        System.out.println("Return code: " + res.rc);
	        System.out.println("error message: " + res.error_msg);
	    }
		ssh.disconnect();	
	}
	
	/*
	 * Get Hive Query result using SSH
	 */
	public static String getQueryResultDownload(String Query) throws TaskExecFailException, FileNotFoundException {
		ConnBean cb = new ConnBean(host, username,password);
		SSHExec ssh = SSHExec.getInstance(cb);          
		ssh.connect();
		
		//Resultant 2-D array will include column name with row data
		
		//Query trimming for executing batch statement
		CustomTask sampleTask = new ExecCommand("hive -e 'set hive.cli.print.header=true; "+Query.trim().replace('\n', ' ')+"' -S");
		Result res = ssh.exec(sampleTask);
		if(res.isSuccess){
			String ModulePath = "tomcat/webapps/openmrs-standalone/WEB-INF/view/module/mysqletl/resources/"; 
	        
			//Download data as tsv
	        PrintWriter out;
	        out = new PrintWriter(ModulePath+"download.tsv");
	        out.println(res.sysout);
	        out.close();
			ssh.disconnect();
			return "/openmrs-standalone/moduleResources/mysqletl/download.tsv";
		}
	    else
	    {
	        System.out.println("Return code: " + res.rc);
	        System.out.println("error message: " + res.error_msg);
			ssh.disconnect();	
	        return null;
	    }
	}
}
