package jp.promotal.sssplayer.data {

	public class SSSPartAnime {

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
		public function attribute(tag:String):SSSAttribute {
			return this.attributes[tag] ||= SSSAttribute.empty();
		}

		public function SSSPartAnime() {
			super();
			this._attributes = {};
		}

		public static function fromXML(xml:XML):SSSPartAnime {
			var result:SSSPartAnime = new SSSPartAnime();
			if (SSSProject.DEBUG) {
				result._xml = xml;
			}
			result._partName = xml.partName;
			for each (var attribute:XML in xml.attributes.attribute) {
				var attributeTag:String = String(attribute.@tag);
				result._attributes[attributeTag] = SSSAttribute.fromXML(attribute);
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
