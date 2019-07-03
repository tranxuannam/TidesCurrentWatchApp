using Toybox.WatchUi;
using Toybox.AntPlus;
using Toybox.System;
using Toybox.Application;
using Toybox.Time;
using Toybox.Time.Gregorian;

var _message = WatchUi.loadResource( Rez.Strings.AppSettingRequired );
var _counter = 0;

class TidesCurrentWatchAppView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }
   
    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout   
        var urlDic = Utils.getUrls("", "");
        var progressAngle = Utils.ANGLE / urlDic.size();
        var customFont = WatchUi.loadResource(Rez.Fonts.large_font);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
		dc.clear();		
		var cx = dc.getWidth() / 2;
		var cy = dc.getHeight() / 3;		
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		var text = Utils.displayMultilineOnScreen(dc, _message, customFont);
       	dc.drawText(cx, cy, customFont, text, Graphics.TEXT_JUSTIFY_CENTER); 
       		
   		if(_counter > 0)
   		{
	       	dc.setPenWidth(3);
		   	dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
		   	dc.drawArc(cx, cy + 60, 25, Graphics.ARC_COUNTER_CLOCKWISE, 0, progressAngle*_counter);
	   	}	 
    }   
}

function setUpProcessing()
{
	_message = WatchUi.loadResource( Rez.Strings.Processing );
	WatchUi.requestUpdate();
}

function setUpMessagePhoneConnected()
{
	_message = WatchUi.loadResource( Rez.Strings.phoneConnected );	
	WatchUi.requestUpdate();
}

function setUpMessageFailed()
{
	_messageConfirmDialog = WatchUi.loadResource( Rez.Strings.requestFailed );	
	_counterConfirmDialog = 0;
	WatchUi.requestUpdate();
}

function setUpProgressBar(counter)
{
	System.println("setProgressBar");	
   	_counter = counter;   	
	WatchUi.requestUpdate();
}
