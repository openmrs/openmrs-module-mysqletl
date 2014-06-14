<%@ include file="/WEB-INF/template/include.jsp"%>
<%@ include file="/WEB-INF/template/header.jsp"%>
<%@ include file="template/localHeader.jsp"%>

<!-- Tell 1.7+ versions of core to not include JQuery themselves. Also, on 1.7+ we may get different jquery and jquery-ui versions than 1.3.2 and 1.7.2 -->
<c:set var="DO_NOT_INCLUDE_JQUERY" value="true"/>

  <style type='text/css'>
    ul li {
    min-width: 200px;
}
.dragging li.ui-state-hover {
    min-width: 240px;
}
.dragging .ui-state-hover a {
    color:green !important;
    font-weight: bold;
}

.connectedSortable tr, .ui-sortable-helper {
    cursor: move;
}
.connectedSortable tr:first-child {
    cursor: default;
}
.ui-sortable-placeholder {
    background: yellow;
}
  </style>
<openmrs:htmlInclude file="/moduleResources/mysqletl/jquery.min.js" />
<openmrs:htmlInclude file="/moduleResources/mysqletl/jquery-ui.min.js" />
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
			clearHTMLTable('available-column-table');
 			clearHTMLTable('selected-column-table');	
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
						if(column_list!=null){
							//add columns in available column table
						  for(i=0; i<column_list.length;i++){
								addColumnRow(column_list[i], table_info);
								//Passing table_info results [db_name].[table_name].[column_name] so from multiple database and tables column can be selected
						  }
						}
					  }
					});			 
 }
 function addColumnRow(info,table_info){
	  var db_name = table_info.substring(0,table_info.indexOf('.'));
	  var table_name = table_info.substring(table_info.indexOf('.')+1);
	  var TABLE = document.getElementById('available-column-table');
	  var BODY = TABLE.getElementsByTagName('tbody')[0];
	  var TR = document.createElement('tr');
// 	  var checkbox = document.createElement("input");
// 	  checkbox.type = "checkbox";    // make the element a checkbox
// 	  checkbox.name = "column_check";
// 	  checkbox.value = table_info+"."+info;
// 	  TR.appendChild(checkbox);   // add the box to the element
	  var TD_DB = document.createElement('td');
	  TD_DB.innerHTML = db_name;//set only database name
	  TR.appendChild (TD_DB);
	  var TD_TABLE = document.createElement('td');
	  TD_TABLE.innerHTML = table_name;//set only table name
	  TR.appendChild (TD_TABLE);
	  var TD_COLUMN = document.createElement('td');
	  TD_COLUMN.innerHTML = info;//set only column name
	  TR.appendChild (TD_COLUMN);
	  BODY.appendChild(TR);
 }
 function transform(){
	 var loginParams = {
			 user: document.getElementById('dwuser').value,
		     pass: document.getElementById('dwpass').value,
		 	 host: document.getElementById('dwhost').value,
		 	 port: document.getElementById('dwport').value 
		 	};	 
	 var servers = document.getElementsByName('type');
	 var serverType;
	 for(var i = 0; i < servers.length; i++){
	     if(servers[i].checked){
	    	 serverType = servers[i].value;
	     }
	 }
	 var db_name = document.getElementById('dw_db').value;
	 var table_name = document.getElementById('dw_table').value;
	 
	 var table = document.getElementById('selected-column-table');
	 var column_list = [];
	 //Row 0 is for heading, start from Row 1
	 for (var i = 1, row; row = table.rows[i]; i++) {
	    //iterate through rows
	    //rows would be accessed using the "row" variable assigned in the for loop
		 column_list.push(row.cells[0].innerHTML+'.'+row.cells[1].innerHTML+'.'+row.cells[2].innerHTML);
	 }
	 DWRMySQLLoginService.goTransform(loginParams,serverType,db_name,table_name,column_list,{ 
		 callback:function(result){ 
			 //if transformation takes place without any interruption, success message will return
			 		document.getElementById('loginStatus').innerHTML = result;
					  }
					});	 
 }
 function notImplemented(){
	alert('Coming Soon');
 }
 $(window).load(function(){
	 $(document).ready(function() {

	     var $tabs=$('#selected-column-table')
	     $( "tbody.connectedSortable" )
	         .sortable({
	             connectWith: ".connectedSortable",
	             items: "> tr:not(:first)",
	             appendTo: $tabs,
	             helper:"clone",
	             zIndex: 999990
	         })
	         .disableSelection()
	     ;
	     
	     var $tab_items = $( ".nav-tabs > li", $tabs ).droppable({
	       accept: ".connectedSortable tr",
	       hoverClass: "ui-state-hover",
	       
	       drop: function( event, ui ) {
	         return false;
	       }
	     });
	     
	 });
	 });

 </script>
 <div id="mysql_log">
	<p>Hello ${user.systemId}!. Please input MySQL Login Details</p>
	<p id='change'>Click Login</p>
	 	<div style="background: #009D8E; width:'100%';" align="center">
  			<font color="#ffffff" size="4pt">
				<b>MySQL Login</b>
			</font>
		</div>
  		<table align=center bgcolor="#f5f5f5" style="width: 316px; height: 100px">
            <tr>
                <td style="width: 184px;">
                    Username
                </td>
                <td style="width: 5px">
                	<input type="text" name="user" id="user" style="width: 226px">
                </td>
                
            </tr>
            <tr>
                <td style="width: 184px; height: 1px;">
 					 Password
  				</td>
                <td style="width: 5px; height: 1px">
                	<input type="password" name="pass" id="pass" style="width: 226px">
                </td>
            </tr>
            <tr>
                <td style="width: 184px;">
  					Host 
                </td>
                <td style="width: 5px">
                	<input type="text" name="host" id="host" value="localhost" style="width: 227px">
                </td>
            </tr>
            <tr>
                <td style="width: 184px; height: 3px;">
 					 Port
  				</td>
                <td style="width: 5px; height: 3px">
                	<input type="text" name="port" id="port" value="3306" style="width: 226px">
                </td>
            </tr>
            <tr>
                <td style="width: 184px; height: 3px;"></td>
                <td style="width: 5px; height: 3px">
                    &nbsp;<input type="submit" value="Login" name="login" onclick="mysql_login()" style="width: 86px">
                </td>
            </tr>
  		</table>
</div>
<div id="db_list" style="display:none">  
	<div style="background: #009D8E; width:'100%';" align="center">
  		<font color="#ffffff" size="4pt">
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
	<div style="background: #009D8E; width:'100%';" align="center">
  		<font color="#ffffff" size="4pt">
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
	<div style="background: #009D8E; width:'100%';" align="center">
  		<font color="#ffffff" size="4pt">
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
   			<table>
   				<th>
            		<table id='available-column-table' align=center bgcolor="#f5f5f5">  
                		<tbody class="connectedSortable">  
                    		<tr>
                        		<th>Available columns</th>
                    		</tr> 
                		</tbody> 
            		</table>
            	</th>
            	<th>
            		<table id='selected-column-table' align=center bgcolor="#f5f5f5">  
                		<tbody class="connectedSortable">  
                    		<tr>
                        		<th>Selected Column</th>    
                    		</tr> 
                		</tbody> 
            		</table>
            	</th> 
   			</table>
  		<input type="button" onclick="show('dw_log','column_list');" value="Next" />
		</div>
	</center>
    <a href="#" onclick="show('table_list','column_list');">Back</a>
</div>    
<div id="dw_log" style="display:none">
	<div style="background: #009D8E; width:'100%';" align="center">
  		<font color="#ffffff" size="4pt">
			<b>Datawarehouse Login</b>
		</font>
	</div>
	<div  align="center">
		<input type="radio" name="type" value="mysql" checked="true">MySQL
		<input type="radio" name="type" value="hive2">Hive Server 2
		<input type="radio" name="type" value="hive">Hive Server
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
                	<input type="text" name="port" id="dwport" value="10000" style="width: 226px">
                </td> 
            </tr>
            <tr>
                <td style="width: 184px; height: 3px;">
					Database
  				</td>
                <td style="width: 5px; height: 3px">
                	<input type="text" name="datawarehouse_db" id="dw_db" value="dw_db" style="width: 226px">
                </td> 
            </tr>
            <tr>
                <td style="width: 184px; height: 3px;">
					Table
  				</td>
                <td style="width: 5px; height: 3px">
                	<input type="text" name="datawarehouse_table" id="dw_table" value="dw_table" style="width: 226px">
                </td> 
            </tr>
            <tr>
                <td style="width: 184px; height: 3px;">
                	<div id='loginStatus'>
                		Status
                	</div>
                </td>
                <td style="width: 5px; height: 3px">
                    &nbsp;<input type="submit" value="Load" name="login" onclick="transform()" style="width: 86px">
                </td>
            </tr>
        </table>
    	<a href="#" onclick="show('column_list','dw_log');">Back</a>
</div>
<%@ include file="/WEB-INF/template/footer.jsp"%>