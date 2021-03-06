using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Communications;
using Toybox.Timer;

var timer;

class TidesCurrentWatchAppApp extends Application.AppBase {

	function initialize() {
    	AppBase.initialize();
    	/*
    	if(Utils.getProperty(Utils.OLD_CODE) != null)
       	{}
       	else
       	{   
       		Utils.setProperty(Utils.CODE, "WOI0RPDG");
            WatchUi.switchToView(new MiddleProcessView(WatchUi.loadResource( Rez.Strings.Processing )), new MiddleProcessDelegate(true), WatchUi.SLIDE_UP);
       	}
       	*/    	
    }

    // onStart() is called on application start up
    function onStart(state) {    	
    }    
  
     // Return the initial view of your application here
    function getInitialView() {    	
        return [ new TidesCurrentWatchAppView(), new TidesCurrentWatchAppDelegate() ];
    }
    
    function onSettingsChanged() {	
    	if( timer == null )
	    {	    	
	    	WatchUi.switchToView(new MiddleProcessView(WatchUi.loadResource( Rez.Strings.Processing )), new MiddleProcessDelegate(true), WatchUi.SLIDE_IMMEDIATE);
	    }    	 
	}	
	
}
