var hive_data;	// hive_data should contains result of a hive query made

/*
 * Following are basic methods for creating HTML interface
 */

/*
 * Show a div by hiding other using jQuery. For Wizard like feel
 */
function show(shown, hidden){
	$( "#"+hidden ).hide();
	$( "#"+shown ).show( "slow" );
	
 }

/*
 * Clears a HTML table with the given table.id
 */
 function clearHTMLTable(tableID){
		var table = document.getElementById(tableID);
		for(var i = table.rows.length - 1; i > 0; i--)
		{
	    	table.deleteRow(i);
		}
 }
 
 /*
  * Generate a Random String with Specified length and over set of characters provided
  */
 function randomString(length, chars) {
	  var result = '';
	  for (var i = length; i > 0; --i) result += chars[Math.round(Math.random() * (chars.length - 1))];
	  return result;
 }
 
 /*
  * Remove element in HTML by providing parent id and child id where child is removed
  */
 function removeElement(parent,child){
	  var pardiv = document.getElementById(parent);
	  var childdiv = document.getElementById(child);
	  try{
		  pardiv.removeChild(childdiv);
	  }catch(err){}
 }
 
 /*
 * Pass the checkbox name tag to the function, returns all checked boxes with that name 
 */
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
 
 /*
  * Checks that a particular array contains the given value or not
  */
 function hasValue(element, value) {
	    var results = true;

	    for (var i=element.options.length-1; i >= 0; i--) (function() {

	        if (element.options[i].value == value) (function() { 
	            results = false;
	        }());
	    }());

	    return (results);
 };
 
/*
* if array do not contains the given value add it with given option in Join condition
*/ 
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
 
 /*
  * Clear Combo Box with given combo box ID
  */
 function clearComboBox(boxID){
	 var select = document.getElementById(boxID);
	 var length = select.options.length;
	 for (i = 0; i < length; i++) {
	   select.options[i] = null;
	 }
 }
 
 /*
  * Create HTML table with given array and division id
  */
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

/*
 * Create HTML table for Graph Data for graphical representation of Hive Result with given array, chart type and division id
 */
function createGraphTable(tableData,div_id,table_id,chart_type) {
	var populate = document.getElementById(div_id);
	populate.innerHTML="<table class='"+table_id+"' id='"+table_id+"' data-graph-container-before='1' data-graph-type='"+chart_type+"' style='display:none;'></table>";
	var table = document.getElementById(table_id)
	  	, tableHead = document.createElement('thead')
	    , tableBody = document.createElement('tbody');
	  table.innerHTML="";
	  var headcount = false;
	  tableData.forEach(function(rowData) {
		  if(headcount==false){
			    var row = document.createElement('tr');

			    rowData.forEach(function(cellData) {
			      var cell = document.createElement('th');
			      cell.appendChild(document.createTextNode(cellData));
			      row.appendChild(cell);
			    });

			    tableHead.appendChild(row);
			    headcount=true;			  
		  }else{
			  	var row = document.createElement('tr');

			  	rowData.forEach(function(cellData) {
			  		var cell = document.createElement('td');
			  		cell.appendChild(document.createTextNode(cellData));
			  		row.appendChild(cell);
			  	});
			  	tableBody.appendChild(row);
		  }
	  });
	  
	  table.appendChild(tableHead);
	  table.appendChild(tableBody);
	  
	  $('table.highchart').highchartTable();
}  

/*
 * Converting a HTML table into Excel Sheet
 */
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

/*
 * Following are methods for Spring MVC calls anf fetching back result
 */
	
/*
 * Spring MVC calls to login to MySQL DB and fetch back database list
 */
 function mysql_login(){  
	 var loginParams = {
	 user: document.getElementById('user').value,
     pass: document.getElementById('pass').value,
 	 host: document.getElementById('host').value,
 	 port: document.getElementById('port').value
	 
 	};
	$.ajax({  
	    type : "Post",   
	    url : "login_mysql.form",   
	    data : loginParams,  
	    success : function(db_list) {  
			if(db_list.length>0){
				clearHTMLTable('db_table');
				for(i=0; i<db_list.length;i++){
					addDatabaseRow(db_list[i]);
			 	}
				show('db_list','mysql_log');
			}else{
				Apprise('Login Failed');
			}
	    },  
	    error : function(e) {  
	    Apprise('Error: ' + e);   
	   }  
	}); 
 }

/*
 * Spring MVC calls to login to hive DB and move to query editor on successful login
 */
 function hive_login(){  
	 var loginParams = {
	 user: document.getElementById('hiveuser').value,
     pass: document.getElementById('hivepass').value,
 	 host: document.getElementById('hivehost').value,
 	 port: document.getElementById('hiveport').value
	 
 	};
		$.ajax({  
		    type : "Post",   
		    url : "login_hive.form",   
		    data : loginParams,  
		    success : function(reslt) {  
				  if(parseInt(reslt)==0){show('hive_query_editor','hive_query_page');}
				  else Apprise('Invalid SSH Credentials');
		    },  
		    error : function(e) {  
		    Apprise('Error: ' + e);   
		   }  
		});  	
	  	
 }
 
 /*
  * Spring MVC calls to execute hive query using ssh and fetch result list as table
  */
 function hive_query(){  
	 var Query = document.getElementById('queryholder').value;
		$.ajax({  
		    type : "Post",   
		    url : "query_hive.form",   
		    data : {
		    		query: Query
		    },
		    success : function(reslt) {  
			  	show('hive_data','hive_query_editor');
			  	createTable(reslt,'populated_data');
			  	hive_data = reslt;
		    },  
		    error : function(e) {  
		    Apprise('Error: ' + e);   
		   }  
		}); 
 }
 
 /*
  * Spring MVC calls to execute hive query using ssh and fetch result list as downloadable file
  */
 function hive_query_download(){  
	 var downloadQuery = document.getElementById('queryholder').value;
		$.ajax({  
		    type : "Post",   
		    url : "query_download.form",   
		    data : {
		    		dquery: downloadQuery
		    },
		    success : function(reslt) {  
		    	if(reslt!=null)
		    		window.open(reslt);
		    	else 
		    		Apprise('Download Error');
		    },  
		    error : function(e) {  
		    	Apprise('Error: ' + e);   
		   }  
		}); 
 }
 
 /*
  * Sava Query data to local Storage
  */
 function saveQuery(textAreaId){
	 var value = document.getElementById(textAreaId).value;
	 	 $.jStorage.set(textAreaId,value); 			 
 }
 
 /*
  * Load Query data from local Storage
  */
 function loadQuery(textAreaId){
	 var element = document.getElementById(textAreaId);
	 element.value =  $.jStorage.get(textAreaId); 			 
 } 

 /*
  * populating HTML table with database list
  */
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
 
 /*
  * Populating HTML table with table List
  */
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
 
 /*
  * Populate HTML table with mysql table list with the databases where that databases is chosen
  */
 function selectDatabases(){
		var checkedBoxes = getCheckedBoxes("db_check");
		if(checkedBoxes==null){ Apprise("None Database Selected"); }
		else{
			clearHTMLTable('table_table');	
			for(i=0;i<checkedBoxes.length;i++){
				clickDatabase(checkedBoxes[i].value);
			}
		}
	 
}
 
 /*
  * Populate HTML table with mysql table list with the database where that database is chosen
  */
 function clickDatabase(db_name){
	 
	 $.ajax({  
		    type : "Post",   
		    url : "get_tables.form",   
		    data : {
		    		dbname:db_name
		    	},  
		    success : function(table_list) {  
 					show('table_list','db_list');							
 					if(table_list!=null){
						for(i=0; i<table_list.length;i++){
							addTableRow(table_list[i],db_name);
				  		}
					}
		    },  
		    error : function(e) {  
		    Apprise('Error: ' + e);   
		   }  
	 });
 }
 
 /*
  * Populate HTML table with mysql column list with the tables name where that tables is chosen
  */
 function selectTables(){
		var checkedBoxes = getCheckedBoxes("table_check");
		if(checkedBoxes==null){ Apprise("None Table Selected"); }
		else{
			clearHTMLTable('available-column-table');
 			clearHTMLTable('selected-column-table');
 			clearComboBox('tableSelect');
			for(i=0;i<checkedBoxes.length;i++){
				clickTable(checkedBoxes[i].value);
			}
		}
	 
 }
 
 /*
  * Populate HTML table with mysql column list with the table name where that table is chosen
  */
 function clickTable(table_info){
	 
	 var db_name = table_info.substring(0,table_info.indexOf('.'));
	 var table_name = table_info.substring(table_info.indexOf('.')+1);

	 $.ajax({  
		    type : "Post",   
		    url : "get_columns.form",   
		    data : {
		    		dbname: db_name,
		    		tablename: table_name
		    	},  
		    success : function(column_list) {  
 				show('column_list','table_list');				
				if(column_list!=null){
					//add columns in available column table
				  for(i=0; i<column_list.length;i++){
						addColumnRow(column_list[i], table_info);
						//Passing table_info results [db_name].[table_name].[column_name] so from multiple database and tables column can be selected
				  }
				}
		    },  
		    error : function(e) {  
		    Apprise('Error: ' + e);   
		   }  
	 });
 }
 
 /*
  * Populate HTML table with mysql column list
  */
 function addColumnRow(info,table_info){
	  var db_name = table_info.substring(0,table_info.indexOf('.'));
	  var table_name = table_info.substring(table_info.indexOf('.')+1);
	  var TABLE = document.getElementById('available-column-table');
	  var BODY = TABLE.getElementsByTagName('tbody')[0];
	  var TR = document.createElement('tr');
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
 
 /*
  * Creating SQL query statement for the join condition
  */
 function addJoinCondition(){
		  //document.getElementById('chk').innerHTML=document.getElementById('joinSelect').value+" "+document.getElementById('tableSelect').value+" "+document.getElementById('onCondition').value+" "+document.getElementById('clauseStmt').value;
		if(document.getElementById('onCondition').value==null||document.getElementById('onCondition').value==''){
			Apprise('No On Join Condition Provided');
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
 
 /*
  * Show the js generated Join Statement
  */
 function showJoinStatement() {
	  var joinStatements = document.getElementsByName("join-condition-statement");
	  var completeJoinStatement = "  ";
	  // loop over them all
	  for (var i=0; i<joinStatements.length; i++) {
	     // And stick the checked ones onto an array...
		  completeJoinStatement+=joinStatements[i].id+" ";
	  }
	  document.getElementById('show-statement').innerHTML=completeJoinStatement;
	  // 
	  return completeJoinStatement;
}
 
 /*
  * Join Condition page jump from column list
  */
 function joinConditionPage(){
	 show('join_list','column_list');

 }
 
 /*
  * Spring MVC calls for Complete transformation of selected mysql data and loading to datawarehouse
  */
 function transform(){
	 show('process_status','dw_log');

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
	 //Adding Raw Condition statement and Join Condition Table Statement
	 var join_cndtn = document.getElementById('rawCondition').value+" "+showJoinStatement();

	 $.ajax({  
		    type : "Post",   
		    url : "sqoop_transform.form",   
		    data : {
				 	user: document.getElementById('dwuser').value,
				 	pass: document.getElementById('dwpass').value,
				 	host: document.getElementById('dwhost').value,
				 	port: document.getElementById('dwport').value,
		    		servertype: serverType,
		    		dbname: db_name,
		    		tablename: table_name,
		    		columnlist: column_list,
		    		joincndtn: join_cndtn
		    	},  
		    success : function(result) {  
				 
		    	//if transformation takes place without any interruption, success message will return
	 			document.getElementById('my-progressbar-text1').innerHTML = result;
	 			if(result=='Success'){
	 				removeElement('showProgressBar','nextToQuery');
	 				var nextButton = document.createElement("input");
	 				nextButton.setAttribute("type","button");
	 				nextButton.id='nextToQuery';
	 				nextButton.value = "Execute Query on Hive ?";
	 				nextButton.onclick = function(){
	 					show('hive_query_page','process_status');
	 				};
	 				var getDiv = document.getElementById('showProgressBar');
	 				getDiv.appendChild(nextButton);
	 			}
		    },  
		    error : function(e) {  
		    Apprise('Error: ' + e);   
		   }  
	 });
 }
 
 /*
  * Show charts and graph data of hiove query resultd
  */
 function showCharts(){ 
	 show('hive_data_chart','hive_data');
	 chart_type = document.getElementById('chart_type').value;
	 createGraphTable(hive_data,'graph_data','highchart',chart_type);
 }
 
 /*
  * For non implemented methods
  */
 function notImplemented(){
	Apprise('Coming Soon');
 }
 
 /*
  * jQuery drag and drop for join condition
  */
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
 
 /*
  * jQuery drag and drop for columns selection
  */ 
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
 

 var progressBar;	//Progress bar data

 /*
  * Progress bar initiated
  */
 window.onload = function(){
	 try{

		 progressBar = new ProgressBar("my-progressbar", {'width':'200px', 'height':'6px'});
     
		 // Start initial Mode
		 progressBar.initialMode(true);
     
		 // CHANGE OPTIONS
		 //progressBar.setOptionValue(ProgressBar.OPTION_NAME.COLOR_ID, ProgressBar.OPTION_VALUE.COLOR_ID.BLACK);
		 //progressBar.setOptionValue(ProgressBar.OPTION_NAME.OPACITY, 0.2);
		 //progressBar.setPercent(60);
     
		 // Stop Initial Mode
		 //progressBar.initialMode(false);
	 }
	 catch(err){} //In case of no need of load of progress bar
 }
