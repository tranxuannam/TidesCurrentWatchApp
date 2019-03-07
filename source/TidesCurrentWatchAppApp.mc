using Toybox.Application;
using Toybox.WatchUi;
using Toybox.Position;
using Toybox.System;
using Toybox.Communications;
using Toybox.Timer;

class TidesCurrentWatchAppApp extends Application.AppBase {

	const URL1 = "http://localhost/TidesCurrent/public/test/0/2018/01/0/10";
	const URL2 = "http://localhost/TidesCurrent/public/test/0/2018/01/10/10";
	const URL3 = "http://localhost/TidesCurrent/public/test/0/2018/01/20/11";
	const URL_LOCATION = "http://localhost/TidesCurrent/public/location/60.8/-78.2167/5";
	hidden var beginTidesData = {};
	hidden var midleTidesData = {};
	hidden var lastTidesData = {};
	var notify;
	
    function initialize() {
        AppBase.initialize();      
    }

    // onStart() is called on application start up
    function onStart(state) {	    
    	System.println("onStart");
    	var myTimer1 = new Timer.Timer();
    	var myTimer2 = new Timer.Timer();
    	var myTimer3 = new Timer.Timer();
		myTimer1.start(method(:makeBeginRequest), 5000, false);
		myTimer2.start(method(:makeMidleRequest), 10000, false);
		myTimer3.start(method(:makeLastRequest), 15000, false);	
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new TidesCurrentWatchAppView(beginTidesData, midleTidesData, lastTidesData), new TidesCurrentWatchAppDelegate() ];
    }
    
    function onSettingsChanged() {	
		var app = Application.getApp();
		//var json = app.getProperty("jsonData");	
		//app.setProperty("myNumber", app.getProperty("myNumber"));		
		//System.println( "myNumber = " + app.getProperty("myNumber"));
		WatchUi.requestUpdate();
	}	
	
	// set up the response callback function
    function onBeginReceive(responseCode, data) {             
       if (responseCode == 200) {
            var app = Application.getApp();
	        var keys = data.keys();
	   		for (var j=0; j<keys.size(); j++)
	   		{
	   			beginTidesData.put(keys[j], data[keys[j]]);
	   		}    
	   		System.println("beginTidesData :" + beginTidesData);	       		
	   		app.setProperty("beginTidesData", beginTidesData); 	       
       }
       else {
           System.println("Response: " + responseCode);            // print response code
       }
	}		
	
	function onMidleReceive(responseCode, data) {             
       if (responseCode == 200) {
            var app = Application.getApp();
	        var keys = data.keys();
       		for (var j=0; j<keys.size(); j++)
       		{
       			midleTidesData.put(keys[j], data[keys[j]]);
       		}  
       		System.println("midleTidesData :" + midleTidesData); 
       		app.setProperty("midleTidesData", midleTidesData); 	       
       }
       else {
           System.println("Response: " + responseCode);            // print response code
       }
	}		
	
	function onLastReceive(responseCode, data) {             
       if (responseCode == 200) {
			var app = Application.getApp();
	    	var keys = data.keys();
       		for (var j=0; j<keys.size(); j++)
       		{
       			lastTidesData.put(keys[j], data[keys[j]]);
       		}       		
       		System.println("lastTidesData :" + lastTidesData); 	 
	        app.setProperty("lastTidesData", lastTidesData); 
	        WatchUi.requestUpdate();
       }
       else {
           System.println("Response: " + responseCode);            // print response code
       }
	}		
    
    function makeBeginRequest() {
    	//notify.invoke("Executing\nRequest");
       var params = null;
       var options = {
         :method => Communications.HTTP_REQUEST_METHOD_GET,
         :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
       };
       Communications.makeWebRequest(URL1, params, options, method(:onBeginReceive));
    }
    
    function makeMidleRequest() {
       var params = null;
       var options = {
         :method => Communications.HTTP_REQUEST_METHOD_GET,
         :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
       };
       Communications.makeWebRequest(URL2, params, options, method(:onMidleReceive));
    }
    
    function makeLastRequest() {
       var params = null;
       var options = {
         :method => Communications.HTTP_REQUEST_METHOD_GET,
         :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
       };
       Communications.makeWebRequest(URL3, params, options, method(:onLastReceive));
    }

}
