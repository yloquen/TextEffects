package com.yloquen.tools
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Ease;
	import com.yloquen.texteffects.CharOrder;
	import com.yloquen.texteffects.CharOrder;
	import com.yloquen.texteffects.EaseManager;
	import com.yloquen.texteffects.EaseManager;
	import com.yloquen.texteffects.EaseManager;
	import com.yloquen.texteffects.EaseManager;
	import com.yloquen.texteffects.MultiTween;

	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.PickerList;
	import feathers.controls.Slider;

	import flash.utils.Dictionary;
	import flash.utils.describeType;

	import starling.core.Starling;

	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;

	public class MultiTweenEditor extends Sprite
	{
		private var sliders:Dictionary;
		private var editButton:Button;
		private var sliderContainer:Sprite;
		private var _multiTween:MultiTween;

		private var sliderSettings:Object;
		private var easeSettings:Object = {distribFunc:{}, tweenEase:{}, delayDistrib:{}, durationDistrib:{}};

		private var valueTFs:Dictionary;
		private var enableCheckbox:Check;
		private var targetWidth:Number;
		private var targetHeight:Number;

		private var sliderOrder:Vector.<String> = Vector.<String>([null, "firstVal", "lastVal", "distribFunc", "tweenEase", "randomEase", "masterDelay", "delayDuration", "delayDistrib", "firstDuration", "lastDuration", "durationDistrib"]);
		private var pickers:Dictionary;
		private var orderPicker:PickerList;
		private var randomEaseCheck:Check;
		private var randomEaseTF:TextField;

		public function create(property:String, sliderSettings:Object, width:Number, height:Number)
		{
			this.targetWidth = width;
			this.targetHeight = height;

			this._multiTween = new MultiTween();
			this._multiTween.prop = property;

			this.valueTFs = new Dictionary();
			this.sliders = new Dictionary();
			this.pickers = new Dictionary();
			this.sliderSettings = sliderSettings;

			this.sliderContainer = new Sprite();
			TweenMax.to(this.sliderContainer, 0, {autoAlpha:0});
			addChild(this.sliderContainer);

			this.enableCheckbox = new Check();
			this.enableCheckbox.x = targetWidth*.1;
			this.enableCheckbox.height = this.enableCheckbox.width = this.targetHeight*.5;
			this.enableCheckbox.y = (this.targetHeight-this.enableCheckbox.height)/2;
			addChild(this.enableCheckbox);

			this.editButton = new Button();
			this.editButton.width = targetWidth*.75;
			this.editButton.height = this.targetHeight;
			this.editButton.x = targetWidth*.25;
			this.editButton.label = property;
			this.editButton.addEventListener(Event.TRIGGERED, toggleEditPanel);
			addChild(this.editButton);

			this.orderPicker = new PickerList();
			this.sliderContainer.addChild(orderPicker);
			orderPicker.width = targetWidth;
			orderPicker.x = targetWidth*1.05;
			orderPicker.selectedIndex = CharOrder.getIndexOf(_multiTween.orderingFunc);
			orderPicker.dataProvider = CharOrder.getListCollection();
			orderPicker.listProperties.@itemRendererProperties.labelField = "text";
			orderPicker.labelFunction = function():Object{return "Pick order func:" + ":" + this.selectedItem.text };
			orderPicker.addEventListener(Event.CHANGE, onOrderPickerChange);



			var cnt:int = 0;
			for (var prop:String in this.sliderSettings)
			{
				var slider:Sprite = drawSlider(prop);
				slider.name = prop;
				this.sliderContainer.addChild(slider);
				slider.y = targetHeight*.7*sliderOrder.indexOf(prop);
				slider.x = targetWidth*1.1;
				cnt++;
			}

			for (var prop:String in this.easeSettings)
			{
				var list:PickerList = new PickerList();
				this.sliderContainer.addChild(list);
				list.y = targetHeight*.7*sliderOrder.indexOf(prop);
				list.width = targetWidth;
				list.x = targetWidth*1.05;
				list.selectedIndex = EaseManager.getIndexOf(_multiTween[prop]);
				list.dataProvider = EaseManager.getListCollection();
				list.listProperties.@itemRendererProperties.labelField = "text";
				list.addEventListener(Event.CHANGE, onPickerChange);
				list.name = prop;
				list.labelFunction = function():Object{return this.name + ":" + this.selectedItem.text};
				this.pickers[prop] = list;
			}

			this.randomEaseCheck = new Check();
			this.randomEaseCheck.x = targetWidth*1.1;
			this.randomEaseCheck.height = this.randomEaseCheck.width = this.targetHeight*.5;
			this.randomEaseCheck.y = sliderOrder.indexOf("randomEase")*targetHeight*.7;
			this.randomEaseCheck.addEventListener(Event.CHANGE, onRandomEaseChange);
			sliderContainer.addChild(this.randomEaseCheck);

			this.randomEaseTF = new TextField(targetWidth *.7, 20, "RANDOM EASE", "Verdana", targetHeight *.3);
			this.randomEaseTF.x = targetWidth*1.3;
			this.randomEaseTF.y = sliderOrder.indexOf("randomEase")*targetHeight*.7;
			this.randomEaseTF.color = 0xffffff;
			this.randomEaseTF.hAlign = HAlign.LEFT;
			sliderContainer.addChild(this.randomEaseTF);
		}

		private function onRandomEaseChange(event:Event):void
		{
			this._multiTween.randomEase = this.randomEaseCheck.isSelected;
		}

		private function onOrderPickerChange(event:Event):void
		{
			this._multiTween.orderingFunc = CharOrder.getOrderByIndex(orderPicker.selectedIndex);
		}

		private function onPickerChange(event:Event):void
		{
			var picker:PickerList = PickerList(event.currentTarget);
			var prop:String = picker.name;

			this._multiTween[prop] = EaseManager.getEaseByIndex(picker.selectedIndex);
			trace(EaseManager.getEaseName(_multiTween[prop]));
		}


		public function set isSelected(value:Boolean):void
		{
			this.enableCheckbox.isSelected = value;
		}


		public function get isSelected():Boolean
		{
			return this.enableCheckbox.isSelected;
		}


		public function set multiTween(multiTween:MultiTween):void
		{
			this._multiTween = multiTween;

			this.orderPicker.selectedIndex = CharOrder.getIndexOf(_multiTween.orderingFunc);
			this.randomEaseCheck.isSelected = _multiTween.randomEase;

			for (var prop:String in this.sliderSettings)
			{
				Slider(this.sliders[prop]).value = _multiTween[prop];
			}

			for (var prop:String in this.easeSettings)
			{
				PickerList(this.pickers[prop]).selectedIndex = EaseManager.getIndexOf(_multiTween[prop]);
			}
		}


		private function toggleEditPanel(event:Event):void
		{
			if (!this.editButton.isSelected)
				dispatchEvent(event);

			this.editButton.isSelected = !this.editButton.isSelected;
			TweenMax.killTweensOf(this.editButton);
			TweenMax.to(this.sliderContainer,.2,{autoAlpha:Number(this.editButton.isSelected)});
		}


		public function closeEditPanel():void
		{
			this.editButton.isSelected = false;
			TweenMax.killTweensOf(this.editButton);
			TweenMax.to(this.sliderContainer,.2,{autoAlpha:0});
		}


		private function drawSlider(type:String):Sprite
		{
			var container:Sprite = new Sprite();

			var slider:Slider = new Slider();
			slider.width = this.targetWidth*.9;
			slider.height = this.targetHeight*.3;
			slider.y = this.targetHeight*.3;

			slider.validate();

			slider.minimum = sliderSettings[type].min;
			slider.maximum = sliderSettings[type].max;

			slider.name = type;
			slider.value = 0;
			slider.step = (slider.maximum - slider.minimum)/2000;
			container.addChild(slider);

			var valueTF:TextField = new TextField(150,this.targetHeight *.5,"","Verdana",this.targetHeight *.5,0xffffff);

			this.valueTFs[type] = valueTF;
			valueTF.autoScale = true;
			valueTF.hAlign = HAlign.LEFT;
			valueTF.touchable = false;
			valueTF.text = String(type + ": " + slider.value);

			container.addChild(valueTF);

			slider.addEventListener(Event.CHANGE, onSliderChange);

			this.sliders[type] = slider;

			return container;
		}


		private function onSliderChange(event:Event):void
		{
			var slider:Slider = Slider(event.currentTarget);
			var prop:String = slider.name;

			TextField(this.valueTFs[prop]).text = String(prop + ": " + slider.value.toFixed(3));
			this._multiTween[prop] = slider.value;
		}


		public function get multiTween():MultiTween
		{
			return _multiTween;
		}
	}
}
