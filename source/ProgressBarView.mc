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
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onBack() {
        return true;
    }
}

class ProgressBarDelegate extends WatchUi.BehaviorDelegate
{
    hidden var location = 0;
    hidden var count = 1;
	hidden var timer;
	hidden var urlDic;
	hidden var timeForCheckConnect = 2;
	hidden var displayedDate;
	hidden var progressBar;

    function initialize() {
        BehaviorDelegate.initialize();        
        loadNextTidesCurrent();
    }
    
    function onBack() {
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
        urlDic = Utils.getUrls(location, displayedDate);
        app.clearProperties();
        progressBar = new WatchUi.ProgressBar( "Processing", null );
        WatchUi.pushView( progressBar, new ProgressDelegate(), WatchUi.SLIDE_DOWN );
        timer.start( method(:tideCurrentCallback), 2000, true );
    }

    function tideCurrentCallback()
    {
    	System.println("count=" + count);
        if( count > 6 )
        {
            timer.stop();
            var app = Application.getApp();
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
			Utils.setTidesData(data);       		
		}
		else {
			System.println("Response: " + responseCode);
		}
	}
}
