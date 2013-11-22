package jp.promotal.ssplayer.data {

	public class SSAnime {

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

		public function SSAnime() {
			super();
			this._partAnimes = {};
		}

		public static function fromXML(xml:XML):SSAnime {
			var result:SSAnime = new SSAnime();
			if (SSProject.DEBUG) {
				result._xml = xml;
			}
			result._name = xml.name;
			result._frameCount = xml.settings.frameCount;
			result._fps = xml.settings.fps;
			for each (var partAnimeXML:XML in xml.partAnimes.partAnime) {
				var partAnime:SSPartAnime = SSPartAnime.fromXML(partAnimeXML);
				result._partAnimes[partAnime.partName] = partAnime;
			}
			return result;
		}
	}
}
