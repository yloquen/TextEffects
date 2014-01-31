package com.yloquen
{
	import com.greensock.easing.Ease;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;

	public class MultiTween
	{
		public var prop:String;
		private var _firstVal:Number;
		private var _lastVal:Number;
		public var valueRange:Number;
		public var distribFunc:Ease;
		public var tweenEase:Ease;
		public var randomEase:Boolean;

		public var pickupOrder:Function;
		public var masterDelay:Number;
		public var delayDuration:Number;
		public var delayDistrib:Ease;

		private var _firstDuration:Number;
		private var _lastDuration:Number;
		public var durationRange:Number;
		public var durationDistrib:Ease;


		/**
		 *
		 * @param prop - property to be tweened
		 * @param firstVal - the value of the property for the first letter
		 * @param lastVal - the value of the property for the last letter
		 * @param distribFunc - the distribution function for setting the start value of a letter
		 * @param tweenEase - the easing function of the tween
		 * @param randomEase - random ease for each letter
		 */
		public function propertySettings(prop:String, firstVal:Number, lastVal:Number, distribFunc:Ease, tweenEase:Ease, randomEase:Boolean = false):void
		{
			this.prop = prop;
			this._firstVal = firstVal;
			this._lastVal = lastVal;
			this.valueRange = lastVal - firstVal;
			this.distribFunc = distribFunc;
			this.tweenEase = tweenEase;
			this.randomEase = randomEase;
		}

		/**
		 *
		 * @param pickupOrder - function which sets the order in which each letter is put in the animation queue
		 * @param masterDelay - delay before any animation starts
		 * @param delayDuration - duration of the delays for all letters (combined), which influences per letter delay (which also depends on order and number of letters)
		 * @param delayDistrib - distribution function of the individual delays over the whole delay range
		 * @param firstDuration - duration for the tween of the first letter
		 * @param lastDuration - duration for the tween of the last letter
		 * @param durationDistrib - function which determines how the duration changes from the first to the last letter
		 */
		public function timingSettings(pickupOrder:Function, masterDelay:Number, delayDuration:Number, delayDistrib:Ease, firstDuration:Number, lastDuration:Number, durationDistrib:Ease)
		{
			this.pickupOrder = pickupOrder;

			this.masterDelay = masterDelay;
			this.delayDuration = delayDuration;
			this.delayDistrib = delayDistrib;

			this._firstDuration = firstDuration;
			this._lastDuration = lastDuration;
			this.durationRange = lastDuration - firstDuration;
			this.durationDistrib = durationDistrib;
		}

		public function get firstVal():Number
		{
			return _firstVal;
		}

		public function set firstVal(value:Number):void
		{
			_firstVal=value;
			valueRange = _lastVal - _firstVal;
		}

		public function get lastVal():Number
		{
			return _lastVal;
		}

		public function set lastVal(value:Number):void
		{
			_lastVal=value;
			valueRange = _lastVal - _firstVal;
		}

		public function get firstDuration():Number
		{
			return _firstDuration;
		}

		public function set firstDuration(value:Number):void
		{
			_firstDuration=value;
			this.durationRange = _lastDuration - _firstDuration;
		}

		public function get lastDuration():Number
		{
			return _lastDuration;
		}

		public function set lastDuration(value:Number):void
		{
			_lastDuration=value;
			this.durationRange = _lastDuration - _firstDuration;
		}

		public function toJSON(k):*
		{
			return {    "prop":             this.prop,
						"firstVal":         _firstVal.toFixed(3),
						"lastVal":          _lastVal.toFixed(3),
						"distribFunc":      TextEffect.getEaseId(distribFunc),
						"tweenEase":        TextEffect.getEaseId(distribFunc),
						"randomEase":       randomEase,
						"pickupOrder":      CharOrder.getOrderId(pickupOrder),
						"masterDelay":      masterDelay.toFixed(3),
						"delayDuration":    delayDuration.toFixed(3),
						"delayDistrib":     TextEffect.getEaseId(delayDistrib),
						"firstDuration":    _firstDuration.toFixed(3),
						"lastDuration":     _lastDuration.toFixed(3),
						"durationDistrib":  TextEffect.getEaseId(durationDistrib)
			};
		}


		public function fromJSON(initObj:Object):void
		{
			this.prop = initObj.prop;
			this.firstVal = initObj.firstVal;
			this.lastVal = initObj.lastVal;
			this.distribFunc = TextEffect.getEaseById(initObj.distribFunc);
			this.tweenEase = TextEffect.getEaseById(initObj.tweenEase);
			this.randomEase = initObj.randomEase;
			this.pickupOrder = CharOrder.getOrderById(initObj.pickupOrder);
			this.masterDelay = initObj.masterDelay;
			this.delayDuration = initObj.delayDuration;
			this.delayDistrib = TextEffect.getEaseById(initObj.delayDistrib);
			this.firstDuration = initObj.firstDuration;
			this.lastDuration = initObj.lastDuration;
			this.durationDistrib = TextEffect.getEaseById(initObj.durationDistrib);
		}

	}
}
