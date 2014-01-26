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

	import starling.display.DisplayObjectContainer;
	import starling.display.Image;

	// TODO pivots
	// TODO per character pivot
	// TODO - link scaleX & scaleY
	// TODO - colors
	// TODO - GUI editor
	// TODO - saving presets as JSON

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
		public static const PROBABILITY:Number = .6;
		public static const RANDOM_EASE_PER_LETTER:Number = .3;


		private static const randomGenerationSettings:Array =
		[
			{prop:"y",          probability:PROBABILITY,        lowLimit:-200,          highLimit:500,          masterDelayRange:MASTER_DELAY_RANGE, delayDurationRange:DELAY_DURATION_RANGE,     minDuration:MIN_DURATION,   maxStartDuration:MAX_START_DURATION,     maxEndDuration:MAX_END_DURATION},
			{prop:"x",          probability:PROBABILITY,        lowLimit:-200,          highLimit:500,          masterDelayRange:MASTER_DELAY_RANGE, delayDurationRange:DELAY_DURATION_RANGE,     minDuration:MIN_DURATION,   maxStartDuration:MAX_START_DURATION,     maxEndDuration:MAX_END_DURATION},
			{prop:"scaleX",     probability:PROBABILITY,        lowLimit:-40,            highLimit:40,           masterDelayRange:MASTER_DELAY_RANGE, delayDurationRange:DELAY_DURATION_RANGE,     minDuration:MIN_DURATION,   maxStartDuration:MAX_START_DURATION,     maxEndDuration:MAX_END_DURATION},
			{prop:"scaleY",     probability:PROBABILITY,        lowLimit:-40,            highLimit:40,           masterDelayRange:MASTER_DELAY_RANGE, delayDurationRange:DELAY_DURATION_RANGE,     minDuration:MIN_DURATION,   maxStartDuration:MAX_START_DURATION,     maxEndDuration:MAX_END_DURATION},
			{prop:"rotation",   probability:PROBABILITY,        lowLimit:-Math.PI*4,    highLimit:Math.PI*4,    masterDelayRange:MASTER_DELAY_RANGE, delayDurationRange:DELAY_DURATION_RANGE,     minDuration:MIN_DURATION,   maxStartDuration:MAX_START_DURATION,     maxEndDuration:MAX_END_DURATION},
			{prop:"skewX",      probability:PROBABILITY,        lowLimit:-Math.PI*4,    highLimit:Math.PI*4,    masterDelayRange:MASTER_DELAY_RANGE, delayDurationRange:DELAY_DURATION_RANGE,     minDuration:MIN_DURATION,   maxStartDuration:MAX_START_DURATION,     maxEndDuration:MAX_END_DURATION},
			{prop:"skewY",      probability:PROBABILITY,        lowLimit:-Math.PI*4,    highLimit:Math.PI*4,    masterDelayRange:MASTER_DELAY_RANGE, delayDurationRange:DELAY_DURATION_RANGE,     minDuration:MIN_DURATION,   maxStartDuration:MAX_START_DURATION,     maxEndDuration:MAX_END_DURATION},
			{prop:"alpha",      probability:1,                  lowLimit:0,             highLimit:0,            masterDelayRange:MASTER_DELAY_RANGE, delayDurationRange:DELAY_DURATION_RANGE,     minDuration:MIN_DURATION,   maxStartDuration:.3,    maxEndDuration:.3},
		];

		private var multiTweens:Vector.<MultiTween>;


		public function TextEffect()
		{
			this.multiTweens = new Vector.<MultiTween>();
		}


		public static function fromPreset(json:String):void
		{

		}


		public static function generateRandom():TextEffect
		{
			var textEffect:TextEffect = new TextEffect();

			for each (var obj:Object in randomGenerationSettings)
			{
				if (Math.random()<obj.probability)
				{
					var multiTween:MultiTween = new MultiTween();
					multiTween.propertySettings(obj.prop, Math.random()*obj.lowLimit, Math.random()*obj.highLimit, getRandomEase(), getRandomEase(), Math.random()<RANDOM_EASE_PER_LETTER);
					multiTween.timingSettings(CharOrder.getRandomOrderFunction(), obj.masterDelayRange*Math.random(), obj.delayDurationRange*Math.random(), getRandomEase(), obj.minDuration+Math.random()*obj.maxStartDuration, obj.minDuration+Math.random()*obj.maxEndDuration, getRandomEase());
					textEffect.addTween(multiTween);

					trace(JSON.stringify(multiTween));
				}
			}
			return textEffect;
		}


		public function addTween(multiTween:MultiTween):void
		{
			this.multiTweens.push(multiTween);
		}


		public function apply(charContainer:DisplayObjectContainer):void
		{
			for (var j:int=0; j < multiTweens.length; j++)
			{
				var multiTween:MultiTween=multiTweens[j];
				var numChildren:Number = charContainer.numChildren;
				var order:Vector.<int> = CharOrder.getOrder(numChildren, multiTween.pickupOrder);

				 for (var i:int=0; i <numChildren; i++)
				 {
					 var char:Image = charContainer.getChildAt(order[i]) as Image;
					 var ratioInput:Number = order[i]/numChildren;

					 var tweenObj:Object = {};
					 tweenObj[multiTween.prop] = char[multiTween.prop];
					 tweenObj["delay"] = multiTween.masterDelay + multiTween.delayDuration*multiTween.delayDistrib.getRatio(ratioInput);
					 if (multiTween.randomEase)
					 {
					    tweenObj["ease"] = getRandomEase();//multiTween.tweenEase;
					 }
					 else
					 {
						 tweenObj["ease"] = multiTween.tweenEase;
					 }

					 TweenMax.to(char, multiTween.startDuration + multiTween.durationRange*multiTween.durationDistrib.getRatio(ratioInput), tweenObj);

					 char[multiTween.prop] = multiTween.firstVal + multiTween.valueRange*multiTween.distribFunc.getRatio(ratioInput);
				 }

			}
		}


		private static function getRandomEase():Ease
		{
		   return eases[int(Math.floor(Math.random()*eases.length))];
		}


	}
}
