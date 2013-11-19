package jp.promotal.ssplayer.data {

	public class SSPartAnime {

		private var _xml:XML;

		private var _partName:String;
		public function get partName():String {
			return this._partName;
		}

		private var _attributes:Object;
		public function get attributes():Object {
			if (this._attributes) {
				return this._attributes;
			}
			return this._attributes;
		}
		public function attribute(tag:String):SSAttribute {
			return this.attributes[tag] ||= SSAttribute.empty();
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
			for each (var attribute:XML in xml.attributes.attribute) {
				var attributeTag:String = String(attribute.@tag);
				result._attributes[attributeTag] = SSAttribute.fromXML(attribute);
				switch (attributeTag) {
					case "CELL":
					case "HIDE":
					case "POSX":
					case "POSY":
					case "ROTZ":
					case "SCLX":
					case "SCLY":
					case "ALPH":
						break;
					default:
						trace("SSSPartAnime.attributes(): Attribute not supported:", attributeTag);
				}
			}
			return result;
		}
	}
}
