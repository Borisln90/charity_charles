package  {
	
	import ArduinoWrapper;
	import net.eriksjodin.arduino.events.ArduinoEvent;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	
	public class HeroRedArduino extends Hero {
		
		var arduino:ArduinoWrapper;
		var timer:Timer;
		var leftPin:int = 4;
		var rightPin:int = 6;
		var upPin:int = 3;
		var leftKeyDown:Boolean = false;
		var rightKeyDown:Boolean = false;
		var upKeyDown:Boolean = false;
		
		
		public function HeroRedArduino(a:ArduinoWrapper) {
			// constructor code
			arduino = a;
			timer = new Timer(50);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, arduinoHandler);
			this.addEventListener(Event.ENTER_FRAME, update);
			this.nme = "red";
		}
		
		
		private function update(e:Event):void {
			this.move(leftKeyDown, rightKeyDown);
			if (upKeyDown && !this.isJumping) {
				this.jump();
			}
		}
		
		public function arduinoHandler(e:TimerEvent):void {
			leftKeyDown = arduino.getDigitalData(leftPin);
			rightKeyDown = arduino.getDigitalData(rightPin);
			upKeyDown = arduino.getDigitalData(upPin) == false;
		}
		
		
		public function keyDownHandler(e:KeyboardEvent):void {
			var target = e.keyCode;
			switch (target) {
				case Keyboard.W:
					upKeyDown = true;
					break;
				case Keyboard.A:
					leftKeyDown = true;
					break;
				case Keyboard.D:
					rightKeyDown = true;
					break;
			}
		} // end keyDownHandler
		
		
		public function keyUpHandler(e:KeyboardEvent):void {
			var target = e.keyCode;
			switch (target) {
				case Keyboard.W:
					upKeyDown = false;
					break;
				case Keyboard.A:
					leftKeyDown = false;
					break;
				case Keyboard.D:
					rightKeyDown = false;
					break;
			}
		} // end keyUpHandler
	}
	
}