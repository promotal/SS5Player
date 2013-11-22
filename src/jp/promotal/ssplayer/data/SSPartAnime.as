package jp.promotal.ssplayer.data {

	public class SSPartAnime {

		private var _xml:XML;

		private var _partName:String;
		public function get partName():String {
			return this._partName;
		}

		private var _attributes:Object;
		public function get attributes():Object {
			return this._attributes;
		}
		public function attribute(tag:String):SSAttribute {
			return this._attributes[tag] ||= SSAttribute.empty(tag);
		}

		public function attributeValueAt(tag:String, time:Number):* {
			return this.attribute(tag).valueAt(time);
		}

		public function SSPartAnime() {
			super();
			this._attributes = {};
		}

		public static function fromXML(xml:XML):SSPartAnime {
			var result:SSPartAnime = new SSPartAnime();
			if (SSProject.DEBUG) {
				result._xml = xml;
			}
			result._partName = xml.partName;
			for each (var attributeXML:XML in xml.attributes.attribute) {
				var attribute:SSAttribute = SSAttribute.fromXML(attributeXML);
				result._attributes[attribute.tag] = attribute;
			}
			return result;
		}
	}
}
