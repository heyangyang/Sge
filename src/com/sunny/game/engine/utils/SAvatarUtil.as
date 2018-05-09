package com.sunny.game.engine.utils
{
	import com.sunny.game.engine.avatar.SAvatar;
	import com.sunny.game.engine.avatar.SAvatarAnimationLibrary;
	import com.sunny.game.engine.avatar.SAvatarDescription;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.enum.SDirection;
	import com.sunny.game.engine.manager.SReferenceManager;
	import com.sunny.game.engine.ns.sunny_engine;

	use namespace sunny_engine;

	/**
	 *
	 * <p>
	 * SunnyGame的纸娃娃工具
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
	public class SAvatarUtil
	{
		/**
		 * 创建Avatar
		 * @param avatarDesc
		 * @param singleParts 单独的部件
		 * @param composeParts 要合成在一起的部件
		 * @param mainPart 定义一个主部件
		 * @param priority 加载的优先级 0表示不使用
		 * @return
		 */
		public static function createAvatar(avatarDesc : SAvatarDescription, priority : int, parts : Array, partsProps : Object = null, needReversalPart : Boolean = false, isShowModelData : Boolean = true) : SAvatar
		{
			var singleParts : Array = [];
			parts = SAvatarUtil.sortParts(avatarDesc, parts);
			var part : String;
			//倒序检测部件是否为NULL，如果为NULL则删除掉
			for (var i : int = parts.length - 1; i >= 0; i--)
			{
				part = parts[i];
				singleParts.unshift(part);
			}

			if (singleParts.length == 0)
				SDebug.error("avatar:" + avatarDesc.name);


			var animationsByParts : Vector.<SAvatarAnimationLibrary> = new Vector.<SAvatarAnimationLibrary>();
			var animations : SAvatarAnimationLibrary;

			for each (part in singleParts)
			{
				//建立每个独立部件的动画数据
				animations = SReferenceManager.getInstance().createAvatarCollection(priority, part, avatarDesc, needReversalPart);
				animations.depth = parts.indexOf(part);
				animationsByParts.push(animations);
			}
			var avatar : SAvatar = new SAvatar(avatarDesc);
			avatar.dirMode = SDirection.checkDirsDirMode(avatarDesc.directions);
			avatar.animationsByParts = animationsByParts[0];
			avatar.parts = parts;
			avatar.isShowModel = isShowModelData;
			return avatar;
		}

		/**
		 * 根据avatar的部件合成顺序对part进行排序
		 */
		public static function sortParts(avatarDesc : SAvatarDescription, parts : Array) : Array
		{
			var orderedParts : Array = [];
			var partTypes : Array = [];

			if (parts.length == 0)
			{
				parts = avatarDesc.getPartNames();
			}

			var partType : uint;
			for each (var partName : String in parts)
			{
				partType = avatarDesc.getPartType(partName);
				if (partType)
				{
					partTypes.push(partType);
				}
				else
				{
					partTypes.length = 0;
					partTypes = partTypes.concat(avatarDesc.getAvaliableParts());
					if (SDebug.OPEN_WARNING_TRACE)
						SDebug.warningPrint(avatarDesc, "avatar:" + avatarDesc.name + "描述中不存在部件：%s，将取有效部件%s", partName, partTypes.join(","));
					return partTypes;
				}
			}

			var index : int;
			for each (partType in avatarDesc.partOrder)
			{
				index = partTypes.indexOf(partType);
				if (index != -1)
				{
					orderedParts.push(parts[index]);
				}
				else
				{
					if (SDebug.OPEN_WARNING_TRACE)
						SDebug.warningPrint(avatarDesc, "avatar:" + avatarDesc.name + "描述中没有注册部件排序：%s，该部件将无法显示！", partType);
				}
			}
			return orderedParts;
		}

		public static function getAnimationId(avatarId : String, part : uint, kind : uint, action : uint, actionKind : uint, direction : uint) : String
		{
			return "avatar." + avatarId + "." + part + "." + kind + "." + action + "." + actionKind + "." + direction;
		}

		public static function getAnimationFileName(part : uint, kind : uint, action : uint, actionKind : uint, direction : uint) : String
		{
			var kindName : String = "p" + part + "k" + kind;
			var actionName : String = "a" + action + "k" + actionKind;
			var directionName : String = "d" + direction;
			var name : String = kindName + actionName + directionName;
			return name;
		}
	}
}