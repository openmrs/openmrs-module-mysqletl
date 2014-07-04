<%@ include file="/WEB-INF/template/include.jsp"%>
<%@ include file="/WEB-INF/template/header.jsp"%>
<%@ include file="template/localHeader.jsp"%>

<!-- Tell 1.7+ versions of core to not include JQuery themselves. Also, on 1.7+ we may get different jquery and jquery-ui versions than 1.3.2 and 1.7.2 -->
<c:set var="DO_NOT_INCLUDE_JQUERY" value="true"/>

<openmrs:htmlInclude file="/moduleResources/mysqletl/lib/control/progressbar.min.js"/>
<openmrs:htmlInclude file="/moduleResources/mysqletl/lib/jquery.min.js" />
<openmrs:htmlInclude file="/moduleResources/mysqletl/lib/jquery-ui.min.js" />
<openmrs:htmlInclude file="/moduleResources/mysqletl/css/lib/control/progressbar.css" />

<openmrs:htmlInclude file="/moduleResources/mysqletl/module_style.css"/>
<openmrs:htmlInclude file="/moduleResources/mysqletl/module_js.js"/>
<script type="text/javascript" src="<openmrs:contextPath/>/dwr/interface/DWRMySQLLoginService.js"> </script>

 <div id="mysql_log" style="border:1px solid  #009D8E;">
	 	<div style="background: #009D8E; width:'100%';border:1px solid  #009D8E;" align="center">
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
                	<input type="text" name="user" id="user" value="openmrs" style="width: 226px">
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
  		<a href="#" onclick="show('hive_query_page','mysql_log');">Skip to Hive Query</a>
</div>
<div id="db_list" style="display:none;border:1px solid  #009D8E;">  
	<div style="background: #009D8E; width:'100%';border:1px solid  #009D8E;" align="center">
  		<font color="#ffffff" size="4pt">
			<b>Existing Database</b>
  		</font>
 	</div>
 	<br>
 	<center>
  		<div align="center" style="height:300px;overflow:auto;margin-top:20px;">
   		<table id="db_table" align=center class="CSSTableGenerator">
      		<tr>
      		</tr>
   		</table>
 		</div>
 		 <br><input type="button" onclick="selectDatabases();" value="Next" />
	</center>
    <a href="#" onclick="show('mysql_log','db_list');">Back</a>
</div>
<div id="table_list" style="display:none;border:1px solid  #009D8E;">
	<div style="background: #009D8E; width:'100%';border:1px solid  #009D8E;" align="center">
  		<font color="#ffffff" size="4pt">
			<b>Existing Tables</b>
 		</font>
	</div>
 	<center>
  		<div align="center" style="height:300px;overflow:auto;margin-top:20px;"><br>
   			<table id="table_table" align=center class="CSSTableGenerator">
      			<tr>
      			</tr>
   			</table>
 		</div>
 		<br><input type="button" onclick="selectTables();" value="Next" />
	</center>
    <a href="#" onclick="show('db_list','table_list');">Back</a>
</div>
<div id="column_list" style="display:none;border:1px solid  #009D8E;">    
	<div style="background: #009D8E; width:'100%';border:1px solid  #009D8E;" align="center">
  		<font color="#ffffff" size="4pt">
			<b>Existing Columns</b>
  		</font>
 	</div>
	<center>
  		<div style="background: #ffffcc; width:'100%';" align="center">
   			<table id="column_table" align=center bgcolor="#f5f5f5"  class="CSSTableGenerator">
      			<tr>
      			</tr>
   			</table>
   			<table>
   				<th>
            		<table id='available-column-table' align=right bgcolor="#f5f5f5">  
                		<tbody class="connectedSortable">  
                    		<tr id='dragRow' align="center">    
                  				  <th id='dragRow' align="right">Database</th> 
                  				  <th id='dragRow' align="right">Table</th>   
                  				  <th id='dragRow' align="right">Available Column</th>   
                    		</tr> 
                		</tbody> 
            		</table>
            	</th>
            	<th>
            		<table id='selected-column-table' align=right bgcolor="#f5f5f5">  
                		<tbody class="connectedSortable">  
                    		<tr id='dragRow' align="center">    
                  				  <th id='dragRow' align="right">Database</th> 
                  				  <th id='dragRow' align="right">Table</th>   
                  				  <th id='dragRow' align="right">Available Column</th>   
                    		</tr> 
                		</tbody> 
            		</table>
            	</th> 
   			</table>
  		<input type="button" onclick="joinConditionPage();" value="Next" />
		</div>
	</center>
    <a href="#" onclick="show('table_list','column_list');">Back</a>
</div>    
<div id="join_list" style="display:none;border:1px solid  #009D8E;">    
	<div style="background: #009D8E; width:'100%';border:1px solid  #009D8E;" align="center">
  		<font color="#ffffff" size="4pt">
			<b>Existing Columns</b>
  		</font>
 	</div>
	<center>
  		<div style="background: #ffffcc; width:'100%';" align="center">
   			<table id="join_head" align=center bgcolor="#f5f5f5">
      			<tr>
         			<td width="100%">Join Condition</td>
      			</tr>
   			</table>
   			<table>
   				<th>
            		<table id='join-conditions' align=right bgcolor="#f5f5f5">  
                		<tbody  class="joinSortable" id='join-add'>  
                    		<tr id='dragRow' align="center">    
                  				  <th id='dragRow' align="right">Type of JOIN</th> 
                  				  <th id='dragRow' align="right">Table</th> 
                  				  <th id='dragRow' align="right">ON Condition</th> 
                  				  <th id='dragRow' align="right">Clause</th>    
                    		</tr>
                     		<tr>
                      			  <th>
 									<select id='joinSelect'>
  										<option value="JOIN">JOIN</option>
  										<option value="INNER JOIN">INNER JOIN</option>
  										<option value="LEFT JOIN">LEFT JOIN</option>
  										<option value="LEFT OUTER JOIN">LEFT OUTER JOIN</option>
  										<option value="RIGHT JOIN">RIGHT JOIN</option>
  										<option value="RIGHT OUTER JOIN">RIGHT OUTER JOIN</option>
  										<option value="FULL OUTER JOIN">FULL OUTER JOIN</option>
  									</select> 
   				                  </th>
                      			  <th>
									<select id='tableSelect'>
									</select> 
								  </th>
                    			  <th>
                    				<input type="text" name="onCondition" id='onCondition'>
                    			  </th>
                    			  <th>
                    				<input type="text" name="clause" id='clauseStmt'>
                    			  </th>
                    		</tr> 
                		</tbody> 
            		</table>
            	</th>
            	<th>
					<input type="button" name="add-condition" value="Add Condition" id='addCondtn' onClick='addJoinCondition();'>
					<input type="button" name="show-condition" value="Show Statement" id='showCondtn' onClick='showJoinStatement();'>
            	</th> 
   			</table>
   		<div id='show-statement'></div>
  		<input type="button" onclick="show('dw_log','join_list');" value="Next" />
		</div>
	</center>
    <a href="#" onclick="show('column_list','join_list');">Back</a>
</div> 
<div id="dw_log" style="display:none;border:1px solid  #009D8E;">
	<div style="background: #009D8E; width:'100%';border:1px solid  #009D8E;" align="center">
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
                	<input type="text" name="user" id="dwuser" value="root" style="width: 226px">
                </td> 
            </tr>
            <tr>
                <td style="width: 184px; height: 1px;">
  					Password
  				</td>
                <td style="width: 5px; height: 1px">
                	<input type="password" name="pass" id="dwpass" value="hadoop" style="width: 226px">
                </td>
            </tr>
            <tr>
                <td style="width: 184px;">
					SSH Host 
                </td>
                <td style="width: 5px">
                	<input type="text" name="host" id="dwhost" value="localhost" style="width: 227px">
                </td>
            </tr>
            <tr>
                <td style="width: 184px; height: 3px;">
					SSH Port
  				</td>
                <td style="width: 5px; height: 3px">
                	<input type="text" name="port" id="dwport" value="22" style="width: 226px">
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
                </td>
                <td style="width: 5px; height: 3px">
                    &nbsp;<input type="submit" value="Load" name="login" onclick="transform()" style="width: 86px">
                </td>
            </tr>
        </table>
    	<a href="#" onclick="show('join_list','dw_log');">Back</a>
</div>
<div id="process_status" style="display:noneborder:1px solid  #009D8E;">
	<div style="background: #009D8E; width:'100%';border:1px solid  #009D8E;" align="center">
  		<font color="#ffffff" size="4pt">
			<b>Status</b>
		</font>
	</div>
	<div id="showProgressBar" align="center">
	    <div id="my-progressbar-container"  align="center">
            
            <div id="my-progressbar-text1" class="progressbar-text top-left">Initializing...</div>
            <div id="my-progressbar-text2" class="progressbar-text top-right"></div>
            
            <div id="my-progressbar"></div>
            
            <div id="my-progressbar-text3" class="progressbar-text bottom-left"></div>
            <div id="my-progressbar-text4" class="progressbar-text bottom-right"></div>
        
        </div>
    </div>
     	<a href="#" onclick="show('dw_log','process_status');">Back</a>
</div>
<div id="hive_query_page" style="display:none;border:1px solid  #009D8E;">
	<div style="background: #009D8E; width:'100%';border:1px solid  #009D8E;" align="center">
  		<font color="#ffffff" size="4pt">
			<b>Hive Login</b>
		</font>
	</div>
	<div align="center">

  	<table align=center bgcolor="#f5f5f5" style="width: 316px; height: 100px">
            <tr>
                <td style="width: 184px;">
                    Username
                </td>
                <td style="width: 5px">
                	<input type="text" name="user" id="hiveuser" value="root" style="width: 226px">
                </td> 
            </tr>
            <tr>
                <td style="width: 184px; height: 1px;">
  					Password
  				</td>
                <td style="width: 5px; height: 1px">
                	<input type="password" name="pass" id="hivepass" value="hadoop" style="width: 226px">
                </td>
            </tr>
            <tr>
                <td style="width: 184px;">
					SSH Host 
                </td>
                <td style="width: 5px">
                	<input type="text" name="host" id="hivehost" value="localhost" style="width: 227px">
                </td>
            </tr>
            <tr>
                <td style="width: 184px; height: 3px;">
					SSH Port
  				</td>
                <td style="width: 5px; height: 3px">
                	<input type="text" name="port" id="hiveport" value="22" style="width: 226px">
                </td> 
            </tr>

            <tr>
                <td style="width: 184px; height: 3px;">
                </td>
                <td style="width: 5px; height: 3px">
                    &nbsp;<input type="submit" value="Login" name="login" onclick="hive_login();" style="width: 86px">
                </td>
            </tr>
        </table>
    </div>
     	<a href="#" onclick="show('mysql_log','hive_query_page');">Back</a>
</div>
<div id="hive_query_editor" style="display:none;border:1px solid  #009D8E;">
	<div style="background: #009D8E; width:'100%';border:1px solid  #009D8E;" align="center">
  		<font color="#ffffff" size="4pt">
			<b>Query Editor</b>
		</font>
	</div>
	<div align="center">
		<textarea name="queryholder" id="queryholder" cols="100" rows="20"></textarea>
		<div align="center">
			<input type='button' onclick='hive_query();' value='Execute Query'/>
			<input type='button' onclick='notImplemented();' value='Save Query'/>
			<input type='button' onclick='notImplemented();' value='Load Query'/>
		</div>
		<h2 align="center">Logs</h2>
		<textarea align="center" name="querylogs" id="querylogs" cols="100" rows="5" disabled="true"></textarea>
	</div>
     	<a href="#" onclick="show('hive_query_page','hive_query_editor');">Back</a>
</div>
<div id="hive_data" style="display:none;border:1px solid  #009D8E;">
	<div style="background: #009D8E; width:'100%';border:1px solid  #009D8E;" align="center">
  		<font color="#ffffff" size="4pt">
			<b>Populated Hive Data</b>
		</font>
	</div>
	<br>
	<div align="center">
		<div id='populated_data' ></div>
		<input type='button' id='savexls' onclick='notImplemented();' value='Save as XLS'/>
		<input type='button' id='savecsv' onclick='notImplemented();' value='Save as CSV'/>
		<input type='button' id='savetsv' onclick='notImplemented();' value='Save as TSV'/>
	</div>
     	<a href="#" onclick="show('hive_query_editor','hive_data');">Back</a>
</div>
<%@ include file="/WEB-INF/template/footer.jsp"%>