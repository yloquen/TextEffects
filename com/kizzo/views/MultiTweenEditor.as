package com.kizzo.views
{
	import com.yloquen.MultiTween;

	import feathers.controls.Slider;
	import feathers.controls.TextInput;

	import flash.utils.Dictionary;
	import flash.utils.describeType;

	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;

	public class MultiTweenEditor extends Sprite
	{
		private static const SLIDER_PROPERTIES:Object =
		{
			delayDuration:{min:0, max:10},
			masterDelay:{min:0, max:10}
		}

		private var sliders:Dictionary;




		public function MultiTweenEditor()
		{
			this.sliders = new Dictionary();

			var description:XML = describeType(MultiTween);
			var variables:XMLList = description..variable;

			trace(description.toString());

			var cnt:int = 0;
			for each(var variable:XML in variables)
			{
				trace("VARIABLE: " + variable.@name);

				if (variable.@type == "Number")
				{
					var slider:Sprite = drawSlider(variable.@name);
					addChild(slider);
					slider.y = cnt*17;
					cnt++;
				}
			}
		}


		private function drawSlider(type:String):Sprite
		{
			var container:Sprite = new Sprite();

			var slider:Slider = new Slider();
			slider.width = 150;
			slider.height = 12;
			if(SLIDER_PROPERTIES[type])
			{
				slider.minimum = SLIDER_PROPERTIES[type].min;
				slider.maximum = SLIDER_PROPERTIES[type].max;
			}
			slider.value = 0;
			slider.liveDragging = true;
			slider.step = 1;
			slider.page = 10;
			container.addChild(slider);

			var valueTF:TextField = new TextField(150,18,"","Verdana",12,0xffffff);
			valueTF.autoScale = true;
			valueTF.y = -2;
			valueTF.hAlign = HAlign.LEFT;
			valueTF.touchable = false;
			valueTF.text = String(type + ": " + slider.value);
			container.addChild(valueTF);


			slider.addEventListener(Event.CHANGE,
				function ( event:Event ):void
				{
					var slider:Slider = Slider( event.currentTarget );
					valueTF.text = String(type + ": " + slider.value);
				});

			this.sliders[type] = slider;
			return container;
		}



		public function showMultiTween(multiTween:MultiTween):void
		{

		}
	}
}
