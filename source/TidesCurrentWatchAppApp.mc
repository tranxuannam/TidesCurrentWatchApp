using Toybox.Application;
using Toybox.WatchUi;
using Toybox.Position;
using Toybox.System;
using Toybox.Communications;
using Toybox.Timer;
using Toybox.Time;
using Toybox.Time.Gregorian;

class TidesCurrentWatchAppApp extends Application.AppBase {

	const URL_LOCATION = "http://localhost/TidesCurrent/public/location/60.8/-78.2167/5";
	hidden var tidesData1 = {};
	hidden var tidesData2 = {};
	hidden var tidesData3 = {};
	hidden var tidesData4 = {};
	hidden var url;
	var month;
	var location = 0;
	var count = 0;
	var myTimer1;
	var urlDic;
	
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
    	url = Lang.format("http://localhost/TidesCurrent/public/test/$1$/$2$/$3$/", [location, today.year, month]);
    	urlDic = {"1"=>url + "0/5", "2"=>url + "5/5", "3"=>url + "10/5", "4"=>url + "15/5"};    	
    	
    	myTimer1 = new Timer.Timer();
		myTimer1.start(method(:callBack), 5000, true);		
		
    }
    
    function callBack()
    {
    	count++;
    	System.println("count=" + count);
    	switch (count)
    	{
    		case 1:
    			makeRequest(urlDic["1"]);
      		break;
      		
      		case 2:
    			makeRequest(urlDic["2"]);
      		break;
      		
      		case 3:
    			makeRequest(urlDic["3"]);
      		break;
      		
      		case 4:
    			makeRequest(urlDic["4"]);
      		break;
      		
      		default:
      			myTimer1.stop();
      		break;
    	}    	
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new TidesCurrentWatchAppView(tidesData1, tidesData2, tidesData3), new TidesCurrentWatchAppDelegate() ];
    }
    
    function onSettingsChanged() {	
		var app = Application.getApp();
		//var json = app.getProperty("jsonData");	
		//app.setProperty("myNumber", app.getProperty("myNumber"));		
		//System.println( "myNumber = " + app.getProperty("myNumber"));
		WatchUi.requestUpdate();
	}	
	
	function setTidesData(tideDate, name, data)
	{
		var app = Application.getApp();
        var keys = data.keys();
   		for (var j=0; j<keys.size(); j++)
   		{
   			tideDate.put(keys[j], data[keys[j]]);
   		}    
   		System.println(name + " = " + tideDate);	       		
   		app.setProperty(name, tideDate); 	 
	}
	
	// set up the response callback function
    function onReceive(responseCode, data) {             
       if (responseCode == 200) {
       		switch (count)
	    	{
	    		case 1:
	    			 setTidesData(tidesData1, "tidesData1", data);
	      		break;
	      		
	      		case 2:
	    			setTidesData(tidesData2, "tidesData2", data);
	      		break;
	      		
	      		case 3:
	    			setTidesData(tidesData3, "tidesData3", data);
	      		break;
	      		
	      		case 4:
	    			setTidesData(tidesData4, "tidesData4", data);
	      		break;	      	
	      		
	      		default:
	      		break;
	    	}           
       }
       else {
           System.println("Response: " + responseCode);
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
