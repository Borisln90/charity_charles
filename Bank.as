package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Bank extends MovieClip {
		
		private var _owner:Hero;
		
		public function Bank(owner:Hero) {
			_owner = owner;
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		
		private function update(e:Event):void {
			if (this.hitTestObject(_owner) && _owner.hasCoins()) {
				var val:int = _owner.getCoinsValue();
				_owner.emptyCoins();
				_owner.score += val;
			}
		}
		
	}
	
}
