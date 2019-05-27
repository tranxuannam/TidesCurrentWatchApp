using Toybox.WatchUi;
using Toybox.AntPlus;
using Toybox.System;
using Toybox.Application;
using Toybox.Time;
using Toybox.Time.Gregorian;

hidden var _message = "App settings required";

class TidesCurrentWatchAppView extends WatchUi.View {

	const URL = "http://localhost/TidesCurrent/public/test/0/2018/01/0/15";
	hidden var dateDic;

    function initialize() {
    	System.println("Init view");
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {     
        //setLayout(Rez.Layouts.MainLayout(dc));
        setLayout(Rez.Layouts.SetUpLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }
   
    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout   
        var app = Application.getApp();
        var displayedDate = app.getProperty("displayedDate");
        if(displayedDate != null)
        {
			WatchUi.switchToView(new TidesCurrentWatchAppView2(), new TidesCurrentWatchAppDelegate2(), WatchUi.SLIDE_UP); 
        }
        else
        {
        	View.findDrawableById("appMgs").setText(_message);	
        }     
       View.onUpdate(dc);    
    }   
}

function settingsChanged()
{
	System.println("onSettingsChanged");
	_message = "Processing...";
	WatchUi.requestUpdate();
}
