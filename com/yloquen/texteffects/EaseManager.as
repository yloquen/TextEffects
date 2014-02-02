package com.yloquen.texteffects
{
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Ease;
	import com.greensock.easing.EaseLookup;
	import com.greensock.easing.EaseLookup;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quart;
	import com.greensock.easing.Quint;
	import com.greensock.easing.Sine;
	import com.greensock.easing.Strong;

	import feathers.data.ListCollection;


	public class EaseManager
	{
		public static const easeNames:Vector.<String> = Vector.<String>([
			"Back.easeIn",
			"Back.easeInOut",
			"Back.easeOut",
			"Bounce.easeIn",
			"Bounce.easeInOut",
			"Bounce.easeOut",
			"Circ.easeIn",
			"Circ.easeInOut",
			"Circ.easeOut",
			"Cubic.easeIn",
			"Cubic.easeInOut",
			"Cubic.easeOut",
			"Elastic.easeIn",
			"Elastic.easeInOut",
			"Elastic.easeOut",
			"Expo.easeIn",
			"Expo.easeInOut",
			"Expo.easeOut",
			"Linear.easeIn",
			"Linear.easeInOut",
			"Linear.easeOut",
			"Linear.easeNone",
			"Quad.easeIn",
			"Quad.easeInOut",
			"Quad.easeOut",
			"Quart.easeIn",
			"Quart.easeInOut",
			"Quart.easeOut",
			"Quint.easeIn",
			"Quint.easeInOut",
			"Quint.easeOut",
			"Sine.easeIn",
			"Sine.easeInOut",
			"Sine.easeOut",
		]);

		private static var eases:Vector.<Ease>;
		private static var listCollection:ListCollection;

		init();

		private static function init():void
		{
			eases = new Vector.<Ease>();
			listCollection = new ListCollection();

			for (var i:int=0; i < easeNames.length; i++)
			{
				eases.push(EaseLookup.find(easeNames[i]));
				listCollection.push({text:easeNames[i]});
			}
		}


		public static function getListCollection():ListCollection
		{
			return listCollection;
		}


		public static function getRandom():Ease
		{
			return eases[int(Math.floor(Math.random()*eases.length))];
		}


		public static function getEaseName(ease:Ease):String
		{
			return easeNames[eases.indexOf(ease)];
		}


		public static function getEaseByName(name:String):Ease
		{
			return eases[easeNames.indexOf(name)];
		}


		public static function getIndexOf(ease:Ease):int
		{
			return eases.indexOf(ease);
		}

		public static function getEaseByIndex(index:int):Ease
		{
			return eases[index];
		}
	}
}
