package sssplayer.data {

	public class SSSAnime {

		private var xml:XML;

		private var _name:String;
		public function get name():String {
			return this._name ||= xml.name;
		}

		private var _frameCount:int;
		public function get frameCount():int {
			return this._frameCount ||= xml.settings.frameCount;
		}

		private var _fps:int;
		public function get fps():int {
			return this._fps ||= xml.settings.fps;
		}

		private var _partAnimes:Object;
		public function get partAnimes():Object {
			if (this._partAnimes) {
				return this._partAnimes;
			}
			this._partAnimes = {};
			for each (var partAnimeXML:XML in this.xml.partAnimes.partAnime) {
				var partAnime:SSSPartAnime = SSSPartAnime.fromXML(partAnimeXML);
				this._partAnimes[partAnime.partName] = partAnime;
			}
			return this._partAnimes;
		}

		public function SSSAnime() {
			super();
		}

		public static function fromXML(xml:XML):SSSAnime {
			var result:SSSAnime = new SSSAnime();
			result.xml = xml;
			return result;
		}
	}
}
