package sssplayer.data {

	public class SSSModel {

		private var xml:XML;

		private var _parts:Vector.<SSSPart>;
		public function get parts():Vector.<SSSPart> {
			if (this._parts) {
				return this._parts;
			}
			this._parts = new Vector.<SSSPart>();
			for each (var partXML:XML in this.xml.Model.partList.value) {
				var part:SSSPart = SSSPart.fromXML(partXML);
				this._parts.push(part);
			}
			return this._parts;
		}

		private var _animes:Object;
		public function get animes():Object {
			if (this._animes) {
				return this._animes;
			}
			this._animes = {};
			for each (var animeXML:XML in this.xml.animeList.anime) {
				var anime:SSSAnime = SSSAnime.fromXML(animeXML);
				this._animes[anime.name] = anime;
			}
			return this._animes;
		}
		public function anime(name:String):SSSAnime {
			return this.animes[name];
		}

		private var _cellmapNames:Array;
		public function get cellmapNames():Array {
			if (this._cellmapNames) {
				return this._cellmapNames;
			}
			this._cellmapNames = [];
			for each (var cellmapName:XML in this.xml.cellmapNames.value) {
				this._cellmapNames.push(String(cellmapName));
			}
			return this._cellmapNames;
		}
		public function cellmapName(index:int):String {
			return this.cellmapNames[index];
		}

		public function SSSModel() {
			super();
		}

		public static function fromXML(xml:XML):SSSModel {
			var result:SSSModel = new SSSModel();
			result.xml = xml;
			return result;
		}
	}
}
