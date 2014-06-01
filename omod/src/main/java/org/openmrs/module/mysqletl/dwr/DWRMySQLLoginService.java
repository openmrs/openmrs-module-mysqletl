package org.openmrs.module.mysqletl.dwr;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.api.APIException;

public class DWRMySQLLoginService {
	private static final Log log = LogFactory.getLog(DWRMySQLLoginService.class);
	
	public static String loginMySQL(LoginParams params) throws APIException  {
	    if(params.getuser().equals("admin")==true && params.getpass().equals("test")==true) return "Successful Login";
		return "Login Attempt Failed";
	}
}
