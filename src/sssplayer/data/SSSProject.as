package sssplayer.data {

	import starling.textures.Texture;

	public class SSSProject {

		private var models:Object;
		public function model(name:String):SSSAnime {
			return this.models[name];
		}

		public function modelForAnime(name:String):SSSModel {
			for each (var model:SSSModel in this.models) {
				if (name in model.animes) {
					return model;
				}
			}
			return null;
		}

		public function anime(name:String):SSSAnime {
			for each (var model:SSSModel in this.models) {
				if (name in model.animes) {
					return model.anime(name);
				}
			}
			return null;
		}

		private var cells:Object;
		public function cell(name:String):SSSCell {
			return this.cells[name];
		}

		private var xmls:Object;
		public function xml(name:String):XML {
			return this.xmls[name];
		}

		private var textures:Vector.<Texture>;
		public function SSSProject() {
			super();
			this.models = {};
			this.cells = {};
			this.textures = new Vector.<Texture>();
		}

		public function addAnimePackXML(xml:XML, name:String):SSSProject {
			var model:SSSModel = SSSModel.fromXML(xml);
			this.models[name] = model;
			return this;
		}

		public function addCellMapXML(texture:Texture, xml:XML, name:String):SSSProject {
			this.textures.push(texture);
			for each (var cellXML:XML in xml.cells.cell) {
				var cell:SSSCell = SSSCell.fromXML(cellXML, texture);
				this.cells[SSSCell.globalCellName(name, cell.name)] = cell;
			}
			return this;
		}

		public function dispose():void {
			for each (var texture:Texture in this.textures) {
				texture.root.dispose();
			}
		}
	}
}
