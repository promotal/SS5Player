package jp.promotal.ssplayer.data {

	public class SSCellName {

		private var _xml:XML;
		public var mapId:int;
		public var name:String;

		public function SSCellName() {
			super();
		}

		public function resolve(project:SSProject, model:SSModel):SSCell {
			var cellmapName:String = model.cellmapName(this.mapId);
			return project.cell(cellmapName, this.name);
		}

		public static function fromXML(xml:XML):SSCellName {
			var mapId:int = xml.mapId;
			var name:String = xml.name;
			if (!mapId && !name) {
				return null;
			}
			var result:SSCellName = new SSCellName();
			if (SSProject.DEBUG) {
				result._xml = xml;
			}
			result.mapId = mapId;
			result.name = name;
			return result;
		}
	}
}
