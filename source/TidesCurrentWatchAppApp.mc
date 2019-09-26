using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Communications;
using Toybox.Timer;
using Toybox.Position;

var timer;

class TidesCurrentWatchAppApp extends Application.AppBase {
		
	hidden var positionView;
	
	function initialize() {
    	AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) { 
    	startGpsLocation();
    }  
    
    //! onStop() is called when your application is exiting
    function onStop(state) {
    	stopGpsLocation();
    }  
    
    function startGpsLocation() {    
    	var code = Utils.getProperty("code");
    	var displayedDate = Utils.getProperty("displayedDate");

    	if(((code == null || code.equals("")) && displayedDate != null) || ((code == null || code.equals("")) && displayedDate == null))
    	{
    		Utils.setProperty("selectedDMenu", 1);
	    	Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition));
    	}
    	else
    	{
    		var oldCode = Utils.getProperty("oldCode");

    		if (oldCode == null || !code.equals(oldCode))
    		{    			
    			onSettingsChanged();		    	
	    	}
    	}
    }  
    
    function stopGpsLocation() {
    	Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }
    
    function onPosition(info) {
        positionView.setPosition(info);
    }
  
     // Return the initial view of your application here
    function getInitialView() {    	
        positionView = new TidesCurrentWatchAppView();   	
        return [ positionView, new TidesCurrentWatchAppDelegate() ];        
    }
    
    function onSettingsChanged() {	
    	if( timer == null )
	    {	
	    	WatchUi.switchToView(new MiddleProcessView(WatchUi.loadResource( Rez.Strings.Processing )), new MiddleProcessDelegate(true), WatchUi.SLIDE_IMMEDIATE);
	    }    	 
	}	
	
}
