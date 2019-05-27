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
	hidden var count = 1;
	hidden var timer;
	hidden var urlDic;
	hidden var requestNum;
	hidden var message;
	hidden var view = null;
	
    function initialize() {
    	message = "";
        AppBase.initialize();      
    }

    // onStart() is called on application start up
    function onStart(state) {	    
    	//run();	
    } 
    
    function run()
    {
    	System.println("run()");    	
    	urlDic = Utils.getUrls(location, Utils.getCurrentDate());
    	requestNum = urlDic.size();
    	
    	var app = Application.getApp();
        var displayedDate = app.getProperty("displayedDate");	
        
        if(displayedDate == null)
        {
	    	timer = new Timer.Timer();
			timer.start(method(:callBack), 5000, true);
		}		
		else
		{
			WatchUi.switchToView(new TidesCurrentWatchAppView2(), new TidesCurrentWatchAppDelegate2(), WatchUi.SLIDE_UP); 
		}
    }       
    
    function callBack()
    {
    	System.println("count=" + count);
    	if(count <= requestNum)
    	{
    		var delegate = new WebResponseDelegate(1);
    		delegate.makeWebRequest(urlDic[count], self.method(:onReceive));
    	}
    	else
    	{
    		var app = Application.getApp();
    		app.setProperty("displayedDate", Utils.getCurrentDate());  			
   			//WatchUi.requestUpdate();	
    		WatchUi.switchToView(new TidesCurrentWatchAppView2(), new TidesCurrentWatchAppDelegate2(), WatchUi.SLIDE_UP); 
    		timer.stop();    	
    		
    	}    
    	count++;	
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new TidesCurrentWatchAppView(), new TidesCurrentWatchAppDelegate() ];
    }
    
    function onSettingsChanged() {	
		settingsChanged(); 
		run();
	}	
	
	// set up the response callback function
    function onReceive(responseCode, data, param) {   
		if (responseCode == 200) {
			Utils.setTidesData(data);       		
		}
		else {
			System.println("Response: " + responseCode);
		}
	}		
	
}
