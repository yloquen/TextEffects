TextEffects
===========

Text effects for the Starling framework.


Features
=====================

	Animates bitmap texts in Starling.
	Based on TweenMax.

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


Parameter description
=====================

	prop - property to be tweened
	firstVal - the value of the property for the first letter (after letter ordering is applied)
	lastVal - the value of the property for the last letter (after letter ordering is applied)
	distribFunc - the distribution function for setting the start value of letters based on firstVal and lastVal
	tweenEase - the easing function of the tween
	randomEase - random ease for each letter

	pickupOrder - function which sets the order in which each letter is put in the animation queue
	masterDelay - delay before any animation starts
	delayDuration - duration of the delays for all letters (combined), which influences per letter delay (which also depends on order and number of letters)
	delayDistrib - distribution function of the individual delays over the whole delay range - e.g. if you have linear distribution and 5 letters, their delays will be spaced by .2 seconds
	firstDuration - duration for the tween of the first letter
	lastDuration - duration for the tween of the last letter
	durationDistrib - function which determines how the duration changes from the first to the last letter
		
	

Notes
=====================
Some color tweens show clipping because of the ease function which goes outside of the range [0,1] - to fix that change the tweenEase of color property to something different from Back or Elastic.

The sliders are not useful for editing colors - to do that export the JSON and edit the text in it.



