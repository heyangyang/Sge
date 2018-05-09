package com.sunny.game.engine.manager
{
	import com.sunny.game.engine.resource.SBasicFileSystem;

	public class SFileSystemManager
	{
		private static var instance : SFileSystemManager;

		public static function getInstance() : SFileSystemManager
		{
			if (instance == null)
				instance = new SFileSystemManager();
			return instance;
		}

		public var particleFileSystem : SBasicFileSystem;
		public var movieFileSystem : SBasicFileSystem;
		public var soundFileSystem : SBasicFileSystem;
		public var iconFileSystem : SBasicFileSystem;
		public var imageFileSystem : SBasicFileSystem;
		public var faceFileSystem : SBasicFileSystem;
		public var sceneFileSystem : SBasicFileSystem;
		public var avatarFileSystem : SBasicFileSystem;
		public var effectFileSystem : SBasicFileSystem;
		public var uiFileSystem : SBasicFileSystem;
		public var guideFileSystem : SBasicFileSystem;

		public function SFileSystemManager()
		{
			particleFileSystem = new SBasicFileSystem();
			particleFileSystem.avaliableUrl = "particle/*.smv";
			movieFileSystem = new SBasicFileSystem();
			movieFileSystem.avaliableUrl = "movie/*.smv";
			soundFileSystem = new SBasicFileSystem();
			iconFileSystem = new SBasicFileSystem();
			imageFileSystem = new SBasicFileSystem();
			imageFileSystem.avaliableUrl = "image/*.sim";
			faceFileSystem = new SBasicFileSystem();
			faceFileSystem.avaliableUrl = "face/*.sfc";
			sceneFileSystem = new SBasicFileSystem();
			sceneFileSystem.avaliableUrl = "scene/*/*.smc";
			avatarFileSystem = new SBasicFileSystem();
			avatarFileSystem.avaliableUrl = "avatar/*/*.src";
			effectFileSystem = new SBasicFileSystem();
			effectFileSystem.avaliableUrl = "effect/*/*.sec";
			uiFileSystem = new SBasicFileSystem();
			guideFileSystem = new SBasicFileSystem();
		}

		public function init() : void
		{
			var resMgr : SResourceManager = SResourceManager.getInstance();
			movieFileSystem.init(resMgr.getResource("movie"));
			soundFileSystem.init(resMgr.getResource("sound"));
			particleFileSystem.init(resMgr.getResource("particle"));
			iconFileSystem.init(resMgr.getResource("icon"));
			imageFileSystem.init(resMgr.getResource("image"));
			faceFileSystem.init(resMgr.getResource("face"));
			sceneFileSystem.init(resMgr.getResource("scene"));
			avatarFileSystem.init(resMgr.getResource("avatar"));
			effectFileSystem.init(resMgr.getResource("effect"));
			uiFileSystem.init(resMgr.getResource("ui"));
			guideFileSystem.init(resMgr.getResource("guide"));
		}

		public function get movie_initialized() : Boolean
		{
			return movieFileSystem.initialized
		}

		public function get image_initialized() : Boolean
		{
			return imageFileSystem.initialized
		}
	}
}