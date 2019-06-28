using Toybox.WatchUi as Ui;

class CustomLineRoundFace extends Ui.Drawable {
	function initialize(params) {
		Drawable.initialize(params);
	}
	
    function draw(dc) {
        // Draw the move bar here
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.setPenWidth(1);      
        
        dc.drawLine(65, 50, 185, 50);
        dc.drawLine(65, 175, 185, 175);
    }
}