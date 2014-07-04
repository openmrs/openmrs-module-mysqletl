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
 function randomString(length, chars) {
	  var result = '';
	  for (var i = length; i > 0; --i) result += chars[Math.round(Math.random() * (chars.length - 1))];
	  return result;
 }
 function removeElement(parent,child){
	  var pardiv = document.getElementById(parent);
	  var childdiv = document.getElementById(child);
	  pardiv.removeChild(childdiv);
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
 function hasValue(element, value) {
	    var results = true;

	    for (var i=element.options.length-1; i >= 0; i--) (function() {

	        if (element.options[i].value == value) (function() { 
	            results = false;
	        }());
	    }());

	    return (results);
 };
 function addCombo(reportID,reportName,selectID) {
	    var textb = document.getElementById(selectID);
	    var option = document.createElement("option");

	    if (hasValue(textb, reportID)) (function() {


	        // selected attr remove
	        for (var i=textb.options.length-1; i >= 0; i--) (function() {

	            if (textb.options[i].selected == true) (function() {

	                textb.options[i].removeAttribute("selected");
	            }());
	        }());

	        option.text = reportName;
	        option.value = reportID;

	        // selected new option element 
	        option.setAttribute("selected", "selected");


	        try {
	            textb.add(option, null); //Standard
	        } catch(error) {
	            textb.add(option); // IE only
	        };

	        /*
	        *  I do not understand selected added option value "" ?? 
	        */ 
	        //textb.value = "";

	       }());
 };
 function clearComboBox(boxID){
	 var select = document.getElementById(boxID);
	 var length = select.options.length;
	 for (i = 0; i < length; i++) {
	   select.options[i] = null;
	 }
 }
function createTable(tableData,div_id) {
	  var populated = document.getElementById(div_id);
	  populated.innerHTML="";
	  var table = document.createElement('table')
	    , tableBody = document.createElement('tbody');
	  table.className = "CSSTableGenerator";
	  table.id = "autoCreateTable";
	  tableData.forEach(function(rowData) {
	    var row = document.createElement('tr');

	    rowData.forEach(function(cellData) {
	      var cell = document.createElement('td');
	      cell.appendChild(document.createTextNode(cellData));
	      row.appendChild(cell);
	    });

	    tableBody.appendChild(row);
	  });

	  table.appendChild(tableBody);
	  populated.appendChild(table);
}  
var tableToExcel = (function() {
	  var uri = 'data:application/vnd.ms-excel;base64,'
	    , template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>'
	    , base64 = function(s) { return window.btoa(unescape(encodeURIComponent(s))) }
	    , format = function(s, c) { return s.replace(/{(\w+)}/g, function(m, p) { return c[p]; }) }
	  return function(table, name) {
	    if (!table.nodeType) table = document.getElementById(table)
	    var ctx = {worksheet: name || 'Worksheet', table: table.innerHTML}
	    window.location.href = uri + base64(format(template, ctx))
	  }
	})()
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
					alert('Login Failed');
				}
			  }
			});
 }
 function hive_login(){  
	 var loginParams = {
	 user: document.getElementById('hiveuser').value,
     pass: document.getElementById('hivepass').value,
 	 host: document.getElementById('hivehost').value,
 	 port: document.getElementById('hiveport').value
	 
 	};
	  	DWRMySQLLoginService.loginHive(loginParams,{
			  callback:function(reslt) { 
				  if(parseInt(reslt)==0){show('hive_query_editor','hive_query_page');}
				  else alert('Invalid SSH Credentials');
				  }
				});
 }
 function hive_query(){  
	 var query = document.getElementById('queryholder').value;
	  	DWRMySQLLoginService.queryHive(query,{
			  callback:function(reslt) { 
				  	show('hive_data','hive_query_editor');
				  	createTable(reslt,'populated_data');
				  }
				});
 }
 function saveQuery(textAreaId){//Sava Query data to local Storage
	 var value = document.getElementById(textAreaId).value;
	 	 $.jStorage.set(textAreaId,value); 			 
 }
 function loadQuery(textAreaId){//Load Query data from local Storage
	 var element = document.getElementById(textAreaId);
	 element.value =  $.jStorage.get(textAreaId); 			 
 } 
 function addDatabaseRow(info){
	  var TABLE = document.getElementById('db_table');
	  var BODY = TABLE.getElementsByTagName('tbody')[0];
	  var TR = document.createElement('tr');
	  var TD = document.createElement('td');
	  var checkbox = document.createElement("input");
	  checkbox.type = "checkbox";    // make the element a checkbox
	  checkbox.name = "db_check"; 
	  checkbox.value = info;     // give it a name we can check on the server side
	  TD.appendChild(checkbox);   // add the box to the element
	  TD.innerHTML = TD.innerHTML + '  <a href="#" style="color : black;text-decoration: none;" onclick="clickDatabase(\''+info+'\');">'+info+'</a>';
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
	  TD.appendChild(checkbox);   // add the box to the element
	  TD.innerHTML = TD.innerHTML+ '  <a href="#" style="color : black;text-decoration: none;" onclick="return clickTable(\''+info+'\');">'+info+'</a>';
	  TR.appendChild (TD);
	  BODY.appendChild(TR);
 }
 function selectDatabases(){
		var checkedBoxes = getCheckedBoxes("db_check");
		if(checkedBoxes==null){ alert("None Database Selected"); }
		else{
			clearHTMLTable('table_table');	
			for(i=0;i<checkedBoxes.length;i++){
				clickDatabase(checkedBoxes[i].value);
			}
		}
	 
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
 			clearComboBox('tableSelect');
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
	  TD_DB.id='dragRow';
	  TR.appendChild (TD_DB);
	  var TD_TABLE = document.createElement('td');
	  TD_TABLE.innerHTML = table_name;//set only table name
	  TD_TABLE.id='dragRow';
	  TR.appendChild (TD_TABLE);
	  var TD_COLUMN = document.createElement('td');
	  TD_COLUMN.innerHTML = info;//set only column name
	  TD_COLUMN.id='dragRow';
	  TR.appendChild (TD_COLUMN);
	  BODY.appendChild(TR);
	  addCombo(table_info,table_info,"tableSelect");
 }
 function addJoinCondition(){
		  //document.getElementById('chk').innerHTML=document.getElementById('joinSelect').value+" "+document.getElementById('tableSelect').value+" "+document.getElementById('onCondition').value+" "+document.getElementById('clauseStmt').value;
		if(document.getElementById('onCondition').value==null||document.getElementById('onCondition').value==''){
			alert('No On Join Condition Provided');
		}
		else{
		  var TABLE = document.getElementById('join-conditions');
		  var BODY = TABLE.getElementsByTagName('tbody')[0];
		  var TR = document.createElement('tr');
		  TR.id=randomString(12, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ');// For generating a probably unique id
		  var TD = document.createElement('td');
		  TD.name = document.getElementById('joinSelect').value+" "+document.getElementById('tableSelect').value+" ON "+document.getElementById('onCondition').value+" "+document.getElementById('clauseStmt').value;
		  TD.innerHTML =  '<div id="dragRow"><div name="join-condition-statement" id="'+TD.name+'">'+TD.name+'<input type="button" value="x" onClick=\'removeElement("join-add","'+TR.id+'");\'/></div></div>';
		  TR.appendChild (TD);
		  BODY.appendChild(TR);
		}
}
 function showJoinStatement() {
	  var checkboxes = document.getElementsByName("join-condition-statement");
	  var checkboxesChecked = "";
	  // loop over them all
	  for (var i=0; i<checkboxes.length; i++) {
	     // And stick the checked ones onto an array...
	        checkboxesChecked+=checkboxes[i].id+" ";
	  }
	  document.getElementById('show-statement').innerHTML=checkboxesChecked;
	  // Return the array if it is non-empty, or null
	  return checkboxesChecked.length > 0 ? checkboxesChecked : null;
}
 function joinConditionPage(){
	 show('join_list','column_list');

 }
 function transform(){
	 show('process_status','dw_log');
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
	 //get column details from selected columns, Start from index 1, 0 reserved for Text
	 for (var i = 1, row; row = table.rows[i]; i++) {
	    //iterate through rows
	    //rows would be accessed using the "row" variable assigned in the for loop
		 column_list.push(row.cells[0].innerHTML+'.'+row.cells[1].innerHTML+'.'+row.cells[2].innerHTML);
	 }
	 var join_cndtn = showJoinStatement();
	 DWRMySQLLoginService.sqoopTransform(loginParams,serverType,db_name,table_name,column_list,join_cndtn,{ 
		 callback:function(result){ 
			 //if transformation takes place without any interruption, success message will return
			 		document.getElementById('my-progressbar-text1').innerHTML = result;
			 		var nextButton = document.createElement("input");
		            nextButton.setAttribute("type","button");
		            nextButton.value = "Execute Query on Hive ?";
		            nextButton.onclick = "show('hive_query_page','process_status');";
		            var getDiv = document.getElementById('showProgressBar');
		            getDiv.appendChild(nextButton);
					  }
					});	 
 }
 function notImplemented(){
	alert('Coming Soon');
 }
 $(window).load(function(){
	 $(document).ready(function() {

	     var $tabs=$('#join-conditions')
	     $( "tbody.joinSortable" )
	         .sortable({
	             connectWith: ".joinSortable",
	             items: "> tr:not(:first)",
	             appendTo: $tabs,
	             helper:"clone",
	             zIndex: 999990
	         })
	         .disableSelection()
	     ;
	     
	     var $tab_items = $( ".nav-tabs > li", $tabs ).droppable({
	       accept: ".joinSortable tr",
	       hoverClass: "ui-state-hover",
	       
	       drop: function( event, ui ) {
	         return false;
	       }
	     });
	     
	 });
	 });
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
 
 var progressBar;

 window.onload = function(){

     progressBar = new ProgressBar("my-progressbar", {'width':'500px', 'height':'6px'});
     
     // Start initial Mode
     progressBar.initialMode(true);
     
     // CHANGE OPTIONS
     //progressBar.setOptionValue(ProgressBar.OPTION_NAME.COLOR_ID, ProgressBar.OPTION_VALUE.COLOR_ID.BLACK);
     //progressBar.setOptionValue(ProgressBar.OPTION_NAME.OPACITY, 0.2);
     //progressBar.setPercent(60);
     
     // Stop Initial Mode
     //progressBar.initialMode(false);
     
 }
