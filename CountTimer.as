package  {
	
	// Needed for timer
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	// Update textfield with time
	import flash.text.TextField;
	
	public class CountTimer extends Timer {
		
		private var targetText:TextField;
		private var direction:String;
		private var minutes:int;
		private var seconds:int;
		private var totalSeconds:int;
		private var timeTotal;
		private var timeLoaded = 0;
		private var test:Boolean = false;
		

		public function CountTimer(min:int, sec:int, dir:String, targetTextField:TextField=null) {
			this.minutes = int(min * 60);
			this.seconds = int(sec);
			this.timeTotal = this.minutes + this.seconds;
			super(1000, this.timeTotal);
			if (dir == "down") {
				this.totalSeconds = this.minutes + this.seconds;
			}
			else {
				this.totalSeconds = 0;
			}
			if (targetTextField != null) {
				this.targetText = targetTextField;
			}
			this.direction = dir;
		}
		
		
		override public function start():void {
			super.start();
			addEventListener(TimerEvent.TIMER, timerHandler);
		}
		
		
		private function timerHandler(e:TimerEvent):void {
			// update time loaded variable
			this.timeLoaded += 1;
			if (direction == "up") {
				// totalseconds is = 0, to start with. We add 1 to it.
				this.totalSeconds++;
			}
			else {
				// totalSeconds = theNumber of seconds by adding min and sec; We subtract 1 from it.
				this.totalSeconds--;
			}
			
			// How many seconds there are left.
			this.seconds = totalSeconds % 60;
			// How many minutes are left.
			this.minutes = Math.floor(totalSeconds / 60);
			// The minutes and seconds to display in the textField.
			var minutesDisplay:String = (minutes < 10) ? "0" + minutes.toString() : minutes.toString();
			var secondsDisplay:String = (seconds < 10) ? "0" + seconds.toString() : seconds.toString();
			if (this.targetText != null) {
				targetText.text = minutesDisplay + ":" + secondsDisplay;
			}
			if (test == true) {
				trace(minutesDisplay + ":" + secondsDisplay);
			}
		}
		
		
		public function getTimeTotal():int {
			return this.timeTotal;
		}
		
		
		public function getTimeLoaded():int {
			return this.timeLoaded;
		}
		
		
		public function getProg():int {
			return Math.floor(timeLoaded/timeTotal*100);
		}
		
		public function set testMode(val:Boolean):void {
			this.test = val;
		}
		
		public function set textField(val:TextField) {
			this.targetText = val;
		}
	}
}
