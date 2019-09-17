using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Communications;
using Toybox.Timer;
using Toybox.Position;

var timer;

class TidesCurrentWatchAppApp extends Application.AppBase {
		
	hidden var positionView;
	hidden var device;
	
	function initialize() {
    	AppBase.initialize();
    	device = WatchUi.loadResource(Rez.Strings.Device);
    }

    // onStart() is called on application start up
    function onStart(state) {    	      	
    	
    	if (Utils.getProperty("displayedDate") == null)
    	{
    		System.println("onStart");
    		Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition));
    	}  
    }  
    
    //! onStop() is called when your application is exiting
    function onStop(state) {
    	if (Utils.getProperty("displayedDate") == null)
    	{
        	Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
        }
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
