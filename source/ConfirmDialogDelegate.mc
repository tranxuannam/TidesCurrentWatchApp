using Toybox.WatchUi;
using Toybox.Communications;
using Toybox.Application;
using Toybox.System;
using Toybox.Timer;

class ConfirmDialogDelegate extends WatchUi.BehaviorDelegate {

	hidden var location;
    hidden var count = 1;	
	hidden var urlDic;
	hidden var displayedDate;
	hidden var timer;
	hidden var tmpDic = {};
	
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {        
    }   
    
    function onSelect() {  
    	if(!Utils.checkPhoneConnected())
        {
        	setMessagePhoneConnected();
        }  
        else
        {
	    	setProgressBarConfirmDialog(0);
	    	loadNextTidesCurrent();  
    	}
    }  
    
    function onBack() {    
	    if( timer != null )
	    {	    	
	    	timer.stop();
	    }
	    setProgressBarToDefault();
    }	
    
    function loadNextTidesCurrent()
    {
        if( timer == null )
        {
            timer = new Timer.Timer();
        }
		var app = Application.getApp();
    	displayedDate = app.getProperty("displayedDate");	
    	location = app.getProperty("code");
    	displayedDate = Utils.getDisplayDate(displayedDate, Utils.addOneDay(), true);
        app.setProperty("displayedDate", displayedDate);
        urlDic = Utils.getUrls(location, displayedDate);
        timer.start( method(:tideCurrentCallback), Utils.TIME_REQUEST_API, true );
    }

    function tideCurrentCallback()
    {
    	System.println("count=" + count);
        if( count > urlDic.size() )
        {
            timer.stop();
            var app = Application.getApp();
       		var name = app.getProperty("location"); 
       		var code = app.getProperty("code"); 
       		var latitude = app.getProperty("latitude"); 
       		var longitude = app.getProperty("longitude");       
            app.clearProperties();
            Utils.setTidesData(tmpDic);
            app.setProperty("displayedDate", displayedDate);
            app.setProperty("location", name); 
            app.setProperty("code", code); 
            app.setProperty("latitude", latitude); 
            app.setProperty("longitude", longitude); 
            setProgressBarConfirmDialog(count);
            WatchUi.popView( WatchUi.SLIDE_UP );
        }     
        else
        {
            var delegate = new WebResponseDelegate(1);
    		delegate.makeWebRequest(urlDic[count], self.method(:onReceive));
    		setProgressBarConfirmDialog(count);
        }
        count++;
    }   
   
    function onReceive(responseCode, data, param) 
    {   
		if (responseCode == 200) {			
			Utils.saveTidesDataToDictionary(data, tmpDic);       	
			System.println("TideDate in tmpDic = " + tmpDic); 		
		}
		else {
			System.println("Response: " + responseCode);
			setMessageFailed();
			count = 1;
			timer.stop();
		}
	}
}