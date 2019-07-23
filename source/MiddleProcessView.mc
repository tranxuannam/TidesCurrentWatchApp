using Toybox.WatchUi;
using Toybox.AntPlus;
using Toybox.System;
using Toybox.Application;
using Toybox.Time;
using Toybox.Time.Gregorian;

var _message;
var _counter = 0;

class MiddleProcessView extends WatchUi.View {
		
    function initialize(message) {
        View.initialize();
        _message = message;
    }
   
    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout   
        var urlDic = Utils.getUrls("", "")["url"];
        var progressAngle = Utils.ANGLE / urlDic.size();
        var customFont = WatchUi.loadResource(Rez.Fonts.large_font);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
		dc.clear();		
		var cx = dc.getWidth() / 2;
		var cy = dc.getHeight() / 2;		
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		var text = Utils.displayMultilineOnScreen(dc, _message, customFont, WatchUi.loadResource( Rez.Strings.ExtraRoom ).toFloat());		
		var centerY = 0;
		
		if(text.length() >= 20)
		{
			centerY = cy - text.length() / 2;
		}
		else
		{		
       		centerY = cy / 2;
       	} 
       	
       	dc.drawText(cx, centerY, customFont, text, Graphics.TEXT_JUSTIFY_CENTER);
       		
   		if(_counter > 0)
   		{
	       	dc.setPenWidth(3);
		   	dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
		   	dc.drawArc(cx, centerY + 60, 25, Graphics.ARC_COUNTER_CLOCKWISE, 0, progressAngle * _counter);
		   	_counter = 0;
	   	}	 
    }   
}

function setUpProcessing()
{
	_message = WatchUi.loadResource( Rez.Strings.Processing );
	WatchUi.requestUpdate();
}

function setUpMessageFailed(message)
{
	_message = message;	
	_counter = 0;
	WatchUi.requestUpdate();
}

function setUpProgressBar(counter)
{
	System.println("setProgressBar");	
   	_counter = counter;   	
	WatchUi.requestUpdate();
}
