using Toybox.WatchUi as Ui;

class CustomLineRoundFace extends Ui.Drawable {
	function initialize(params) {
		Drawable.initialize(params);
	}
	
    function draw(dc) {
        // Draw the move bar here
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
        dc.setPenWidth(2);     
        dc.drawLine(WatchUi.loadResource( Rez.Strings.XFirstLine ).toNumber(), WatchUi.loadResource( Rez.Strings.YFirstLine ).toNumber()
        			, WatchUi.loadResource( Rez.Strings.XSecondLine ).toNumber(), WatchUi.loadResource( Rez.Strings.YSecondLine ).toNumber());
    }
}