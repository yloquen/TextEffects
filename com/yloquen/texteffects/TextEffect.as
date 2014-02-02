package com.yloquen.texteffects
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.plugins.HexColorsPlugin;
	import com.greensock.plugins.TweenPlugin;

	import flash.geom.Point;

	import starling.display.DisplayObjectContainer;
	import starling.display.Image;

	public class TextEffect
	{
		private var _multiTweens:Vector.<MultiTween>;
		private var _randomPivotPerChar:Boolean;
		private var _pivot:Point;

		private static const PIVOT_RANGE:Number= 2;
		private var _timeline:TimelineMax;


		public function TextEffect()
		{
			TweenPlugin.activate([HexColorsPlugin]);
			this._multiTweens = new Vector.<MultiTween>();
			this._randomPivotPerChar = false;
			this._pivot = new Point(0,0);
			this._timeline = new TimelineMax();
		}


		public function addTween(multiTween:MultiTween):void
		{
			this._multiTweens.push(multiTween);
		}


		public function generateTimeline(charContainer:DisplayObjectContainer, text:String):void
		{
			var char:Image;

			this._timeline.gotoAndStop(0);
			this._timeline.clear();

			//this._timeline = new TimelineMax();

			for (var i:int=0; i <charContainer.numChildren; i++)
			{
				char = charContainer.getChildAt(i) as Image;
				if (_randomPivotPerChar)
				{
					char.pivotX = char.texture.width*(.5 - Math.random()*PIVOT_RANGE/2 + PIVOT_RANGE);
					char.pivotY = char.texture.height*(.5 - Math.random()*PIVOT_RANGE/2 + PIVOT_RANGE);
					char.x += char.pivotX*char.scaleX;
					char.y += char.pivotY*char.scaleY;
				}
				else
				{
					char.pivotX = char.texture.width * this._pivot.x;
					char.pivotY = char.texture.height * this._pivot.y;
					char.x += char.pivotX*char.scaleX;
					char.y += char.pivotY*char.scaleY;
				}
			}

			for (var j:int=0; j < _multiTweens.length; j++)
			{
				var multiTween:MultiTween=_multiTweens[j];
				var numChildren:Number = charContainer.numChildren;
				var order:Vector.<int> = CharOrder.getOrder(numChildren, multiTween.orderingFunc, text, charContainer);
				var color:Boolean = (multiTween.prop == "color");

				 for (i=0; i <numChildren; i++)
				 {
					 char = charContainer.getChildAt(order[i]) as Image;
					 var ratioInput:Number = i/numChildren;

					 var tweenObj:Object = {};
					 tweenObj["delay"] = multiTween.masterDelay + multiTween.delayDuration*multiTween.delayDistrib.getRatio(ratioInput);

					 if (multiTween.randomEase)
					 {
					    tweenObj["ease"] = EaseManager.getRandom();
					 }
					 else
					 {
						 tweenObj["ease"] = multiTween.tweenEase;
					 }

					 if (color)
					 {
						 tweenObj["hexColors"] = {color:char.color};
						 //TweenMax.to(char, multiTween.firstDuration + multiTween.durationRange*multiTween.durationDistrib.getRatio(ratioInput), tweenObj);
						 this._timeline.insert(TweenMax.to(char, multiTween.firstDuration + multiTween.durationRange*multiTween.durationDistrib.getRatio(ratioInput), tweenObj));
						 char.color = tweenColor(multiTween.firstVal, multiTween.lastVal, multiTween.distribFunc.getRatio(ratioInput));
					 }
					 else
					 {
						 tweenObj[multiTween.prop] = char[multiTween.prop];
						 //TweenMax.to(char, multiTween.firstDuration + multiTween.durationRange*multiTween.durationDistrib.getRatio(ratioInput), tweenObj);
						 this._timeline.insert(TweenMax.to(char, multiTween.firstDuration + multiTween.durationRange*multiTween.durationDistrib.getRatio(ratioInput), tweenObj));
						 char[multiTween.prop] = multiTween.firstVal + multiTween.valueRange*multiTween.distribFunc.getRatio(ratioInput);
					 }
				 }
			}
		}


		public function tweenColor(startColor:uint, endColor:uint, ratio:Number):uint
		{
			var r:uint = startColor >> 16;
			var g:uint = startColor >> 8 & 0xff;
			var b:uint = startColor & 0xff;

			r += ((endColor >> 16)-r)*ratio;
			g += ((endColor >> 8 & 0xff)-g)*ratio;
			b += ((endColor & 0xff)-b)*ratio;

			return(r<<16 | g<<8 | b);
		}


		public function get randomPivotPerChar():Boolean
		{
			return _randomPivotPerChar;
		}


		public function set randomPivotPerChar(value:Boolean):void
		{
			_randomPivotPerChar=value;
		}


		public function get multiTweens():Vector.<MultiTween>
		{
			return _multiTweens;
		}


		public function toJSON(k):*
		{
			return {    "multiTweens": _multiTweens,
						"pivot"     : {"x":_pivot.x.toFixed(3), "y":_pivot.y.toFixed(3)},
						"randomPivotPerChar":_randomPivotPerChar
			};
		}


		public function fromJSON(initObj:Object):void
		{
			this._multiTweens = new Vector.<MultiTween>();

			this._pivot = new Point(initObj.pivot.x, initObj.pivot.y);
			this.randomPivotPerChar = initObj.randomPivotPerChar;

			for each (var obj:Object in initObj.multiTweens)
			{
				var multiTween:MultiTween = new MultiTween();
				multiTween.fromJSON(obj);
				this._multiTweens.push(multiTween);
			}
		}


		public function get timeline():TimelineMax
		{
			return _timeline;
		}


		public function scaleTimes(scaleFactor:Number):void
		{
			for (var i:int=0; i < multiTweens.length; i++)
			{
				multiTweens[i].scaleTimes(scaleFactor);
			}
		}

		public function clearTweens():void
		{
			this._multiTweens = new Vector.<MultiTween>();
		}

		public function get pivot():Point
		{
			return _pivot;
		}

		public function set pivot(value:Point):void
		{
			_pivot=value;
		}
	}
}
