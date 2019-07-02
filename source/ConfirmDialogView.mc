using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Graphics;
using Toybox.System;

var _messageConfirmDialog = WatchUi.loadResource( Rez.Strings.LoadNextData );
var _counterConfirmDialog = 0;

class ConfirmDialogView extends WatchUi.View {

    function initialize() {
        View.initialize();    
    }   
  
    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout        
        
		var customFont = WatchUi.loadResource(Rez.Fonts.large_font);      
		dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
		dc.clear();		
		var cx = dc.getWidth() / 2;
		var cy = dc.getHeight() / 3;		
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		var text = Utils.displayMultilineOnScreen(dc, _messageConfirmDialog, customFont);
       	dc.drawText(cx, cy, customFont, text, Graphics.TEXT_JUSTIFY_CENTER);
       	
       	if(_counterConfirmDialog > 0)
   		{
	       	dc.setPenWidth(3);
		   	dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
		   	dc.drawArc(cx, cy + 60, 25, Graphics.ARC_COUNTER_CLOCKWISE, 0, 120*_counterConfirmDialog);
	   	}	
    }  
}

function setProgressBarConfirmDialog(counter)
{
	System.println("setProgressBar");
	var urlDic = Utils.getUrls("", "");
	if(counter > urlDic.size())
	{
		setProgressBarToDefault();
	}
	else {
		_messageConfirmDialog = WatchUi.loadResource( Rez.Strings.Processing );	
	   	_counterConfirmDialog = counter;   
	   	WatchUi.requestUpdate();
   	}
}

function setProgressBarToDefault()
{
	_messageConfirmDialog = WatchUi.loadResource( Rez.Strings.LoadNextData );	
	_counterConfirmDialog = 0;
}

function setMessageFailed()
{
	_messageConfirmDialog = "Connection failed. You make sure the device connected to phone application. Please try again!";	
	_counterConfirmDialog = 0;
	WatchUi.requestUpdate();
}

function setMessagePhoneConnected()
{
	_messageConfirmDialog = WatchUi.loadResource( Rez.Strings.phoneConnected );	
	_counterConfirmDialog = 0;
	WatchUi.requestUpdate();
}
