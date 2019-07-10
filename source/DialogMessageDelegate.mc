using Toybox.WatchUi;
using Toybox.Communications;
using Toybox.Application;
using Toybox.System;
using Toybox.Timer;

class DialogMessageDelegate extends WatchUi.BehaviorDelegate {

	hidden var timer;
    hidden var counter = 0;
    
    function initialize() {
        BehaviorDelegate.initialize();
        timer = new Timer.Timer();
		timer.start(method(:onClose), 1000, true);
    }

    function onMenu() {        
    }     	
    
    function onClose()
    {
    	counter++;
    	if(counter == 5)
    	{
    		timer.stop();
    		WatchUi.popView( WatchUi.SLIDE_UP );    		
    	}
    }
}