package com.yloquen.tools
{
	import com.yloquen.texteffects.*;
	import flash.geom.Point;

	public class RandomGenerator
	{
		public static const MASTER_DELAY_RANGE:Number = 1;
		public static const DELAY_DURATION_RANGE:Number = 5;
		public static const MIN_DURATION:Number = .2;
		public static const MAX_START_DURATION:Number = 1;
		public static const MAX_END_DURATION:Number = 1;
		public static const PROBABILITY:Number = .5;
		public static const RANDOM_EASE_PER_LETTER:Number = .2;

		private static const PER_CHARACTER_PIVOT_PROBABILITY:Number= .2;
		private static const CENTER_PIVOT_PROBABILITY:Number= .5;
		private static const PIVOT_RANGE:Number= 2;
		private static const LINKED_SCALE_PROBABILITY:Number = .6;


		private static const RANDOM_GENERATION_SETTINGS:Array =
		[
			{prop:"y",          probability:PROBABILITY,        lowLimit:-200,          highLimit:500,          masterDelayRange:MASTER_DELAY_RANGE,    delayDurationRange:DELAY_DURATION_RANGE,     minDuration:MIN_DURATION,   maxStartDuration:MAX_START_DURATION,     maxEndDuration:MAX_END_DURATION},
			{prop:"x",          probability:PROBABILITY,        lowLimit:-200,          highLimit:500,          masterDelayRange:MASTER_DELAY_RANGE,    delayDurationRange:DELAY_DURATION_RANGE,     minDuration:MIN_DURATION,   maxStartDuration:MAX_START_DURATION,     maxEndDuration:MAX_END_DURATION},
			{prop:"scaleX",     probability:.2,                 lowLimit:-40,           highLimit:40,           masterDelayRange:MASTER_DELAY_RANGE,    delayDurationRange:DELAY_DURATION_RANGE,     minDuration:MIN_DURATION,   maxStartDuration:MAX_START_DURATION,     maxEndDuration:MAX_END_DURATION},
			{prop:"scaleY",     probability:.2,                 lowLimit:-40,           highLimit:40,           masterDelayRange:MASTER_DELAY_RANGE,    delayDurationRange:DELAY_DURATION_RANGE,     minDuration:MIN_DURATION,   maxStartDuration:MAX_START_DURATION,     maxEndDuration:MAX_END_DURATION},
			{prop:"rotation",   probability:PROBABILITY,        lowLimit:-Math.PI*4,    highLimit:Math.PI*4,    masterDelayRange:MASTER_DELAY_RANGE,    delayDurationRange:DELAY_DURATION_RANGE,     minDuration:MIN_DURATION,   maxStartDuration:MAX_START_DURATION,     maxEndDuration:MAX_END_DURATION},
			{prop:"skewX",      probability:.3,                 lowLimit:-Math.PI*4,    highLimit:Math.PI*4,    masterDelayRange:MASTER_DELAY_RANGE,    delayDurationRange:DELAY_DURATION_RANGE,     minDuration:MIN_DURATION,   maxStartDuration:MAX_START_DURATION,     maxEndDuration:MAX_END_DURATION},
			{prop:"skewY",      probability:.3,                 lowLimit:-Math.PI*4,    highLimit:Math.PI*4,    masterDelayRange:MASTER_DELAY_RANGE,    delayDurationRange:DELAY_DURATION_RANGE,     minDuration:MIN_DURATION,   maxStartDuration:MAX_START_DURATION,     maxEndDuration:MAX_END_DURATION},
			{prop:"color",      probability:.5,                 lowLimit:0xffffff,      highLimit:0xffffff,     masterDelayRange:MASTER_DELAY_RANGE,    delayDurationRange:DELAY_DURATION_RANGE,     minDuration:MIN_DURATION,   maxStartDuration:MAX_START_DURATION,     maxEndDuration:MAX_END_DURATION},
			{prop:"alpha",      probability:1,                  lowLimit:0,             highLimit:0,            masterDelayRange:MASTER_DELAY_RANGE,    delayDurationRange:DELAY_DURATION_RANGE,     minDuration:MIN_DURATION,   maxStartDuration:MAX_START_DURATION/2,    maxEndDuration:MAX_END_DURATION/2},
		];


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

			for each (var obj:Object in RANDOM_GENERATION_SETTINGS)
			{
				if (Math.random()<obj.probability)
				{
					if (obj.prop == "scaleX" || obj.prop == "scaleY")
						scaleApplied = true;

					var multiTween:MultiTween = new MultiTween();
					multiTween.propertySettings(obj.prop, Math.random()*obj.lowLimit, Math.random()*obj.highLimit, EaseManager.getRandom(), EaseManager.getRandom(), Math.random()<RANDOM_EASE_PER_LETTER);
					multiTween.timingSettings(CharOrder.getRandomOrderFunction(), obj.masterDelayRange*Math.random(), obj.delayDurationRange*Math.random(), EaseManager.getRandom(), obj.minDuration+Math.random()*obj.maxStartDuration, obj.minDuration+Math.random()*obj.maxEndDuration, EaseManager.getRandom());
					textEffect.addTween(multiTween);
				}
			}

			if (!scaleApplied && Math.random()<LINKED_SCALE_PROBABILITY)
			{
				obj = RANDOM_GENERATION_SETTINGS[2];
				var sXtween:MultiTween = new MultiTween();
				sXtween.propertySettings("scaleX", Math.random()*obj.lowLimit, Math.random()*obj.highLimit, EaseManager.getRandom(), EaseManager.getRandom());
				sXtween.timingSettings(CharOrder.getRandomOrderFunction(), obj.masterDelayRange*Math.random(), obj.delayDurationRange*Math.random(), EaseManager.getRandom(), obj.minDuration+Math.random()*obj.maxStartDuration, obj.minDuration+Math.random()*obj.maxEndDuration, EaseManager.getRandom());
				textEffect.addTween(sXtween);

				var sYtween:MultiTween = new MultiTween();
				sYtween.propertySettings("scaleY", sXtween.firstVal, sXtween.lastVal, sXtween.distribFunc, sXtween.tweenEase)
				sYtween.timingSettings(sXtween.orderingFunc, sXtween.masterDelay, sXtween.delayDuration, sXtween.delayDistrib, sXtween.firstDuration, sXtween.lastDuration, sXtween.durationDistrib);
				textEffect.addTween(sYtween);
			}

			return textEffect;
		}

	}
}
