/**
 * Charity Charles
 * HeroGreenArduino
 * Package for red hero with arduino.
 * @author Boris Lykke Nielsen
 */
package  {

	import ArduinoWrapper;
	import net.eriksjodin.arduino.events.ArduinoEvent;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.events.TimerEvent;


	/**
	 * Red hero with Arduino support
	 */
	public class HeroRedArduino extends Hero {

		var arduino:ArduinoWrapper;
		var timer:Timer;
		var leftPin:int = 4;
		var rightPin:int = 6;
		var upPin:int = 3;
		var leftKeyDown:Boolean = false;
		var rightKeyDown:Boolean = false;
		var upKeyDown:Boolean = false;


		/**
		 * Constructor
		 * @param a Arduino instance
		 */
		public function HeroRedArduino(a:ArduinoWrapper) {
			// constructor code
			arduino = a;
			timer = new Timer(50);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, arduinoHandler);
			this.addEventListener(Event.ENTER_FRAME, update);
			this.nme = "red";
		}


		/**
		 * Update loop
		 * @param  e Event.ENTER_FRAME
		 * @return   void
		 */
		private function update(e:Event):void {
			this.move(leftKeyDown, rightKeyDown);
			if (upKeyDown && !this.isJumping) {
				this.jump();
			}
		}


		/**
		 * Reads input from Arduino
		 * @param  e TimerEvent
		 * @return   void
		 */
		public function arduinoHandler(e:TimerEvent):void {
			leftKeyDown = arduino.getDigitalData(leftPin);
			rightKeyDown = arduino.getDigitalData(rightPin);
			upKeyDown = arduino.getDigitalData(upPin) == false;
		}


		/**
		 * Key down for keyboard support
		 * @param  e KeyboardEvent
		 * @return   void
		 */
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
		}


		/**
		 * Key up for keyboard support
		 * @param  e KeyboardEvent
		 * @return   void
		 */
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
		}
	}

}
