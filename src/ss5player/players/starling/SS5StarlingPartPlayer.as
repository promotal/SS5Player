package ss5player.players.starling {

	import flash.geom.Matrix;

	import ss5player.data.SS5Cell;
	import ss5player.data.SS5CellName;
	import ss5player.data.SS5Model;
	import ss5player.data.SS5PartAnime;
	import ss5player.data.SS5Project;
	import ss5player.data.SS5Part;
	import ss5player.utils.SS5Color;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class SS5StarlingPartPlayer extends Sprite {

		private var project:SS5Project;

		private var model:SS5Model;

		private var parentPartPlayer:SS5StarlingPartPlayer;

		private var image:Image;

		private var _color:SS5Color = new SS5Color(0xffffffff);
		public function get color():uint {
			return this._color.value;
		}
		public function set color(value:uint):void {
			this._color.value = value;
		}

		private var _part:SS5Part;
		public function get part():SS5Part {
			return _part;
		}

		private var partAnime:SS5PartAnime;

		private var _cell:SS5Cell;
		public function get cell():SS5Cell {
			return this._cell;
		}
		public function set cell(value:SS5Cell):void {
			this._cell = value;
			if (value) {
				this.texture = value.texture;
				this.image.x = -value.pivotX;
				this.image.y = -value.pivotY;
			} else {
				this.texture = null;
			}
		}

		public function get cellName():String {
			return this._cell ? this._cell.name : null;
		}

		private var _texture:Texture;
		private function set texture(value:Texture):void {
			this._texture = value;
			if (value) {
				if (this.image) {
					this.image.visible = true;
					this.image.texture = value;
				} else {
					this.image = new Image(value);
					this.addChild(this.image);
				}
			} else if (this.image) {
				this.image.visible = false;
			}
		}

		public function get partName():String {
			return this._part.name;
		}

		public function SS5StarlingPartPlayer(project:SS5Project, model:SS5Model, part:SS5Part, partAnime:SS5PartAnime, parentPartPlayer:SS5StarlingPartPlayer) {
			super();
			this.project = project;
			this.model = model;
			this._part = part;
			this.partAnime = partAnime;
			this.parentPartPlayer = parentPartPlayer;
		}

		public function set currentFrame(time:Number):void {
			if (!this.partAnime) {
				return;
			}
			switch (this._part.type) {
				case "normal":
					if (this.part.show == 0) {
						this.cell = null;
					} else {
						var cellName:SS5CellName = this.partAnime.attributeValueAt("CELL", time);
						this.cell = cellName.resolve(this.project, this.model);
						var matrix:Matrix = new Matrix();
						matrix.scale(
							this.partAnime.attributeValueAt("SCLX", time),
							this.partAnime.attributeValueAt("SCLY", time)
						);
						matrix.rotate(-this.partAnime.attributeValueAt("ROTZ", time) / 180 * Math.PI);
						matrix.translate(
							this.partAnime.attributeValueAt("POSX", time),
							-this.partAnime.attributeValueAt("POSY", time)
						);
						if (this.parentPartPlayer) {
							matrix.concat(this.parentPartPlayer.transformationMatrix);
						}
						if (this.image) {
							this.image.visible = this.partAnime.attributeValueAt("HIDE", time) != 1;
							this.image.alpha = this.partAnime.attributeValueAt("ALPH", time);
							this.image.color = this._color.value;
						}
						this.transformationMatrix = matrix;
					}
					break;
			}
		}
	}
}
