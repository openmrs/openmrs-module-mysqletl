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
<div id="hive_query_page" style="border:1px solid  #009D8E;">
	<div style="background: #009D8E; width:'100%';border:1px solid  #009D8E;" align="center">
  		<font color="#ffffff" size="4pt">
			<b><spring:message code="mysqletl.page.title.hivelogin"/></b>
		</font>
	</div>
	<div align="center">

  	<table align=center bgcolor="#f5f5f5" style="width: 316px; height: 100px">
            <tr>
                <td style="width: 184px;">
                    <spring:message code="mysqletl.credentials.username"/>
                </td>
                <td style="width: 5px">
                	<input type="text" name="user" id="hiveuser" value="root" style="width: 226px">
                </td> 
            </tr>
            <tr>
                <td style="width: 184px; height: 1px;">
                    <spring:message code="mysqletl.credentials.password"/>
  				</td>
                <td style="width: 5px; height: 1px">
                	<input type="password" name="pass" id="hivepass" value="hadoop" style="width: 226px">
                </td>
            </tr>
            <tr>
                <td style="width: 184px;">
                    <spring:message code="mysqletl.credentials.ssh.host"/>
                </td>
                <td style="width: 5px">
                	<input type="text" name="host" id="hivehost" value="localhost" style="width: 227px">
                </td>
            </tr>
            <tr>
                <td style="width: 184px; height: 3px;">
					<spring:message code="mysqletl.credentials.ssh.port"/>
  				</td>
                <td style="width: 5px; height: 3px">
                	<input type="text" name="port" id="hiveport" value="22" style="width: 226px">
                </td> 
            </tr>

            <tr>
                <td style="width: 184px; height: 3px;">
                </td>
                <td style="width: 5px; height: 3px">
                    &nbsp;<input type="submit" value="<spring:message code="mysqletl.label.login"/>" name="login" onclick="hive_login();" style="width: 86px">
                </td>
            </tr>
        </table>
    </div>
</div>
<div id="hive_query_editor" style="display:none;border:1px solid  #009D8E;">
	<div style="background: #009D8E; width:'100%';border:1px solid  #009D8E;" align="center">
  		<font color="#ffffff" size="4pt">
			<b><spring:message code="mysqletl.page.title.hive.query"/></b>
		</font>
	</div>
	<div align="center">
		<textarea name="queryholder" id="queryholder" cols="100" rows="20"></textarea>
		<div align="center">
			<input type='button' onclick='hive_query();' value='<spring:message code="mysqletl.label.query.execute"/>'/>
			<input type='button' onclick='saveQuery("queryholder");' value='<spring:message code="mysqletl.label.query.save"/>'/>
			<input type='button' onclick='loadQuery("queryholder");' value='<spring:message code="mysqletl.label.query.load"/>'/>
			<input type='button' onclick='hive_query_download();' value='<spring:message code="mysqletl.label.query.execute.download"/>'/>
		</div>
		<h2 align="center"><spring:message code="mysqletl.label.logs"/></h2>
		<textarea align="center" name="querylogs" id="querylogs" cols="100" rows="5" disabled="true"></textarea>
	</div>
     	<a href="#" onclick="show('hive_query_page','hive_query_editor');"><spring:message code="mysqletl.page.nav.back"/></a>
</div>
<div id="hive_data" style="display:none;border:1px solid  #009D8E;">
	<div style="background: #009D8E; width:'100%';border:1px solid  #009D8E;" align="center">
  		<font color="#ffffff" size="4pt">
			<b><spring:message code="mysqletl.page.title.hive.query.result"/></b>
		</font>
	</div>
	<br>
	<div align="center">
		<div id='populated_data'></div>
		<input type='button' id='savexls' onclick="tableToExcel('autoCreateTable', 'Hive Result')" value='<spring:message code="mysqletl.label.save.xls"/>'/>
		<input type='button' id='savecsv' onclick='window.open("/openmrs-standalone/moduleResources/mysqletl/download.csv");' value='<spring:message code="mysqletl.label.save.csv"/>'/>
		<input type='button' id='savetsv' onclick='window.open("/openmrs-standalone/moduleResources/mysqletl/download.tsv");' value='<spring:message code="mysqletl.label.save.tsv"/>'/>
	</div>
     	<a href="#" onclick="show('hive_query_editor','hive_data');"><spring:message code="mysqletl.page.nav.back"/></a>
     	<a href="#" onclick="showCharts();"><spring:message code="mysqletl.page.nav.next.charts"/></a>
     	<select id='chart_type'>
  			<option value="line"><spring:message code="mysqletl.label.charts.type.line"/></option>
  			<option value="column"><spring:message code="mysqletl.label.charts.type.column"/></option>
  			<option value="area"><spring:message code="mysqletl.label.charts.type.area"/></option>
  			<option value="spline"><spring:message code="mysqletl.label.charts.type.spline"/></option>
  			<option value="pie"><spring:message code="mysqletl.label.charts.type.pie"/></option>
  		</select> 
</div>
<div id="hive_data_chart" style="display:none;border:1px solid  #009D8E;">
	<div style="background: #009D8E; width:'100%';border:1px solid  #009D8E;" align="center">
  		<font color="#ffffff" size="4pt">
			<b><spring:message code="mysqletl.page.title.hive.query.result.charts"/></b>
		</font>
	</div>
	<br>
	<div align="center" id='graph_data'>	
	<table class="highchart" id="highchart" data-graph-container-before="1" data-graph-type="line" style="display:none;">
  		<thead>
   		</thead>
   		<tbody>
  		</tbody>
	</table>
	</div>
     	<a href="#" onclick="show('hive_data','hive_data_chart');"><spring:message code="mysqletl.page.nav.back"/></a>
</div>
<%@ include file="/WEB-INF/template/footer.jsp"%>