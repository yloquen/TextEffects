package com.yloquen
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Ease;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quart;
	import com.greensock.easing.Quint;
	import com.greensock.easing.Sine;
	import com.greensock.easing.Strong;
	import com.greensock.plugins.HexColorsPlugin;
	import com.greensock.plugins.TweenPlugin;

	import flash.geom.Point;

	import starling.display.DisplayObjectContainer;
	import starling.display.Image;

	// TODO pivot tweening
	// TODO - GUI editor
	// TODO - saving/loading presets as JSON

	public class TextEffect
	{
		private static const eases:Vector.<Ease> = Vector.<Ease>([
			Back.easeIn,
			Back.easeInOut,
			Back.easeOut,
			Bounce.easeIn,
			Bounce.easeInOut,
			Bounce.easeOut,
			Circ.easeIn,
			Circ.easeInOut,
			Circ.easeOut,
			Cubic.easeIn,
			Cubic.easeInOut,
			Cubic.easeOut,
			Elastic.easeIn,
			Elastic.easeInOut,
			Elastic.easeOut,
			Expo.easeIn,
			Expo.easeInOut,
			Expo.easeOut,
			Linear.easeIn,
			Linear.easeInOut,
			Linear.easeOut,
			Quad.easeIn,
			Quad.easeInOut,
			Quad.easeOut,
			Quart.easeIn,
			Quart.easeInOut,
			Quart.easeOut,
			Quint.easeIn,
			Quint.easeInOut,
			Quint.easeOut,
			Sine.easeIn,
			Sine.easeInOut,
			Sine.easeOut,
			Strong.easeIn,
			Strong.easeInOut,
			Strong.easeOut,
		]);

		public static const MASTER_DELAY_RANGE:Number = 1;
		public static const DELAY_DURATION_RANGE:Number = 5;
		public static const MIN_DURATION:Number = .2;
		public static const MAX_START_DURATION:Number = 1;
		public static const MAX_END_DURATION:Number = 1;
		public static const PROBABILITY:Number = .5;
		public static const RANDOM_EASE_PER_LETTER:Number = .2;


		private static const randomGenerationSettings:Array =
		[
			{prop:"y",          probability:PROBABILITY,        lowLimit:-200,          highLimit:500,          masterDelayRange:MASTER_DELAY_RANGE, delayDurationRange:DELAY_DURATION_RANGE,     minDuration:MIN_DURATION,   maxStartDuration:MAX_START_DURATION,     maxEndDuration:MAX_END_DURATION},
			{prop:"x",          probability:PROBABILITY,        lowLimit:-200,          highLimit:500,          masterDelayRange:MASTER_DELAY_RANGE, delayDurationRange:DELAY_DURATION_RANGE,     minDuration:MIN_DURATION,   maxStartDuration:MAX_START_DURATION,     maxEndDuration:MAX_END_DURATION},
			{prop:"scaleX",     probability:.3,                 lowLimit:-40,           highLimit:40,           masterDelayRange:MASTER_DELAY_RANGE, delayDurationRange:DELAY_DURATION_RANGE,     minDuration:MIN_DURATION,   maxStartDuration:MAX_START_DURATION,     maxEndDuration:MAX_END_DURATION},
			{prop:"scaleY",     probability:.3,                 lowLimit:-40,           highLimit:40,           masterDelayRange:MASTER_DELAY_RANGE, delayDurationRange:DELAY_DURATION_RANGE,     minDuration:MIN_DURATION,   maxStartDuration:MAX_START_DURATION,     maxEndDuration:MAX_END_DURATION},
			{prop:"rotation",   probability:PROBABILITY,        lowLimit:-Math.PI*4,    highLimit:Math.PI*4,    masterDelayRange:MASTER_DELAY_RANGE, delayDurationRange:DELAY_DURATION_RANGE,     minDuration:MIN_DURATION,   maxStartDuration:MAX_START_DURATION,     maxEndDuration:MAX_END_DURATION},
			{prop:"skewX",      probability:PROBABILITY,        lowLimit:-Math.PI*4,    highLimit:Math.PI*4,    masterDelayRange:MASTER_DELAY_RANGE, delayDurationRange:DELAY_DURATION_RANGE,     minDuration:MIN_DURATION,   maxStartDuration:MAX_START_DURATION,     maxEndDuration:MAX_END_DURATION},
			{prop:"skewY",      probability:PROBABILITY,        lowLimit:-Math.PI*4,    highLimit:Math.PI*4,    masterDelayRange:MASTER_DELAY_RANGE, delayDurationRange:DELAY_DURATION_RANGE,     minDuration:MIN_DURATION,   maxStartDuration:MAX_START_DURATION,     maxEndDuration:MAX_END_DURATION},
			{prop:"color",      probability:.5,                 lowLimit:0xffffff,      highLimit:0xffffff,     masterDelayRange:MASTER_DELAY_RANGE, delayDurationRange:DELAY_DURATION_RANGE,     minDuration:MIN_DURATION,   maxStartDuration:MAX_START_DURATION,     maxEndDuration:MAX_END_DURATION},
			{prop:"alpha",      probability:1,                  lowLimit:0,             highLimit:0,            masterDelayRange:MASTER_DELAY_RANGE, delayDurationRange:DELAY_DURATION_RANGE,     minDuration:MIN_DURATION,   maxStartDuration:MAX_START_DURATION/2,    maxEndDuration:MAX_END_DURATION/2},
		];

		private static const PER_CHARACTER_PIVOT_PROBABILITY:Number= .2;
		private static const CENTER_PIVOT_PROBABILITY:Number= .5;
		private static const PIVOT_RANGE:Number= 2;
		private static const LINKED_SCALE_PROBABILITY:Number = .5;


		private var _multiTweens:Vector.<MultiTween>;
		private var _randomPivotPerChar:Boolean;
		private var _pivot:Point;



		public function TextEffect()
		{
			TweenPlugin.activate([HexColorsPlugin]);
			this._multiTweens = new Vector.<MultiTween>();
			this._pivot = new Point(0,0);
		}


		public static function fromPreset(json:String):void
		{

		}


		public static function generateRandom():TextEffect
		{
			var textEffect:TextEffect = new TextEffect();
			var scaleApplied:Boolean = false;

			if (Math.random()<PER_CHARACTER_PIVOT_PROBABILITY)
			{
				textEffect.randomPivotPerChar = true;
			}
			else
			{
				if (Math.random()<CENTER_PIVOT_PROBABILITY)
				{
					textEffect.pivot = new Point(.5,.5);
				}
				else
				{
				 	textEffect.pivot = new Point(.5 - Math.random()*PIVOT_RANGE/2 + PIVOT_RANGE, .5 - Math.random()*PIVOT_RANGE/2 + PIVOT_RANGE);
				}
			}

			for each (var obj:Object in randomGenerationSettings)
			{
				if (Math.random()<obj.probability)
				{
					if (obj.prop == "scaleX" || obj.prop == "scaleY")
						scaleApplied = true;

					var multiTween:MultiTween = new MultiTween();
					multiTween.propertySettings(obj.prop, Math.random()*obj.lowLimit, Math.random()*obj.highLimit, getRandomEase(), getRandomEase(), Math.random()<RANDOM_EASE_PER_LETTER);
					multiTween.timingSettings(CharOrder.getRandomOrderFunction(), obj.masterDelayRange*Math.random(), obj.delayDurationRange*Math.random(), getRandomEase(), obj.minDuration+Math.random()*obj.maxStartDuration, obj.minDuration+Math.random()*obj.maxEndDuration, getRandomEase());
					textEffect.addTween(multiTween);
				}
			}

			if (!scaleApplied && Math.random()<LINKED_SCALE_PROBABILITY)
			{
				var sXtween:MultiTween = new MultiTween();
				sXtween.propertySettings("scaleX", Math.random()*obj.lowLimit, Math.random()*obj.highLimit, getRandomEase(), getRandomEase());
				sXtween.timingSettings(CharOrder.getRandomOrderFunction(), obj.masterDelayRange*Math.random(), obj.delayDurationRange*Math.random(), getRandomEase(), obj.minDuration+Math.random()*obj.maxStartDuration, obj.minDuration+Math.random()*obj.maxEndDuration, getRandomEase());
				textEffect.addTween(sXtween);

				var sYtween:MultiTween = new MultiTween();
				sYtween.propertySettings("scaleY", sXtween.firstVal, sXtween.lastVal, sXtween.distribFunc, sXtween.tweenEase)
				sYtween.timingSettings(sXtween.pickupOrder, sXtween.masterDelay, sXtween.delayDuration, sXtween.delayDistrib, sXtween.firstDuration, sXtween.lastDuration, sXtween.durationDistrib);
				textEffect.addTween(sYtween);
			}

			return textEffect;
		}


		public function addTween(multiTween:MultiTween):void
		{
			this._multiTweens.push(multiTween);
		}


		public function apply(charContainer:DisplayObjectContainer):void
		{
			var char:Image;
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
				var order:Vector.<int> = CharOrder.getOrder(numChildren, multiTween.pickupOrder);
				var color:Boolean = (multiTween.prop == "color");

				 for (i=0; i <numChildren; i++)
				 {
					 char = charContainer.getChildAt(order[i]) as Image;
					 var ratioInput:Number = i/numChildren;

					 var tweenObj:Object = {};
					 tweenObj["delay"] = multiTween.masterDelay + multiTween.delayDuration*multiTween.delayDistrib.getRatio(ratioInput);

					 if (multiTween.randomEase)
					 {
					    tweenObj["ease"] = getRandomEase();
					 }
					 else
					 {
						 tweenObj["ease"] = multiTween.tweenEase;
					 }

					 if (color)
					 {
						 tweenObj["hexColors"] = {color:char.color};
						 TweenMax.to(char, multiTween.firstDuration + multiTween.durationRange*multiTween.durationDistrib.getRatio(ratioInput), tweenObj);
						 char.color = tweenColor(multiTween.firstVal, multiTween.lastVal, multiTween.distribFunc.getRatio(ratioInput));
					 }
					 else
					 {
						 tweenObj[multiTween.prop] = char[multiTween.prop];
						 TweenMax.to(char, multiTween.firstDuration + multiTween.durationRange*multiTween.durationDistrib.getRatio(ratioInput), tweenObj);
						 char[multiTween.prop] = multiTween.firstVal + multiTween.valueRange*multiTween.distribFunc.getRatio(ratioInput);
					 }
				 }
			}
		}


		public function tweenColor(startColor:uint, endColor:uint, ratio:Number):uint
		{
			var r:uint = startColor >> 16;
			var g:uint = startColor >> 8 & 0xFF;
			var b:uint = startColor & 0xFF;
			r += ((endColor >> 16)-r)*ratio;
			g += ((endColor >> 8 & 0xFF)-g)*ratio;
			b += ((endColor & 0xFF)-b)*ratio;

			return(r<<16 | g<<8 | b);
		}


		private static function getRandomEase():Ease
		{
		   return eases[int(Math.floor(Math.random()*eases.length))];
		}


		public function get pivot():Point
		{
			return _pivot;
		}


		public function set pivot(value:Point):void
		{
			_pivot=value;
		}

		public function get randomPivotPerChar():Boolean
		{
			return _randomPivotPerChar;
		}


		public function set randomPivotPerChar(value:Boolean):void
		{
			_randomPivotPerChar=value;
		}


	}
}
