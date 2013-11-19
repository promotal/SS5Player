package jp.promotal.ssplayer.data {

	public class SSModel {

		private var _xml:XML;

		private var _parts:Vector.<SSPart>;
		public function get parts():Vector.<SSPart> {
			return this._parts;
		}

		private var _animes:Object;
		public function get animes():Object {
			return this._animes;
		}
		public function anime(name:String):SSAnime {
			return this._animes[name];
		}

		private var _cellmapNames:Array;
		public function get cellmapNames():Array {
			return this._cellmapNames;
		}
		public function cellmapName(index:int):String {
			return this._cellmapNames[index];
		}

		public function SSModel() {
			super();
			this._parts = new Vector.<SSPart>();
			this._animes = {};
			this._cellmapNames = [];
		}

		public static function fromXML(xml:XML):SSModel {
			var result:SSModel = new SSModel();
			if (SSProject.DEBUG) {
				result._xml = xml;
			}
			for each (var partXML:XML in xml.Model.partList.value) {
				var part:SSPart = SSPart.fromXML(partXML);
				result._parts.push(part);
			}
			for each (var animeXML:XML in xml.animeList.anime) {
				var anime:SSAnime = SSAnime.fromXML(animeXML);
				result._animes[anime.name] = anime;
			}
			for each (var cellmapName:XML in xml.cellmapNames.value) {
				result._cellmapNames.push(String(cellmapName));
			}
			return result;
		}
	}
}
