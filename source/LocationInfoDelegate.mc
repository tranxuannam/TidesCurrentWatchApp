using Toybox.WatchUi;
using Toybox.Communications;
using Toybox.Application;
using Toybox.System;
using Toybox.Timer;

class LocationInfoDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onBack() {        
        WatchUi.switchToView(new TidesCurrentWatchAppView(), new TidesCurrentWatchAppDelegate(), WatchUi.SLIDE_UP);
        return true;
    }     	
}