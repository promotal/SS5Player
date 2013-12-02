package ss5player.data {

	public class SS5CellName {

		private var _xml:XML;
		public var mapId:int;
		public var name:String;

		public function SS5CellName() {
			super();
		}

		public function resolve(project:SS5Project, model:SS5Model):SS5Cell {
			var cellmapName:String = model.cellmapName(this.mapId);
			return project.cell(cellmapName, this.name);
		}

		public static function fromXML(xml:XML):SS5CellName {
			var mapId:int = xml.mapId;
			var name:String = xml.name;
			if (!mapId && !name) {
				return null;
			}
			var result:SS5CellName = new SS5CellName();
			if (SS5Project.DEBUG) {
				result._xml = xml;
			}
			result.mapId = mapId;
			result.name = name;
			return result;
		}
	}
}
