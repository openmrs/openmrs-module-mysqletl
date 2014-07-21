<%@ include file="/WEB-INF/template/include.jsp"%>
<%@ include file="/WEB-INF/template/header.jsp"%>
<%@ include file="template/localHeader.jsp"%>

<!-- Tell 1.7+ versions of core to not include JQuery themselves. Also, on 1.7+ we may get different jquery and jquery-ui versions than 1.3.2 and 1.7.2 -->
<c:set var="DO_NOT_INCLUDE_JQUERY" value="true"/>

<openmrs:htmlInclude file="/moduleResources/mysqletl/lib/control/progressbar.min.js"/>

<openmrs:htmlInclude file="/moduleResources/mysqletl/lib/jquery.min.js" />
<openmrs:htmlInclude file="/moduleResources/mysqletl/lib/jquery-ui.min.js" />

<openmrs:htmlInclude file="/moduleResources/mysqletl/lib/jstorage.js" />

<openmrs:htmlInclude file="/moduleResources/mysqletl/lib/highcharts/jquery.highchartTable.js" />
<openmrs:htmlInclude file="/moduleResources/mysqletl/lib/highcharts/highcharts.js" />
<openmrs:htmlInclude file="/moduleResources/mysqletl/css/lib/control/progressbar.css" />

<openmrs:htmlInclude file="/moduleResources/mysqletl/module_style.css"/>
<openmrs:htmlInclude file="/moduleResources/mysqletl/module_js.js"/>

<openmrs:htmlInclude file="/moduleResources/mysqletl/lib/apprise-v2.js" />
<openmrs:htmlInclude file="/moduleResources/mysqletl/css/apprise-v2.css" />

 <div id="mysql_log" style="border:1px solid  #009D8E;">
	 	<div style="background: #009D8E; width:'100%';border:1px solid  #009D8E;" align="center">
  			<font color="#ffffff" size="4pt">
				<b><spring:message code="mysqletl.page.title.mysqllogin"/></b>
			</font>
		</div>
		<div align="center">
  		<table align=center bgcolor="#f5f5f5" style="width: 316px; height: 100px">
            <tr>
                <td style="width: 184px;">
                    <spring:message code="mysqletl.credentials.username"/>
                </td>
                <td style="width: 5px">
                	<input type="text" name="user" id="user" value="openmrs" style="width: 226px">
                </td>
                
            </tr>
            <tr>
                <td style="width: 184px; height: 1px;">
 					 <spring:message code="mysqletl.credentials.password"/>
  				</td>
                <td style="width: 5px; height: 1px">
                	<input type="password" name="pass" id="pass" style="width: 226px">
                </td>
            </tr>
            <tr>
                <td style="width: 184px;">
  					<spring:message code="mysqletl.credentials.host"/> 
                </td>
                <td style="width: 5px">
                	<input type="text" name="host" id="host" value="localhost" style="width: 227px">
                </td>
            </tr>
            <tr>
                <td style="width: 184px; height: 3px;">
 					 <spring:message code="mysqletl.credentials.port"/> 
  				</td>
                <td style="width: 5px; height: 3px">
                	<input type="text" name="port" id="port" value="3306" style="width: 226px">
                </td>
            </tr>
  		</table>
  		<input type="button" class="myButton" value="Login" name="login" onclick="mysql_login()" align="center">
  		</div>
</div>
<div id="db_list" style="display:none;border:1px solid  #009D8E;">  
	<div style="background: #009D8E; width:'100%';border:1px solid  #009D8E;" align="center">
  		<font color="#ffffff" size="4pt">
			<b><spring:message code="mysqletl.page.title.exist.db"/></b>
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
 		 <br><input type="button" class="myButton" onclick="selectDatabases();" value="<spring:message code="mysqletl.page.nav.next"/>" />
	</center>
    <a class="myLink" href="#" onclick="show('mysql_log','db_list');"><spring:message code="mysqletl.page.nav.back"/></a>
</div>
<div id="table_list" style="display:none;border:1px solid  #009D8E;">
	<div style="background: #009D8E; width:'100%';border:1px solid  #009D8E;" align="center">
  		<font color="#ffffff" size="4pt">
			<b><spring:message code="mysqletl.page.title.exist.table"/></b>
 		</font>
	</div>
 	<center>
  		<div align="center" style="height:300px;overflow:auto;margin-top:20px;"><br>
   			<table id="table_table" align=center class="CSSTableGenerator">
      			<tr>
      			</tr>
   			</table>
 		</div>
 		<br><input type="button" class="myButton" onclick="selectTables();" value="<spring:message code="mysqletl.page.nav.next"/>" />
	</center>
    <a class="myLink" href="#" onclick="show('db_list','table_list');"><spring:message code="mysqletl.page.nav.back"/></a>
</div>
<div id="column_list" style="display:none;border:1px solid  #009D8E;">    
	<div style="background: #009D8E; width:'100%';border:1px solid  #009D8E;" align="center">
  		<font color="#ffffff" size="4pt">
			<b><spring:message code="mysqletl.page.title.exist.column"/></b>
  		</font>
 	</div>
	<center>
  		<div style="background: #ffffcc; width:'100%';" align="center">
   			<table id="column_table" align=center bgcolor="#f5f5f5">
      			<tr>
      			</tr>
   			</table>
   			<table>
   				<th>
            		<table id='available-column-table' align=right bgcolor="#f5f5f5">  
                		<tbody class="connectedSortable">  
                    		<tr id='dragRow' align="center">    
                  				  <th id='dragRow' align="right"><spring:message code="mysqletl.label.database"/></th> 
                  				  <th id='dragRow' align="right"><spring:message code="mysqletl.label.table"/></th>   
                  				  <th id='dragRow' align="right"><spring:message code="mysqletl.label.column.avail"/></th>   
                    		</tr> 
                		</tbody> 
            		</table>
            	</th>
            	<th>
            		<table id='selected-column-table' align=right bgcolor="#f5f5f5">  
                		<tbody class="connectedSortable">  
                    		<tr id='dragRow' align="center">    
                  				  <th id='dragRow' align="right"><spring:message code="mysqletl.label.database"/></th> 
                  				  <th id='dragRow' align="right"><spring:message code="mysqletl.label.table"/></th>   
                  				  <th id='dragRow' align="right"><spring:message code="mysqletl.label.column.select"/></th>
                    		</tr> 
                		</tbody> 
            		</table>
            	</th> 
   			</table>
  		<input type="button" class="myButton" onclick="joinConditionPage();" value="<spring:message code="mysqletl.page.nav.next"/>" />
		</div>
	</center>
    <a class="myLink" href="#" onclick="show('table_list','column_list');"><spring:message code="mysqletl.page.nav.back"/></a>
</div>    
<div id="join_list" style="display:none;border:1px solid  #009D8E;">    
	<div style="background: #009D8E; width:'100%';border:1px solid  #009D8E;" align="center">
  		<font color="#ffffff" size="4pt">
			<b><spring:message code="mysqletl.page.title.join.condition"/></b>
  		</font>
 	</div>
	<center>
  		<div style="background: #ffffcc; width:'100%';" align="center">
   			<table id="join_head" align=center bgcolor="#f5f5f5">
      			<tr>
         			<td width="100%"><spring:message code="mysqletl.page.title.join.condition.form"/></td>
      			</tr>
   			</table>
   			<table>
   				<th><table>
                		<thead id='dragRow' align="center">    
                  				  <th id='dragRow' align="right"><spring:message code="mysqletl.label.join.type"/></th> 
                  				  <th id='dragRow' align="right"><spring:message code="mysqletl.label.table"/></th> 
                  				  <th id='dragRow' align="right"><spring:message code="mysqletl.label.on.condition"/></th> 
                  				  <th id='dragRow' align="right"><spring:message code="mysqletl.label.clause"/></th>    
                    	</thead>
                    	<tbody>  
                     		<tr>
                      			  <th>
 									<select id='joinSelect'>
  										<option value="<spring:message code="mysqletl.sql.join"/>"><spring:message code="mysqletl.sql.join"/></option>
  										<option value="<spring:message code="mysqletl.sql.join.inner"/>"><spring:message code="mysqletl.sql.join.inner"/></option>
  										<option value="<spring:message code="mysqletl.sql.join.left"/>"><spring:message code="mysqletl.sql.join.left"/></option>
  										<option value="<spring:message code="mysqletl.sql.join.left.outer"/>"><spring:message code="mysqletl.sql.join.left.outer"/></option>
  										<option value="<spring:message code="mysqletl.sql.join.right"/>"><spring:message code="mysqletl.sql.join.right"/></option>
  										<option value="<spring:message code="mysqletl.sql.join.right.outer"/>"><spring:message code="mysqletl.sql.join.right.outer"/></option>
  										<option value="<spring:message code="mysqletl.sql.join.full.outer"/>"><spring:message code="mysqletl.sql.join.full.outer"/></option>
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
            		<table id='join-conditions' align=right bgcolor="#f5f5f5">  
                		<tbody  class="joinSortable" id='join-add'>  
                		</tbody> 
            		</table>
            	</th>
            	<th>
					<input type="button" class="myButton" name="add-condition" value="<spring:message code="mysqletl.sql.join.add"/>" id='addCondtn' onClick='addJoinCondition();'>
					<input type="button" class="myButton" name="show-condition" value="<spring:message code="mysqletl.sql.join.show"/>" id='showCondtn' onClick='showJoinStatement();'>
            	</th> 
   			</table>
   		<div align="center">
   				<spring:message code="mysqletl.sql.join.raw.query"/><br> <input type="text" name="rawCondition" id='rawCondition' value=" " style="width=80%;">
   		</div>
   		<div id='show-statement'></div>
  		<input type="button" class="myButton" onclick="show('dw_log','join_list');" value="<spring:message code="mysqletl.page.nav.next"/>" />
		</div>
	</center>
    <a class="myLink" href="#" onclick="show('column_list','join_list');"><spring:message code="mysqletl.page.nav.back"/></a>
</div> 
<div id="dw_log" style="display:none;border:1px solid  #009D8E;">
	<div style="background: #009D8E; width:'100%';border:1px solid  #009D8E;" align="center">
  		<font color="#ffffff" size="4pt">
			<b><spring:message code="mysqletl.datawarehouse"/></b>
		</font>
	</div>
	<div  align="center">
		<input type="radio" name="type" value="<spring:message code="mysqletl.server.hive"/>" checked="true"><spring:message code="mysqletl.label.server.hive"/>
		<input type="radio" name="type" value="<spring:message code="mysqletl.server.mysql"/>"><spring:message code="mysqletl.label.server.mysql"/>
	</div>
	<div align="center">
  	<table align=center bgcolor="#f5f5f5" style="width: 316px; height: 100px">
            <tr>
                <td style="width: 184px;">
                    <spring:message code="mysqletl.credentials.username"/>
                </td>
                <td style="width: 5px">
                	<input type="text" name="user" id="dwuser" value="root" style="width: 226px">
                </td> 
            </tr>
            <tr>
                <td style="width: 184px; height: 1px;">
                    <spring:message code="mysqletl.credentials.password"/>
  				</td>
                <td style="width: 5px; height: 1px">
                	<input type="password" name="pass" id="dwpass" value="hadoop" style="width: 226px">
                </td>
            </tr>
            <tr>
                <td style="width: 184px;">
                    <spring:message code="mysqletl.credentials.ssh.host"/>
                </td>
                <td style="width: 5px">
                	<input type="text" name="host" id="dwhost" value="localhost" style="width: 227px">
                </td>
            </tr>
            <tr>
                <td style="width: 184px; height: 3px;">
                    <spring:message code="mysqletl.credentials.ssh.port"/>
  				</td>
                <td style="width: 5px; height: 3px">
                	<input type="text" name="port" id="dwport" value="22" style="width: 226px">
                </td> 
            </tr>
            <tr>
                <td style="width: 184px; height: 3px;">
                    <spring:message code="mysqletl.label.database"/>
  				</td>
                <td style="width: 5px; height: 3px">
                	<input type="text" name="datawarehouse_db" id="dw_db" value="dw_db" style="width: 226px">
                </td> 
            </tr>
            <tr>
                <td style="width: 184px; height: 3px;">
                    <spring:message code="mysqletl.label.table"/>
  				</td>
                <td style="width: 5px; height: 3px">
                	<input type="text" name="datawarehouse_table" id="dw_table" value="dw_table" style="width: 226px">
                </td> 
            </tr>
            <tr>
                <td style="width: 184px; height: 3px;">
                </td>
                <td style="width: 5px; height: 3px">
                    &nbsp;
                </td>
            </tr>
        </table>
        <input type="button" class="myButton" value="<spring:message code="mysqletl.page.nav.load"/>" name="login" onclick="notImplemented()">
        </div>
    	<a class="myLink" href="#" onclick="show('join_list','dw_log');"><spring:message code="mysqletl.page.nav.back"/></a>
</div>
<div id="etl_scheduler" style="display:none;border:1px solid  #009D8E;">
	<div style="background: #009D8E; width:'100%';border:1px solid  #009D8E;" align="center">
  		<font color="#ffffff" size="4pt">
			<b></b>
		</font>
	</div>
	<div align="center">

    </div>
     	<a class="myLink" href="#" onclick="show('dw_log','etl_scheduler');"><spring:message code="mysqletl.page.nav.back"/></a>
</div>
<%@ include file="/WEB-INF/template/footer.jsp"%>