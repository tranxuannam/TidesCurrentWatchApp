using Toybox.WatchUi as Ui;

class CustomLineRoundFace extends Ui.Drawable {
	function initialize(params) {
		Drawable.initialize(params);
	}
	
    function draw(dc) {
        // Draw the move bar here
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.setPenWidth(1);      
        
        dc.drawLine(50, 50, 170, 50);
        dc.drawLine(50, 175, 170, 175);
    }
}