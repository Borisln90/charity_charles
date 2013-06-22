/**
 * Charity Charles
 * Bank
 * Package for in-game bank objects.
 * @author Boris Lykke Nielsen
 */
package  {

	import flash.display.MovieClip;
	import flash.events.Event;


	/**
	 * Bank object
	 */
	public class Bank extends MovieClip {

		private var _owner:Hero;

		/**
		 * Constructor
		 * @param owner The hero object that owns this bank.
		 */
		public function Bank(owner:Hero) {
			_owner = owner;
			this.addEventListener(Event.ENTER_FRAME, update);
		}


		/**
		 * Update loop.
		 * When owner is within bounds, deposit his coins.
		 * @param  e Event.ENTER_FRAME
		 * @return   void
		 */
		private function update(e:Event):void {
			if (this.hitTestObject(_owner) && _owner.hasCoins()) {
				var val:int = _owner.getCoinsValue();
				_owner.emptyCoins();
				_owner.score += val;
			}
		}

	} // End class

} // end package
