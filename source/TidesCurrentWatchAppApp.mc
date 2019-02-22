using Toybox.Application;
using Toybox.WatchUi;
using Toybox.Position;
using Toybox.System;

class TidesCurrentWatchAppApp extends Application.AppBase {

	const URL = "http://localhost/TidesCurrent/public/test/0/2018/01/0/15";
	const URL_LOCATION = "http://localhost/TidesCurrent/public/location/60.8/-78.2167/5";
	
    function initialize() {
        AppBase.initialize();      
    }

    // onStart() is called on application start up
    function onStart(state) {	    
		
    	makeRequest(URL_LOCATION);
    	return true;
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new TidesCurrentWatchAppView(), new TidesCurrentWatchAppDelegate() ];
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
           System.println("First time...");                   // print success
           var app = Application.getApp();
    	   app.setProperty("jsonData", data);
    	   System.println("JsonData in onReceive: " + data); 
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
