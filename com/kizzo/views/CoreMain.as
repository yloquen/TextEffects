package com.kizzo.views
{

    import com.greensock.TweenMax;

	import com.yloquen.MultiTween;
	import com.yloquen.Presets;

	import com.yloquen.TextEffect;

	import feathers.controls.Button;
	import feathers.controls.NumericStepper;

	import feathers.controls.ProgressBar;
	import feathers.themes.MetalWorksMobileTheme;


	import flash.utils.Dictionary;

	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.utils.AssetManager;

	public class CoreMain extends Sprite
	{
		private var mLoadingProgress:ProgressBar;
		private var assetsManager:AssetManager;

		var properties:Object =
		{
			x:          {firstVal:{min:-1000,max:1000}, lastVal:{min:-1000,max:1000}, masterDelay:{min:0, max:3}, delayDuration:{min:0, max:3}, firstDuration:{min:.2, max:4}, lastDuration:{min:.2, max:4}},
			y:          {firstVal:{min:-1000,max:1000}, lastVal:{min:-1000,max:1000}, masterDelay:{min:0, max:3}, delayDuration:{min:0, max:3}, firstDuration:{min:.2, max:4}, lastDuration:{min:.2, max:4}},
			scaleX:     {firstVal:{min:-1000,max:1000}, lastVal:{min:-1000,max:1000}, masterDelay:{min:0, max:3}, delayDuration:{min:0, max:3}, firstDuration:{min:.2, max:4}, lastDuration:{min:.2, max:4}},
			scaleY:     {firstVal:{min:-1000,max:1000}, lastVal:{min:-1000,max:1000}, masterDelay:{min:0, max:3}, delayDuration:{min:0, max:3}, firstDuration:{min:.2, max:4}, lastDuration:{min:.2, max:4}},
			rotation:   {firstVal:{min:-1000,max:1000}, lastVal:{min:-1000,max:1000}, masterDelay:{min:0, max:3}, delayDuration:{min:0, max:3}, firstDuration:{min:.2, max:4}, lastDuration:{min:.2, max:4}},
			skewX:      {firstVal:{min:-1000,max:1000}, lastVal:{min:-1000,max:1000}, masterDelay:{min:0, max:3}, delayDuration:{min:0, max:3}, firstDuration:{min:.2, max:4}, lastDuration:{min:.2, max:4}},
			skewY:      {firstVal:{min:-1000,max:1000}, lastVal:{min:-1000,max:1000}, masterDelay:{min:0, max:3}, delayDuration:{min:0, max:3}, firstDuration:{min:.2, max:4}, lastDuration:{min:.2, max:4}},
			color:      {firstVal:{min:-1000,max:1000}, lastVal:{min:-1000,max:1000}, masterDelay:{min:0, max:3}, delayDuration:{min:0, max:3}, firstDuration:{min:.2, max:4}, lastDuration:{min:.2, max:4}},
			alpha:      {firstVal:{min:-1000,max:1000}, lastVal:{min:-1000,max:1000}, masterDelay:{min:0, max:3}, delayDuration:{min:0, max:3}, firstDuration:{min:.2, max:4}, lastDuration:{min:.2, max:4}}
		}
		private var currentOpenEditor:MultiTweenEditor;
		private var editors:Dictionary;
		private var runButton:Button;
		private var bmpFont:BitmapFont;
		private var textEffect:TextEffect;
		private var charContainer:Sprite;
		private var randomizeButton:Button;
		private var presetSelector:NumericStepper;


		public function loadAssets(assets:AssetManager):void
		{
			new MetalWorksMobileTheme();

			mLoadingProgress = new ProgressBar();

			mLoadingProgress.minimum = 0;
			mLoadingProgress.maximum = 100;
			mLoadingProgress.width = 200;
			mLoadingProgress.height = 20;
			mLoadingProgress.x = (stage.stageWidth - mLoadingProgress.width) / 2;
			mLoadingProgress.y = stage.stageHeight * 0.9;

			addChild(mLoadingProgress);

			assets.loadQueue(function (ratio:Number):void
			{
				mLoadingProgress.value = ratio*100;

				if (ratio == 1)
                TweenMax.delayedCall(1,
					function ():void
						{
							mLoadingProgress.removeFromParent(true);
							mLoadingProgress = null;
							assetsManager = assets;
							createMain();
						}
					);
			});
		}

		private function createMain():void
		{
			var cnt:int = 0;
			this.editors = new Dictionary();
			this.bmpFont = TextField.getBitmapFont("Seymour");


			for (var prop:String in properties)
			{
				var editor:MultiTweenEditor = new MultiTweenEditor();
				addChild(editor);
				editor.y = cnt*50;
				editor.create(prop, properties[prop]);
				editor.addEventListener(Event.TRIGGERED, onOpenEditor);
				this.editors[prop] = editor;
				cnt++
			}

			cnt++;
			this.runButton = new Button();
			this.runButton.width = 140;
			this.runButton.height = 50;
			this.runButton.label = "RUN";
			this.runButton.addEventListener(Event.TRIGGERED, run);
			addChild(this.runButton);
			this.runButton.y = cnt*50;
			cnt++;

			this.randomizeButton = new Button();
			this.randomizeButton.width = 140;
			this.randomizeButton.height = 50;
			this.randomizeButton.label = "RANDOM";
			this.randomizeButton.addEventListener(Event.TRIGGERED, randomize);
			addChild(this.randomizeButton);
			this.randomizeButton.y = cnt*50;
			cnt++;

			this.presetSelector = new NumericStepper();
			this.presetSelector.width = 140;
			this.presetSelector.height = 50;
			this.presetSelector.minimum = 1;
			this.presetSelector.maximum = Presets.number();
			this.presetSelector.value = 1;
			this.presetSelector.step = 1;
			this.presetSelector.addEventListener(Event.CHANGE, changePreset);
			addChild(this.presetSelector);
			this.presetSelector.y = cnt*50;
			cnt++;

			//this.textEffect = TextEffect.generateRandom();
			this.textEffect = new TextEffect();
			textEffect.fromJSON(Presets.current());
			putEffectInEditor();
		}


		private function run():void
		{
			var lorem:String = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

			if (this.charContainer)
				this.charContainer.removeFromParent(true);

			this.charContainer = bmpFont.createSprite(400, 400, lorem, 20);
			addChild(charContainer);

			charContainer.x = 400;
			charContainer.y = 100;
			this.textEffect.apply(charContainer);
		}


		private function changePreset():void
		{

			//this.presetSelector.value++;
			textEffect.fromJSON(Presets.getPreset(this.presetSelector.value));
			run();
		}


		private function randomize():void
		{
			this.textEffect = TextEffect.generateRandom();
			putEffectInEditor();
			run();
		}


		private function putEffectInEditor():void
		{
			for each (var multiTween:MultiTween in textEffect.multiTweens)
			{
				MultiTweenEditor(this.editors[multiTween.prop]).multiTween = multiTween;
			}
		}


		private function onOpenEditor(event:Event):void
		{
			var editor:MultiTweenEditor = (event.currentTarget as MultiTweenEditor);
			if (this.currentOpenEditor && this.currentOpenEditor != editor)
			{
				this.currentOpenEditor.closeEditPanel();
				this.currentOpenEditor = editor;
			}

		}

    }
}