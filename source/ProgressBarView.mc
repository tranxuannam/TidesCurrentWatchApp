using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Timer;

class ProgressBarView extends WatchUi.View
{
    function initialize() {
        View.initialize();
    }

    function onUpdate(dc)
    {       
    }
}

class ProgressDelegate extends WatchUi.BehaviorDelegate
{
	hidden var _timer;
    function initialize(timer) {
    	_timer = timer;
        BehaviorDelegate.initialize();
    }

    function onBack() {
    	if( _timer != null )
        {
        	System.println("onBack");
            _timer.stop();
        }
        return true;        
    }
}

class ProgressBarDelegate extends WatchUi.BehaviorDelegate
{
    hidden var location = 0;
    hidden var count = 1;	
	hidden var urlDic;
	hidden var timeForCheckConnect = 2;
	hidden var displayedDate;
	hidden var progressBar;
	hidden var timer;
	hidden var tmpDic = {};

    function initialize() {
        BehaviorDelegate.initialize();        
        loadNextTidesCurrent();
    }
    
    function onBack() {  
    	System.println("onBack in bar");  	
        return true;
    }

    function loadNextTidesCurrent()
    {
    	WatchUi.popView( WatchUi.SLIDE_IMMEDIATE );
        if( timer == null )
        {
            timer = new Timer.Timer();
        }
		var app = Application.getApp();
    	displayedDate = app.getProperty("displayedDate");	
    	location = app.getProperty("code");
        urlDic = Utils.getUrls(location, displayedDate);
        progressBar = new WatchUi.ProgressBar( "Processing", null );
        WatchUi.pushView( progressBar, new ProgressDelegate(timer), WatchUi.SLIDE_DOWN );
        timer.start( method(:tideCurrentCallback), 2000, true );
    }

    function tideCurrentCallback()
    {
    	System.println("count=" + count);
        if( count > 6 )
        {
            timer.stop();
            var app = Application.getApp();
            app.clearProperties();
            Utils.setTidesData(tmpDic);
            app.setProperty("displayedDate", displayedDate);
            WatchUi.popView( WatchUi.SLIDE_UP );
        }
        else if( count > 5 )
        {
            progressBar.setDisplayString( "Complete" );
        }
        else if( count > timeForCheckConnect )
        {
            progressBar.setProgress( (count - timeForCheckConnect) * 35 );
            var delegate = new WebResponseDelegate(1);
    		delegate.makeWebRequest(urlDic[count - timeForCheckConnect], self.method(:onReceive));
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
		}
	}
}
