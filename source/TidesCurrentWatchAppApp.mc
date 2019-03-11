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
	hidden var url;
	hidden var month;
	hidden var location = 0;
	hidden var count = 0;
	hidden var timer;
	hidden var urlDic;
	hidden var tidesDic;
	hidden var requestNum = 6;
	
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
    	urlDic = {1=>url + "0/5", 2=>url + "5/5", 3=>url + "10/5", 4=>url + "15/5", 5=>url + "20/5", 6=>url + "25/6"};
    	//urlDic = {1=>url + "0/6", 2=>url + "6/6", 3=>url + "12/6", 4=>url + "18/6", 5=>url + "24/7"};     	
    	
    	timer = new Timer.Timer();
		timer.start(method(:callBack), 5000, true);		
		
		//var str = "{2019-03-01=>{flood2=>10:30 AM PST 1.8 kt, flood3=>11:48 PM PST 4.2 kt, ebb1=>06:16 AM PST âˆ’1.8 kt, ebb2=>05:40 PM PST âˆ’3.4 kt, slack2=>02:42 AM PST, slack3=>08:23 AM PST, slack4=>12:48 PM PST, slack5=>08:38 PM PST, sunset=>05:55 PM PST, moonrise=>04:20 AM PST, moonset=>01:13 PM PST, sunrise=>06:50 AM PST}, 2019-03-02=>{flood2=>11:34 AM PST 1.9 kt, ebb1=>07:12 AM PST âˆ’2.2 kt, ebb2=>06:41 PM PST âˆ’3.5 kt, slack2=>03:40 AM PST, slack3=>09:24 AM PST, slack4=>01:54 PM PST, slack5=>09:31 PM PST, sunset=>05:56 PM PST, moonrise=>05:04 AM PST, moonset=>02:08 PM PST, sunrise=>06:48 AM PST}, 2019-03-03=>{flood1=>12:43 AM PST 4.4 kt, flood2=>12:30 PM PST 2.2 kt, ebb1=>07:59 AM PST âˆ’2.5 kt, ebb2=>07:29 PM PST âˆ’3.7 kt, slack2=>04:25 AM PST, slack3=>10:16 AM PST, slack4=>02:53 PM PST, slack5=>10:19 PM PST, sunset=>05:58 PM PST, moonrise=>05:42 AM PST, moonset=>03:07 PM PST, sunrise=>06:46 AM PST}, 2019-03-04=>{flood1=>01:27 AM PST 4.7 kt, flood2=>01:19 PM PST 2.6 kt, ebb1=>08:38 AM PST âˆ’2.7 kt, ebb2=>08:08 PM PST âˆ’3.9 kt, slack2=>05:00 AM PST, slack3=>10:59 AM PST, slack4=>03:45 PM PST, slack5=>11:02 PM PST, sunset=>05:59 PM PST, moonrise=>06:14 AM PST, moonset=>04:07 PM PST, sunrise=>06:44 AM PST}, 2019-03-05=>{flood1=>02:04 AM PST 4.9 kt, flood2=>02:01 PM PST 3.0 kt, ebb1=>09:12 AM PST âˆ’2.9 kt, ebb2=>08:41 PM PST âˆ’4.0 kt, slack2=>05:31 AM PST, slack3=>11:38 AM PST, slack4=>04:31 PM PST, slack5=>11:41 PM PST, sunset=>06:01 PM PST, moonrise=>06:42 AM PST, moonset=>05:09 PM PST, sunrise=>06:43 AM PST}}";	
		
    	//System.println("Final Dic = " + Utils.convertStringToDictionary(str));
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
	
	function setTidesData(name, data)
	{
		var app = Application.getApp();      
   		System.println(name + " = " + data);	       		
   		app.setProperty(name, data.toString()); 
	}
	
	// set up the response callback function
    function onReceive(responseCode, data) {             
       if (responseCode == 200) {
       		setTidesData("tidesData"+count, data);
       		if(count == requestNum)
       		{
       			WatchUi.requestUpdate();
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
