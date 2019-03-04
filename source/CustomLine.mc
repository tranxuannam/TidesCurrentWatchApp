using Toybox.WatchUi as Ui;

class CustomLine extends Ui.Drawable {
	function initialize(params) {
		Drawable.initialize(params);
	}
	
    function draw(dc) {
        // Draw the move bar here
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.setPenWidth(1);
        //dc.drawLine(15, 34, 210, 34);
        //dc.drawLine(15, 160, 210, 160);
        dc.drawLine(50, 34, 160, 34);
        dc.drawLine(50, 160, 160, 160);
    }
}