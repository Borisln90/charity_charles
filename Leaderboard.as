package  {

    import flash.net.SharedObject;

    public class Leaderboard {

        private var so:SharedObject;
        private var idCount:int;


        public function Leaderboard() {

            so = SharedObject.getLocal("leaderboard");
            idCount = so.data.idCount;
        }

        public function initDB():void {
            so.data.idCount = 0;
            so.data.sessions = [];
        }

        /*
        * Adds a user with its score and jumps on the opponent and stores it in a SharedObject.
        *
        * Returns an ID of the user that was added
        *
        *@param n   name of the user saving a score
        *@param s   value of the score being saved
        *@param o   the number of times the user has jumped onto its opponent
        */
        public function addScore(session:Session):int {
            var newID:int = so.data.idCount + 1;
            session.id = newID;
            trace(session.id);
            so.data.sessions.push(session.getObject());
            so.data.idCount++;
            so.flush();
            return newID;
        }

        /*
        * Searches for a specific player using an ID of the player or a name and score of the player.
        * If the ID is unknown the integer 0 must be inserted.
        *
        * Returns the rank of the specific player.
        *
        *@param thisID  ID of the player being searched for
        *@param n       name of the player to be ranked
        *@param s       score of the player to be ranked
        */
        public function getRank(id:int):int {
            so.data.sessions.sortOn("highestScore", Array.DESCENDING);

            var i:int;
            for (i = 0; i < so.data.sessions.length; i++) {
                if (so.data.sessions[i].id == id) {
                    return i + 1;
                    break;
                }
            }
            return 0;
        }


        public function getSession(id:int):Object {
            for (var i:int=0; i < so.data.sessions.length; i++) {
                var session:Object = so.data.sessions[i];
                if (session.id == id) {
                    return session;
                }
            }
            return null;
        }

        /*
        * Returns an array including name and score of all ranks between the ranks r1 and r2 both included.
        * Defaults to top 10.
        *
        *@param r1  Highest rank to be shown
        *@param r2  Lowest rank to be shown
        */
        public function viewBoard(r1:int = 1, r2:int = 10):Array {
            so.data.sessions.sortOn("highestScore", Array.NUMERIC | Array.DESCENDING);

            var topXArr:Array = [];
            var hiRank:int = r1 - 1;
            var i:int;
            for (i = hiRank; i < r2; i++) {
                if (so.data.sessions[i] != null) {
                    topXArr.push(so.data.sessions[i]);
                }
            }
            return topXArr;
        }

        /*
        * Removes an element in the array according to the specified ID or index.
        * If the ID is unknown the integer 0 must be inserted.
        *
        *@param thisID  ID number of the element in the array to be deleted
        *@param index   The index number of the element in the array to be deleted.
        */
        public function removeLine(thisID:int, index:int = 0):void {
            var i:int;
            if (thisID == 0) {
                so.data.sessions.splice(index,1);
            } else {
                for (i = 0; i < so.data.sessions.length; i++) {
                    if (so.data.sessions[i].id == thisID) {
                        so.data.sessions.splice(i,1);
                    }
                }
            }
            so.flush();
        }

    }

}
