package com.sunny.game.engine.component.sync
{
	import com.sunny.game.engine.lang.memory.SIRecyclable;

	/**
	 *
	 * <p>
	 * SunnyGame的同步路径数据
	 * </p>
	 * <p><strong><font color="#0000ff">Copyright © 2012 Sunny3D. All rights reserved.</font></strong><br>
	 * <font color="#0000ff">www.sunny3d.com</font></p>
	 * @langversion 3.0
	 * @playerversion Flash 11.2
	 * @playerversion AIR 3.2
	 * @productversion Flex 4.5
	 * @author <strong><font color="#0000ff">刘黎明</font></strong><br>
	 * <font color="#0000ff">www.liuliming.org</font>
	 *
	 */
	public class SSyncMovement implements SIRecyclable
	{
//		public var realServerTime : Number;
//		public var dir : int;
////		public var gridX : int;
////		public var gridY : int;
//		public var x : Number;
//		public var y : Number;
//		public var speed : Number;
//
//
//		public var isStand : Boolean;
//
//		public var isDirAvailable : Boolean;
//		public var isPosAvailable : Boolean;
//		public var isSpeedAvailable : Boolean;
//
//		public var paths : Array = [];
//		public var serverTime : Number;
//		public var stepTime : int = -1;

		public var delay : int;
		public var endGridX : int;
		public var endGridY : int;

		public function SSyncMovement()
		{
		}

//		public function setDir(dir : int) : void
//		{
//			this.dir = dir;
//			isDirAvailable = true;
//		}
//
//		public function setPos(x : Number, y : Number) : void
//		{
//			this.x = x;
//			this.y = y;
//			isPosAvailable = true;
//		}
//
//		public function setSpeed(speed : Number) : void
//		{
//			this.speed = speed;
//			isSpeedAvailable = true;
//		}
//
//		public function setIsStand(stand : Boolean) : void
//		{
//			isStand = stand;
//		}

//		public function setTime(time : Number) : void
//		{
//			this.serverTime = time;
//		}

		public function free() : void
		{
//			isDirAvailable = false;
//			isPosAvailable = false;
//			isSpeedAvailable = false;
//			isStand = false;
//			realServerTime = 0;
//			x = 0;
//			y = 0;
//			speed = 0;
//			paths = new Array();
//			stepTime = -1;
//			serverTime = 0;
			delay = 0;
			endGridX = 0;
			endGridY = 0;
		}

		public function toString() : String
		{
			var attr : Array = [];
//			attr.push(SPrintf.printf('[server time : %s]', serverTime));
//
//			if (isDirAvailable)
//			{
//				attr.push(SPrintf.printf('[dir : %s]', SDirection.STR_DIR[dir]));
//			}
//
//			if (isPosAvailable)
//			{
//				attr.push(SPrintf.printf('[x : %s, y : %s]', x, y));
//			}
//			attr.push(SPrintf.printf('[isStand: %s]', isStand));
//			attr = attr.concat(paths);
			return attr.join('');
		}
	}
}