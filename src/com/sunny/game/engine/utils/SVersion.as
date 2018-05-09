package com.sunny.game.engine.utils
{

	public class SVersion
	{
		public var major : uint;
		public var minor : uint;
		public var update : uint;
		public var build : uint;

		protected var _versionString : String;

		public function SVersion(versionString : String)
		{
			parseVersionString(versionString);
			_versionString = versionString;
		}

		protected function parseVersionString(value : String) : void
		{
			var pieces : Array = value.split(".");

			major = parseInt(pieces[0]);
			minor = parseInt(pieces[1]);
			update = parseInt(pieces[2]);
			build = parseInt(pieces[3]);
		}

		public function toString() : String
		{
			return _versionString;
		}
	}
}