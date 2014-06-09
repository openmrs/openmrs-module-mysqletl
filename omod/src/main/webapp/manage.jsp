<%@ include file="/WEB-INF/template/include.jsp"%>
<%@ include file="/WEB-INF/template/header.jsp"%>

<%@ include file="template/localHeader.jsp"%>

<script type="text/javascript" src="<openmrs:contextPath/>/dwr/interface/DWRMySQLLoginService.js"> </script>

<script>
 function show(shown, hidden){
	  document.getElementById(shown).style.display='block';
	  document.getElementById(hidden).style.display='none';
 }
 function clearHTMLTable(tableID){
		var table = document.getElementById(tableID);
		for(var i = table.rows.length - 1; i > 0; i--)
		{
	    	table.deleteRow(i);
		}
 }
 // Pass the checkbox name to the function 
 function getCheckedBoxes(chkboxName) {
	  var checkboxes = document.getElementsByName(chkboxName);
	  var checkboxesChecked = [];
	  // loop over them all
	  for (var i=0; i<checkboxes.length; i++) {
	     // And stick the checked ones onto an array...
	     if (checkboxes[i].checked) {
	        checkboxesChecked.push(checkboxes[i]);
	     }
	  }
	  // Return the array if it is non-empty, or null
	  return checkboxesChecked.length > 0 ? checkboxesChecked : null;
 }
 function mysql_login(){  
	 var loginParams = {
	 user: document.getElementById('user').value,
     pass: document.getElementById('pass').value,
 	 host: document.getElementById('host').value,
 	 port: document.getElementById('port').value
	 
 	};
  	DWRMySQLLoginService.loginMySQL(loginParams,{
		  callback:function(db_list) { 
				if(db_list!=null){
				  clearHTMLTable('db_table');
				  for(i=0; i<db_list.length;i++){
					addDatabaseRow(db_list[i]);
		 		  }
				  show('db_list','mysql_log');
				}else{
					document.getElementById('change').innerHTML = 'Login Failed';
				}
			  }
			});
 }
 function addDatabaseRow(info){
	  var TABLE = document.getElementById('db_table');
	  var BODY = TABLE.getElementsByTagName('tbody')[0];
	  var TR = document.createElement('tr');
	  var TD = document.createElement('td');
	  TD.innerHTML =      '<a href="#" onclick="clickDatabase(\''+info+'\');">'+info+'</a>';
	  TR.appendChild (TD);
	  BODY.appendChild(TR);
 }
 function addTableRow(info,db_info){
	  var TABLE = document.getElementById('table_table');
	  var BODY = TABLE.getElementsByTagName('tbody')[0];
	  var TR = document.createElement('tr');
	  var TD = document.createElement('td');
	  var checkbox = document.createElement("input");
	  checkbox.type = "checkbox";    // make the element a checkbox
	  checkbox.name = "table_check"; 
	  checkbox.value = db_info+"."+info;     // give it a name we can check on the server side
	  TR.appendChild(checkbox);   // add the box to the element
	  TD.innerHTML =      '<a href="#" onclick="return clickTable(\''+info+'\');">'+info+'</a>';
	  TR.appendChild (TD);
	  BODY.appendChild(TR);
 }
 function clickDatabase(db_name){
	 var loginParams = {
			 user: document.getElementById('user').value,
		     pass: document.getElementById('pass').value,
		 	 host: document.getElementById('host').value,
		 	 port: document.getElementById('port').value 
		 	};	 
	 DWRMySQLLoginService.getTables(loginParams,db_name,{
		 		callback:function(table_list){ 
	     				show('table_list','db_list');				
    	 				clearHTMLTable('table_table');				
						if(table_list!=null){
						  for(i=0; i<table_list.length;i++){
								addTableRow(table_list[i],db_name);
						  }
						}
					  }
					});
			 
 }
 function selectTables(){
		var checkedBoxes = getCheckedBoxes("table_check");
		if(checkedBoxes==null){ alert("None Table Selected"); }
		else{
			for(i=0;i<checkedBoxes.length;i++){
				clickTable(checkedBoxes[i].value);
			}
		}
	 
 }
 function clickTable(table_info){
	 var loginParams = {
			 user: document.getElementById('user').value,
		     pass: document.getElementById('pass').value,
		 	 host: document.getElementById('host').value,
		 	 port: document.getElementById('port').value 
		 	};	 
	 var db_name = table_info.substring(0,table_info.indexOf('.'));
	 var table_name = table_info.substring(table_info.indexOf('.')+1);
	 DWRMySQLLoginService.getColumns(loginParams,db_name,table_name,{ 
		 callback:function(column_list){ 
	     				show('column_list','table_list');				
    	 				clearHTMLTable('column_table');				
						if(column_list!=null){
						  for(i=0; i<column_list.length;i++){
								addColumnRow(column_list[i], table_name);
						  }
						}
					  }
					});			 
 }
 function addColumnRow(info,table_info){
	  var TABLE = document.getElementById('column_table');
	  var BODY = TABLE.getElementsByTagName('tbody')[0];
	  var TR = document.createElement('tr');
	  var TD = document.createElement('td');
	  var checkbox = document.createElement("input");
	  checkbox.type = "checkbox";    // make the element a checkbox
	  checkbox.name = "column_check";
	  checkbox.value = table_info+"."+info;
	  TR.appendChild(checkbox);   // add the box to the element
	  TD.innerHTML = info;
	  TR.appendChild (TD);
	  BODY.appendChild(TR);
 }
 function notImplemented(){
	alert('Coming Soon');
 }
 </script>
 <div id="mysql_log">
	<p>Hello ${user.systemId}!. Please input MySQL Login Details</p>
	<p id='change'>Click Login</p>
	 	<div style="background: #cf2255; width:'100%';" align="center">
  			<font color="#ffffcc" size="12pt">
				<b>MySQL Login</b>
			</font>
		</div>
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
</div>
<div id="db_list" style="display:none">  
	<div style="background: #cf2255; width:'100%';" align="center">
  		<font color="#ffffcc" size="12pt">
			<b>Existing Database</b>
  		</font>
 	</div>
 
 	<center>
  		<div style="background: #ffffcc; width:'100%';" align="center">
   		<table id="db_table" align=center bgcolor="#f5f5f5">
      		<tr>
         		<td width="50%">Select Databases</td>
      		</tr>
   		</table>
 		</div>
	</center>
    <a href="#" onclick="show('mysql_log','db_list');">Back</a>
</div>
<div id="table_list" style="display:none">
	<div style="background: #cf2255; width:'100%';" align="center">
  		<font color="#ffffcc" size="12pt">
			<b>Existing Tables</b>
 		</font>
	</div>
 	<center>
  		<div style="background: #ffffcc; width:'100%';" align="center">
   			<table id="table_table" align=center bgcolor="#f5f5f5">
      			<tr>
         			<td width="50%">Select Tables</td>
      			</tr>
   			</table>
 		<input type="button" onclick="selectTables();" value="Next" />
 		</div>
	</center>
    <a href="#" onclick="show('db_list','table_list');">Back</a>
</div>
<div id="column_list" style="display:none">    
	<div style="background: #cf2255; width:'100%';" align="center">
  		<font color="#ffffcc" size="12pt">
			<b>Existing Columns</b>
  		</font>
 	</div>
	<center>
  		<div style="background: #ffffcc; width:'100%';" align="center">
   			<table id="column_table" align=center bgcolor="#f5f5f5">
      			<tr>
         			<td width="50%">Select Columns</td>
      			</tr>
   			</table>
  		<input type="button" onclick="show('dw_log','column_list');" value="Next" />
		</div>
	</center>
    <a href="#" onclick="show('table_list','column_list');">Back</a>
</div>    
<div id="dw_log" style="display:none">
	<div style="background: #cf2255; width:'100%';" align="center">
  		<font color="#ffffcc" size="12pt">
			<b>Datawarehouse Login</b>
		</font>
	</div>
  	<table align=center bgcolor="#f5f5f5" style="width: 316px; height: 100px">
            <tr>
                <td style="width: 184px;">
                    Username
                </td>
                <td style="width: 5px">
                	<input type="text" name="user" id="dwuser" style="width: 226px">
                </td> 
            </tr>
            <tr>
                <td style="width: 184px; height: 1px;">
  					Password
  				</td>
                <td style="width: 5px; height: 1px">
                	<input type="password" name="pass" id="dwpass" style="width: 226px">
                </td>
            </tr>
            <tr>
                <td style="width: 184px;">
					Host 
                </td>
                <td style="width: 5px">
                	<input type="text" name="host" id="dwhost" value="localhost" style="width: 227px">
                </td>
            </tr>
            <tr>
                <td style="width: 184px; height: 3px;">
					Port
  				</td>
                <td style="width: 5px; height: 3px">
                	<input type="text" name="port" id="dwport" value="3306" style="width: 226px">
                </td> 
            </tr>
            <tr>
                <td style="width: 184px; height: 3px;">
                	<div id='loginStatus'>
                		Status
                	</div>
                </td>
                <td style="width: 5px; height: 3px">
                    &nbsp;<input type="submit" value="Login" name="login" onclick="notImplemented()" style="width: 86px">
                </td>
            </tr>
        </table>
    	<a href="#" onclick="show('column_list','dw_log');">Back</a>
</div>
<%@ include file="/WEB-INF/template/footer.jsp"%>