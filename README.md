SS5Player for AS3
=================

See [README_jp.md](https://github.com/promotal/SS5Player/blob/master/README_jp.md) for Japanese documentation.

About this library
------------------

"SS5Player for AS3" is an ActionScript 3 library which enables Flash to display
[OPTPiX SpriteStudio](http://www.webtech.co.jp/spritestudio/) animation data.

Currently, [Starling Framework](http://starling-framework.org/) is supported as display target.


Requirements
------------

* Adobe AIR or Adobe Flash Player, latest
* Starling Framework, latest
* OPTPiX SpriteStudio, version 5


Demo
-------------

TBD


Simple Example
--------------

Try this in Starling Sprite:

	public class SS5Viewer extends Sprite {

		private var loader:SS5ProjectLoader;

		public function SS5Viewer() {
			const SSPJ:String = "path/to/your/SpriteStudioProject.sspj";
			this.loader = new SS5ProjectLoader();
			this.loader.load(new URLRequest(SSPJ), this.onProgress);
		}

		private function onProgress(progress:Number):void {
			if (progress == 1) {
				// progress is 1 when loading is complete
				var player:SS5StarlingPlayer = new SS5StarlingPlayer(this.loader.project);
				player.startAnime("nameOfYourAnime");
				this.addChild(player);
			}
		}
	}

Detailed Usage
--------------

### Loading a Project

"SS5Player for AS3" can read SpriteStudio project files (```.sspj```) without conversion.
Use ```SS5ProjectLoader``` to load a SpriteStudio project file (```.sspj```).

```SS5ProjectLoader.load()``` requires two arguments, ```URLRequest``` and ```Function```.
First argument locates the target SpriteStudio project file to load.
Second argument is callback to be called when loading has progressed or completed.
(It is similar to using ```AssetManager.loadQueue()``` of Starling.)

Note: All of the related anime packs (```.ssae```), cell maps (```.ssce```),
and texture files must be placed along with the project file.

When loading is complete,
you can retrieve the SpriteStudio project as ```SS5Project``` from ```SS5ProjectLoader.project```.

	var loader:SS5ProjectLoader;
	const SSPJ:String = "path/to/your/SpriteStudioProject.sspj";

	this.loader = new SS5ProjectLoader();
	this.loader.load(new URLRequest(SSPJ), this.onProgress);
	private function onProgress(progress:Number):void {
		if (progress == 1) {
			// progress is 1 when loading is complete
		}
	}

### Displaying SpriteStudio animation

```SS5StarlingPlayer``` is a Starling ```DisplayObject```
which can display the SpriteStudio animation data with Starling.

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

Setting ```withFlatten``` to ```true``` will call ```Sprite.flatten()``` of Starling on each display update,
which may improve performance for GPU optimized data.

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


Copyrights
----------

Copyright (c) 2013, PROMOTAL Inc. All rights reserved.
Simplified BSD License.

Also refer [LICENSE.md](https://github.com/promotal/SS5Player/blob/master/LICENSE.md).

Latest version of this software can be found at [here](https://github.com/promotal/SS5Player/).

* Web Technology, OPTPiX, SpriteStudio and Web Technology are the registered trademarks of
  [Web Technology Corp.](http://www.webtech.co.jp/)
* Adobe, Adobe AIR, Flash, and Adobe Flash Player are the registered trademarks of
  [Adobe Systems Incorporated.](http://www.adobe.com/)
* Other product names are registered trademarks or trademarks of their respective companies.
