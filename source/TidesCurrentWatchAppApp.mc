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
	hidden var beginTidesData = {};
	hidden var midleTidesData = {};
	hidden var lastTidesData = {};
	hidden var i = 1;
	
    function initialize() {
        AppBase.initialize();      
    }

    // onStart() is called on application start up
    function onStart(state) {	    
    	System.println("onStart");
		makeRequest(URL1);
    	makeRequest(URL2);
    	makeRequest(URL3);  
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
    function onReceive(responseCode, data) {             
       if (responseCode == 200) {
           var app = Application.getApp();
	       if(i == 1)
	       {
	       		beginTidesData = data;
	       		System.println("beginTidesData :" + beginTidesData);	       		
	       		app.setProperty("beginTidesData", beginTidesData); 
	       		i++;
	       }   
	       else
	       if(i == 2)
	       {
	       		System.println("midleTidesData :" + data); 
	       		midleTidesData = data;
	       		app.setProperty("midleTidesData", midleTidesData); 
	       		i++;
	       }  
	       else
	       {  	
	       		System.println("lastTidesData :" + data); 	 
	       		lastTidesData = data;      		
		        app.setProperty("lastTidesData", lastTidesData); 
		        WatchUi.requestUpdate();
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
