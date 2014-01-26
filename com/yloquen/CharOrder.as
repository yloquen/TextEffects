package com.yloquen
{
	import flash.geom.Point;

	public class CharOrder
	{
		private static var orderingFunctions:Vector.<Function> = Vector.<Function>([
			LEFT_TO_RIGHT,
			RANDOM,
			RIGHT_TO_LEFT,
			MODULO_2,
			MODULO_3,
			SQR
		]);


		public static function getRandomOrderFunction():Function
		{
			return orderingFunctions[int(Math.floor(Math.random()*orderingFunctions.length))];
		}


		public static function getOrder(num:int, func:Function):Vector.<int>
		{
			var points:Array = new Array();

			for (var i:int=0; i < num; i++)
			{
				points[i] = new Point(i, func(i, num-1));
			}

			points = points.sortOn("y", Array.NUMERIC);

			var order:Vector.<int> = new Vector.<int>(num);

			for (var i:int=0; i < points.length; i++)
			{
				order[i] = points[i].x;
			}
			trace("------------------------------")
			trace(order);
			trace(orderingFunctions.indexOf(func))
			return order;
		}

		public static function LEFT_TO_RIGHT(index:int, num:int):Number
		{
			return index;
		}

		public static function RANDOM(index:int, num:int):Number
		{
			return Math.random()*100;
		}

		public static function RIGHT_TO_LEFT(index:int, num:int):Number
		{
			return num - index - 1;
		}

		public static function MODULO_2(index:int, num:int):Number
		{
			return index/num + index%2;
		}


		public static function MODULO_3(index:int, num:int):Number
		{
			return index/num + index%3;
		}


		public static function SQR(index:int, num:int):Number
		{
			index -= 0.001;
			return index*index - num*index;
		}



	}
}
