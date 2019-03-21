using Toybox.WatchUi;
using Toybox.System;
using Toybox.Communications;
using Toybox.Timer;
using Toybox.Time;

class ComfirmationLoadNextTidesCurrent extends WatchUi.ConfirmationDelegate {
    
    hidden var location = 0;
    hidden var count = 1;
	hidden var timer;
	hidden var urlDic;
	hidden var requestNum;
	hidden var displayedDate;
    
    function initialize() {
        ConfirmationDelegate.initialize();
    }

    function onResponse(response) {
        if (response != 0) {
            System.println("Confirm");
            var app = Application.getApp();
        	displayedDate = app.getProperty("displayedDate");	
            urlDic = Utils.getUrls(location, displayedDate);
    		requestNum = urlDic.size();
    		app.clearProperties();
            timer = new Timer.Timer();
			timer.start(method(:callBack), 5000, true);
        }
    }
    
    function callBack()
    {
    	System.println("count=" + count);
    	var app = Application.getApp();    	
    	
    	if(count <= requestNum)
    	{
    		var delegate = new WebResponseDelegate(1);
    		delegate.makeWebRequest(urlDic[count], self.method(:onReceive));
    	}
    	else
    	{
    		app.setProperty("displayedDate", displayedDate);
   			WatchUi.requestUpdate();
    		timer.stop();    		
    	}    
    	count++;	
    }
    
    function onReceive(responseCode, data, param) {   
		if (responseCode == 200) {
			Utils.setTidesData(data);       		
		}
		else {
			System.println("Response: " + responseCode);
		}
	}		
}