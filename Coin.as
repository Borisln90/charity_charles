package  {
	
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.display.Sprite;
	
	
	public class Coin extends MovieClip {
		
		private var _value:int = 5;
		private var _dropSpeed:int = 10;
		private var _instance:Main;
		
		var grounded:Boolean = false;
		
		public function Coin() {
			// Get the game instance
			_instance = Main.instance;
		}
		
		public function begin():void {
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		public function end():void {
			this.removeEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(e:Event):void {
			// Move the coin
			if (!grounded) {
				this.y += _dropSpeed;
				// Check if coin has landed on a platform.
				var blocks:Sprite = _instance.blocks;
				for (var i:int=0; i<blocks.numChildren; i++) {
					var block:DisplayObject = blocks.getChildAt(i);
					if (this.hitTestObject(block)) {
						this.y = block.y - this.height/2 - 3;
						grounded = true;
					}
				}
				// If the coin drops from bottom of stage, stop it.
				if (this.y > stage.stageHeight) {
					this.y = stage.stageHeight - this.height/2 - 3;
					grounded = true;
				}
			}
			// Check if the hero collects the coin.
			var heroes:Array = _instance.heroes;
			for (var i:int=0; i < heroes.length; i++) {
				var hero:Hero = heroes[i];
				if (hero.hitTestObject(this)) {
					hero.coinCollected(this);
					_instance.removeCoin(this);
				}
			}
			
		}
		
		public function get value():int { return _value; }
	}
	
}
