package sssplayer.data {

	public class SSSPartAnime {

		private var xml:XML;

		private var _partName:String;
		public function get partName():String {
			return this._partName ||= xml.partName;
		}

		private var _attributes:Object;
		public function get attributes():Object {
			if (this._attributes) {
				return this._attributes;
			}
			this._attributes = {};
			for each (var attribute:XML in this.xml.attributes.attribute) {
				var attributeTag:String = String(attribute.@tag);
				this._attributes[attributeTag] = SSSAttribute.fromXML(attribute);
				switch (attributeTag) {
					case "CELL":
					case "HIDE":
					case "POSX":
					case "POSY":
					case "ROTZ":
					case "SCLX":
					case "SCLY":
						break;
					default:
						trace("SSSPartAnime.attributes(): Attribute not supported:", attributeTag);
				}
			}
			return this._attributes;
		}

		public function attribute(tag:String):SSSAttribute {
			return this.attributes[tag] ||= SSSAttribute.empty();
		}

		public function SSSPartAnime() {
			super();
		}

		public static function fromXML(xml:XML):SSSPartAnime {
			var result:SSSPartAnime = new SSSPartAnime();
			result.xml = xml;
			return result;
		}
	}
}
