<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>
      <%=get_feature_name()%> feature category - CR Status (W<%=config.min_wk%> ~ W<%=config.max_wk%>) <%=g_db_create_time%>  (author: DaylongChen Design)
    </title>
    
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.2/jquery-ui.min.js"></script>
    <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.2/themes/smoothness/jquery-ui.min.css">
    
    <style type="text/css">    
        body {
            font-family: "Trebuchet MS", "Helvetica", "Arial",  "Verdana", "sans-serif";
            font-size: 62.5%;
        }
        
        .slider { 
            margin: .3em;
            width: 14em;
        }
        
        div.table_list { border:1px solid black; }
        input.filter { width:8em; }
        input.week { width:8em; }
    </style>     
     
    
    </head>

    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
        function getRawParameterByName(name) {
            // & is the limitor of url
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\@/g, "&") );
        }
        
        ///////////////////////////////////////////////////////////////////////////////////
        //
        //    Global declare and config here
        //
    
        google.load('visualization', '1', {packages: ['corechart', 'table']});

        $.widget("ui.tooltip", $.ui.tooltip, {
                  options: {
                      content: function () {
                          return $(this).prop('title');
                      }
                  }
              });    
        $( document ).tooltip();
        
        var chart_width = 1000;
        var chart_height = 320;     
        var g_diagram_width = 0;
    var g_diagram_height = 0;
    var g_diagram_filted_issues = [];
    var g_diagram_default_width = 800;
    var g_diagram_default_height = 400;
    var PROJECT_ISSUE_THRESHOLD = 10;
    var PROECT_TEAM_THRESHOLD = 20;
    var swteams = ['mbj_wsd_oss5_cnn2', 'mbj_wsd_oss5_cnn3', 'wcn_se1_cs5', 'wcn_se1_cs6', 'ctd_se5_cs1', 'ctd_se5_cs2', 'wsd_acf_af11'];
    var fwteams = ['ctd_se5_cs3', 'ctd_se5_cs5', 'ctd_se5_cs6', 'mcd_ctd_se5_cs6', 'mcd_ctd_se5_cs7'];
    
        function finishloading(){
			console.log('google chart ready done');
			var endtime = new Date();
			var difftime = endtime.getTime() - begintime.getTime();
			console.log(" takes " + parseInt( difftime/1000/60) + " mins " + parseInt( (difftime/1000)%60) + " seconds " + difftime %1000);
			
			var project = getRawParameterByName('project');
            if (project)
            {
               console.log("project: " + project);
               $("#list_project_assign").val(project);
                $('select').selectmenu('refresh', true);
            }
            
            var filter = getRawParameterByName('filter');
            if (filter)
            {
               // + in url become space
               console.log("filter: [" + filter + "] " + filter.length);
               filter = filter.split("|").join("&")
               console.log("filter: [" + filter + "] " + filter.length);
               
               document.getElementById('list_cr_filter').value = filter;
               refresh_list_table();
            }

            var state = getRawParameterByName('state');
            if (state)
            {
               // + in url become space
               console.log("state: [" + state + "] " );
               $("#list_cr_state").val(state);
                $('select').selectmenu('refresh', true);
            }

		}
		
		$(function(){
			google.load("visualization", "1", {packages:["corechart"]});
			google.setOnLoadCallback(finishloading);
		});
		
		var begintime = new Date();
    </script>


    <script type="text/javascript">
    ////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //    Following script is gen by tools
    //
    <%='\n'.join(g_script_blocks)%>
    //
    //    End of tool gen script
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////
    </script>    
        
    <body>
    <button style="float: right;" id="help_icon">HELP</button>
    <h1> <%=get_feature_name()%> feature category - CR Status (W<%=config.min_wk%> ~ W<%=config.max_wk%>) <%=g_db_create_time%>  </h1>     

    <script>
        $("#help_icon").button({
          icons: {
            primary: "ui-icon-info"
          },
          text: true
        })
        .click(function() {
        		window.open("http://wiki/download/attachments/29196349/CQReport_BT_Daylong.pptx?api=v2");
            //window.open("http://swdev/cqreport/doc/CQReport.pptx");
        });
    </script>
    
    <!---------------------------------------------------------------------------------------------------------
    
        Utility functions
    
    --------------------------------------------------------------------------------------------------------->
    <script>
        Date.prototype.format = function (fmt) { //author: meizz 
            var o = {
                "M+": this.getMonth() + 1,
                "d+": this.getDate(), 
                "h+": this.getHours(), 
                "m+": this.getMinutes(), 
                "s+": this.getSeconds(), 
                "q+": Math.floor((this.getMonth() + 3) / 3), 
                "S": this.getMilliseconds()
            };
            if (/(y+)/.test(fmt)) 
                fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
            for (var k in o)
                if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
            return fmt;
        }        
        // from http://jsfiddle.net/joquery/9KYaQ/
        String.format = function() {
            // The string containing the format items (e.g. "{0}")
            // will and always has to be the first argument.
            var theString = arguments[0];
            
            // start with the second argument (i = 1)
            for (var i = 1; i < arguments.length; i++) {
                // "gm" = RegEx options for Global search (more than one instance)
                // and for Multiline search
                var regEx = new RegExp("\\{" + (i - 1) + "\\}", "gm");
                theString = theString.replace(regEx, arguments[i]);
            }
            return theString;
        }

        // http://stackoverflow.com/questions/15313418/javascript-assert
        function assert(condition, message) {
            if (!condition) {
                message = message || "Assertion failed";
                if (typeof Error !== "undefined") {
                    throw new Error(message);
                }
                throw message; // Fallback
            }
        }
                
        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }  
                
        function get_default_param(v, default_value) {
            v = typeof v !== 'undefined' ? v : default_value;
            return v;
        }

        function get_param(v, default_value) {
            v = typeof v !== 'undefined' ? v : default_value;
            return v;
        }

        function get_dict_key_len(dict) {
            var sz = 0;
            for (var p in dict)
            {
                if (dict.hasOwnProperty(p)) 
                    sz++;
            }
            return sz;
        }
        
        /////////////////////////////////////////////////////////////////////////////
        //
        // Issue helper
        //
        function getIssueField(id, fieldname) {
            if (fieldname in g_issue_field_idx && id in g_issues) {
                return g_issues[id][g_issue_field_idx[fieldname]];
            }
            return null;
        }

        function isEService(key) {        
            return getIssueField(key, 'Source') == "Customer";
        }
        
        function isClosed(id) {
            return getIssueField(id, 'State') == 'Closed';
        }
        
        function isResolvedVerified(id) {
            var state = getIssueField(id, 'State');
            return (state == 'Resolved' || state == 'Verified');
        }
        
        function isOpen(id) {
            if (isClosed(id)) return false;
            if (isResolvedVerified(id)) return false;
            return true;
        }
        function isCompleted(id) {
            return getIssueField(id, 'Resolution') == 'Completed';
        }
        function isNR(id) {
            return getIssueField(id, 'Resolution') == 'Not reproducible';
        }

        function isDuplicated(id) {
            return getIssueField(id, 'Resolution') == 'Duplicated';
        }
        
        function isRejected(id) {
            return getIssueField(id, 'Resolution') == 'Rejected';
        }

        function isGoogleIssue(id) {
            return getIssueField(id, 'Resolution') == 'Google or Android not fix';
        }

        function isVendorResolving(id) {
            return getIssueField(id, 'Progress') == 'Vendor resolving';
        }

        function isVendorResolved(id) {
            var v = getIssueField(id, 'Progress');
            if (v && v != 'Vendor resolving') return true;
            return false;
        }

        function isVendor(id) {
            if (getIssueField(id, 'Progress')) return true;
            return false;
        }

        function contains(s, finds) {
            if (typeof finds == 'string')
                return (s.indexOf(finds) > -1);
            else
            {
                for (var idx in finds)
                {
                    if (finds[idx] && contains(s, finds[idx])) 
                        return true;
                }
                return false;
            }
        }
        
        function isSideEffect(id) {
            return contains(getIssueField(id, 'Title'), '[Side Effect]');
        }

        function isCarkit(id) {
            return contains(getIssueField(id, 'Title').toLowerCase(), 'carkit');
        }
        
        function isSanityFail(id) {
            var Title = getIssueField(id, 'Title');
            return (Title.indexOf('[Sanity Fail]') > -1);
        }

        function isRework(id) {
            return getIssueField(id, 'Reworking') ? true : false;
        }
        
        function isAcceptSource(source_or_isES, qc_type, es_type)
        {
            var isES = (source_or_isES == 'Customer' || source_or_isES == true);
            
            if (!isES && qc_type) return true;
            if (isES && es_type)  return true;
            
            return false;
        }
                
        function isDateInWeeks(d, wk1, wk2)
        {
            if (!d) return false;

            assert(wk2 >= wk1 && wk1 >= 0 && wk2 + 1 < g_wkdate_list.length, "invalid isDateInWeeks");
            var d_start = g_wkdate_list[wk1].getTime();
            var d_end = g_wkdate_list[wk2 + 1].getTime();
            
            return (d.getTime() >= d_start && d.getTime() < d_end);
        }
        
        function compareDateByWeek(d, wk)
        {
            assert(wk >= 0 && wk + 1 < g_wkdate_list.length, "invalid compareDateByWeek");
            
            var d_start = g_wkdate_list[wk].getTime();
            if (d.getTime() < d_start) return -1;
            
            if (g_wkdate_list[wk + 1])
            {
                var d_end = g_wkdate_list[wk + 1].getTime();
                if (d.getTime() >= d_end) return 1;
            }
            
            return 0;            
        }
        
        function isDateInWeek(d, wk)
        {
            if (!d) return false;
            return compareDateByWeek(d, wk) == 0;
        }
        
        /*---------------------------------------------------------------------------------------------------------
            UI widget utility
        ---------------------------------------------------------------------------------------------------------*/
        
        function initWeekSlide(name, range, values, onUpdateCallback)
        {
            function callback() {
                onUpdateCallback();
            }
        
            function updateRange(r)
            {
                var m1 = r[0];
                var m2 = r[1];
                
                $("#" + name).data("start", m1);
                $("#" + name).data("end", m2);

                $("#" + name).data("start_date", g_wkdate_list[m1]);
                $("#" + name).data("end_date", g_wkdate_list[m2 + 1]);

                $("#" + name + "-text").val( "W" + g_wk_list[m1] + " ~ W" + g_wk_list[m2] );
            }
                        
            function onWeekSlideChanged(event, ui) {
                updateRange(ui.values);
                callback();
            }
            
            $("#" + name).slider({
              range: true,
              min: range[0],
              max: range[1],
              values : values,
              slide: onWeekSlideChanged,
            });
            updateRange(values);
        }
        
        function initCrTypeButton(name, qc, es, onUpdateCallback)
        {
            function callback() {
                onUpdateCallback();
            }
        
            $("#" + name).buttonset();
            $("#" + name).data("qc", qc);
            $("#" + name).data("es", es);
            
            $("#" + name + "-qc").button().click(
                function() {
                    var checked = $(this).is(':checked');
                    if (checked)
                    {
                        $("#" + name).data("qc", true);
                        $("#" + name).data("es", false);
                    }
                    callback();
                }
            );
            $("#" + name + "-es").button().click(
                function() {
                    var checked = $(this).is(':checked');
                    if (checked)
                    {
                        $("#" + name).data("qc", false);
                        $("#" + name).data("es", true);
                    }
                    callback();
                }
            );
            $("#" + name + "-all").button().click(
                function() {
                    var checked = $(this).is(':checked');
                    if (checked)
                    {
                        $("#" + name).data("qc", true);
                        $("#" + name).data("es", true);
                    }
                    callback();
                }
            );
                        
            if (qc && es) {
                $("#" + name + "-all").prop( "checked", true);
            }
            else if (qc) {
                $("#" + name + "-qc").prop( "checked", true);
            }
            else if (es) {
                $("#" + name + "-es").prop( "checked", true);
            }
            $("#" + name).buttonset("refresh");        
        }
        
        function initSelectMenu(name, array, onCallback)
        {
            var options = [];
            for (var idx in array) {
                var m = array[idx];
                options.push("<option value='" + m + "'>" + m + "</option>");                
            }
            $('#' + name).empty();
            $('#' + name)
                .append(options.join(""))
                .selectmenu({
                        select: function( event, ui ){
                            $(this).data("select_label", ui.item.label); 
                            onCallback();
                        },
                        width : 'auto',
                    });
            $('#' + name).data("select_label", array[0]);        
            $('#' + name).selectmenu('refresh');
        }
        
        function initMemberList(name, onCallback)
        {
            var all_teams = {};
            var all_members = {};
            for (var key in g_issues)
            {
                a = getIssueField(key, 'Assignee_Name');
                t = getIssueField(key, 'Assignee.groups');
                
                if (L2Mode && g_active_team != t) continue;
                
                all_members[a] = 1;
                all_teams[t] = 1;
            }
        
            var options = ["All"];
            
            /*if (L1Mode) 
            {
                var teams = [];
                for(var t in all_teams) teams.push(t);
                teams.sort();
                
                for (var t in teams)
                    options.push(teams[t]);
            }
            else
            {
                for (var m in all_members) {
                    options.push(m);
                }
            }*/
            initSelectMenu(name, options, onCallback);
        }        

        function initProjectList(name, onCallback)
        {
            var all_teams = {};
            for (var key in g_issues)
            {
                t = getIssueField(key, 'Project');
                
                
                if( all_teams[t] == undefined){
                    all_teams[t] = 1;
                }else{
                    all_teams[t] = all_teams[t] + 1;
                }
                
            }
        
            var options = ["All"];
            
            //if (L1Mode) 
            {
                var teams = [];
                for(var t in all_teams){
                    if( all_teams[t] >= PROJECT_ISSUE_THRESHOLD ){
                    teams.push(t);
                    }
                }
                teams.sort();
                
                for (var t in teams)
                    options.push(teams[t]);
            }
            initSelectMenu(name, options, onCallback);
        } 
        
    function initTeamList(name, onCallback)
        {
            var all_teams = {};
            for (var key in g_issues)
            {
                t = getIssueField(key, 'Assignee.groups');
                
                
                if( all_teams[t] == undefined){
                    all_teams[t] = 1;
                }else{
                    all_teams[t] = all_teams[t] + 1;
                }
                
            }
        
            var options = ["All"];
            
            //if (L1Mode) 
            {
                var teams = [];
                for(var t in all_teams){
                    if( all_teams[t] >= PROJECT_ISSUE_THRESHOLD && all_teams[t] != '' && all_teams[t] != ' '){
                        teams.push(t);
                    }
                }
                teams.sort();
                
                for (var t in teams)
                    options.push(teams[t]);
            }
            initSelectMenu(name, options, onCallback);
        } 
        
        /*---------------------------------------------------------------------------------------------------------
            Project class utility
        ---------------------------------------------------------------------------------------------------------*/
        function Project(name){
            this.name = name;
            this.r = [];
            this.r.push(name)
            console.log( this.r)
        }
        
            Project.prototype.add = function (cr) {
                console.log( " push " + typeof(cr) );
                this.r.push( cr);
                //
                
            };
            Project.prototype.dump = function (){
                console.log("-" * 10 + this.r.name);
                for (var i in this.r ){
                    console.log( i, this.r[i] , this.r.length);
                }
            };
            Project.prototype.getSummary = function (){
                console.log( "" + this.r.length)
                return [this.name, this.r.length, 0, 0, 0, 0]
            };
        
        
        var projlist = []; // global array to construct 
        
        function buildProjectArray(){
            var issuerow = g_issues;
            
            projlist = {};
            projnamelist = get_cr_field_set(g_issues, "Project");
            for( var i in projnamelist ){
                var k ;
                console.log(projnamelist[i]);
                k = new Project(projnamelist[i]);
                projlist[projnamelist[i]] = k;
                k.dump();
            }
            
            console.log(Object.keys(projlist).length); // length of a dictionary by its keys

            for ( var i in issuerow ){
                var name = issuerow[i][g_issue_field_idx['Project']];
                console.log ( "name is " + name  + " id:" + i ); // i is ALPS02324891, issuerow[i] is the content-arry
                
                projlist[name].add( issuerow[i] );
            }
            
            console.log("*****++++++******");
            for( var i in projlist){ // i is the keys
                console.log( i , projlist[i], projlist[i].dump());
            }
        }
        
        
        /*---------------------------------------------------------------------------------------------------------
            CR List Utility
        ---------------------------------------------------------------------------------------------------------*/
    
        function filter_cr_list(cr_list /*a dict*/, filter_function)
        {
            var issues = [];
            for(var key in cr_list)
            {
                if (filter_function(key))
                    issues[key] = cr_list[key];
            }
            return issues;
        }
        
        function filter_cr_date(key, range)
        {
            var week_start = range[0].getTime();
            var week_end = range[1].getTime();
        
            var Submit_Date = getIssueField(key, 'Submit_Date').getTime();
            
            var Resolve_Date = getIssueField(key, 'Resolve_Date');
            
            if (Resolve_Date == '' || Resolve_Date == null)
                Resolve_Date = new Date(2044,1,1,00,00,00,0); // set a very long date

            Resolve_Date = Resolve_Date.getTime();

            if (Resolve_Date < week_start) return false;
            if (Submit_Date  >= week_end) return false;

            return true;
        }

        function filter_cr_assign(key, man)
        {
            if (man != "All" && man != getIssueField(key, 'Assignee_Name'))
                return false;
            return true;
        } 
        
        function filter_project_assign(key, project)
        {
            if (project != "All" && project != getIssueField(key, 'Project'))
                return false;
            return true;
        }         

        function filter_cr_team(key, team)
        {
            if (team != "All" && team != getIssueField(key, 'Assignee.groups'))
                return false;
            return true;
        }    

        function filter_cr_state(key, show_state)
        {
            if (show_state == "All")
                return true;
        
            var cr_isopen = isOpen(key);
            
            if (isOpen(key) && isVendor(key) && show_state == "Vendor Open")
                return true;
                
            if (isOpen(key) && !isVendor(key) && show_state == "Open")
                return true;

            if (!isOpen(key) && show_state == "Resolved")
                return true;
                
            return false;
        }    
        
        function filter_cr_resolution(key, show_resolution)
        {
            if (show_resolution == "All")
                return true;
        
            var resolution = getIssueField(key, 'Resolution');
            
            if ( resolution.toLowerCase().indexOf(show_resolution.toLowerCase()) >=0 )
                return true;
                
            return false;
        }  
       
        
        function filter_cr_class(key, show_class)
        {
            if (show_class == "All")
                return true;
        
            var cr_class = getIssueField(key, 'Class');
            
            if ( cr_class.toLowerCase().indexOf(show_class.toLowerCase()) >=0 )
                return true;
                
            return false;
        }        
        
        function filter_cr_source_type(key, qc_type, es_type)
        {
            return isAcceptSource(isEService(key), qc_type, es_type);
        }    
    
        function filter_cr_range_source(key, range, qc_type, es_type)
        {
            if (typeof qc_type !== 'undefined' && typeof es_type !== 'undefined')
            {
                if (!filter_cr_source_type(key, qc_type, es_type))
                    return false;
            }
            return filter_cr_date(key, range);        
        }
        
        /*---------------------------------------------------------------------------------------------------------
            Cowork List Utility
        ---------------------------------------------------------------------------------------------------------*/
    
        function filter_cowork_list(cowork_list, filter_function)
        {
            var coworks = [];
            for(var idx in cowork_list)
            {
                if (filter_function(cowork_list[idx]))
                    coworks.push(cowork_list[idx]);
            }
            return coworks;
        }
        function filter_cowork_source(item, qc_type, es_type)
        {
            var source_idx = g_cowork_field_idx["Source"];
            return isAcceptSource(item[source_idx], qc_type, es_type);
        }
        function filter_cowork_man(item, man)
        {
            var g = item[g_cowork_field_idx["Coworkers.groups"]];
            var n = item[g_cowork_field_idx["Coworkers.fullname"]];
            if (!g || !n) 
                return false;
            
            if (man == "All") return true;
            if (man in g_team_member)
            {
                return (g == man);
            }
            else
            {
                return (n == man);
            }
            return false;
        }
        function filter_cowork_wks(item, wk1, wk2)
        {
            // If the CR is not resolved, assign the cowork date to last week
            var d = item[g_cowork_field_idx["Resolve_Date"]];
            if (d == null)
            {
                var last_week = g_wkdate_list[g_wkdate_list.length - 1];
                d = new Date(last_week);
                d.setDate(last_week.getDate() -1);
            }

            return isDateInWeeks(
                d, 
                wk1, 
                wk2
            );
        }
        
        /*---------------------------------------------------------------------------------------------------------
            Reassign List Utility
        ---------------------------------------------------------------------------------------------------------*/
        function filter_reassign_list(reassign_list, filter_function)
        {
            var reassigns = [];
            for(var idx in reassign_list)
            {
                if (filter_function(reassign_list[idx]))
                    reassigns.push(reassign_list[idx]);
            }
            return reassigns;
        }
        function filter_reassign_source(item, qc_type, es_type)
        {
            var source_idx = g_reassign_field_idx["Source"];
            return isAcceptSource(item[source_idx], qc_type, es_type);
        }
        function filter_reassign_man(item, man)
        {
            if (man == "All") return true;
            if (man in g_team_member)
            {
                var m = item[g_reassign_field_idx["Change_Log.Old_Value_Brief"]];
                var team = g_member_team[m];
                
                if (man == team)
                    return true;
            }
            else
            {
                var m = item[g_reassign_field_idx["Change_Log.Old_Value_Brief"]];
                if (m == man)
                    return true;
            }
            return false;
        }
        function filter_reassign_wks(item, wk1, wk2)
        {
            return isDateInWeeks(
                item[g_reassign_field_idx["Change_Log.When"]], 
                wk1, 
                wk2
            );
        }

        /*---------------------------------------------------------------------------------------------------------
            Active Team Utility
        ---------------------------------------------------------------------------------------------------------*/
        var filter_owner_ss_add;
        var filter_owner_ss_sub;
        var filter_owner_sss;
        var filter_owner_s;
        
        function filter_owner_name(owner)
        {
            var s = $("#member_filter").val();
            if (!s) return true;
            
            if (s == filter_owner_s)
            {
                ss_add = filter_owner_ss_add;
                ss_sub = filter_owner_ss_sub;
                sss    = filter_owner_sss;
                s      = filter_owner_s;
            }
            else
            {
                filter_owner_s = s;
                
                s = s.toLowerCase();                
                var ss = s.split(" ");
                
                var ss_add = [];
                var ss_sub = [];
                var sss = [];
                for (var idx in ss)
                {
                    var text = ss[idx].replace("&", " ")
                    var pre = text.substring(1, 0);
                    var remain = text.substring(1);
                    if (pre == "+")         { if (remain) ss_add.push(remain); }
                    else if (pre == "-")    { if (remain) ss_sub.push(remain); }
                    else                    { if (ss[idx]) sss.push(text); }
                }
                
                filter_owner_ss_add = ss_add;
                filter_owner_ss_sub = ss_sub;
                filter_owner_sss = sss;                
            }
                        
            owner = owner.toLowerCase();
            if (ss_sub.length && contains(owner, ss_sub)) return false;
            if (ss_add.length && !contains(owner, ss_add)) return false;
            if (!sss.length)return true;
            
            return contains(owner, sss);
        }

        function filter_member(key)
        {
            if (!$.isEmptyObject(g_projects))
            {
                var p = getIssueField(key, 'Project');
                if (!g_projects[p]) return false;
            }
            
            return filter_owner_name(getIssueField(key, 'Assignee_Name'));
        }
        
        function filter_cr_by_active_team(key)
        {
            if (L1Mode) 
                return filter_member(key);
            else 
                return (g_active_team == getIssueField(key, 'Assignee.groups')) && filter_member(key);
        }

        function filter_reassign_by_active_team(item)
        {
            var m = item[g_reassign_field_idx["Change_Log.Old_Value_Brief"]];
            var t = g_member_team[m];
            
            if (!$.isEmptyObject(g_projects))
            {
                var p = item[g_reassign_field_idx['Project']];
                if (!g_projects[p]) return false;
            }            
            
            if (L1Mode) 
                return filter_owner_name(m);
            else
                return (g_active_team == t) && filter_owner_name(m);
        }

        function filter_cowork_by_active_team(item)
        {
            var t = item[g_cowork_field_idx["Coworkers.groups"]];
            var m = item[g_cowork_field_idx["Coworkers.fullname"]];

            if (!$.isEmptyObject(g_projects))
            {
                var p = item[g_cowork_field_idx["Project"]];
                if (!g_projects[p]) return false;
            }            

            if (L1Mode) 
                return filter_owner_name(m);
            else
                return (g_active_team == t) && filter_owner_name(m);
        }

        /*---------------------------------------------------------------------------------------------------------
            Cookie
        ---------------------------------------------------------------------------------------------------------*/
        function setCookie(cname, cvalue, exdays) 
        {
            var d = new Date();
            d.setTime(d.getTime() + (exdays*24*60*60*1000));
            var expires = "expires="+d.toUTCString();
            document.cookie = cname + "=" + cvalue + "; " + expires;
        }        
                
        function getCookie(cname) 
        {
            var name = cname + "=";
            var ca = document.cookie.split(';');
            for(var i=0; i<ca.length; i++) {
                var c = ca[i];
                while (c.charAt(0)==' ') c = c.substring(1);
                if (c.indexOf(name) == 0) return c.substring(name.length,c.length);
            }
            return "";
        }        
        
    </script>

    <!---------------------------------------------------------------------------------------------------------
    
        Team selection
    
    --------------------------------------------------------------------------------------------------------->
    <div style="display:none" id="dialog_member_help" title="Basic dialog">
      <p>The filter syntax is AAA BBB +CCC -DDD.</p>
      <p>That means only showing CR owner name contains AAA or BBB, and must contain CCC, but not contain DDD. You can use "&" to as a white space.
      <p>Ex: CH&Ko YC&Shen Callia</p>
      <p>That means you want show only "CH Ko", "YC Shen", and Callia's data. </p>
      <p>You can specify the default setting in URL, for example:</p>
      <p>Ex: yourteam.html?member=CH%26Ko+YC%26Shen+Callia</p>
      <p>For speed up performance, you also can specify team name by:</p>
      <p>yourteam.html?team=wsd_aaf_af5&member=CH%26Ko+YC%26Shen</p>
    </div>    
    
    <div id="team_selection" class="ui-widget-header ui-corner-all" style="display:none">
        <table><tr>
            <td>
                <span id="team_select"></span>        
            </td>
            <td>
                <input id="member_filter" class="filter" type="text">
                <button id="filter_member_help_icon">Help</button>
            </td> 
            
        </tr></table>    
    </div>

    <script>
        
        var team_name = '<%=get_team_name()%>';
        var L1Mode = true;
        var L2Mode = false;
        var g_active_team = "All";
        var g_projects = {};
        
        /*
        if (get_dict_key_len(g_team_member) == 1)
        {
            // only one team, so hide the header
            L1Mode = false;
            L2Mode = true;
            for (var t in g_team_member)
            {
                g_active_team = t;
                break;
            }
            $("#team_selection").hide();
        }
        else
        {
            var team = getParameterByName('team');
            var previous_team_selection = getCookie(team_name + '_previous_team_selection');
            if (team)
                previous_team_selection = team;

            if (previous_team_selection && previous_team_selection != 'All')
            {
                for (var t in g_team_member)
                {
                    if (t == previous_team_selection)
                    {
                        // found it, it is a valid team name
                        g_active_team = t;
                        L1Mode = false;
                        L2Mode = true;
                        break;
                    }
                }
            }            
        }*/
    // daylong: always l1 mode 
    L1Mode = true;
    L2Mode = false;
        
        
        var member = getParameterByName('member');
        if (member)
        {
            $("#member_filter").val(member);
            setTimeout(function(){refresh_member_filter();}, 1000);
        }

        function filter_project(s, prj)
        {
            if (!s) return [];
            
            s = s.toLowerCase();                
            var ss = s.split(" ");
            
            var ss_add = [];
            var ss_sub = [];
            var sss = [];
            for (var idx in ss)
            {
                var text = ss[idx].replace("&", " ")
                var pre = text.substring(1, 0);
                var remain = text.substring(1);
                if (pre == "+")         { if (remain) ss_add.push(remain); }
                else if (pre == "-")    { if (remain) ss_sub.push(remain); }
                else                    { if (ss[idx]) sss.push(text); }
            }
                                    
            prj = prj.toLowerCase();
            if (ss_sub.length && contains(prj, ss_sub)) return false;
            //if (ss_add.length && !contains(prj, ss_add)) return false;
            if (ss_add.length ){
                for ( var i in ss_add ){
                    if( !contains(prj, ss_add) ){
                        return false;
                    } 
                }
        }             
            if (!sss.length)return true;
            
            return contains(prj, sss);
        }


        var project = getParameterByName('project');
        if (project)
        {
            // final result arrary
            g_projects = {};
            
            // collect all issue project
            projects = [];
            for (var key in g_issues)
            {
                projects[getIssueField(key, 'Project')] = 1;
            }
            for (var p in projects)
            {
                if (filter_project(project, p))
                    g_projects[p] = 1;
            }
            console.log(g_projects);
        }
        
        // handle week offset for weekly report
        function wkdate_offset(offset)
        {
            for (idx in g_wkdate_list)
            {
                var d = g_wkdate_list[idx];
                g_wkdate_list[idx] = new Date(d.setDate(d.getDate() + offset));                
            }
        }
        
        var week_offset = getParameterByName('week_offset');
        if (week_offset)
        {
            console.log("week_offset: " + week_offset);
            week_offset = parseInt(week_offset);
            wkdate_offset(week_offset);
        }
        
        
        // this function is very heavry and almost reset all webpage
        function reset_all(delay)
        {
            reset_summary();
            reset_diagram(delay);
            reset_cr_list();
        }
            
        function team_buttonset_callback() {
            L1Mode = ($("#team_select").data("team") == 'All');
            L2Mode = L1Mode? false : true;
            if (L1Mode)
                $("#js_summay_tabs").tabs("option", "active", 4);
            else
                $("#js_summay_tabs").tabs("option", "active", 0);
            
            reset_all();
        }    

        function onTeamBSButtonClick() {
            var checked = $(this).is(':checked');
            if (checked) {
                
                g_active_team = $(this).data("team");
                $("#team_select").data("team", g_active_team);
                team_buttonset_callback();
                
                setCookie(team_name + '_previous_team_selection', g_active_team, 365);
            }
        }
        
        function refresh_member_filter()
        {
            if ($("#member_filter").val())
            {
                $("#js_summay_tabs").tabs("option", "active", 0);
            }
            else if (L1Mode)
            {
                $("#js_summay_tabs").tabs("option", "active", 4);
            }
            reset_all(1000);
        }
        
        function initMemberFilter()
        {
            $("#filter_member_help_icon").button({
              icons: {
                primary: "ui-icon-help"
              },
              text: true
            })
            .click(function() {
                $( "#dialog_member_help" ).dialog({title: "Filter help"});
            });
            $("#member_filter").keyup(refresh_member_filter);
        }
        
        $(function() 
        {            
            var teams = [];
            for (var t in g_team_member) 
                teams.push(t);
            teams.sort();
            
            function add(t, checked)
            {
                var checked_s = "";
                if (checked) checked_s = ' checked="checked" '
                var s = '<input type="radio" id="team_select-' + t + '" name="team_select"' + checked_s + '><label for="team_select-' + t + '">' + t + '</label>';
                $("#team_select").append(s).buttonset('refresh');
                $("#team_select-" + t).data("team", t);
                $("#team_select-" + t).button().click(onTeamBSButtonClick);
            }
        
            $("#team_select").buttonset();
            add('All', g_active_team == 'All');
            for (var i in teams)
            {
                var t = teams[i];
                add(t, t == g_active_team);
            }
            
            initMemberFilter();
        });
    </script>    
        
    <!---------------------------------------------------------------------------------------------------------
    
        New Report
    
    --------------------------------------------------------------------------------------------------------->
     
    <h2>Overview <div id="checkchrome">- Please use chrome browser<br><br></div></h2>
    
    <script>
                        
        var last_week = g_wk_list.length - 2;
        
        function reset_summary()
        {
            update_summary_table();
        }
        
        function checkChrome(){
          var ua = window.navigator.userAgent;
          var ischrome = ua.toLowerCase().indexOf("chrome");
          
          
          if( ischrome > 0){
             document.getElementById("checkchrome").innerHTML = "";
          }else{
             
          }
        }
        
        $(function() {
            initCrTypeButton("overview_cr_type", true, false, update_summary_table);            
            initWeekSlide("overview_week_slider", 
                [0, last_week], 
                [Math.max(0, last_week - 100), last_week], 
                update_summary_table);                          
        });
        checkChrome();
		
      </script>    
    
    <div class="ui-widget-header ui-corner-all">
        <table><tr>
            <td>
                <span id="overview_cr_type">
                  <input type="radio" id="overview_cr_type-qc" name="overview_cr_type"><label for="overview_cr_type-qc">SQC</label>
                  <input type="radio" id="overview_cr_type-es" name="overview_cr_type"><label for="overview_cr_type-es">eService</label>
                  <input type="radio" id="overview_cr_type-all" name="overview_cr_type"><label for="overview_cr_type-all">*</label>
                </span>        
            </td>
            <td>
                <input type="text" id="overview_week_slider-text" readonly class="ui-state-default week">
            </td>
            <td>
                <div class="slider" id="overview_week_slider"></div>
            </td>
            <td></td> 
            <td><select name="list_project_detail" id="list_project_detail"></select>
            </td>
            <td>
            <a href='#' 
        onclick='downloadCSVProject({ filename: "project_list.csv" });'
    > *** Download Project list as CSV ***</a>
    </td>
        </tr></table>    
    </div>
    
    
    <p>
    </p>
    
    <div id="js_summay_tabs">        
        <ul class="tab">
            <li style="display:none"><a href="#tab_cr_by_member">CR by member</a></li>
            <li style="display:none"><a href="#tab_cr_by_platform">CR by platform</a></li>
            <li style="display:none"><a href="#tab_cr_by_project">CR by project</a></li>
            <li style="display:none"><a href="#tab_cr_by_feature">CR by feature</a></li>
            <li style="display:none"><a href="#tab_cr_by_team">CR by team</a></li>
            <li><a href="#tab_num_by_project">NUM by project</a></li>
        </ul>
        <div id="tab_cr_by_member"></div>
        <div id="tab_cr_by_platform"></div>
        <div id="tab_cr_by_project"></div>
        <div id="tab_cr_by_feature"></div>
        <div id="tab_cr_by_team"></div>
        <div id="tab_num_by_project"></div>
    </div>
    
    <script type="text/javascript">
        function get_project_detail(){
            var show_detail = $("#list_project_detail").data("select_label");
            var detail = 1;
            if (show_detail == 'Simple') detail = 0;
            if (show_detail == 'Carkit') detail = 2;
            if (show_detail == 'All') detail = 3;
            return detail;
        }
        // get each project's summary status array.  the issue_list's project iname already equal project
        function get_summay_row(name, issue_list)
        {
            var Open = 0;
            var Closed = 0;
            var Resolved = 0;
            var NR = 0;
            var Duplicated = 0;
            var Rejected = 0;
            var Google = 0;
            var Rework = 0;
            var Side_Effect = 0;
            var Resolve_Time = 0;
            var Sanity = 0;        
            var rtime = 0;
            var rtime_count = 0;
            var Vendor = 0;
            var CarkitOpen = 0;
            var CarkitResolved = 0;
            
            var carkitCom = 0, carkitDup = 0, carkitNr = 0, carkitRej = 0, carkitsw = 0, carkitfw = 0, carkitother = 0;
            var AllCom = 0, AllDup = 0, AllNr = 0, AllRej = 0, Allsw = 0, Allfw = 0, Allother = 0;
            
            var detail = get_project_detail();
        
            for (var id in issue_list)
            {
                if (isVendor(id))
                {
                    // any reason about vendor
                    Vendor++;
                }
                else if (isClosed(id))
                {
                    Closed++;
                }
                else if (isResolvedVerified(id))
                {
                    Resolved++;
                }
                else
                {
                    Open++;
                }
                    
                if (isNR(id))
                {
                    NR++;
                }
                else if (isDuplicated(id))
                {
                    Duplicated++;
                }
                else if (isRejected(id))
                {
                    Rejected++;
                }
                else if (isGoogleIssue(id))
                {
                    Google++;                    
                }
                
                if (isRework(id))
                    Rework++;
                    
                if (isSideEffect(id))
                    Side_Effect++;
                
                if (isSanityFail(id))
                    Sanity++;
                
                if (isCarkit(id)){
                    if(isClosed(id)){
                        CarkitResolved++;
                    }else if( isResolvedVerified(id) ){
                        CarkitResolved++;
                    }else{
                        CarkitOpen++;
                    }
                    
                    if( detail == 2){
                        // carkitCom = 0, carkitDup = 0, carkitNr = 0, carkitRej = 0, carkitsw = 0, carkitfw = 0, carkitother = 0;
                        if( isRejected(id) )
                            carkitRej++;
                        if( isDuplicated(id) )
                            carkitDup++;
                        if( isNR(id) )
                            carkitNr++;
                        if( isCompleted(id)){
                            carkitCom++;
                            
                            team_name = getIssueField(id, 'Assignee.groups');
                            if(  swteams.indexOf(team_name) > 0 ){
                                carkitsw++;
                            }else if (  fwteams.indexOf(team_name) > 0){
                                carkitfw++;
                            }else{
                                carkitother++;
                            }
                        }
                    }
                }
                
                if( detail == 3){
                        // AllCom = 0, AllDup = 0, AllNr = 0, AllRej = 0, Allsw = 0, Allfw = 0, Allother = 0;
                        if( isRejected(id) )
                            AllRej++;
                        if( isDuplicated(id) )
                            AllDup++;
                        if( isNR(id) )
                            AllNr++;
                        if( isCompleted(id)){
                            AllCom++;
                            
                            team_name = getIssueField(id, 'Assignee.groups');
                            if(  swteams.indexOf(team_name) >= 0 ){
                                Allsw++;
                            }else if (  fwteams.indexOf(team_name) >= 0){
                                Allfw++;
                            }else{
                                Allother++;
                            }
                        }
                }
                
                
                if (!isOpen(id))
                {
                    var is_count_rt = false;
                    
                    if (isNR(id) || isVendor(id))
                    {
                        // do nothing, just skip NR and vendor related
                    }
                    else if (isEService(id))
                    {
                        var ES_ALLOW_CLASS = ['Bug', 'Question'];
                        for (var allow_idx in ES_ALLOW_CLASS)
                        {
                            if (ES_ALLOW_CLASS[allow_idx] == getIssueField(id, 'Class'))
                            {
                                is_count_rt = true;
                            }
                        }
                    }
                    else
                    {
                        if (getIssueField(id, 'Class') == 'Bug')
                        {
                            is_count_rt = true;
                        }
                    }
                    
                    if (is_count_rt)
                    {
                        rtime += getIssueField(id, 'Resolve_Time');
                        rtime_count ++;
                    }
                }
            }
            var rt = rtime / rtime_count;
            var rtime_count;
            if (rtime_count > 0)
                rtime_display = parseFloat(rt.toFixed(1));
            else
                rtime_display = 0;
            
            var ret = [ name, Open, Closed + Resolved, NR, Duplicated, Vendor, Google, Sanity, Rework, Side_Effect]; // ret[0]~ret[9]
            ret = ret.concat( [ rtime_display, CarkitOpen+CarkitResolved, CarkitOpen, CarkitResolved] ); // ret[10] ~ ret[13]
            
            ret = ret.concat([ carkitCom , carkitDup, carkitNr , carkitRej , carkitsw , carkitfw , carkitother ]);
            ret = ret.concat([ AllCom , AllDup, AllNr , AllRej , Allsw , Allfw , Allother ]);
            return ret;
        }
                
        function update_cr_table(table, title, rows)
        {
            var FIELDS = ["Open", "Resolved", "NR", "Duplicated", "Vendor", "Google", "Sanity", "Rework", "Side Effect", "Resolve Time"]
            var FIELDS2 = ["Open", "Resolved", "Reassign", "Cowork", "NR", "Duplicated", "Vendor", "Google", "Sanity", "Rework", "Side Effect", "Resolve Time"]

            var isManMode = true;
            if (rows.length)
                isManMode = (rows[0].length > 2);
            
            var data = new google.visualization.DataTable();
            data.addColumn('string', title);
            
            if (!isManMode)
            {
                for (var f in FIELDS) {
                    data.addColumn('number', FIELDS[f]);
                }
            }
            else
            {
                for (var f in FIELDS2) {
                    data.addColumn('number', FIELDS2[f]);
                }                
            }
            
            for (var m in rows){
                var r = get_summay_row(rows[m][0], rows[m][1]);
                
                if (!isManMode)
                {
                    data.addRow(r);
                }
                else
                {
                    var re = rows[m][2].length;
                    var co = rows[m][3].length;
                    var r2 = [r[0], r[1], r[2], re, co];
                    r2 = $.merge(r2, r.slice(3));
                    
                    data.addRow(r2);
                }
            }
            
            table.draw(data, {showRowNumber: false, allowHtml: true});
        }
        
        function getPercentage( n, total ){
            if(total < 1){
                return 0;
            }
            
            return  Math.floor(n *10000/total)/100;
        }

        function update_num_table(table, title, rows)
        {
            var detail = get_project_detail();
            var FIELDS = ["Submit(Bug/Ques/...)", "Open", "Resolved", "Open Rate", "Carkit-Submit", "Carkit-Open", "Carkit-Resolved", "Carkit-Open Rate", "Total-Carkit Rate" ];
            console.log("detail", detail);
            if( detail == 2){
                FIELDS = FIELDS.concat( [ "CK-Complete", "CK-Dup", "CK-NR", "CK-Rej", "CK-SW", "CK-FW", 'CK-Other'] );
            }
            if( detail == 3){
                FIELDS = FIELDS.concat( [ "All-Complete", "All-Dup", "All-NR", "All-Rej", "All-SW", "All-FW", 'All-Other'] );
            }
            
            var isManMode = false;
            
            var data = new google.visualization.DataTable();
            data.addColumn('string', title);
            
            if (!isManMode)
            {
                for (var f in FIELDS) {
                    if( FIELDS[f] == 'All-SW' ){
                        data.addColumn('number', '<div class="tooltip" title="'+ 'SW teams:'+ swteams.join(',\n') +' ">' + FIELDS[f] + '</div>');
                    }else if( FIELDS[f] == 'All-FW' ){
                        data.addColumn('number', '<div class="tooltip" title="'+ 'FW teams:'+ fwteams.join(',\n') +' ">' + FIELDS[f] + '</div>');
                    }else
                    {
                    data.addColumn('number', FIELDS[f]);
                }
            }
            }
            else
            {
            }
            
            for (var m in rows){
                var r = get_summay_row(rows[m][0], rows[m][1]);
                
                if (!isManMode)
                {
                    // 
                    // [ name, Open, Closed + Resolved, NR, Duplicated, Vendor, Google, Sanity, Rework, Side_Effect, rtime_display, carkitsubmit, carkitopen, carkitresolved];
                    //console.log( r.length);
                    if( (r[1]+r[2]) > PROJECT_ISSUE_THRESHOLD){
                        var onerow = [r[0], r[1]+r[2], r[1], r[2], getPercentage(r[1], r[1]+r[2]), r[11], r[12], r[13], getPercentage(r[12], r[11]), getPercentage(r[11], r[1] + r[2]) ]
                        if( detail == 2){
                            onerow = onerow.concat([ r[14], r[15], r[16], r[17], r[18], r[19], r[20] ]);
                        }
                        if( detail == 3){
                            onerow = onerow.concat([ r[21], r[22], r[23], r[24], r[25], r[26], r[27] ]);
                        }
                        data.addRow( onerow );
                    }
                }
                else
                {
                    var re = rows[m][2].length;
                    var co = rows[m][3].length;
                    var r2 = [r[0], r[1], r[2], re, co];
                    r2 = $.merge(r2, r.slice(3));
                    
                    data.addRow( [r2[0], r2[1],r2[2],r2[3]]);
                }
            }
            
            g_project_datatable = data;
            
            table.draw(data, {showRowNumber: false, allowHtml: true, sortColumn : 2, sortAscending : false});
        }        
        
        function update_cr_man_table(table, title, rows)
        {
            var FIELDS = ["Open", "Resolved", "Reassign", "Cowork", "NR", "Duplicated", "Google", "Sanity", "Rework", "Side Effect", "Resolve Time"]
            
            var data = new google.visualization.DataTable();
            data.addColumn('string', title);
            
            for (var f in FIELDS) {
                data.addColumn('number', FIELDS[f]);
            }
            
            for (var m in rows){
                r = get_summay_row(rows[m][0], rows[m][1]);
                data.addRow(r);
            }
            
            table.draw(data, {showRowNumber: false, allowHtml: true});
        }
        
        function get_overview_cr_list(filter_team)
        {            
            var week_start = $("#overview_week_slider").data("start_date");
            var week_end = $("#overview_week_slider").data("end_date");                
            
            var r = filter_cr_list(g_issues,
                function(key) {
                    return filter_cr_date(key, [week_start, week_end]);
                }
            );
             
            if (get_param(filter_team, true))
            {
                r = filter_cr_list(r,
                    function(key) {
                        return filter_cr_by_active_team(key);
                    }
                );
            }
           
            var qc_type = $("#overview_cr_type").data("qc");
            var es_type = $("#overview_cr_type").data("es");
            
            r = filter_cr_list(r,
                function(key) {
                    return filter_cr_source_type(key, qc_type, es_type);
                }
            );
            return r;
        }
        
        function get_cr_field_set(issues, field_name)
        {
            field_set = [];
            for(var key in issues)
            {
                field_set[getIssueField(key, field_name)] = 1;
            }
            
            var fields = [];
            for (var f in field_set){
                fields[fields.length] = f;
            }
            fields.sort();
            return fields;
        }
        
        function get_overview_reassign_list(filter_team)
        {                        
            var wk1 = $("#overview_week_slider").data("start");
            var wk2 = $("#overview_week_slider").data("end");

            var r = filter_reassign_list(g_reassigns,
                function(item) {
                    return filter_reassign_wks(item, wk1, wk2);
                }
            );
            
            if (get_param(filter_team, true))
            {
                r = filter_reassign_list(r,
                    function(item) {
                        return filter_reassign_by_active_team(item);
                    }
                );
            }
                        
            var qc_type = $("#overview_cr_type").data("qc");
            var es_type = $("#overview_cr_type").data("es");
            
            r = filter_reassign_list(r,
                function(item) {
                    return filter_reassign_source(item, qc_type, es_type);
                }
            );                
            return r;
        }         
        
        function get_overview_cowork_list(filter_team)
        {
            var wk1 = $("#overview_week_slider").data("start");
            var wk2 = $("#overview_week_slider").data("end");

            var r = filter_cowork_list(g_coworks,
                function(item) {
                    return filter_cowork_wks(item, wk1, wk2);
                }
            );
            
            if (get_param(filter_team, true))
            {
                r = filter_cowork_list(r,
                    function(item) {
                        return filter_cowork_by_active_team(item);
                    }
                );
            }
                
            var qc_type = $("#overview_cr_type").data("qc");
            var es_type = $("#overview_cr_type").data("es");
            
            r = filter_cowork_list(r,
                function(item) {
                    return filter_cowork_source(item, qc_type, es_type);
                }
            );
            return r;
        }    
        
        function get_key_sorted_list(ms)
        {
            var members = [];
            for (var m in ms)
                members.push(m);
            members.sort();
            return members;
        }
        
        function update_cr_by_member_table()
        {
            var issues_set = get_overview_cr_list();
            var reassign_set = get_overview_reassign_list();
            var cowork_set = get_overview_cowork_list();
           
            var members1 = get_cr_field_set(issues_set, 'Assignee_Name');
            
            var ms = [];
            for (var m in members1)
                ms[members1[m]] = 1;
            for (var m in reassign_set)
                ms[reassign_set[m][g_reassign_field_idx['Change_Log.Old_Value_Brief']]] = 1;
            for (var m in cowork_set)
                ms[cowork_set[m][g_cowork_field_idx['Coworkers.fullname']]] = 1;
            
            var members = get_key_sorted_list(ms);
            
            var rows = []
            for (var m in members){
                member = members[m];
                var issues = filter_cr_list(issues_set,
                    function(key) {
                        return filter_cr_assign(key, member);
                    }
                );
                var reassigns = filter_reassign_list(reassign_set,
                    function(item) {
                        return filter_reassign_man(item, member);
                    }
                );
                var coworks = filter_cowork_list(cowork_set,
                    function(item) {
                        return filter_cowork_man(item, member);
                    }
                );
                rows[rows.length] = [member, issues, reassigns, coworks];
            }                        
            update_cr_table(g_cr_by_member_table, 'Member', rows);
        }
        
        function update_cr_by_platform_table()
        {
            var issues_set = get_overview_cr_list();
            var platforms = get_cr_field_set(issues_set, 'Platform');
            
            rows = [];
            for (var m in platforms){
                platform = platforms[m];
                var issues = filter_cr_list(issues_set,
                    function(key)
                    {
                        return getIssueField(key, 'Platform') == platform;
                    }
                );
                rows[rows.length] = [platform, issues];
            }                        
            update_cr_table(g_cr_by_platform_table, 'Platform', rows);
        }
        
        function update_cr_by_project_table()
        {
            var issues_set = get_overview_cr_list();
            var names = get_cr_field_set(issues_set, 'Project');

            rows = [];
            for (var m in names){
                name = names[m];
                var issues = filter_cr_list(issues_set,
                    function(key)
                    {
                        return getIssueField(key, 'Project') == name;
                    }
                );
                rows[rows.length] = [name, issues];
            }                        
            update_cr_table(g_cr_by_project_table, 'Project', rows);
        }

        function update_cr_by_feature_table()
        {
            var issues_set = get_overview_cr_list();
            var names = get_cr_field_set(issues_set, 'Feature_Name');
            
            rows = [];
            for (var m in names){
                name = names[m];
                var issues = filter_cr_list(issues_set,
                    function(key)
                    {
                        return getIssueField(key, 'Feature_Name') == name;
                    }
                );
                rows[rows.length] = [name, issues];
            }                        
            update_cr_table(g_cr_by_feature_table, 'Feature', rows);
        }

    function update_num_by_project_table()
        {
            var issues_set = get_overview_cr_list();
            var names = get_cr_field_set(issues_set, 'Project');
            console.log( "update_num_by_project_table")

            rows = [];
            for (var m in names){
                name = names[m];
                var issues = filter_cr_list(issues_set,
                    function(key)
                    {
                        return getIssueField(key, 'Project') == name;
                    }
                );
                rows[rows.length] = [name, issues];
            }                        
            update_num_table(g_num_by_project_table, 'Project', rows);
        }        
        
        function get_teams()
        {
            var teams = [];
            for (var t in g_team_member)
                teams.push(t);
            teams.sort();
            return teams;
        }
        
        function update_cr_by_team_table()
        {
            var issues_set = get_overview_cr_list(false);
            var reassign_set = get_overview_reassign_list(false);
            var cowork_set = get_overview_cowork_list(false);
            
            var rows = [];
            var teams = get_teams();
            
            for (var idx in teams) {
                var team = teams[idx];
                
                var issues = filter_cr_list(issues_set,
                    function(key) {
                        return filter_cr_team(key, team);
                    }
                );
                var reassigns = filter_reassign_list(reassign_set,
                    function(item) {
                        return filter_reassign_man(item, team);
                    }
                );
                var coworks = filter_cowork_list(cowork_set,
                    function(item) {
                        return filter_cowork_man(item, team);
                    }
                );
                rows.push([team, issues, reassigns, coworks]);
            }                        
            update_cr_table(g_cr_by_team_table, 'Team', rows);

        }            
        
        function update_summary_table()
        {
            var active = $("#js_summay_tabs").tabs( "option", "active");
            console.log( "update_summary_table :" + active);
            if (active == 0)
                update_cr_by_member_table();
            else if (active == 1)
                update_cr_by_platform_table();
            else if (active == 2)
                update_cr_by_project_table();
            else if (active == 3)
                update_cr_by_feature_table();
            else if (active == 4)
                update_cr_by_team_table();
            else if (active == 5)
                console.log( "update_summary_table yes:" + active);
                update_num_by_project_table();
        }
        
        function selectHandler(e){
            try{
                rownum = g_num_by_project_table.getSelection()[0]['row'];
                console.log(rownum);
                // get the data of column1 
                 var selection = g_num_by_project_table.getSelection();
                 var value = g_project_datatable.getValue(rownum,     0 );
                console.log(  value);
                $("#diagram_project_assign").children().each(
                    function(){
                        
                        if( $(this).text() == value){
                            $(this).attr("selected", true);
                            console.log("yes selected !");
                        }
                        //console.log($(this).text());
                    }
                );
                
                $("#diagram_project_assign").val(value);
                $("#list_project_assign").val(value);
                $('select').selectmenu('refresh', true);
                // $("#list_project_assign").
            }catch(err){
            }
        }
        
        $(function(){
            var e;
            e = document.getElementById("tab_cr_by_member");
            g_cr_by_member_table = new google.visualization.Table(e);
            
            e = document.getElementById("tab_cr_by_platform");
            g_cr_by_platform_table = new google.visualization.Table(e);

            e = document.getElementById("tab_cr_by_project");
            g_cr_by_project_table = new google.visualization.Table(e);

            e = document.getElementById("tab_cr_by_feature");
            g_cr_by_feature_table = new google.visualization.Table(e);

            e = document.getElementById("tab_cr_by_team");
            g_cr_by_team_table = new google.visualization.Table(e);

            e = document.getElementById("tab_num_by_project");
            g_num_by_project_table = new google.visualization.Table(e);
            google.visualization.events.addListener(g_num_by_project_table, 'select', selectHandler);
            
            var active = 0;
            if (L1Mode)
                active = 5;
                
            $("#js_summay_tabs").tabs({active : active});
            $("#js_summay_tabs").on("tabsactivate", function( event, ui ) {update_summary_table();});
            
            update_summary_table();
        });
    </script>
    

    <!---------------------------------------------------------------------------------------------------------
    
        Diagram
    
    --------------------------------------------------------------------------------------------------------->
    
    <h2>Diagram</h2>
    
    <script type="text/javascript">    
        var cr_trend_diagram;
        var handle_diagram;
        var loading_diagram;
    
        function reset_diagram(delay)
        {
            initMemberList('diagram_cr_assign', refresh_diagram);
            initProjectList('diagram_project_assign', refresh_diagram);
            refresh_diagram_delay(delay);
        }           
                
        function slider_refresh_diagram()
        {
            refresh_diagram_delay(200);
        }

        $(function() {
            initCrTypeButton("diagram_cr_type", true, false, refresh_diagram);
            
            initWeekSlide("diagram_week_slider", 
                [0, last_week], 
                [Math.max(0, last_week - 24), last_week], 
                slider_refresh_diagram);            
            
            initSelectMenu("diagram_display_type", 
                ["Curve", "Line", "Bar"], 
                refresh_diagram);
                
            initSelectMenu("diagram_charttype_type", 
                ["ColumnChart", "PieChart", "Table"], 
                refresh_diagram_list);
            
            initSelectMenu("list_project_detail", 
                ["Basic", "Carkit", "All"], 
                update_summary_table);
            
            $("#diagram_display_info").buttonset();
            $("#diagram_display_info-accu").click(function(){refresh_diagram();});
            $("#diagram_display_info-rate").click(function(){refresh_diagram();});

            $("#loading_diagram_buttonset").buttonset();
            $("#loading_diagram-vendor").click(function(){refresh_diagram();});
            $("#loading_diagram-reassign").click(function(){refresh_diagram();});
            $("#loading_diagram-cowork").click(function(){refresh_diagram();});
            $("#loading_diagram-duplicate").click(function(){refresh_diagram();});

            initMemberList('diagram_cr_assign', refresh_diagram);
            initProjectList('diagram_project_assign', refresh_diagram);
            
            // init the diagram div
            cr_trend_diagram    = new google.visualization.ComboChart(document.getElementById('cr_trend_diagram2'));
            defect_diagram      = new google.visualization.ComboChart(document.getElementById('defect_diagram2'));
            loading_diagram     = new google.visualization.ComboChart(document.getElementById('loading_diagram2'));
        
            $("#diagram_tabs").tabs({activate: refresh_diagram});
            
            //cr_trend_diagram
            
            $( window ).resize(function() {
                // refresh_diagram(); // take too many time to refresh the diagram when issue list is large
            });
            
            
            refresh_diagram();            
        })
    </script>
    
    <div class="ui-widget-header ui-corner-all">
        <table><tr>
            <td>            
                <span id="diagram_cr_type">
                  <input type="radio" id="diagram_cr_type-qc" name="diagram_cr_type"><label for="diagram_cr_type-qc">SQC</label>
                  <input type="radio" id="diagram_cr_type-es" name="diagram_cr_type"><label for="diagram_cr_type-es">eService</label>
                  <input type="radio" id="diagram_cr_type-all" name="diagram_cr_type"><label for="diagram_cr_type-all">*</label>
                </span>        
            </td>
            <td>
                <select name="diagram_display_type" id="diagram_display_type"></select>
            </td>                        
            <td>            
                <span id="diagram_display_info">
                  <input type="checkbox" id="diagram_display_info-accu"><label for="diagram_display_info-accu">Accu</label>
                  <input type="checkbox" id="diagram_display_info-rate"><label for="diagram_display_info-rate">Rate</label>
                </span>        
            </td>
            <td>
                <select name="diagram_cr_assign" id="diagram_cr_assign"></select>
            </td>
            <td>
                <select name="diagram_project_assign" id="diagram_project_assign"></select>
            </td>            
            <td>
                <input type="text" id="diagram_week_slider-text" readonly class="ui-state-default week">
            </td>
            <td>
                <div class="slider" id="diagram_week_slider"></div>
            </td> 
            <td>
                <button id="diagram_resize_update" onclick="refresh_diagram_delay(200)" >Resize Diagram</button>       
            </td>
            <td>
                <label for="diagram_cr_filter" style="display:none">Title Filter  </label>
                </td>
                <td>
                <input id="diagram_cr_filter" class="filter" type="text" style="display:none">
                </td>            
            
        </tr></table>
    </div>    
    <p>
    </p>
    
    <script type="text/javascript">

        var diagram_delay_timer;
        
        function refresh_diagram_delay(ms)
        {
            if (diagram_delay_timer) 
            {
                clearTimeout(diagram_delay_timer);
            }
            diagram_delay_timer = setTimeout(function(){refresh_diagram();}, ms);
        }

        function refresh_diagram() {
            var active = $("#diagram_tabs").tabs( "option", "active");
            if (active == 0)
                update_cr_trend_diagram();
            else if (active == 1)
                update_defect_diagram();
            else if (active == 2)
                update_loading_diagram();

            $('#diagram_display_info-rate').prop("disabled", active != 1);
        }

        function get_cr_diagram_selected_man()
        {
            return $("#diagram_cr_assign").data("select_label");
        }

        function get_diagram_man(man)
        {
            return get_default_param(man, get_cr_diagram_selected_man());
        }
        
        function get_cr_trend_list(man)
        {
            man = get_diagram_man(man);
        
            var qc_type     = $("#diagram_cr_type").data("qc");
            var es_type     = $("#diagram_cr_type").data("es");
            var project = $("#diagram_project_assign").val()
            var filter_text = $("#list_cr_filter").val().toLowerCase();
            
            var issues_by_team = filter_cr_list(g_issues,
                function(key) {
                    return filter_cr_by_active_team(key);
                }
            );
            var issues = [];
            for(var key in issues_by_team)
            {
                var Submit_Date = getIssueField(key, 'Submit_Date');
                
                if (compareDateByWeek(Submit_Date, 0) == -1) 
                {
                    console.log("skip CR due to submit date is below range:" + key);
                    continue;
                }
                
                if (L1Mode)
                {
                    // this is team mode
                    if (man != "All" && man != getIssueField(key, 'Assignee.groups'))
                        continue;
                }
                else
                {
                    if (man != "All" && man != getIssueField(key, 'Assignee_Name'))
                        continue;
                }
                
                if (project != "All" && project != getIssueField(key, 'Project'))
                        continue;
                
                if (!isAcceptSource(isEService(key), qc_type, es_type))
                    continue;

                issues[key] = g_issues[key];
            }
            return issues;
        }        

        function get_diagram_cowork_list(wk, man)
        {
            var qc_type = $("#diagram_cr_type").data("qc");
            var es_type = $("#diagram_cr_type").data("es");
            
            return filter_cowork_list(g_coworks,
                function(item)
                {
                    return  filter_cowork_by_active_team(item) &&
                            filter_cowork_source(item, qc_type, es_type) &&
                            filter_cowork_man(item, man) &&
                            filter_cowork_wks(item, wk, wk);
                }
            );
        }        
        
        function getCoworkDict(man)
        {
            man = get_diagram_man(man);
            var dict = [];
            
            var wk = 0;
            for (; wk <= last_week; wk++)
            {
                var coworks = get_diagram_cowork_list(wk, man);
                
                dict[wk] = coworks.length;
            }
            return dict;
        }

        function get_diagram_reassign_list(wk, man)
        {
            var qc_type = $("#diagram_cr_type").data("qc");
            var es_type = $("#diagram_cr_type").data("es");

            return filter_reassign_list(g_reassigns,
                function(item)
                {
                    return filter_reassign_by_active_team(item) &&
                            filter_reassign_source(item, qc_type, es_type) &&
                            filter_reassign_man(item, man) &&
                            filter_reassign_wks(item, wk, wk);
                }
            );
        }        
        
        function getReassignDict(man)
        {
            man = get_diagram_man(man);
            
            var dict = [];
            var wk = 0;
            for (; wk <= last_week; wk++)
            {
                var reassigns = get_diagram_reassign_list(wk, man);
                dict[wk] = reassigns.length;
            }
            return dict;
        }
        
        function update_cr_trend_diagram() 
        {
            var accu = $("#diagram_display_info-accu").prop("checked");
            var diagram_display_type = $("#diagram_display_type").data("select_label");
            var line = (diagram_display_type == "Bar")? false : true;
            var curve = (diagram_display_type == "Curve");
        
            var issues = get_cr_trend_list();
            
            var coworkDict = getCoworkDict();
            var reassignDict = getReassignDict();
            
            var data = []
            data[data.length] = ['Week', 'Resolve', 'Open', 'Submit', 'Reassign', 'Cowork', 'Vendor Open'];
            
            function data_append(array)
            {
                data[data.length - 1] = $.merge(data[data.length - 1], array);
            }
            
            var accu_submit = 0;
            var accu_resolve = 0;
            var accu_vendor_submit = 0;
            var accu_vendor_resolve = 0;
            
            var Resolve = 0;
            var Reassign = 0;
            var Cowork = 0;
            var Submit = 0;
            var VendorSubmit = 0;
            var VendorResolve = 0;
            var filter_text = $("#diagram_cr_filter").val().toLowerCase();
            
            var bak = [0, 0, 0, 0, 0, 0];
            
            var wk = 0;
            for (; wk <= last_week; wk++)
            {
                if (!accu)
                {
                    Resolve = 0;
                    Reassign = 0;
                    Cowork = 0;
                    Submit = 0;
                    VendorSubmit = 0;
                    VendorResolve = 0;
                }
                
                Cowork += coworkDict[wk];
                Reassign += reassignDict[wk];
                
                for (var key in issues)
                {
                    if( filter_text.length > 0 && filter_cr_title(key, filter_text) == false ){
                        continue;
                    }
                    
                    if (isDateInWeek(getIssueField(key, 'Submit_Date'), wk))
                    {
                        Submit += 1;
                        if (isVendor(key)) VendorSubmit += 1;
                    }

                    if (isDateInWeek(getIssueField(key, 'Resolve_Date'), wk))
                    {
                        Resolve += 1;
                        if (isVendor(key)) VendorResolve += 1;                        
                    }
                }
                
                accu_submit         = accu? Submit : (accu_submit + Submit);
                accu_resolve        = accu? Resolve : (accu_resolve + Resolve);
                accu_vendor_submit  = accu? VendorSubmit : (accu_vendor_submit + VendorSubmit);
                accu_vendor_resolve = accu? VendorResolve : (accu_vendor_resolve + VendorResolve);
                                
                // backup previous data
                if (wk == $("#diagram_week_slider").data("start") - 1)
                {
                    bak = [Resolve, Submit, Reassign, Cowork, VendorSubmit, VendorResolve];
                }
                
                if (wk < $("#diagram_week_slider").data("start")) continue;
                if (wk > $("#diagram_week_slider").data("end")) break;

                if (!accu)
                {
                    data.push([
                        "W" + g_wk_list[wk],
                        Resolve, 
                        (accu_submit - accu_resolve) - (accu_vendor_submit - accu_vendor_resolve), 
                        Submit, 
                        Reassign, 
                        Cowork,
                        accu_vendor_submit - accu_vendor_resolve,
                        ]);
                }
                else
                {
                    data.push([
                        "W" + g_wk_list[wk],
                        Resolve     - bak[0], 
                        (accu_submit - accu_resolve) - (accu_vendor_submit - accu_vendor_resolve), 
                        Submit      - bak[1], 
                        Reassign    - bak[2], 
                        Cowork      - bak[3],
                        accu_vendor_submit - accu_vendor_resolve,
                        ]);
                }
            }

            // debug code for dump collect data
            if (0)
            {            
                var s = ""
                for (var wk in g_wkdate_list)
                {
                    s += "[" + wk + "]";
                    s += g_wkdate_list[wk];
                }
                console.log(s);
            
                for (var idx in data[0])
                {
                    var s = "";
                    var wk = 0;
                    for (var wk in data)
                    {
                        s += data[wk][idx] + " ";
                    }
                    console.log(s);                
                }
            }
                                    
            var dataTable = google.visualization.arrayToDataTable(data);
              
            cr_trend_diagram.draw(dataTable,
                { 
                    title: 'CR Trend' + (accu ? " (Accumulate)" : ""), 
                    seriesType: line?'lines':'bars', 
                    height: chart_height,
                    tooltip: { trigger: 'selection' },
                    curveType: curve?'function':'none',
                    vAxis: {viewWindow: {min:0} },
                }            
            );        
        }
        
        function update_defect_diagram() 
        {
            var accu = $("#diagram_display_info-accu").prop("checked");
            var rate = $("#diagram_display_info-rate").prop("checked");
            var diagram_display_type = $("#diagram_display_type").data("select_label");
            var line = (diagram_display_type == "Bar")? false : true;
            var curve = (diagram_display_type == "Curve");
        
            issues = get_cr_trend_list();
            
            var data = []
            data[data.length] = ['Week', 'Rework', 'Sanity', 'Side Effect', 'Resolve Time(Day)'];
            
            var accu_resolve = 0;
            
            var Rework = 0;
            var SideEffect = 0;
            var Sanity = 0;
            var Resolve_Time = 0;
            var Resolve = 0;
            var bak = [0, 0, 0, 0, 0];
            
            var wk = 0;
            for (; wk <= last_week; wk++)
            {
                var d_start = g_wkdate_list[wk].getTime();
                var d_end = g_wkdate_list[wk + 1].getTime();
                
                if (!accu)
                {
                    Resolve = 0;
                    Sanity = 0;
                    Rework = 0;
                    SideEffect = 0;
                    Resolve_Time = 0;
                }
                
                for (var key in issues)
                {
                    var Resolve_Date = getIssueField(key, 'Resolve_Date');
                    
                    if (Resolve_Date && Resolve_Date.getTime() >= d_start && Resolve_Date.getTime() < d_end)
                    {
                        if (!isVendor(key) && !isNR(key))
                        {
                            Resolve += 1;
                            Resolve_Time += getIssueField(key, 'Resolve_Time');
                        }
                        
                        if (isRework(key))
                            Rework += 1;

                        if (isSideEffect(key))
                            SideEffect += 1;

                        if (isSanityFail(key))
                            Sanity += 1;                        
                    }
                }
                
                accu_resolve = accu? accu_resolve + Resolve : Resolve;
                
                // backup previous data
                if (wk == $("#diagram_week_slider").data("start") - 1)
                {
                    bak = [Resolve, Rework, Sanity, SideEffect, Resolve_Time];
                }
                
                if (wk < $("#diagram_week_slider").data("start")) continue;
                if (wk > $("#diagram_week_slider").data("end")) break;

                function toAverage(v, cnt)
                {
                    return cnt? (v/cnt) : 0;
                }
                function toR(v, cnt)
                {
                    return cnt? (100 * v/cnt) : 0;
                }
                function autoR(v, cnt)
                {
                    if (rate) return toR(v, cnt);
                    return v;
                }
                
                if (accu) {
                    r = Resolve - bak[0];
                    data[data.length] = [
                        "W" + g_wk_list[wk], 
                        autoR(Rework      - bak[1], r),
                        autoR(Sanity      - bak[2], r), 
                        autoR(SideEffect - bak[3], r), 
                        toAverage(Resolve_Time - bak[4], r),
                    ];
                }
                else {
                    r = Resolve;
                    data[data.length] = [
                        "W" + g_wk_list[wk], 
                        autoR(Rework,       r),
                        autoR(Sanity,       r), 
                        autoR(SideEffect, r), 
                        toAverage(Resolve_Time, r),
                    ];
                }
            }
        
            var dataTable = google.visualization.arrayToDataTable(data);
              
            defect_diagram.draw(dataTable,
                { 
                    title: 'Defect Trend' + (accu ? " (Accumulate)" : ""), 
                    seriesType: (line? 'lines' : 'bars'), 
                    height: chart_height,
                    tooltip: { trigger: 'selection' },
                    curveType: curve?'function':'none',
                    vAxis: {
                        viewWindow: {min:0}, 
                        title: rate ? "Percent(%)" : "Count",
                    },
                }            
            );        
        }
        
        function update_loading_diagram() {
            // get setting from UI
            var accu = $("#diagram_display_info-accu").prop("checked");
            var diagram_display_type = $("#diagram_display_type").data("select_label");
            var line = (diagram_display_type == "Bar")? false : true;
            var curve = (diagram_display_type == "Curve");
            var qc_type = $("#diagram_cr_type").data("qc");
            var es_type = $("#diagram_cr_type").data("es");

                
            var is_vendor = $("#loading_diagram-vendor").prop("checked");
            var is_reassign = $("#loading_diagram-reassign").prop("checked");
            var is_cowork = $("#loading_diagram-cowork").prop("checked");
            var is_duplicate = $("#loading_diagram-duplicate").prop("checked");
        
        
            var issues = get_cr_trend_list("All");
            
            var members = get_cr_field_set(issues, 'Assignee_Name');
            var teams   = get_cr_field_set(issues, 'Assignee.groups');
            
            var data = [];

            function data_append(array) {
                data[data.length - 1] = $.merge(data[data.length - 1], array);
            }
            
            data.push(['Week']);
            if (teams.length > 1)
                data_append(teams);
            else
                data_append(members);
            
            function array_op(ary, op, val)
            {
                if (op == 'zero') {
                    for (var idx = 0; idx < val; idx++)
                        ary[idx] = 0;
                    return;
                }            
                for (var idx in val)
                {
                    if (op == '=')
                        ary[idx] = val[idx];
                    else if (op == '+=')
                        ary[idx] += val[idx];
                    else if (op == '-=')
                        ary[idx] -= val[idx];
                }
            }            
                        
            var bak = [];
            var accu_loading = [];
            var length = (teams.length > 1)? teams.length : members.length;

            array_op(bak, 'zero', length);
            array_op(accu_loading, 'zero', length);

            var all_cowork_list = filter_cowork_list(g_coworks, function(item) {
                        return filter_cowork_source(item, qc_type, es_type);
            });
            
            var all_reassign_list = filter_reassign_list(g_reassigns, function(item) {
                        return filter_reassign_source(item, qc_type, es_type);
            });
                        
            var wk = 0;
            for (; wk <= last_week; wk++)
            {
                var wk_reassign_list = filter_reassign_list(all_reassign_list, function(item) {
                        return filter_reassign_wks(item, wk, wk);
                });

                var wk_cowork_list = filter_cowork_list(all_cowork_list, function(item) {
                        return filter_cowork_wks(item, wk, wk);
                });
                
                var wk_issues = filter_cr_list(issues, function(key) {
                    return isDateInWeek(getIssueField(key, 'Resolve_Date'), wk);
                });
                                
                var loading = [];
                
                if (teams.length > 1)
                {
                    for (var idx in teams)
                    {
                        team = teams[idx];
                        
                        var Resolve = 0;
                        var Reassign = filter_reassign_list(wk_reassign_list, function(item) {
                                return filter_reassign_man(item, team);
                        });

                        var Cowork = filter_cowork_list(wk_cowork_list, function(item) {
                                return filter_cowork_man(item, team);
                        });
                    
                        for (var key in wk_issues)
                        {
                            if (!filter_cr_team(key, team))
                                continue;
                                
                            if (isVendor(key) && !is_vendor) continue;
                            if (isDuplicated(key) && !is_duplicate) continue;
                            
                            Resolve += 1;
                        }                    
                        loading[idx] = Resolve;
                        if (is_reassign) loading[idx] += Reassign.length;
                        if (is_cowork) loading[idx] += Cowork.length;
                    }
                }
                else
                {
                    for (var idx in members)
                    {
                        man = members[idx];
                        
                        var Resolve = 0;
                        var Reassign = filter_reassign_list(wk_reassign_list, function(item) {
                                return filter_reassign_man(item, man);
                        });

                        var Cowork = filter_cowork_list(wk_cowork_list, function(item) {
                                return filter_cowork_man(item, man);
                        });
                    
                        for (var key in wk_issues)
                        {
                            if (!filter_cr_assign(key, man))
                                continue;
                                
                            if (isVendor(key) && !is_vendor) continue;
                            if (isDuplicated(key) && !is_duplicate) continue;
                            
                            Resolve += 1;
                        }
                        
                        loading[idx] = Resolve;
                        if (is_reassign) loading[idx] += Reassign.length;
                        if (is_cowork) loading[idx] += Cowork.length;
                    }                
                }
                array_op(accu_loading, '+=', loading);
                
                // backup previous data
                if (wk == $("#diagram_week_slider").data("start") - 1)
                {
                    bak = accu_loading.slice(0);
                }
                
                if (wk < $("#diagram_week_slider").data("start")) continue;
                if (wk > $("#diagram_week_slider").data("end")) break;
                
                var row = [];
                if (!accu)
                    array_op(row, '=', loading);
                else {
                    row = accu_loading.slice(0);
                    array_op(row, '-=', bak);
                }
                
                data.push(
                    $.merge(["W" + g_wk_list[wk]], row)
                );
            }
        
            var dataTable = google.visualization.arrayToDataTable(data);
              
            loading_diagram.draw(dataTable,
                { 
                    title: 'CR Loading' + (accu ? " (Accumulate)" : ""), 
                    seriesType: line?'lines':'bars', 
                    height: chart_height,
                    tooltip: { trigger: 'selection' },
                    curveType: curve?'function':'none',
                    vAxis: {viewWindow: {min:0} },
                }            
            );            
        }
        
    </script>
    
    <div id="diagram_tabs">
        <ul class="tab">
            <li><a href="#cr_trend_diagram">CR Trend</a></li>
            <li><a href="#defect_diagram">Defect</a></li>
            <li><a href="#loading_diagram">Loading</a></li>
        </ul>    
        <div id="cr_trend_diagram">
            <div id="cr_trend_diagram2"></div>
        </div>
        <div id="defect_diagram">
            <div id="defect_diagram2"></div>
        </div>  
        <div id="loading_diagram">
            <div class="ui-widget-header ui-corner-all">
            <span id="loading_diagram_buttonset">
                  <input type="checkbox" checked="checked" id="loading_diagram-vendor"><label for="loading_diagram-vendor">vendor</label>
                  <input type="checkbox" checked="checked" id="loading_diagram-reassign"><label for="loading_diagram-reassign">reassign</label>
                  <input type="checkbox" checked="checked" id="loading_diagram-cowork"><label for="loading_diagram-cowork">cowork</label>
                  <input type="checkbox" checked="checked" id="loading_diagram-duplicate"><label for="loading_diagram-duplicate">duplicate</label>
            </span>
            </div>
            <div id="loading_diagram2"></div>  
        </div>  
    </div>
        
    

    <!---------------------------------------------------------------------------------------------------------
    
        CR List
    
    --------------------------------------------------------------------------------------------------------->
    
    <h2>CR List</h2>
    
    <script type="text/javascript">    
        var cr_list_table;
    
        function reset_cr_list()
        {
            //initMemberList('list_cr_assign', refresh_list_table);
            initProjectList('list_project_assign', refresh_project_table);
            initTeamList('list_cr_group', refresh_project_table);
            refresh_cr_list();
        }
    
        function refresh_list_table()
        {
            refresh_cr_list();
        }
        function refresh_project_table()
        {
            refresh_cr_list();
        }        
        
        function getQuote(i){
            var need = false;
            if( typeof(i) != "string"){
                return i;
            }
            if( i.indexOf(',') >= 0){
                need = true;
            }
            if( i.indexOf('"') >= 0){
                need = true;
                i = i.replace(/"/gi, function myf(x){return "'";});
            }
            if( need == true){
            i = '\"' + i +'\"';
            }
            return i;
        }

        function myCsvString(){
            var myCsv = "Col1,Col2,Col3\nval1,val2,val3";
            line = ""
            
            line += 'id';
            for (var i  in g_issue_field_idx ){
                line += ',' + i;
            }
            line += '\n';
            
            for ( var i in g_diagram_filted_issues ){
                
                line += i;
                for ( var  j in g_diagram_filted_issues[i]){
                    line += ',' + getQuote(g_issues[i][j])
                }
                line += '\n';
            }
            myCsv = line;
            return myCsv;
        }

        /**
 * Convert an instance of google.visualization.DataTable to CSV
 * @param {google.visualization.DataTable} dataTable_arg DataTable to convert
 * @return {String} Converted CSV String
 */
function dataTableToCSV(dataTable_arg) {
    var dt_cols = dataTable_arg.getNumberOfColumns();
    var dt_rows = dataTable_arg.getNumberOfRows();
    
    var csv_cols = [];
    var csv_out;
    
    // Iterate columns
    for (var i=0; i<dt_cols; i++) {
        // Replace any commas in column labels
        csv_cols.push(dataTable_arg.getColumnLabel(i).replace(/,/g,""));
    }
    
    // Create column row of CSV
    csv_out = csv_cols.join(",")+"\r\n";
    
    // Iterate rows
    for (i=0; i<dt_rows; i++) {
        var raw_col = [];
        for (var j=0; j<dt_cols; j++) {
            // Replace any commas in row values
            raw_col.push(dataTable_arg.getFormattedValue(i, j, 'label').replace(/,/g,""));
        }
        // Add row to CSV text
        csv_out += raw_col.join(",")+"\r\n";
    }

    return csv_out;
}

        function myCsvProjectString(){
            var myCsv = "Col1,Col2,Col3\nval1,val2,val3";
            line = ""
            
            return dataTableToCSV(g_project_datatable );
            
        }
        
        function downloadCSVProject(args) {  
        var data, filename, link;
        var csv = myCsvProjectString();
        if (csv == null) return;

        filename = args.filename || 'export.csv';

        if (!csv.match(/^data:text\/csv/i)) {
            csv = 'data:text/csv;charset=utf-8,' + csv;
        }
        data = encodeURI(csv);

        link = document.createElement('a');
        link.setAttribute('href', data);
        link.setAttribute('download', filename);
        link.click();
        }

        function downloadCSV(args) {  
        var data, filename, link;
        var csv = myCsvString();
        if (csv == null) return;

        filename = args.filename || 'export.csv';

        if (!csv.match(/^data:text\/csv/i)) {
            csv = 'data:text/csv;charset=utf-8,' + csv;
        }
        data = encodeURI(csv);

        link = document.createElement('a');
        link.setAttribute('href', data);
        link.setAttribute('download', filename);
        link.click();
        }
        
        $(function() {
            
            initCrTypeButton("list_cr_type", true, false, refresh_list_table);
            
            initWeekSlide("list_cr_week_slider", 
                [0, last_week], 
                [0, last_week], 
                refresh_list_table);
            
            initSelectMenu("list_cr_state", 
                ["Open", "All", "Vendor Open", "Resolved"], 
                refresh_list_table);
            initSelectMenu("list_cr_resolution", 
                ["All", "Completed", "Rejected", "Duplicated"], 
                refresh_list_table);
            initSelectMenu("list_cr_class", 
                ["Bug", "All", "Question", "Feature"], 
                refresh_list_table);

            initSelectMenu("list_cr_detail", 
                ["Basic", "Simple", "Details"], 
                refresh_list_table);
                
            //initMemberList('list_cr_assign', refresh_list_table);
            initProjectList('list_project_assign', refresh_project_table);
            initTeamList('list_cr_group', refresh_project_table);
        
            cr_list_table = new google.visualization.Table(document.getElementById("cr_list_table"));

            $("#list_cr_filter").keyup(refresh_list_table);
            
            $("#filter_help_icon").button({
              icons: {
                primary: "ui-icon-help"
              },
              text: true
            })
            .click(function() {
                $( "#dialog-filter_help" ).dialog({title: "Filter help"});
            });
            
            $("#filter_diagram_width_plus").button({
              
              text: true
            })
            .click(function() {
                g_diagram_width += 100;
                console.log("g_diagram_width:" , g_diagram_width)
                refresh_diagram_list();
            });
            $("#filter_diagram_width_minus").button({
              
              text: true
            })
            .click(function() {
                g_diagram_width -= 100;
                console.log("g_diagram_width:" , g_diagram_width)
                refresh_diagram_list();
            });
            $("#filter_diagram_height_plus").button({
              text: true
            })
            .click(function() {
                g_diagram_height += 100;
                console.log("g_diagram_width:" , g_diagram_width)
                refresh_diagram_list();
            });
            $("#filter_diagram_height_minus").button({
              text: true
            })
            .click(function() {
                g_diagram_height -= 100;
                console.log("g_diagram_width:" , g_diagram_width)
                refresh_diagram_list();
            });
            $("#filter_diagram_carkit").button({
              text: true
            })
            .click(function() {
                document.getElementById('list_cr_filter').value = document.getElementById('list_cr_filter').value + " +Carkit";
                refresh_list_table();
                });
            $("#filter_diagram_IOT").button({
              text: true
            })
            .click(function() {
                document.getElementById('list_cr_filter').value = document.getElementById('list_cr_filter').value + " +IOT";
                refresh_list_table();
            });            
            $("#filter_diagram_btreview").button({
              text: true
            })
            .click(function() {
                document.getElementById('list_cr_filter').value = document.getElementById('list_cr_filter').value + " +btreview";
                refresh_list_table();
            });
            $("#filter_diagram_power").button({
              text: true
            })
            .click(function() {
                document.getElementById('list_cr_filter').value = document.getElementById('list_cr_filter').value + " +power&user";
                refresh_list_table();
            });


             $("#overview_cr_type-qc").click(function() {
                   console.log("overview_cr_type-qc click");
                   $("#list_cr_type-qc").attr("checked", true);
                                      
                    setTimeout(function(){
                        $("#list_cr_type-qc").trigger("click");
                        $("#list_cr_type-qc").trigger("click"); // workaround. take 2 click to update the diagram
                        $("#list_cr_type-qc").change();
                        refresh_list_table();}, 1000);
                   
            });
            $("#overview_cr_type-es").click(function() {
                   console.log("overview_cr_type-es click");
                   $("#list_cr_type-es").attr("checked", true);
                   setTimeout(function(){
                    $("#list_cr_type-es").trigger("click");
                    $("#list_cr_type-es").trigger("click"); // workaround. take 2 click to update the diagram
                    $("#list_cr_type-es").change();
                    refresh_list_table();}, 1000);
            });
            $("#overview_cr_type-all").click(function() {
                   console.log("overview_cr_type-all click");
                   $("#list_cr_type-all").attr("checked", true);
                   setTimeout(function(){
                   $("#list_cr_type-all").trigger("click");
                   $("#list_cr_type-all").trigger("click"); // workaround. take 2 click to update the diagram
                   $("#list_cr_type-all").change();
                   refresh_list_table();}, 1000);
            });



            refresh_list_table();            
        })
    </script>
    
    <div class="ui-widget-header ui-corner-all">
        <table><tr>
            <td>            
                <span id="list_cr_type">
                  <input type="radio" id="list_cr_type-qc" name="list_cr_type"><label for="list_cr_type-qc">SQC</label>
                  <input type="radio" id="list_cr_type-es" name="list_cr_type"><label for="list_cr_type-es">eService</label>
                  <input type="radio" id="list_cr_type-all" name="list_cr_type"><label for="list_cr_type-all">*</label>
                </span>        
            </td>
            
            <td>
                <select name="diagram_charttype_type" id="diagram_charttype_type"></select>
            </td>
            <td>
                <label for="list_cr_resolution">Resolution</label>
                </td>
            <td>
            <select name="list_cr_resolution" id="list_cr_resolution"></select>
            </td>
            <td>
                <label for="list_cr_state">State  </label>
                </td>
            <td>
            <select name="list_cr_class" id="list_cr_class"></select>
            </td>
            <td>
                <select name="list_cr_state" id="list_cr_state"></select>
            </td>
            <td>
                <select name="list_cr_detail" id="list_cr_detail"></select>
            </td>          
            <td>
               <label for="list_project_assign">Project  </label>
               </td>
            <td>
               <select name="list_project_assign" id="list_project_assign"></select>
            </td>
            <td>
                <label for="list_cr_group">Group  </label>
            </td>
            <td>    
                <select name="list_cr_group" id="list_cr_group"></select>
            </td> 
            <td>
                <input type="text" id="list_cr_week_slider-text" readonly class="ui-state-default week">
            </td>
            <td>
                <div class="slider" id="list_cr_week_slider"></div>
            </td> 
            <td>
            </td>
            <td>
                <label for="list_cr_filter">Title Filter  </label>
                </td>
                <td>
                <input id="list_cr_filter" class="filter" type="text">
                </td>
            <td>
                <button id="filter_help_icon">Help</button>
                </td>
            
            </tr></table>
            <table><tr>
                <td><button id="filter_diagram_width_plus">Width + 100</button></td>
                <td><button id="filter_diagram_width_minus">Width - 100</button></td>
                <td><button id="filter_diagram_height_plus">Height + 100</button></td>
                <td><button id="filter_diagram_height_minus">Height - 100</button></td>

                <td><button id="filter_diagram_carkit">Carkit</button></td>
                <td><button id="filter_diagram_IOT">IOT</button></td>
                <td><button id="filter_diagram_btreview">BTReview</button></td>
                <td><button id="filter_diagram_power">PowerUser</button></td>
<td>
<a href='#' 
        onclick='downloadCSV({ filename: "cr_list.csv" });'
    > *** Download CR list as CSV ***</a>
    </td>            
            </td> 
            
        </tr></table>
    </div>    
        <div style="display:none" id="dialog-filter_help" title="Basic dialog">
          <p>The filter syntax is AAA BBB +CCC -DDD.<p>That means showing CR contains AAA or BBB, and must contain CCC, but not contain DDD.</p>
        </div>    
    
    <p>
    </p>    
    
     <!---------------------------------------------------------------------------------------------------------
    
        CR Analysis
    
    --------------------------------------------------------------------------------------------------------->
    
    <!-- <h2>Analysis Diagram</h2> -->
        
        
        <div id="analysis_tabs">
        <ul class="tab">
            <li><a href="#state_analysis">State Analysis</a></li>
            <li><a href="#resolution_analysis">Resolution</a></li>
            <li><a href="#cat2_analysis">Category2</a></li>
            <li><a href="#bugreason_analysis">BugReason</a></li>
            <li><a href="#team_analysis">Team</a></li>
			<li><a href="#project_analysis">Project</a></li>
        </ul>  
        <div id="state_analysis"></div>
        <div id="resolution_analysis"></div>
        <div id="cat2_analysis"></div>
        <div id="bugreason_analysis"></div>  
        <div id="team_analysis"></div>
		<div id="project_analysis"></div>
        </div>
    <!-- state by project -->
    <p>    
    </p>    
    
    <div id="cr_list_table" class="table_list"></div>
    <p></p>
    <h3>Data queried at [ <!-- =query_time.strftime("%Y/%m/%d %H:%M") --> <%=g_db_create_time%>  (author: DaylongChen Design) ]   </h3>
    <div id="cr_list_padding" style="height:300px;"></div>    
    
    <script type="text/javascript">
         //.ArraySort(array)
        /* Sort an array
         */
       
         
         function bySortedValue(obj) {
                    var sortable = [];
                    for (var name in obj){
                      sortable.push( [name, obj[name]] );
                    }
                      
                    sortable.sort(function(a, b) {return b[1] - a[1]})
                
                    //return sortable;
                    var dic = {};
                    for( var i in sortable){
                        dic[sortable[i][0]] = sortable[i][1];
                    }
                    return dic;
                }
        function stateArrayByIssue(issues, field){ // field = "State"
            list = [
                [field, "Count", { role: "style" } ], 
                ]; // ["Platinum", 21.45, "blue"]
            
            state = {};
            for (key in issues){
                var t = getIssueField(key, field);
                if ( state[t] == undefined ){
                    state[t] = 0;
                }
                state[t] = state[t] + 1;
            }
            //state = ArraySort(state, function(a, b){return b >a;});
            state = bySortedValue(state);
            
            for( s in state){
                if( s != "")
                    list.push([s, state[s], "blue"]);
            }
            // limit the team numbers and as a others
            if( field == "Assignee.groups" && list.length > PROECT_TEAM_THRESHOLD && PROECT_TEAM_THRESHOLD > 1 ){
                console.log("Assignee.groups ", PROECT_TEAM_THRESHOLD, " ", list.length);
                list1 = list.slice(0, PROECT_TEAM_THRESHOLD);
                list2 = list.slice(PROECT_TEAM_THRESHOLD, list.length);
                var sum = 0;
                if ( list2.length > 0){
                    for( other in list2 ){
                        sum += list2[other][1];
                    }
                }
                // merge list1 & list2('Others')
                list = list1;
                list.push(["Others Fragment", sum, "blue"]);
                console.log("Others Fragment", sum);
            }
            if( field == "Assignee.groups"  ){
                //console.log("print out the sort by assign number");
                for( var i in state ){
                //console.log( i, " state[i]:", state[i]);
                }
            }
            for ( i in state){
                //    console.log( i, " ==> ", state[i]);
            }

            // error handling - avoid no any issue
            if( list.length == 1){
                list.push(["No Data", 0, "blue"]);
            }
            return list;
        }
                
        function drawAnalysisChart(issues, posttitle, field, id){
                //console.log(issues.length);
                var projectTitle = "";
                var sum = 0;
                var group = $('#list_cr_group').val();
                var crstate = $("#list_cr_state").val();
                var filter_text = $("#list_cr_filter").val();
                var class_type = $("#list_cr_class").val();
                var resolution = $("#list_cr_resolution").val();
                
                var tablelist; 
                tablelist = stateArrayByIssue(issues, field); // field = "State
                if( tablelist.length > 1){
                    for( i in tablelist ){
                    // console.log(i, tablelist[i]);
                    // 6 ["Google or Android not fix", 84, "blue"]
                    if( typeof tablelist[i][1] != 'string' && tablelist[i][0] != ""){
                        sum = sum + tablelist[i][1];
                    }
                    }
                }
                if ( crstate == 'All' ){
                    crstate = 'Open, Resolved';
                }
                if ( filter_text.length > 0){
                    filter_text = ', filter:' + filter_text;
                }
                projectTitle = $("#list_project_assign").val() + "-Project " + posttitle + " (" + crstate + filter_text + ")" + " Total:" + sum ;
                
                if( group != "All")
                    projectTitle += " team:" + group;
                if( class_type != "Bug")
                    projectTitle += " class:" + class_type;
                if( resolution != "All")
                    projectTitle += " resolution:" + resolution;
                    
              var data = google.visualization.arrayToDataTable(
                tablelist
              );

              var view = new google.visualization.DataView(data);
              view.setColumns([0, 1,
                               { calc: "stringify",
                                 sourceColumn: 1,
                                 type: "string",
                                 role: "annotation" },
                               2]);
              var options1 = {
                title: projectTitle,
                width: g_diagram_default_width + g_diagram_width,
                height: g_diagram_default_height + g_diagram_height,
                bar: {groupWidth: "90%"},
                legend: { position: "none" }
              };
              var options2 = {
                title: projectTitle,
                width: g_diagram_default_width + g_diagram_width,
                height: g_diagram_default_height + g_diagram_height,
              };
              if ( g_diagram_width != 0 || g_diagram_height != 0){
              var options3 = {
                title: projectTitle,
                width: g_diagram_default_width + g_diagram_width,
                height: g_diagram_default_height + g_diagram_height,
                pieSliceText: "value"
              };
              }else{
              var options3 = {
                title: projectTitle,
                pieSliceText: "value"
              };
              }
              var chart;
              var options;
              var charttype = $("#diagram_charttype_type").val().toLowerCase();
              if( charttype == 1 || charttype == "columnchart"){
                chart = new google.visualization.ColumnChart(document.getElementById(id)); // id "state_analysis"
                options = options1;
              }else if( charttype == 2|| charttype == "piechart"){
                chart = new google.visualization.PieChart(document.getElementById(id)); // id "state_analysis"
                options = options2;
              }else{
                chart = new google.visualization.Table(document.getElementById(id)); // id "state_analysis"
                options = options3;
                view.setColumns([0, 1,
                               ]);
              }
              
              chart.draw(view, options);
        }
        
        function refresh_diagram_list(){
            //if( g_diagram_filted_issues == undefined) 
            //    g_diagram_filted_issues = g_issues;
            issues = g_diagram_filted_issues;
            ///> day
            /// update the state analysis_tabs. calculate the 
            drawAnalysisChart( issues, "by State", "State", "state_analysis");
            drawAnalysisChart( issues, "by Resolution", "Resolution", "resolution_analysis");
            drawAnalysisChart( issues, "by SolutionCategory2", "Solution_Category_Level2", "cat2_analysis");
            drawAnalysisChart( issues, "by BugReason", "Bug_Reason", "bugreason_analysis");
            drawAnalysisChart( issues, "by Team", "Assignee.groups", "team_analysis");
	    drawAnalysisChart( issues, "by Project", "Project", "project_analysis");
            $("#analysis_tabs").tabs();
            ///< day
        }
        
        // return true: follow the s rules, false: not follow the s rules
        function filter_cr_title(key, s)
                {
                    if (!s) return true;
                    
                    var ss = s.split(" ");
                    
                    var ss_add = [];
                    var ss_sub = [];
                    var sss = [];
                    
                    for (var idx in ss)
                    {
                        var text = ss[idx].replace("&", " ")
                        var pre = text.substring(1, 0);
                        var remain = text.substring(1);
                        if (pre == "+")         { if (remain) ss_add.push(remain); }
                        else if (pre == "-")    { if (remain) ss_sub.push(remain); }
                        else                    { if (ss[idx]) sss.push(text); }
                    }
                    if( ss_add.length > 0){
                        //for (var i in ss_add){
                            //console.log("ss_add:", ss_add[i]);
                        //}
                    }
                    
                    // MUST NO-Have
                    if (ss_sub.length && cr_contains(getIssueField(key, 'Title').toLowerCase(), ss_sub)) return false;
                    
                    // MUST have !
                    if (ss_add.length ){
                        for ( var i in ss_add ){
                            if( !contains(getIssueField(key, 'Title').toLowerCase(), ss_add[i].toLowerCase()) ){
                                //console.log(key, ss_add[i], "no match");
                                return false;
                            } 
                        }
                    } 
                    
                    if (ss_add.length) return true;  //fix bug 
                    if (!sss.length) return true;
                    
                    return cr_contains(getIssueField(key, 'Title').toLowerCase(), sss);
                }
            
                function cr_contains(key, ss)
                {
                    if (contains(key.toLowerCase(), ss)) 
                        return true;

                    var cr = g_issues[key];
                    for (var idx in cr)
                    {
                        if (typeof cr[idx] != 'string')
                            continue;

                        // ship history
                        if (idx == g_issue_field_idx['Reassign_History'])
                            continue;
                            
                        if (contains(cr[idx].toLowerCase(), ss)) return true;
                    }
                    return false;
                }
            
        function refresh_cr_list()
        {
            var show_state = $("#list_cr_state").data("select_label");
            var show_detail = $("#list_cr_detail").data("select_label");
            var detail = 1;
            if (show_detail == 'Simple') detail = 0;
            if (show_detail == 'Details') detail = 2;
            //console.log(show_detail, detail)
            var man = 'All' ; // all people $("#list_cr_assign").data("select_label");

            function get_issues()
            {
                var qc_type = $("#list_cr_type").data("qc");
                var es_type = $("#list_cr_type").data("es");
            
                var week_start = $("#list_cr_week_slider").data("start_date");
                var week_end = $("#list_cr_week_slider").data("end_date");

                var filter_text = $("#list_cr_filter").val().toLowerCase();
                var project = $("#list_project_assign").val();
                var group = $('#list_cr_group').val();
                var show_class = $('#list_cr_class').val();
                var resolution = $("#list_cr_resolution").val();
                
                
                
                function filter_cr(key, s)
                {
                    if (!s) return true;
                    
                    var ss = s.split(" ");
                    
                    var ss_add = [];
                    var ss_sub = [];
                    var sss = [];
                    
                    for (var idx in ss)
                    {
                        var text = ss[idx].replace("&", " ")
                        var pre = text.substring(1, 0);
                        var remain = text.substring(1);
                        if (pre == "+")         { if (remain) ss_add.push(remain); }
                        else if (pre == "-")    { if (remain) ss_sub.push(remain); }
                        else                    { if (ss[idx]) sss.push(text); }
                    }
                    
                    if (ss_sub.length && cr_contains(key, ss_sub)) return false;
                    if (ss_add.length && !cr_contains(key, ss_add)) return false;
                    if (!sss.length)return true;
                    
                    return cr_contains(key, sss);
                }
                
                
                

                function filter_by_team(key, team_or_man)
                {
                    if (L1Mode)
                        return filter_cr_team(key, team_or_man);
                    else
                        return filter_cr_assign(key, team_or_man);
                }
                
        function filter_by_group(key, team_or_man)
                {
                    return filter_cr_team(key, team_or_man);
        }
                
                function filter_by_project(key, project)
                {
                    return filter_project_assign(key, project);
                }
                
                return filter_cr_list(g_issues,
                    function(key) 
                    {
                        return filter_cr_by_active_team(key) &&
                               filter_by_team(key, man) &&
                               filter_cr_state(key, show_state) &&
                               filter_cr_resolution(key, resolution) &&
                               filter_cr_range_source(key, [week_start, week_end], qc_type, es_type) &&
                               filter_cr_title(key, filter_text) &&
                               filter_by_project(key, project) &&
                               filter_by_group(key, group) &&
                               filter_cr_class(key, show_class)
                               ;
                    }
                );
            }
        
            var issues = get_issues();
            var opt = {showRowNumber: false, allowHtml: true};
            
            var data = new google.visualization.DataTable();
    
            function addColumn(n, name)
            {
                if (detail >= n) data.addColumn('string', name);
            }
    
            addColumn(0, 'ID');
            addColumn(1, 'Feature');
            addColumn(1, 'Project');
            addColumn(2, 'SW');
            addColumn(2, 'Platform');
            addColumn(2, 'Class');
            addColumn(2, 'Priority');
            addColumn(2, 'Repeat Ratio');
            addColumn(0, 'Title');
            addColumn(0, 'Assignee');
            addColumn(2, 'Progress');
            
            if (show_state != "Resolved")
                addColumn(1, 'Submit');
            
            if (show_state != "Open" && show_state != "Vendor Open") {
                addColumn(1, 'Resolve');
                addColumn(1, 'Resolution');
            }
            //data.addColumn('number', 'Resolving');
            addColumn(0, 'Resolving');
                        addColumn(0, 'Team'); // Null when left MTK company
                        addColumn(0, 'State'); // extrafield
            
            url = '<a href="http://mtkcqweb.mediatek.inc/mtkcqweb_WCX_SmartPhone_ALPS/mtk/sec/cr/cr_view.jsp?crId={0}" target="_blank">{1}</a> (<a href="http://gerrit.mediatek.inc:8080/#/q/{2}"  target="_blank">gerrit</a>)';
            
            function formatDate(d)
            {
                if (!d) return '';
                return d.format("yyyy-MM-dd");
            }
            
            var row = [];

            function add(v) {
                row[row.length] = v;
            }
            function addIssueField(n, key, field) {
                if (detail >= n) add(getIssueField(key, field));
            }
            function addIssueFieldText(n, key, field, em) {                
                if (detail >= n)
                {
                    var s = '<div style="word-wrap: break-word; max-width:{0}em">{1}</div>'
                    add(String.format(s, em, getIssueField(key, field)));
                }
            }            
            function addIssueFieldTooltip(n, key, field, tooltip) {
                if (detail >= n) 
                {
                    var f = getIssueField(key, field);
                    var s = '<p class="tooltip" title="{0}">{1}';
                    add(String.format(s, tooltip, f));
                }
            }
            function addIssueFieldTextTooltip(n, key, field, em, tooltip) {
                if (detail >= n) 
                {
                    var f = getIssueField(key, field);
                    var s = '<div class="tooltip" title="{0}" style="word-wrap: break-word; max-width:{1}em">{2}</div>'
                    add(String.format(s, tooltip, em, f));
                }
            }
            function addIssueFieldDate(n, key, field) {
                if (detail >= n) add(formatDate(getIssueField(key, field)));
            }
            
            function addIssueFieldDateTooltip(n, key, field, em, tooltip) {
                if (detail >= n) 
                {
                    var f = formatDate(getIssueField(key, field));
                    var s = '<div class="tooltip" title="{0}" style="word-wrap: break-word; max-width:{1}em">{2}</div>'
                    add(String.format(s, tooltip, em, f));
                }
            }
            
            for (key in issues)
            {
                row = [String.format(url, key, key, key)];
                
                addIssueFieldText(1, key, "Feature_Name", 10);
                
                var t = getIssueField(key, "Platform") + "<br>" + getIssueField(key, "Sw_Version");
                addIssueFieldTextTooltip(1, key, "Project", 10, t);
                
                addIssueFieldText(2, key, "Sw_Version", 10);
                addIssueField(2, key, "Platform");

                addIssueField(2, key, "Class");
                addIssueField(2, key, "Priority");
                addIssueField(2, key, "Repeat_Ratio");
                addIssueFieldText(0, key, "Title", 40);
                addIssueFieldTooltip(0, key, "Assignee_Name", getIssueField(key, "Reassign_History"));
                addIssueField(2, key, "Progress");
                
                if (show_state != "Resolved"){
                    if( true){
                    addIssueFieldDate(1, key, "Submit_Date");
                    }else{
                    var passedday = 0;
                    passedday = Math.ceil(( new Date() - new Date(getIssueField(key, "Submit_Date")))/(1000*3600*24));
                    addIssueFieldDateTooltip(1, key, "Submit_Date", 10, passedday + " days");
                    }
                }
                
                if (show_state != "Open" && show_state != "Vendor Open") {
                    addIssueFieldDate(1, key, "Resolve_Date");
                    addIssueFieldText(1, key, "Resolution", 8);
                }
                if( false) {
                addIssueField(0, key, "Resolve_Time");
                }else{
                    addIssueFieldTextTooltip(0, key, "Resolve_Time", 10, "days thas last man holds this");
                }
                addIssueFieldText(0, key, "Assignee.groups");
                if( false){
                       addIssueField(0, key, "State"); //extrafield
                }else{
                    // use tooltip
                    var passedday = 0;
                    passedday = Math.ceil(( new Date() - new Date(getIssueField(key, "Submit_Date")))/(1000*3600*24));
                    addIssueFieldTextTooltip(0, key, "State", 5, passedday + " days");
                }
        
                data.addRow(row);
            }

            var formatter = new google.visualization.ColorFormat();
            formatter.addRange(7, 14, 'red');
            formatter.addRange(14, null, 'white', 'red');
            if (row.length > 0)
                formatter.format(data, row.length - 1); // Apply formatter to Resolve_Time
            
            cr_list_table.draw(data, opt);
            
            g_diagram_filted_issues = issues;
            refresh_diagram_list(); // use g_diagram_filted_issues to update diagram
        }
        
        function filter_cr_resolution(key, show_resolution)
        {
            if (show_resolution == "All")
                return true;
        
            var resolution = getIssueField(key, 'Resolution');
        
            if ( resolution.toLowerCase().indexOf(show_resolution.toLowerCase()) >=0 )
                return true;
                
            return false;
        }  
        
            
        
    </script>
    
    
        
        <script type="text/javascript">
        
        var beforeload = (new Date()).getTime();
        
        function getPageLoadTime(){
        //calculate the current time in afterload
        var afterload = (new Date()).getTime();
        // now use the beforeload and afterload to calculate the seconds
        seconds = (afterload-beforeload) / 1000;
        // Place the seconds in the innerHTML to show the results
        $('#load_time').text('Page load time ::  ' + seconds + ' sec(s).');
        console.log('Page load time ::  ' + seconds + ' sec(s).');
        }

        window.onload = getPageLoadTime();    
        console.log('Page');
    </script>
    
    </body>
</html>
