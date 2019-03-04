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
        //makeRequest();
        //WatchUi.requestUpdate();
        return true;
    } 
       
    // set up the response callback function
    function onReceive(responseCode, data) {             
       if (responseCode == 200) {
           System.println("Second time...");                   // print success
           var app = Application.getApp();
    	   app.setProperty("tidesData", data);
    	   System.println("tidesData in TidesCurrentWatchAppDelegate: " + data); 
       }
       else {
           System.println("Response: " + responseCode);            // print response code
       }
	}	
	
	function makeRequest() {
       var url = URL;
       var params = null;
       var options = {
         :method => Communications.HTTP_REQUEST_METHOD_GET,
         :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
       };
       Communications.makeWebRequest(url, params, options, method(:onReceive));
    }

}