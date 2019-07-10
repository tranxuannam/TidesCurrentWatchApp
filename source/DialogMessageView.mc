using Toybox.WatchUi;
using Toybox.Application;

class DialogMessageView extends WatchUi.View {

	hidden var _message;
	
    function initialize(message) {
        View.initialize();     
        _message = message;  
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
		var text = Utils.displayMultilineOnScreen(dc, _message, customFont);
       	dc.drawText(cx, cy, customFont, text, Graphics.TEXT_JUSTIFY_CENTER);
    }
  
}
