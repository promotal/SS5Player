package jp.promotal.ssplayer.data {

	import flash.geom.Rectangle;

	import starling.textures.Texture;

	public class SSCell {

		public var texture:Texture;

		private var _xml:XML;

		private var _name:String;
		public function get name():String {
			return this._name;
		}

		private var _pictArea:Rectangle;
		public function get pictArea():Rectangle {
			return this._pictArea;
		}

		private var _pivot:Array;
		public function get pivot():Array {
			return this._pivot;
		}

		private var _pivotX:int;
		public function get pivotX():int {
			return this._pivotX ||= (Number(this.pivot[0]) + 0.5) * this.pictArea.width;
		}

		private var _pivotY:int;
		public function get pivotY():int {
			return this._pivotY ||= (-Number(this.pivot[1]) + 0.5) * this.pictArea.height;
		}

		public function SSCell() {
			super();
		}

		public static function fromXML(xml:XML, texture:Texture):SSCell {
			var result:SSCell = new SSCell();
			if (SSProject.DEBUG) {
				result._xml = xml;
			}
			result._name = xml.name;
			var pos:Array = String(xml.pos).split(" ");
			var size:Array = String(xml.size).split(" ");
			result._pictArea = new Rectangle(pos[0], pos[1], size[0], size[1]);
			result.texture = Texture.fromTexture(texture, result.pictArea);
			result._pivot = String(xml.pivot).split(" ");
			return result;
		}
	}
}
