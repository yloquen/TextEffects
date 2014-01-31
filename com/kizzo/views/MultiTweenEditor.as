package com.kizzo.views
{
	import com.greensock.TweenMax;
	import com.yloquen.MultiTween;

	import feathers.controls.Button;
	import feathers.controls.Slider;

	import flash.utils.Dictionary;
	import flash.utils.describeType;

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
		private var valueTFs:Dictionary;


		public function create(property:String, sliderSettings:Object)
		{
			this._multiTween = new MultiTween();
			this._multiTween.prop = property;

			this.valueTFs = new Dictionary();
			this.sliders = new Dictionary();
			this.sliderSettings = sliderSettings;

			this.sliderContainer = new Sprite();
			TweenMax.to(this.sliderContainer, 0, {autoAlpha:0});
			addChild(this.sliderContainer);

			this.editButton = new Button();
			this.editButton.width = 140;
			this.editButton.height = 50;
			this.editButton.label = "Edit " + property;
			this.editButton.addEventListener(Event.TRIGGERED, toggleEditPanel);
			addChild(this.editButton);

			var cnt:int = 0;
			for (var prop:String in this.sliderSettings)
			{
				var slider:Sprite = drawSlider(prop);
				slider.name = prop;
				this.sliderContainer.addChild(slider);
				slider.y = cnt*17;
				slider.x = 150;
				cnt++;

			}
		}


		public function set multiTween(multiTween:MultiTween):void
		{
			this._multiTween = multiTween;

			for (var prop:String in this.sliderSettings)
			{
				Slider(this.sliders[prop]).value = _multiTween[prop];
			}
		}


		private function toggleEditPanel(event:Event):void
		{
			dispatchEvent(event);
			this.editButton.isSelected = !this.editButton.isSelected;
			TweenMax.killTweensOf(this.editButton);
			TweenMax.to(this.sliderContainer,.5,{autoAlpha:Number(this.editButton.isSelected)});
		}


		public function closeEditPanel():void
		{
			this.editButton.isSelected = false;
			TweenMax.killTweensOf(this.editButton);
			TweenMax.to(this.sliderContainer,.5,{autoAlpha:0});
		}



		private function drawSlider(type:String):Sprite
		{
			var container:Sprite = new Sprite();

			var slider:Slider = new Slider();
			slider.width = 200;
			slider.height = 12;

			slider.minimum = sliderSettings[type].min;
			slider.maximum = sliderSettings[type].max;

			slider.name = type;
			slider.value = 0;
			slider.step = .01;
			container.addChild(slider);

			var valueTF:TextField = new TextField(150,18,"","Verdana",12,0xffffff);
			this.valueTFs[type] = valueTF;
			valueTF.autoScale = true;
			valueTF.y = -2;
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

			TextField(this.valueTFs[prop]).text = String(prop + ": " + slider.value);
			this._multiTween[prop] = slider.value;
		}



	}
}
