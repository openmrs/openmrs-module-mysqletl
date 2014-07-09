<%@ include file="/WEB-INF/template/include.jsp"%>
<%@ include file="/WEB-INF/template/header.jsp"%>
<%@ include file="template/localHeader.jsp"%>

<!-- Tell 1.7+ versions of core to not include JQuery themselves. Also, on 1.7+ we may get different jquery and jquery-ui versions than 1.3.2 and 1.7.2 -->
<c:set var="DO_NOT_INCLUDE_JQUERY" value="true"/>

<openmrs:htmlInclude file="/moduleResources/mysqletl/lib/control/progressbar.min.js"/>
<openmrs:htmlInclude file="/moduleResources/mysqletl/lib/jquery.min.js" />
<openmrs:htmlInclude file="/moduleResources/mysqletl/lib/jquery-ui.min.js" />
<openmrs:htmlInclude file="/moduleResources/mysqletl/lib/jstorage.js" />
<openmrs:htmlInclude file="/moduleResources/mysqletl/css/lib/control/progressbar.css" />

<openmrs:htmlInclude file="/moduleResources/mysqletl/module_style.css"/>
<openmrs:htmlInclude file="/moduleResources/mysqletl/module_js.js"/>
<div id="hive_query_page" style="border:1px solid  #009D8E;">
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
			<input type='button' onclick='saveQuery("queryholder");' value='Save Query'/>
			<input type='button' onclick='loadQuery("queryholder");' value='Load Query'/>
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
		<div id='populated_data'></div>
		<input type='button' id='savexls' onclick="tableToExcel('autoCreateTable', 'Hive Result')" value='Download XLS'/>
		<input type='button' id='savecsv' onclick='window.open("/openmrs-standalone/moduleResources/mysqletl/download.csv");' value='Export to CSV'/>
		<input type='button' id='savetsv' onclick='window.open("/openmrs-standalone/moduleResources/mysqletl/download.tsv");' value='Export to TSV'/>
	</div>
     	<a href="#" onclick="show('hive_query_editor','hive_data');">Back</a>
</div>
<%@ include file="/WEB-INF/template/footer.jsp"%>