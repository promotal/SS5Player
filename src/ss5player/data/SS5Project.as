package ss5player.data {

	import starling.textures.Texture;

	public class SS5Project {

		public static const DEBUG:Boolean = false;

		private var models:Object;
		public function model(name:String):SS5Model {
			return this.models[name];
		}

		public function modelForAnime(name:String):SS5Model {
			for each (var model:SS5Model in this.models) {
				if (name in model.animes) {
					return model;
				}
			}
			return null;
		}

		public function get modelAndAnimeNames():Array {
			var result:Array = [];
			for each (var model:SS5Model in this.models) {
				for each (var anime:SS5Anime in model.animes) {
					result.push([model.name, anime.name]);
				}
			}
			return result;
		}

		public function get animeNames():Array {
			var result:Array = [];
			for each (var model:SS5Model in this.models) {
				for each (var anime:SS5Anime in model.animes) {
					result.push(anime.name);
				}
			}
			return result;
		}

		public function anime(name:String):SS5Anime {
			for each (var model:SS5Model in this.models) {
				if (name in model.animes) {
					return model.anime(name);
				}
			}
			return null;
		}

		private var cellmaps:Object;
		private function cellmap(cellmapName:String):Object {
			return this.cellmaps[cellmapName] ||= {};
		}
		public function cell(cellmapName:String, name:String):SS5Cell {
			return this.cellmap(cellmapName)[name];
		}

		private var textures:Vector.<Texture>;
		public function SS5Project() {
			super();
			this.models = {};
			this.cellmaps = {};
			this.textures = new Vector.<Texture>();
		}

		public function addAnimePackXML(xml:XML, name:String):SS5Project {
			var model:SS5Model = SS5Model.fromXML(xml);
			// XXX use file path as unique id instead of given name. model.name can be non-unique
			model.name = name;
			this.models[name] = model;
			return this;
		}

		public function addCellMapXML(texture:Texture, xml:XML, name:String):SS5Project {
			this.textures.push(texture);
			var cellmap:Object = {}
			for each (var cellXML:XML in xml.cells.cell) {
				var cell:SS5Cell = SS5Cell.fromXML(cellXML, texture);
				cellmap[cell.name] = cell;
			}
			this.cellmaps[name] = cellmap;
			return this;
		}

		public function dispose():void {
			for each (var texture:Texture in this.textures) {
				texture.root.dispose();
			}
		}
	}
}
