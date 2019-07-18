using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Graphics;
using Toybox.System;

var _messageConfirmDialog;
var _counterConfirmDialog = 0;

class ConfirmDialogView extends WatchUi.View {

	hidden var extraRoom = 0.8;
	
    function initialize(message, count) {
        View.initialize(); 
        _messageConfirmDialog = message;
        _counterConfirmDialog = count;   
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
		var cy = dc.getHeight() / 3;		
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		var text = Utils.displayMultilineOnScreen(dc, _messageConfirmDialog, customFont, extraRoom);
       	dc.drawText(cx, cy, customFont, text, Graphics.TEXT_JUSTIFY_CENTER);
       	
       	if(_counterConfirmDialog > 0)
   		{
	       	dc.setPenWidth(3);
		   	dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
		   	dc.drawArc(cx, cy + 60, 25, Graphics.ARC_COUNTER_CLOCKWISE, 0, progressAngle*_counterConfirmDialog);
	   	}	
    }  
}

function setProgressBarConfirmDialog(counter)
{
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

function setMessageFailed(message)
{
	_messageConfirmDialog = message;	
	_counterConfirmDialog = 0;
	WatchUi.requestUpdate();
}
