using Toybox.WatchUi;
using Toybox.Communications;
using Toybox.Application;
using Toybox.System;

class TidesCurrentWatchAppDelegate extends WatchUi.BehaviorDelegate {

	const URL = "http://localhost/TidesCurrent/public/test/0/2018/01/10/11";
	
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new TidesCurrentWatchAppMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
    
   	function onNextPage() {   		
        var app = Application.getApp();
        var displayedDate = app.getProperty("displayedDate");	
        var dateDic = {"year" => displayedDate.substring(0, 4), "month" => displayedDate.substring(5, 2), "day" => displayedDate.substring(7, 2)};
        System.println("dateDic = " + dateDic);
        var newDate = Utils.getDateByAddedDay(dateDic, Utils.addOneDay());
        System.println("newDate = " + newDate);
        app.setProperty("displayedDate", Lang.format("$1$-$2$-$3$", [newDate["year"], newDate["month"], newDate["day"]]));
        WatchUi.requestUpdate();
        return true;
    } 
   
}