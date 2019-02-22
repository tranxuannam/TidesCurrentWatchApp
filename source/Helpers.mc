using Toybox.System;
using Toybox.Communications;
using Toybox.Application;
using Toybox.Lang;
using Toybox.WatchUi;

class Helpers extends Application.AppBase {
	var _property;
    var _url;
    
    function initialize() {
        AppBase.initialize();
    }
    
    function Helpers(_property, url)
    {
    	_property;
    	_url = url;
    }
    
    // set up the response callback function
   function onReceive(responseCode, data) {   	
             
       if (responseCode == 200) {
           System.println("onReceive()...");                   // print success
           var app = Application.getApp();
    	   app.setProperty(_property, data);
       }
       else {
           System.println("Response: " + responseCode);            // print response code
       }
	}	
	
	function makeRequest() {
       var params = null;
       var options = {
         :method => Communications.HTTP_REQUEST_METHOD_GET,
         :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
       };
    
       Communications.makeWebRequest(_url, params, options, method(:onReceive));
   }
}