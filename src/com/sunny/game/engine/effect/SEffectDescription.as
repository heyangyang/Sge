package com.sunny.game.engine.effect
{
	import com.sunny.game.engine.animation.SAnimationCollectionDescription;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.enum.SDirection;

	import flash.utils.Dictionary;

	/**
	 *
	 * <p>
	 * SunnyGame的特效描述
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
	public class SEffectDescription extends SAnimationCollectionDescription
	{
		public var version : String;
		/**
		 * 动画所有方向
		 */
		public var animationDirections : Array;
		public var width : int;
		public var height : int;
		public var leftBorder : int;
		public var topBorder : int;
		public var rightBorder : int;
		public var bottomBorder : int;

		public function SEffectDescription()
		{
			super();
			animationDirections = [];
		}

		public function setDirections(dirs : String) : void
		{
			if (version == "2")
			{
				if (!dirs)
					directions = [SDirection.EAST, SDirection.NORTH, SDirection.SOUTH, SDirection.WEST, SDirection.EAST_NORTH, SDirection.WEST_NORTH, SDirection.EAST_SOUTH, SDirection.WEST_SOUTH];
				else
				{
					directions = dirs.split(",");
					for (var i : int = directions.length - 1; i >= 0; i--)
					{
						directions[i] = int(directions[i]);
					}
				}
			}
			for each (var dir : int in directions)
			{
				if (version == "2")
					addAnimationIdByDir(dir, getAnimationId(id, dir));
				else
					addAnimationIdByDir(dir, id);
			}
		}

		public static function getAnimationId(effectId : String, direction : uint) : String
		{
			return "effect." + effectId + "." + direction;
		}

		public static function getAnimationFileName(direction : uint) : String
		{
			var directionName : String = "d" + direction;
			var name : String = directionName;
			return name;
		}

		private static var _parser : SEffectParser = new SEffectParser();
		private static var _effectDescByEffectId : Dictionary = new Dictionary();

		public static function addEffectDescription(id : String, xml : XML, version : String = "0", isReplace : Boolean = false) : SEffectDescription
		{
			if (_effectDescByEffectId[id] == null || isReplace)
			{
				var effectDesc : SEffectDescription = _parser.parseEffectDescription(xml, version);
				if (effectDesc)
				{
					_effectDescByEffectId[id] = effectDesc;
				}
				if (SDebug.OPEN_INFO_TRACE)
					SDebug.infoPrint(xml, "添加特效配置：" + id);
				return effectDesc;
			}
			return getEffectDescription(id);
		}

		public static function getEffectDescription(id : String) : SEffectDescription
		{
			return _effectDescByEffectId[id];
		}

		public static function removeEffectDescription(id : String) : void
		{
			if (_effectDescByEffectId[id])
			{
				_effectDescByEffectId[id] = null;
				delete _effectDescByEffectId[id];
			}
		}
	}
}