using Toybox.WatchUi;
using Toybox.Communications;
using Toybox.Application;
using Toybox.System;
using Toybox.Timer;

class TidesCurrentWatchAppDelegate extends WatchUi.BehaviorDelegate {

	const URL = "http://localhost/TidesCurrent/public/test/0/2018/01/10/11";
	var ppTimer;
	var mPressedTime;
	var mTimer;
	
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
    //    WatchUi.pushView(new Rez.Menus.MainMenu(), new TidesCurrentWatchAppMenuDelegate(), WatchUi.SLIDE_UP);
        ppTimer.stop();	
        return true;
    }
    
   	function onNextPage() {  
        var app = Application.getApp();
        var displayedDate = app.getProperty("displayedDate");
        System.println("displayedDate = " + displayedDate);
        var nextDate = Utils.getDisplayDate(displayedDate, Utils.addOneDay(), true);	
        System.println("newDate = " + nextDate);
        displayedDate = app.getProperty(nextDate);
        
        if(displayedDate != null)
        {
	        app.setProperty("displayedDate", nextDate);
	        WatchUi.requestUpdate();
        }
        return true;
    } 
    
    function onPreviousPage() {   	
    	ppTimer = new Timer.Timer();	
    	ppTimer.start( method(:onPrePage), 100, false );
    	//onPrePage();
        return false;
    }  
    
    function onPrePage() {   		
        var app = Application.getApp();
        var displayedDate = app.getProperty("displayedDate");
        System.println("displayedDate = " + displayedDate);
        var nextDate = Utils.getDisplayDate(displayedDate, Utils.addOneDay(), false);	
        System.println("newDate = " + nextDate);
        displayedDate = app.getProperty(nextDate);
        
        if(displayedDate != null)
        {
	        app.setProperty("displayedDate", nextDate);
	        WatchUi.requestUpdate();
        }
    }  
    
    /*
    //https://forums.garmin.com/forum/developers/connect-iq/131739-?351195-Behavior-delegate-and-partial-redraw-questions=
    function onKeyPressed(evt) {
	    var key = evt.getKey();
	    if (key == WatchUi.KEY_UP) {
	    	System.println("KEY_UP press");
	        mPressedTime = System.getTimer();
	        mTimer.start(method(:onKeyHeld), 300, false);
	    }
	    System.println("KEY press = " + key);
	    return true;
	}
	
	function onKeyReleased(evt) {
	    mTimer.stop();
		var key = evt.getKey();
	    if (mPressedTime == null) {
	        return true;
	    }
	
	    var now = System.getTimer();
	    if ((now - mPressedTime) < 300) {
	        // short key press
	        System.println("short key press");
	    }
	    else {
	        // long key press
	        System.println("long key press");
	    }
	    mPressedTime = null;
	    return true;
	}
	
	function onKeyHeld() {
	    // long key press
	    mPressedTime = null;
	    System.println("onKeyHeld press");
	}*/
}