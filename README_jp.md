SS5Player for AS3
=================

このライブラリについて
----------------------

"SS5Player for AS3" は、Flash で
[OPTPiX SpriteStudio](http://www.webtech.co.jp/spritestudio/) のアニメーションデータを表示するライブラリです。

現在、 [Starling Framework](http://starling-framework.org/) に対応しています。

動作環境
--------

* 最新の Adobe AIR または Adobe Flash Player
* 最新の Starling Framework
* OPTPiX SpriteStudio バージョン 5


動作サンプル
-------------

TBD


単純な使用例
------------

Starling を使ってアニメーションを表示するサンプルプログラムの一部です。

	public class SS5Viewer extends Sprite {

		private var loader:SS5ProjectLoader;

		public function SS5Viewer() {
			const SSPJ:String = "path/to/your/SpriteStudioProject.sspj";
			this.loader = new SS5ProjectLoader();
			this.loader.load(new URLRequest(SSPJ), this.onProgress);
		}

		private function onProgress(progress:Number):void {
			if (progress == 1) {
				// progress は読み込み完了時に 1 になる
				var player:SS5StarlingPlayer = new SS5StarlingPlayer(this.loader.project);
				player.startAnime("nameOfYourAnime");
				this.addChild(player);
			}
		}
	}


使い方
------

### プロジェクトの読み込み

"SS5Player for AS3"は、SpriteStudio プロジェクトファイル（```.sspj```）を直接読み込みます。
SpriteStudio プロジェクトファイルを読み込むには、 ```SS5ProjectLoader``` を使用します。

```SS5ProjectLoader.load()``` は二つの引数を取ります:  ```URLRequest``` と ```Function``` です。
最初の引数で読み込む対象の SpriteStudio プロジェクトファイルを指定します。
二つ目の引数はコールバック関数で、読み込みが進行および完了したときに呼び出されます。
(Starlingの ```AssetManager.loadQueue()``` と同じような使い方です。)

※注意： アニメーション (```.ssae```) 、セルマップ (```.ssce```) 、
画像ファイルなどはプロジェクトから参照できる場所に配置して下さい。

読み込みが完了したら、 ```SS5ProjectLoader.project``` を用いて読み込まれた SpriteStudio プロジェクトを取得することができます。

	var loader:SS5ProjectLoader;
	const SSPJ:String = "path/to/your/SpriteStudioProject.sspj";

	this.loader = new SS5ProjectLoader();
	this.loader.load(new URLRequest(SSPJ), this.onProgress);
	private function onProgress(progress:Number):void {
		if (progress == 1) {
			// progress is 1 when loading is complete
		}
	}

### SpriteStudio アニメーションの表示

```SS5StarlingPlayer``` は Starling を用いて SpriteStudio アニメーションデータを表示します。

	var player:SS5StarlingPlayer = new SS5StarlingPlayer(this.loader.project);
	this.addChild(player);


### Playback controls

```setAnime()``` を呼ぶとプロジェクトからアニメーションを読み込みます。

	player.setAnime("nameOfYourAnime");

アニメーションを読み込んだ状態で、```play()``` と ```stop()``` はそれぞれアニメーションを再生および停止します。

	player.play();
	player.stop();

```startAnime()``` は ```setAnime()``` と ```play()``` の両方を行います。

	player.startAnime("nameOfYourAnime");

```loop``` を ```true``` にするとアニメーションがループします。

	player.loop = true;

```withFlatten``` を ```true``` にすると、表示が更新されるたびにStarlingの ```Sprite.flatten()``` を呼び出します。
適切に作られたアニメーションデータの再生速度が向上するかもしれません。

	player.withFlatten = true;

パーツに対しての当たり判定を取るには、```partNameAt()``` と ```partPlayerAt()``` を使用します。

	var name:String = player.partNameAt(x, y, forTouch);
	var partPlayer:SS5StarlingPartPlayer = player.partPlayerAt(x, y, forTouch);

### 対応状況

現在サポートしているアトリビュートの一覧：

	"CELL"
	"HIDE"
	"POSX"
	"POSY"
	"ROTZ"
	"SCLX"
	"SCLY"
	"ALPH"

現在、補完タイプは ```"linear"``` のみ対応しています。


API Reference
-------------

TBD


Copyrights
----------

Copyright (c) 2013, PROMOTAL Inc. All rights reserved.
Simplified BSD License.

[LICENSE.md](https://github.com/promotal/SS5Player/blob/master/LICENSE.md) ファイルをあわせて参照してください。

本ソフトウェアの最新版は、 [Github](https://github.com/promotal/SS5Player/) より入手できます。

* OPTPiX、SpriteStudio、Web Technologyは、
  [株式会社ウェブテクノロジ](http://www.webtech.co.jp/)の登録商標です。
* Adobe、Adobe AIR、Flash、Adobe Flash Playerは、
  [Adobe Systems Incorporated(アドビシステムズ社)](http://www.adobe.com/jp/)の商標または登録商標です。
* その他の商品名は各社の登録商標または商標です。
