package ss5player.data {

	public class SS5PartAnime {

		private var _xml:XML;

		private var _partName:String;
		public function get partName():String {
			return this._partName;
		}

		private var _attributes:Object;
		public function get attributes():Object {
			return this._attributes;
		}
		public function attribute(tag:String):SS5Attribute {
			return this._attributes[tag] ||= SS5Attribute.empty(tag);
		}

		public function attributeValueAt(tag:String, time:Number):* {
			return this.attribute(tag).valueAt(time);
		}

		public function SS5PartAnime() {
			super();
			this._attributes = {};
		}

		public static function fromXML(xml:XML):SS5PartAnime {
			var result:SS5PartAnime = new SS5PartAnime();
			if (SS5Project.DEBUG) {
				result._xml = xml;
			}
			result._partName = xml.partName;
			for each (var attributeXML:XML in xml.attributes.attribute) {
				var attribute:SS5Attribute = SS5Attribute.fromXML(attributeXML);
				result._attributes[attribute.tag] = attribute;
			}
			return result;
		}
	}
}
