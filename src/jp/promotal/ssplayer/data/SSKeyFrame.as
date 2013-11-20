package jp.promotal.ssplayer.data {

	public class SSKeyFrame extends SSFrame {

		private var _xml:XML;

		public function SSKeyFrame() {
			super();
		}

		public static function fromXML(xml:XML):SSKeyFrame {
			var result:SSKeyFrame = new SSKeyFrame();
			if (SSProject.DEBUG) {
				result._xml = xml;
			}
			result.time = xml.@time;
			result.ipType = xml.@ipType;

			if (xml.value.elements().length() == 0) {
				// primitive value (treat as Number)
				result.value = parseFloat(String(xml.value.text()).replace(/\s/g, ""));
			} else {
				// complex value (treat as Hash)
				result.value = SSCell.globalCellName(xml.value.mapId.text(), xml.value.name.text());
			}

			return result;
		}
	}
}
