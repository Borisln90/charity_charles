/**
 * Charity Charles
 * Coin
 * Package for in-game coin objects.
 * @author Boris Lykke Nielsen
 */
package  {

	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.display.Sprite;


	/**
	 * Coin class
	 */
	public class Coin extends MovieClip {

		private var _value:int = 5;
		private var _dropSpeed:int = 10;
		private var _instance:Main;

		var grounded:Boolean = false;


		/**
		 * Constructor
		 */
		public function Coin() {
			// Get the game instance
			_instance = Main.instance;
		}


		/**
		 * Begins the update loop.
		 * @return void
		 */
		public function begin():void {
			this.addEventListener(Event.ENTER_FRAME, update);
		}


		/**
		 * Ends the update loop.
		 * @return void
		 */
		public function end():void {
			this.removeEventListener(Event.ENTER_FRAME, update);
		}


		/**
		 * Update loop.
		 * Updates position and checks if collected.
		 * @param  e Event.ENTER_FRAME
		 * @return   void
		 */
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


		/** getters */
		public function get value():int { return _value; }
	}

}
