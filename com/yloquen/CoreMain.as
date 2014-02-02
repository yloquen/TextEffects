package com.yloquen
{

    import com.greensock.TweenMax;
	import com.greensock.easing.EaseLookup;
	import com.yloquen.texteffects.CharOrder;
	import com.yloquen.texteffects.EaseManager;

	import com.yloquen.texteffects.MultiTween;
	import com.yloquen.tools.Presets;
	import com.yloquen.tools.RandomGenerator;

	import com.yloquen.texteffects.TextEffect;
	import com.yloquen.tools.MultiTweenEditor;

	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.NumericStepper;

	import feathers.controls.ProgressBar;
	import feathers.controls.TextInput;
	import feathers.themes.AeonDesktopTheme;

	import flash.geom.Point;

	import flash.utils.Dictionary;

	import starling.display.DisplayObject;

	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.utils.AssetManager;
	import starling.utils.HAlign;

	public class CoreMain extends Sprite
	{
		private var _loadingProgress:ProgressBar;
		private var _assetsManager:AssetManager;

		private static const propOrder:Array = ["x", "y", "scaleX", "scaleY", "rotation", "skewX", "skewY", "color", "alpha"];

		private static const SLIDER_PROPERTIES:Object =
		{
			x:          {firstVal:{min:-1000,max:1000}, lastVal:{min:-1000,max:1000}, masterDelay:{min:0, max:3}, delayDuration:{min:0, max:3}, firstDuration:{min:.2, max:4}, lastDuration:{min:.2, max:4}},
			y:          {firstVal:{min:-1000,max:1000}, lastVal:{min:-1000,max:1000}, masterDelay:{min:0, max:3}, delayDuration:{min:0, max:3}, firstDuration:{min:.2, max:4}, lastDuration:{min:.2, max:4}},
			scaleX:     {firstVal:{min:  -50,max:  50}, lastVal:{min:  -50,max:  50}, masterDelay:{min:0, max:3}, delayDuration:{min:0, max:3}, firstDuration:{min:.2, max:4}, lastDuration:{min:.2, max:4}},
			scaleY:     {firstVal:{min:  -50,max:  50}, lastVal:{min:  -50,max:  50}, masterDelay:{min:0, max:3}, delayDuration:{min:0, max:3}, firstDuration:{min:.2, max:4}, lastDuration:{min:.2, max:4}},
			rotation:   {firstVal:{min:  -30,max:  30}, lastVal:{min:  -30,max:  30}, masterDelay:{min:0, max:3}, delayDuration:{min:0, max:3}, firstDuration:{min:.2, max:4}, lastDuration:{min:.2, max:4}},
			skewX:      {firstVal:{min:  -30,max:  30}, lastVal:{min:  -30,max:  30}, masterDelay:{min:0, max:3}, delayDuration:{min:0, max:3}, firstDuration:{min:.2, max:4}, lastDuration:{min:.2, max:4}},
			skewY:      {firstVal:{min:  -30,max:  30}, lastVal:{min:  -30,max:  30}, masterDelay:{min:0, max:3}, delayDuration:{min:0, max:3}, firstDuration:{min:.2, max:4}, lastDuration:{min:.2, max:4}},
			color:      {firstVal:{min:    0,max:0xffffff}, lastVal:{min:    0,max:0xffffff}, masterDelay:{min:0, max:3}, delayDuration:{min:0, max:3}, firstDuration:{min:.2, max:4}, lastDuration:{min:.2, max:4}},
			alpha:      {firstVal:{min:   0,max:   1}, lastVal:{min:   0,max:   1}, masterDelay:{min:0, max:3}, delayDuration:{min:0, max:3}, firstDuration:{min:.2, max:4}, lastDuration:{min:.2, max:4}}
		}

		private var _currentOpenEditor:MultiTweenEditor;
		private var _editors:Dictionary;
		private var _reverseButton:Button;
		private var _bmpFont:BitmapFont;
		private var _textEffect:TextEffect;
		private var _charContainer:Sprite;
		private var _randomizeButton:Button;
		private var _presetSelector:NumericStepper;

		private var V_STEP:Number = 36;
		private var BUT_HEIGHT:Number = 35;
		private var BUT_WIDTH:Number = 160;
		private var _prevPresetBut:Button;
		private var _nextPresetBut:Button;
		private var _presetTF:TextField;
		private var _timeScaleMinus:Button;
		private var _timeScalePlus:Button;
		private var _timeScaleTF:TextField;
		private var _runButton:Button;
		private var _exportButton:Button;
		private var exportTF:TextInput;
		private var _pivotTF:TextField;
		private var _pivotXinput:TextInput;
		private var _pivotYinput:TextInput;
		private var _randomPivotCheck:Check;
		private var _randomPivotTF:TextField;


		public function loadAssets(assets:AssetManager):void
		{
			//new MetalWorksMobileTheme(null, false);
			//new MinimalMobileTheme(null, false);
			new AeonDesktopTheme();

			_loadingProgress = new ProgressBar();

			_loadingProgress.minimum = 0;
			_loadingProgress.maximum = 100;
			_loadingProgress.width = 200;
			_loadingProgress.height = 20;
			_loadingProgress.x = (stage.stageWidth - _loadingProgress.width) / 2;
			_loadingProgress.y = stage.stageHeight * 0.9;

			addChild(_loadingProgress);

			assets.loadQueue(function (ratio:Number):void
			{
				_loadingProgress.value = ratio*100;

				if (ratio == 1)
                TweenMax.delayedCall(.2,
					function ():void
						{
							_loadingProgress.removeFromParent(true);
							_loadingProgress = null;
							_assetsManager = assets;
							createMain();
						}
					);
			});
		}

		private function createMain():void
		{


			var cnt:Number = .5;
			this._editors = new Dictionary();
			//this._bmpFont = TextField.getBitmapFont("Bebas_0");
			this._bmpFont = TextField.getBitmapFont("Accidental_0");
			//this._bmpFont = TextField.getBitmapFont("Probert_0");
			//this._bmpFont = TextField.getBitmapFont("Melody_0");


			for (var prop:String in SLIDER_PROPERTIES)
			{
				var editor:MultiTweenEditor = new MultiTweenEditor();
				addChild(editor);
				editor.y = propOrder.indexOf(prop)*V_STEP;
				editor.create(prop, SLIDER_PROPERTIES[prop], BUT_WIDTH, BUT_HEIGHT);
				editor.addEventListener(Event.TRIGGERED, onOpenEditor);
				this._editors[prop] = editor;
				cnt++
			}

			this._pivotTF = new TextField(BUT_WIDTH *.9, 20, "PIVOT (X,Y)", "Verdana", BUT_HEIGHT *.3);
			this._pivotTF.x = BUT_WIDTH*.1;
			this._pivotTF.y = cnt*V_STEP;
			this._pivotTF.hAlign = HAlign.LEFT;
			addChild(_pivotTF);

			this._pivotXinput = new TextInput();
			this._pivotXinput.y = cnt*V_STEP + 20;
			this._pivotXinput.x = BUT_WIDTH*.1;
			this._pivotXinput.width = BUT_WIDTH*.4;
			this._pivotXinput.height = 20;
			this._pivotXinput.addEventListener(Event.CHANGE, onPivotChange);
			addChild(this._pivotXinput);

			this._pivotYinput = new TextInput();
			this._pivotYinput.y = cnt*V_STEP + 20;
			this._pivotYinput.x = BUT_WIDTH*.6;
			this._pivotYinput.width = BUT_WIDTH*.4;
			this._pivotYinput.height = 20;
			this._pivotYinput.addEventListener(Event.CHANGE, onPivotChange);
			addChild(this._pivotYinput);
			cnt++

			this._randomPivotCheck = new Check();
			this._randomPivotCheck.x = BUT_WIDTH*.1
			this._randomPivotCheck.width = this._randomPivotCheck.height = BUT_HEIGHT*.5;
			this._randomPivotCheck.y = cnt*V_STEP + (BUT_HEIGHT-this._randomPivotCheck.height)/2;
			this._randomPivotCheck.addEventListener(Event.CHANGE, onRandomPivotChange);
			addChild(this._randomPivotCheck);

			this._randomPivotTF = new TextField(BUT_WIDTH *.7, BUT_HEIGHT, "RANDOM PIVOTS", "Verdana", BUT_HEIGHT *.3);
			this._randomPivotTF.x = BUT_WIDTH*.3;
			this._randomPivotTF.y = cnt*V_STEP;
			addChild(this._randomPivotTF);
			cnt++

			this._timeScaleMinus = new Button();
			this._timeScaleMinus.x = BUT_WIDTH*.1;
			this._timeScaleMinus.width = this._timeScaleMinus.height = BUT_HEIGHT;
			this._timeScaleMinus.label = "-";
			this._timeScaleMinus.addEventListener(Event.TRIGGERED, changeTimescale);
			addChild(this._timeScaleMinus);
			this._timeScaleMinus.y = cnt*V_STEP;

			this._timeScalePlus = new Button();
			this._timeScalePlus.width = this._timeScalePlus.height = BUT_HEIGHT;
			this._timeScalePlus.x = BUT_WIDTH-BUT_HEIGHT;
			this._timeScalePlus.label = "+";
			this._timeScalePlus.addEventListener(Event.TRIGGERED, changeTimescale);
			addChild(this._timeScalePlus);
			this._timeScalePlus.y = cnt*V_STEP;

			this._timeScaleTF = new TextField(BUT_WIDTH *.9-2*BUT_HEIGHT, BUT_HEIGHT, "TIMESCALE", "Verdana", BUT_HEIGHT *.3);
			this._timeScaleTF.x = BUT_WIDTH*.1 + BUT_HEIGHT;
			this._timeScaleTF.y = cnt*V_STEP;
			addChild(this._timeScaleTF);
			cnt++;
			cnt++;


			this._runButton = new Button();
			this._runButton.width = BUT_WIDTH*.9;
			this._runButton.x = BUT_WIDTH*.1;
			this._runButton.height = BUT_HEIGHT;
			this._runButton.label = "RUN";
			this._runButton.addEventListener(Event.TRIGGERED, run);
			addChild(this._runButton);
			this._runButton.y = cnt*V_STEP;
			cnt++;


			this._reverseButton = new Button();
			this._reverseButton.width = BUT_WIDTH*.9;
			this._reverseButton.x = BUT_WIDTH*.1;
			this._reverseButton.height = BUT_HEIGHT;
			this._reverseButton.label = "REVERSE";
			this._reverseButton.addEventListener(Event.TRIGGERED, reverse);
			addChild(this._reverseButton);
			this._reverseButton.y = cnt*V_STEP;
			cnt++;


			this._randomizeButton = new Button();
			this._randomizeButton.width = BUT_WIDTH*.9;
			this._randomizeButton.x = BUT_WIDTH*.1;
			this._randomizeButton.height = BUT_HEIGHT;
			this._randomizeButton.label = "RANDOM";
			this._randomizeButton.addEventListener(Event.TRIGGERED, randomize);
			addChild(this._randomizeButton);
			this._randomizeButton.y = cnt*V_STEP;
			cnt++;

			this._prevPresetBut = new Button();
			this._prevPresetBut.x = BUT_WIDTH*.1;
			this._prevPresetBut.width = this._prevPresetBut.height = BUT_HEIGHT;
			this._prevPresetBut.label = "<";
			this._prevPresetBut.addEventListener(Event.TRIGGERED, changePreset);
			addChild(this._prevPresetBut);
			this._prevPresetBut.y = cnt*V_STEP;

			this._nextPresetBut = new Button();
			this._nextPresetBut.width = this._nextPresetBut.height = BUT_HEIGHT;
			this._nextPresetBut.x = BUT_WIDTH-BUT_HEIGHT;
			this._nextPresetBut.label = ">";
			this._nextPresetBut.addEventListener(Event.TRIGGERED, changePreset);
			addChild(this._nextPresetBut);
			this._nextPresetBut.y = cnt*V_STEP;

			this._presetTF = new TextField(BUT_WIDTH *.9-2*BUT_HEIGHT, BUT_HEIGHT, "PRESET "+ Presets.currentId(), "Verdana", BUT_HEIGHT *.3);
			this._presetTF.x = BUT_WIDTH*.1 + BUT_HEIGHT;
			this._presetTF.y = cnt*V_STEP;
			addChild(this._presetTF);
			cnt++;



			this.exportTF = new TextInput();
			this.exportTF.width = 1024 - .2*BUT_WIDTH;
			this.exportTF.height = 20;
			addChild(this.exportTF);
			this.exportTF.x = .1*BUT_WIDTH
			this.exportTF.y = 768 - 20 - .1*BUT_WIDTH;

			this._exportButton = new Button();
			this._exportButton.width = BUT_WIDTH*.9;
			this._exportButton.x = BUT_WIDTH*.1;
			this._exportButton.height = BUT_HEIGHT;
			this._exportButton.label = "EXPORT JSON";
			this._exportButton.addEventListener(Event.TRIGGERED, export);
			addChild(this._exportButton);
			this._exportButton.y = exportTF.y - BUT_HEIGHT*1.1;

			this._textEffect = new TextEffect();
			_textEffect.fromJSON(Presets.current());
			putEffectInEditor();
		}

		private function onRandomPivotChange(event:Event):void
		{
			this._textEffect.randomPivotPerChar = this._randomPivotCheck.isSelected;
		}

		private function onPivotChange(event:Event):void
		{
			this._textEffect.pivot.x = Number(this._pivotXinput.text);
			this._textEffect.pivot.y = Number(this._pivotYinput.text);
		}

		private function changeTimescale(event:Event):void
		{
			if (event.currentTarget == _timeScalePlus)
			{
				this._textEffect.scaleTimes(10/9);
			}
			else if (event.currentTarget == _timeScaleMinus)
			{
				this._textEffect.scaleTimes(.9);
			}

		}

		private function changePreset(event:Event):void
		{
			event.currentTarget == _prevPresetBut ? _textEffect.fromJSON(Presets.previous()) : _textEffect.fromJSON(Presets.next());
			this._presetTF.text = "PRESET "+ Presets.currentId();
			putEffectInEditor();
			run();
		}


		private function reverse():void
		{
			this._textEffect.timeline.reverse();
		}

		private function run():void
		{
			if(this._currentOpenEditor)
				this._currentOpenEditor.closeEditPanel();

			this._textEffect.clearTweens();

			for (var prop:String in SLIDER_PROPERTIES)
			{
				if (MultiTweenEditor(this._editors[prop]).isSelected)
				{
					this._textEffect.addTween(MultiTweenEditor(this._editors[prop]).multiTween);
				}
			}

			var lorem:String = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.";// Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

			if (this._charContainer)
				this._charContainer.removeFromParent(true);

			this._charContainer = _bmpFont.createSprite(400, 400, lorem, 30);
			this._charContainer.touchable = false;
			addChild(_charContainer);

			_charContainer.x = 400;
			_charContainer.y = 100;

			this._textEffect.generateTimeline(_charContainer, lorem);
			this._textEffect.timeline.play();
		}


		private function randomize():void
		{
			this._textEffect = RandomGenerator.generateRandom();
			putEffectInEditor();
			run();
		}


		private function putEffectInEditor():void
		{
			if (!_textEffect.randomPivotPerChar)
			{
				this._randomPivotCheck.isSelected = false;
			}
			else
			{
				this._randomPivotCheck.isSelected = true;
			}

			var p:Point = _textEffect.pivot.clone();
			this._pivotXinput.text = String(p.x);
			this._pivotYinput.text = String(p.y);


			for (var prop:String in SLIDER_PROPERTIES)
			{
				MultiTweenEditor(this._editors[prop]).isSelected = false;
			}

			for each (var multiTween:MultiTween in _textEffect.multiTweens)
			{
				MultiTweenEditor(this._editors[multiTween.prop]).multiTween = multiTween;
				MultiTweenEditor(this._editors[multiTween.prop]).isSelected = true;
			}
		}


		private function onOpenEditor(event:Event):void
		{
			var editor:MultiTweenEditor = (event.currentTarget as MultiTweenEditor);

			if (this._currentOpenEditor != editor)
			{
				if(this._currentOpenEditor)
					this._currentOpenEditor.closeEditPanel();

				this._currentOpenEditor = editor;
			}

		}


		private function export(e:Event):void
		{
			this.exportTF.text = JSON.stringify(this._textEffect);
		}

    }
}