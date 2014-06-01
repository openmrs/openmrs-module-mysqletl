<%@ include file="/WEB-INF/template/include.jsp"%>
<%@ include file="/WEB-INF/template/header.jsp"%>

<%@ include file="template/localHeader.jsp"%>

<script type="text/javascript" src="<openmrs:contextPath/>/dwr/interface/DWRMySQLLoginService.js"> </script>

<script>
 function mysql_login()
 {  
	 var loginParams = {
	 user: document.getElementById('user').value,
     pass: document.getElementById('pass').value,
 	 host: document.getElementById('host').value,
 	 port: document.getElementById('port').value
	 
 	};
  	DWRMySQLLoginService.loginMySQL(loginParams, {
		  callback:function(str) { 
				 document.getElementById('change').innerHTML = str; 
			  }
			});

 }
 </script>
<p>Hello ${user.systemId}!. Welcome to MySQL Login Page</p>
<p id='change'>Click Login</p>

  <table align=center bgcolor="#f5f5f5" style="width: 316px; height: 100px">
            <tr>
                <td style="width: 184px;">
                    Username</td>
                <td style="width: 5px">
                <input type="text" name="user" id="user" style="width: 226px"></td>
                
            </tr>
            <tr>
                <td style="width: 184px; height: 1px;">
 					 Password
  				</td>
                <td style="width: 5px; height: 1px">
                <input type="password" name="pass" id="pass" style="width: 226px"></td>
                
            </tr>
            <tr>
                <td style="width: 184px;">
  					Host 
                </td>
                <td style="width: 5px">
                <input type="text" name="host" id="host" value="localhost" style="width: 227px"></td>
               
            </tr>
            <tr>
                <td style="width: 184px; height: 3px;">
 					 Port
  				</td>
                <td style="width: 5px; height: 3px">
                <input type="text" name="port" id="port" value="3306" style="width: 226px"></td>
               
            </tr>
            <tr>
                <td style="width: 184px; height: 3px;"></td>
                <td style="width: 5px; height: 3px">
                    &nbsp;<input type="submit" value="Login" name="login" onclick="mysql_login()" style="width: 86px"></td>
               
            </tr>
        </table>

<%@ include file="/WEB-INF/template/footer.jsp"%>