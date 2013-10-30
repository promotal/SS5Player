package sssplayer.net {

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class SSSLoaderTask {

		private var afterFunc:Function;

		private var waitsFor:Vector.<SSSLoaderTask>;

		private var _isComplete:Boolean = false;
		public function get isComplete():Boolean {
			return this._isComplete;
		}

		private var _waitingEventListenerCount:int = 0;
		public function get isRunnable():Boolean {
			return this._waitingEventListenerCount == 0;
		}

		public function get ratio():Number {
			var result:Number = this._isComplete ? 1 : 0;
			for each (var task:SSSLoaderTask in this.waitsFor) {
				var taskRatio:Number = task.ratio;
				result += taskRatio;
			}
			return result / (this.waitsFor.length + 1);
		}

		private var _event:*;

		public function SSSLoaderTask(afterFunc:Function = null) {
			super();
			this.afterFunc = afterFunc;
			this.waitsFor = new Vector.<SSSLoaderTask>();
		}

		public function waitFor(task:SSSLoaderTask):void {
			this.waitsFor.push(task);
		}

		public function spawn(afterFunc:Function = null):SSSLoaderTask {
			var task:SSSLoaderTask = new SSSLoaderTask(afterFunc);
			this.waitsFor.push(task);
			return task;
		}

		public function spawnEventListener(afterFunc:Function = null):Function {
			var task:SSSLoaderTask = new SSSLoaderTask(afterFunc);
			this.waitsFor.push(task);
			task._waitingEventListenerCount++;
			return function(event:*/*Event*/):void {
				task._waitingEventListenerCount--;
				task._event = event;
			}
		}

		public function tryRun():Boolean {
			// run blocking task
			for each (var task:SSSLoaderTask in this.waitsFor) {
				if (!task.isComplete) {
					task.tryRun();
					return false;
				}
			}
			// run me?
			if (!this.isRunnable) {
				return false;
			}
			// run me
			if (this.afterFunc != null) {
				this.afterFunc(this._event);
			}
			this._isComplete = true;
			return true;
		}

		private var timer:Timer;
		private var onProgress:Function;
		/* onProgress is function(ratio:Number) where 0 <= ratio <= 1 */
		public function start(onProgress:Function):void {
			this.onProgress = onProgress;
			this.timer = new Timer(1, 0);
			this.timer.addEventListener(TimerEvent.TIMER, this.onTimer);
			this.timer.start();
			onProgress(0.0);
		}
		private function onTimer(event:TimerEvent):void {
			if (this.tryRun()) {
				this.onProgress(1.0);
				this.timer.stop();
			} else {
				this.onProgress(this.ratio);
			}
		}
	}
}
