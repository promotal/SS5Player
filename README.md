SS5Player for AS3
=================

About this library
------------------

"SS5Player for AS3" is an ActionScript 3 library which displays
[OPTPiX SpriteStudio](http://www.webtech.co.jp/spritestudio/) animation data with [Starling Framework](http://starling-framework.org/).


Requirements
------------

* Adobe AIR or Adobe Flash Player, latest
* Starling Framework, latest
* OPTPiX SpriteStudio, version 5


Simple Example
--------------

Try this in Starling Sprite:

	var loader:SS5ProjectLoader;
	const SSPJ:String = "path/to/your/SpriteStudioProject.sspj";

	this.loader = new SS5ProjectLoader();
	this.loader.load(new URLRequest(SSPJ), this.onProgress);

	private function onProgress(progress:Number):void {
		if (progress == 1) {
			// progress is 1 when loading is complete
			var player:SS5StarlingPlayer = new SS5StarlingPlayer(this.loader.project);
			player.startAnime("nameOfYourAnime");
			this.addChild(player);
		}
	}


Detailed Usage
--------------

### Loading 
Use ```SS5ProjectLoader``` to load a ```.sspj``` file.

Note: All of the related ```.ssae```, ```.ssce```, and texture files must be placed along with ```.sspj```.

When loading is complete, you can retrieve the SpriteStudio project as ```SS5Project``` from ```SS5ProjectLoader.project```.

	var loader:SS5ProjectLoader;
	const SSPJ:String = "path/to/your/SpriteStudioProject.sspj";

	this.loader = new SS5ProjectLoader();
	this.loader.load(new URLRequest(SSPJ), this.onProgress);
	private function onProgress(progress:Number):void {
		if (progress == 1) {
			// progress is 1 when loading is complete
		}
	}

### Display SpriteStudio animation

Add a ```SS5StarlingPlayer``` to a Starling ```DisplayObject``` to display the animation data with Starling.

	var player:SS5StarlingPlayer = new SS5StarlingPlayer(this.loader.project);
	this.addChild(player);


### Playback controls

First, calling ```setAnime()``` will load an animation from the project by name.

	player.setAnime("nameOfYourAnime");

Then, calling ```play()``` and ```stop()``` will respectively start and stop the animation.

	player.play();
	player.stop();

Calling ```startAnime()``` does ```setAnime()``` and ```play()``` in order.

	player.startAnime("nameOfYourAnime");

Setting ```loop``` to ```true``` will loop the animation.

	player.loop = true;

Setting ```withFlatten``` to ```true``` will call ```Sprite.flatten()``` of Starling on each display update, which may improve performance for GPU optimized data.

	player.withFlatten = true;

Use ```partNameAt()``` and ```partPlayerAt()``` to ```hitTest()``` against parts.

	var name:String = player.partNameAt(x, y, forTouch);
	var partPlayer:SS5StarlingPartPlayer = player.partPlayerAt(x, y, forTouch);

### Specs

Currently, these attributes are supported:  
(will work with some of the most basic animations)

	"CELL"
	"HIDE"
	"POSX"
	"POSY"
	"ROTZ"
	"SCLX"
	"SCLY"
	"ALPH"

Additionally, only interpolation type ```"linear"``` is supported for now.


API Reference
-------------

TBD


Trademark Info
--------------

[OPTPiX SpriteStudio](http://www.webtech.co.jp/spritestudio/) is trademark of [Web Technology Corp.](http://www.webtech.co.jp/)
