/**
 * Charity Charles
 * Session
 * Package for storing game related data.
 * @author Boris Lykke Nielsen
 */
package  {


	/**
	 * Session class
	 */
	public class Session {

		private var _id:int;
		private var _createdAt:Date;
		private var _players:Array;
		private var _highestScore:int;
		private var _highestScoreName:String;


		/**
		 * Constructor
		 * @param players heroes
		 * @param id      id for the session. default 0
		 */
		public function Session(players:Array, id:int=0) {
			// constructor code
			this._id = id;
			this._createdAt = new Date();
			this._players = players;
			// calculate the higest score of the submited players
			var scores:Array = [];
			for (var i:int=0; i < _players.length; i++) {
				var player:Hero = _players[i];
				scores.push(player.score);
			}
			if (scores.length > 0) {
				scores.sort();
				this._highestScore = scores.pop();
			} else {
				this._highestScore = 0;
			}
		}


		/**
		 * Returns a new object with session data
		 * @return Session object
		 */
		public function getObject():Object {
			var jumps:int = 0;
			var attacks:int = 0;
			for (var i:int=0; i < _players.length; i++) {
				var player:Hero = _players[i];
				jumps += player.jumps;
				attacks += player.attacks;
			}
			var obj:Object = {
				id: this._id,
				highestScore: this._highestScore,
				highestScoreName: this.highestScoreName,
				createdAt: this.createdAt,
				totalJumps: jumps,
				totalAttacks: attacks
			};

			return obj;
		}

		/** getters setters */
		public function get highestScore():int { return this._highestScore; }
		public function get highestScoreName():String { return this._highestScoreName; }
		public function set highestScoreName(val:String):void { this._highestScoreName = val; }
		public function get players():Array { return this._players; }
		public function get createdAt():Date { return this._createdAt; }
		public function get id():int { return this._id; }
		public function set id(val:int):void { this._id = val; }

	}

}
