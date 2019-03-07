using Toybox.Application;
using Toybox.WatchUi;
using Toybox.Position;
using Toybox.System;
using Toybox.Communications;
using Toybox.Timer;
using Toybox.Time;
using Toybox.Time.Gregorian;

class TidesCurrentWatchAppApp extends Application.AppBase {

	var URL1;
	var URL2;
	var URL3;
	const URL_LOCATION = "http://localhost/TidesCurrent/public/location/60.8/-78.2167/5";
	hidden var beginTidesData = {};
	hidden var midleTidesData = {};
	hidden var lastTidesData = {};
	hidden var URL;
	var month;
	var location = 0;
	
    function initialize() {
        AppBase.initialize();      
    }

    // onStart() is called on application start up
    function onStart(state) {	    
    	System.println("onStart");
    	
    	var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    	
    	if(today.month.toString().length() == 1)
    	{
    		month = "0" + today.month;
    	}
    	URL = Lang.format("http://localhost/TidesCurrent/public/test/$1$/$2$/$3$/", [location, today.year, month]);
    	URL1 = URL + "0/10";
    	URL2 = URL + "10/10";
    	URL3 = URL + "20/11";
    	
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
