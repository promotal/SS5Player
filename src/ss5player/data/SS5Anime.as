package ss5player.data {

	public class SS5Anime {

		private var _xml:XML;

		private var _name:String;
		public function get name():String {
			return this._name;
		}

		private var _frameCount:int;
		public function get frameCount():int {
			return this._frameCount;
		}

		private var _fps:int;
		public function get fps():int {
			return this._fps;
		}

		private var _partAnimes:Object;
		public function get partAnimes():Object {
			return this._partAnimes;
		}

		public function SS5Anime() {
			super();
			this._partAnimes = {};
		}

		public static function fromXML(xml:XML):SS5Anime {
			var result:SS5Anime = new SS5Anime();
			if (SS5Project.DEBUG) {
				result._xml = xml;
			}
			result._name = xml.name;
			result._frameCount = xml.settings.frameCount;
			result._fps = xml.settings.fps;
			for each (var partAnimeXML:XML in xml.partAnimes.partAnime) {
				var partAnime:SS5PartAnime = SS5PartAnime.fromXML(partAnimeXML);
				result._partAnimes[partAnime.partName] = partAnime;
			}
			return result;
		}
	}
}
