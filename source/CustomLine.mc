using Toybox.WatchUi as Ui;

class CustomLine extends Ui.Drawable {
	function initialize(params) {
		Drawable.initialize(params);
	}
	
    function draw(dc) {
        // Draw the move bar here
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.setPenWidth(1);
        //dc.drawLine(15, 42, 210, 42);
        //dc.drawLine(15, 150, 210, 150);
        dc.drawLine(15, 35, 210, 35);
        dc.drawLine(15, 160, 210, 160);
        //dc.clear();
    }
}