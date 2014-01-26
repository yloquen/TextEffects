package com.yloquen
{
	import com.greensock.easing.Ease;

	public class MultiTween
	{
		public var prop:String;
		public var firstVal:Number;
		public var lastVal:Number;
		public var valueRange:Number;
		public var distribFunc:Ease;
		public var tweenEase:Ease;
		public var randomEase:Boolean;

		public var pickupOrder:Function;
		public var masterDelay:Number;
		public var delayDuration:Number;
		public var delayDistrib:Ease;

		public var startDuration:Number;
		public var endDuration:Number;
		public var durationRange:Number;
		public var durationDistrib:Ease;


		/**
		 *
		 * @param prop - property to be tweened
		 * @param firstVal - the value of the property for the first letter
		 * @param lastVal - the value of the property for the last letter
		 * @param distribFunc - the distribution function for setting the start value of a letter
		 * @param tweenEase - easing of the tween
		 */
		public function propertySettings(prop:String, firstVal:Number, lastVal:Number, distribFunc:Ease, tweenEase:Ease, randomEase:Boolean = false):void
		{
			this.prop = prop;
			this.firstVal = firstVal;
			this.lastVal = lastVal;
			this.valueRange = lastVal - firstVal;
			this.distribFunc = distribFunc;
			this.tweenEase = tweenEase;
			this.randomEase = randomEase;
		}

		/**
		 *
		 * @param pickupOrder - the order in which each letter is put in the animation queue
		 * @param masterDelay - delay before any anymation starts
		 * @param delayDuration - duration of the delays for all letters (combined), which influences per letter delay (which also depends on order and number of letters)
		 * @param delayDistrib - distribution function of the individual delays over the whole delay range
		 * @param startDuration - duration for the tween of the first letter
		 * @param endDuration - duration for the tween of the last letter
		 * @param durationDistrib - function which determines how the duration changes from the first to the last letter
		 */
		public function timingSettings(pickupOrder:Function, masterDelay:Number, delayDuration:Number, delayDistrib:Ease, startDuration:Number, endDuration:Number, durationDistrib:Ease)
		{
			this.pickupOrder = pickupOrder;

			this.masterDelay = masterDelay;
			this.delayDuration = delayDuration;
			this.delayDistrib = delayDistrib;

			this.startDuration = startDuration;
			this.endDuration = endDuration;
			this.durationRange = endDuration - startDuration;
			this.durationDistrib = durationDistrib;
		}

	}
}
