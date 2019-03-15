using Toybox.Application;
using Toybox.WatchUi;
using Toybox.Position;
using Toybox.System;
using Toybox.Communications;
using Toybox.Timer;
using Toybox.Time;
using Toybox.Time.Gregorian;

class TidesCurrentWatchAppApp extends Application.AppBase {

	//const URL_LOCATION = "http://localhost/TidesCurrent/public/location/60.8/-78.2167/5";	
	hidden var location = 0;
	hidden var count = 0;
	hidden var timer;
	hidden var urlDic;
	hidden var requestNum;
	
    function initialize() {
        AppBase.initialize();      
    }

    // onStart() is called on application start up
    function onStart(state) {	    
    	System.println("onStart");    	
    	urlDic = Utils.getUrls(location, Utils.getCurrentDate());
    	requestNum = urlDic.size();
    	
    	var app = Application.getApp();
        var displayedDate = app.getProperty("displayedDate");	
        
        if(displayedDate == null)
        {
	    	timer = new Timer.Timer();
			timer.start(method(:callBack), 5000, true);
		}		
    }        
    
    function callBack()
    {
    	count++;
    	System.println("count=" + count);
    	if(count <= requestNum)
    	{
    		makeRequest(urlDic[count]);
    	}
    	else
    	{
    		timer.stop();    		
    	}    	
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
	
	function setTidesData(data)
	{
		var app = Application.getApp();      
   		var keys = data.keys();
   		for(var i = 0; i< keys.size(); i++)
   		{
   			app.setProperty(keys[i], {keys[i] => data[keys[i]]}.toString()); 
   		}
   		System.println("TideDate = " + data); 		
	}
	
	// set up the response callback function
    function onReceive(responseCode, data) {             
       if (responseCode == 200) {
       		setTidesData(data);
       		if(count == requestNum)
       		{
       			var app = Application.getApp();
        		app.setProperty("displayedDate", Utils.getCurrentDate());
       			WatchUi.requestUpdate();
       		}
       }
       else {
           System.println("Response: " + responseCode);
       }
	}		
	
	//https://forums.garmin.com/forum/developers/connect-iq/143937-
    function makeRequest(url) {
       var params = null;
       var options = {
         :method => Communications.HTTP_REQUEST_METHOD_GET,
         :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
       };
       Communications.makeWebRequest(url, params, options, method(:onReceive));
    }    
   
}
