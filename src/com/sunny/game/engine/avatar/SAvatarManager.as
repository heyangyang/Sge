package com.sunny.game.engine.avatar
{
	import com.sunny.game.engine.debug.SDebug;

	import flash.utils.Dictionary;

	/**
	 *
	 * <p>
	 * SunnyGame的纸娃娃管理器
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
	public class SAvatarManager
	{
		private var _avatarDescByAvatarId : Dictionary = new Dictionary();

		private static var _instance : SAvatarManager;
		private var _parser : SAvatarParser = new SAvatarParser();

		public static function getInstance() : SAvatarManager
		{
			if (!_instance)
			{
				_instance = new SAvatarManager();
			}
			return _instance;
		}

		public function addAvatarDescription(id : String, xml : XML, version : String = "0", isReplace : Boolean = false) : SAvatarDescription
		{
			if (_avatarDescByAvatarId[id] == null || isReplace)
			{
				var avatarDesc : SAvatarDescription = _parser.parseAvatarDescription(xml, version);
				if (avatarDesc)
					_avatarDescByAvatarId[id] = avatarDesc;
				if (SDebug.OPEN_INFO_TRACE)
					SDebug.infoPrint(this, "添加纸娃娃配置：" + id);
				return avatarDesc;
			}
			return getAvatarDescription(id);
		}

		public function getAvatarDescription(id : String) : SAvatarDescription
		{
			return _avatarDescByAvatarId[id];
		}

		public function removeAvatarDescription(id : String) : void
		{
			if (_avatarDescByAvatarId[id])
			{
				_avatarDescByAvatarId[id] = null;
				delete _avatarDescByAvatarId[id];
			}
		}
	}
}