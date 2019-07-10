using Toybox.System;
using Toybox.Communications;
using Toybox.Application;
using Toybox.Lang;
using Toybox.WatchUi;
using Toybox.Time;
using Toybox.Time.Gregorian;

class DialogMessage extends Application.AppBase {
    
    hidden var timer;
    hidden var counter = 0;
    	
    function initialize() {    	
        AppBase.initialize();        
    }   
    
    function dialogMessage()
    {
    	//timer = new Timer.Timer();
		//timer.start(method(:onClose), 1000, true);
    }
    
    function onClose()
    {
    	counter++;
    	if(counter == 5)
    	{
    		//timer.stop();    		
    	}
    }
    
}