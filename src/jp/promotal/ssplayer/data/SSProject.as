package jp.promotal.ssplayer.data {

	import starling.textures.Texture;

	public class SSProject {

		public static const DEBUG:Boolean = false;

		private var models:Object;
		public function model(name:String):SSAnime {
			return this.models[name];
		}

		public function modelForAnime(name:String):SSModel {
			for each (var model:SSModel in this.models) {
				if (name in model.animes) {
					return model;
				}
			}
			return null;
		}

		public function anime(name:String):SSAnime {
			for each (var model:SSModel in this.models) {
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
		public function cell(cellmapName:String, name:String):SSCell {
			return this.cellmap(cellmapName)[name];
		}

		private var textures:Vector.<Texture>;
		public function SSProject() {
			super();
			this.models = {};
			this.cellmaps = {};
			this.textures = new Vector.<Texture>();
		}

		public function addAnimePackXML(xml:XML, name:String):SSProject {
			var model:SSModel = SSModel.fromXML(xml);
			this.models[name] = model;
			return this;
		}

		public function addCellMapXML(texture:Texture, xml:XML, name:String):SSProject {
			this.textures.push(texture);
			var cellmap:Object = {}
			for each (var cellXML:XML in xml.cells.cell) {
				var cell:SSCell = SSCell.fromXML(cellXML, texture);
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
