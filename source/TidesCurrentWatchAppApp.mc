using Toybox.Application;
using Toybox.WatchUi;
using Toybox.Position;
using Toybox.System;
using Toybox.Communications;

class TidesCurrentWatchAppApp extends Application.AppBase {

	const URL1 = "http://localhost/TidesCurrent/public/test/0/2018/01/0/10";
	const URL2 = "http://localhost/TidesCurrent/public/test/0/2018/01/10/10";
	const URL3 = "http://localhost/TidesCurrent/public/test/0/2018/01/20/11";
	const URL_LOCATION = "http://localhost/TidesCurrent/public/location/60.8/-78.2167/5";
	var tidesData = {};
	var i = 1;
	
    function initialize() {
    	var app = Application.getApp();
    	//app.setProperty("tidesData", new [0]);
    	tidesData = {};
        AppBase.initialize();      
    }

    // onStart() is called on application start up
    function onStart(state) {	    
    	System.println( "onStart");
		makeRequest(URL1);
    	makeRequest(URL2);
    	makeRequest(URL3);  
		//WatchUi.requestUpdate(); 
    	//return true;
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
    	var app = Application.getApp();
    	var json = app.getProperty("tidesData");	
    	System.println( "getInitialView = " + json);
        return [ new TidesCurrentWatchAppView(tidesData), new TidesCurrentWatchAppDelegate() ];
    }
    
    function onSettingsChanged() {	
		var app = Application.getApp();
		//var json = app.getProperty("jsonData");	
		//app.setProperty("myNumber", app.getProperty("myNumber"));		
		//System.println( "myNumber = " + app.getProperty("myNumber"));
		WatchUi.requestUpdate();
	}	
	
	// set up the response callback function
    function onReceive(responseCode, data) {             
       if (responseCode == 200) {
                      
           if(i == 3)
	       {  		
	       		var app = Application.getApp();
	       		//tidesData.addAll(data); 
	       		System.println("data " + i + ":" + data); 
	       		var keys = data.keys();
	       		for (var j=0; j<keys.size(); j++)
	       		{
	       			tidesData.put(keys[j], data[keys[j]]);
	       		}      	
		        app.setProperty("tidesData", tidesData); 
		        System.println("tidesData in onReceive: " + tidesData); 
		        i=0;
		        WatchUi.requestUpdate();
	       }  
	       else
	       {
	       		System.println("data " + i + ":" + data); 
	       		//tidesData.addAll(data);
	       		var keys = data.keys();
	       		for (var j=0; j<keys.size(); j++)
	       		{
	       			tidesData.put(keys[j], data[keys[j]]);
	       		}
	       		i++;
	       }    	 
       }
       else {
           System.println("Response: " + responseCode);            // print response code
       }
	}	
	
	function makeRequest(url) {
       var params = null;
       var options = {
         :method => Communications.HTTP_REQUEST_METHOD_GET,
         :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
       };
       Communications.makeWebRequest(url, params, options, method(:onReceive));
    }

}
