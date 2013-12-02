package ss5player.data {

	public class SS5Model {

		private var _xml:XML;

		private var _name:String;
		public function get name():String {
			return this._name;
		}
		public function set name(value:String):void {
			this._name = value;
		}

		private var _parts:Vector.<SS5Part>;
		public function get parts():Vector.<SS5Part> {
			return this._parts;
		}

		private var _animes:Object;
		public function get animes():Object {
			return this._animes;
		}
		public function anime(name:String):SS5Anime {
			return this._animes[name];
		}

		private var _cellmapNames:Array;
		public function get cellmapNames():Array {
			return this._cellmapNames;
		}
		public function cellmapName(index:int):String {
			return this._cellmapNames[index];
		}

		public function SS5Model() {
			super();
			this._parts = new Vector.<SS5Part>();
			this._animes = {};
			this._cellmapNames = [];
		}

		public static function fromXML(xml:XML):SS5Model {
			var result:SS5Model = new SS5Model();
			if (SS5Project.DEBUG) {
				result._xml = xml;
			}
			result._name = xml.name;
			for each (var partXML:XML in xml.Model.partList.value) {
				var part:SS5Part = SS5Part.fromXML(partXML);
				result._parts.push(part);
			}
			for each (var animeXML:XML in xml.animeList.anime) {
				var anime:SS5Anime = SS5Anime.fromXML(animeXML);
				result._animes[anime.name] = anime;
			}
			for each (var cellmapName:XML in xml.cellmapNames.value) {
				result._cellmapNames.push(String(cellmapName));
			}
			return result;
		}
	}
}
