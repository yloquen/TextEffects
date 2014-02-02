package com.yloquen.texteffects
{
	import feathers.data.ListCollection;

	import flash.geom.Point;
	import flash.ui.Keyboard;

	import starling.display.DisplayObjectContainer;

	public class CharOrder
	{
		// !IMPORTANT Add new ones on the bottom, so as not to break existing presets
		private static var ORDER_FUNCS:Vector.<Function> = Vector.<Function>
		([
			LEFT_TO_RIGHT,
			RANDOM,
			RIGHT_TO_LEFT,
			MODULO_2,
			MODULO_3,
			SQR,
			SIN_1,
			SIN_2,
			RANDOM_WORD_ORDER
		]);


		private static var ORDER_FUNC_NAMES:Vector.<String> = Vector.<String>
		([
			"LEFT_TO_RIGHT",
			"RANDOM",
			"RIGHT_TO_LEFT",
			"MODULO_2",
			"MODULO_3",
			"SQR",
			"SIN_1",
			"SIN_2",
			"RANDOM_WORD_ORDER"
		]);

		private static var listCollection:ListCollection;

		init();

		private static function init():void
		{
			listCollection = new ListCollection();
			for (var i:int=0; i<ORDER_FUNC_NAMES.length; i++)
			{
				listCollection.push({text:ORDER_FUNC_NAMES[i]});
			}
		}


		public static function getOrder(num:int, func:Function, text:String, charContainer:DisplayObjectContainer):Vector.<int>
		{
			var points:Array = new Array();

			if (func == RANDOM_WORD_ORDER)
			{
				var randVal = Math.random()*100;

				for (var i:int=0; i< num; i++)
				{
					if (text.charCodeAt(i) == Keyboard.SPACE)
						randVal = Math.random()*100;

					points[i] = new Point(i, randVal);
				}
			}
			else
			{
				for (var i:int=0; i < num; i++)
				{
					points[i] = new Point(i, func(i, num-1, text, charContainer));
				}
			}

			points = points.sortOn("y", Array.NUMERIC);

			var order:Vector.<int> = new Vector.<int>(num);

			for (var i:int=0; i < points.length; i++)
			{
				order[i] = points[i].x;
			}

			return order;
		}


		public static function LEFT_TO_RIGHT(index:int, num:int, text:String, charContainer:DisplayObjectContainer):Number
		{
			return index;
		}


		public static function RANDOM(index:int, num:int, text:String, charContainer:DisplayObjectContainer):Number
		{
			return Math.random()*100;
		}


		public static function RIGHT_TO_LEFT(index:int, num:int, text:String, charContainer:DisplayObjectContainer):Number
		{
			return num - index - 1;
		}


		public static function MODULO_2(index:int, num:int, text:String, charContainer:DisplayObjectContainer):Number
		{
			return index/num + index%2;
		}


		public static function MODULO_3(index:int, num:int, text:String, charContainer:DisplayObjectContainer):Number
		{
			return index/num + index%3;
		}


		public static function SQR(index:int, num:int, text:String, charContainer:DisplayObjectContainer):Number
		{
			index -= 0.001;
			return index*index - num*index;
		}


		public static function SIN_1(index:int, num:int, text:String, charContainer:DisplayObjectContainer):Number
		{
			return Math.sin(index*5/num);
		}


		public static function SIN_2(index:int, num:int, text:String, charContainer:DisplayObjectContainer):Number
		{
			return Math.sin(index*10/num);
		}


		public static function RANDOM_WORD_ORDER(index:int, num:int, text:String, charContainer:DisplayObjectContainer):Number
		{
			return 0;
		}

		public static function DISTANCE_TO_CENTER(index:int, num:int, text:String, charContainer:DisplayObjectContainer):Number
		{
			return 0;
		}


		public static function getIndexOf(orderingFunc:Function):int
		{
			return ORDER_FUNCS.indexOf(orderingFunc);
		}


		public static function getListCollection():ListCollection
		{
			return listCollection;
		}


		public static function getOrderByIndex(index:int):Function
		{
			return ORDER_FUNCS[index];
		}


		public static function getOrderFuncName(orderFunc:Function):String
		{
			return ORDER_FUNC_NAMES[ORDER_FUNCS.indexOf(orderFunc)];
		}


		public static function getOrderFuncByName(name:String):Function
		{
			return ORDER_FUNCS[ORDER_FUNC_NAMES.indexOf(name)];
		}


		public static function getRandomOrderFunction():Function
		{
			return ORDER_FUNCS[int(Math.floor(Math.random()*ORDER_FUNCS.length))];
		}


	}
}
