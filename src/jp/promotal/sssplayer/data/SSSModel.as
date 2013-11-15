package jp.promotal.sssplayer.data {

	public class SSSModel {

		private var _xml:XML;

		private var _parts:Vector.<SSSPart>;
		public function get parts():Vector.<SSSPart> {
			return this._parts;
		}

		private var _animes:Object;
		public function get animes():Object {
			return this._animes;
		}
		public function anime(name:String):SSSAnime {
			return this._animes[name];
		}

		private var _cellmapNames:Array;
		public function get cellmapNames():Array {
			return this._cellmapNames;
		}
		public function cellmapName(index:int):String {
			return this._cellmapNames[index];
		}

		public function SSSModel() {
			super();
			this._parts = new Vector.<SSSPart>();
			this._animes = {};
			this._cellmapNames = [];
		}

		public static function fromXML(xml:XML):SSSModel {
			var result:SSSModel = new SSSModel();
			if (SSSProject.DEBUG) {
				result._xml = xml;
			}
			for each (var partXML:XML in xml.Model.partList.value) {
				var part:SSSPart = SSSPart.fromXML(partXML);
				result._parts.push(part);
			}
			for each (var animeXML:XML in xml.animeList.anime) {
				var anime:SSSAnime = SSSAnime.fromXML(animeXML);
				result._animes[anime.name] = anime;
			}
			for each (var cellmapName:XML in xml.cellmapNames.value) {
				result._cellmapNames.push(String(cellmapName));
			}
			return result;
		}
	}
}
