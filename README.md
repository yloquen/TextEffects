TextEffects
===========

Text effects for the Starling framework.


Features
=====================

	Animates bitmap texts in Starling.

	Uses the TweenMax library:
	http://www.greensock.com/tweenmax/

	GUI editor for the animations at:
	http://yloquen.eu5.org/TextEffects/


Example code
=====================

	// You can generate this with the GUI editor
	var effect:Object = {"randomPivotPerChar":false,"pivot":{"y":"0.500","x":"0.500"},"multiTweens":[{"prop":"scale","durationDistrib":"Linear.easeInOut","distribFunc":"Cubic.easeOut","tweenEase":"Bounce.easeOut","randomEase":false,"firstVal":"-26.000","orderingFunc":"RANDOM","lastVal":"25.950","masterDelay":"0.000","firstDuration":"0.728","delayDuration":"0.547","lastDuration":"0.226","delayDistrib":"Cubic.easeIn"}]};
	
	var textEffect:TextEffect = new TextEffect();
	textEffect.fromJSON(effect);
	var animatedText:String = "Text to animate";
	var bmpFont:BitmapFont = TextField.getBitmapFont("Your bitmap font");
	var charContainer:Sprite = bmpFont.createSprite(400, 400, animatedText, 30);
	addChild(charContainer);
	textEffect.generateTimeline(charContainer, animatedText);
	textEffect.timeline.play();




Notes
=====================
Some color tweens show clipping because of the ease function which goes outside of the range [0,1] - to fix that change the tweenEase of color property to something different from Back or Elastic.

The sliders are not useful for editing colors - to do that export the JSON and edit the text in it.



