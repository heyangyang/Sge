package com.sunny.game.engine.core
{
	import flash.utils.Dictionary;

	/**
	 *
	 * <p>
	 * SunnyGame的一个键盘
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
	public final class SKeyboard extends SObject
	{
		private var keys : Dictionary;

		public var downKeys : Vector.<uint>;

		/**
		 * @private
		 */
		protected var _lookup : Dictionary;
		protected var _reverseLookup : Dictionary;
		/**
		 * @private
		 */
		protected var _map : Vector.<Object>;
		/**
		 * @private
		 */
		protected const _t : uint = 256;

		/**
		 * Constructor
		 */
		public function SKeyboard()
		{
			super();
			keys = new Dictionary();
			downKeys = new Vector.<uint>();
			//BASIC STORAGE & TRACKING			
			var i : uint = 0;
			_lookup = new Dictionary();
			_reverseLookup = new Dictionary();
			_map = new Vector.<Object>(_t,true);

			//LETTERS
			for (i = 65; i <= 90; i++)
				addKey(String.fromCharCode(i), i); //A-Z

			//NUMBERS
			i = 48;
			addKey("ZERO", i++);
			addKey("ONE", i++);
			addKey("TWO", i++);
			addKey("THREE", i++);
			addKey("FOUR", i++);
			addKey("FIVE", i++);
			addKey("SIX", i++);
			addKey("SEVEN", i++);
			addKey("EIGHT", i++);
			addKey("NINE", i++);

			//FUNCTION KEYS
			for (i = 1; i <= 12; i++)
				addKey("F" + i, 111 + i); //F1-F12

			//SPECIAL KEYS + PUNCTUATION
			addKey("ESCAPE", 27);
			addKey("MINUS", 189);
			addKey("PLUS", 187);
			addKey("DELETE", 46);
			addKey("BACKSPACE", 8);
			addKey("LBRACKET", 219);
			addKey("RBRACKET", 221);
			addKey("BACKSLASH", 220);
			addKey("CAPSLOCK", 20);
			addKey("SEMICOLON", 186);
			addKey("QUOTE", 222);
			addKey("ENTER", 13);
			addKey("SHIFT", 16);
			addKey("COMMA", 188);
			addKey("PERIOD", 190);
			addKey("SLASH", 191);
			addKey("CONTROL", 17);
			addKey("ALT", 18);
			addKey("SPACE", 32);
			addKey("UP", 38);
			addKey("DOWN", 40);
			addKey("LEFT", 37);
			addKey("RIGHT", 39);
		}

		/**
		 * Updates the key states (for tracking just pressed, just released, etc).
		 */
		public function update() : void
		{
			var o : Object;
			for (var i : uint = 0; i < _t; i++)
			{
				o  = _map[i];
				if (o == null)
					continue;
				
				if ((o.last == -1) && (o.current == -1))
				{
					o.current = 0;
				}
				else if ((o.last == 2) && (o.current == 2))
				{
					o.current = 1;
				}
				o.last = o.current;
			}
		}

		/**
		 * Resets all the keys.
		 */
		public function reset() : void
		{
			var o : Object;
			for (var i : uint = 0; i < _t; i++)
			{
				if (_map[i] == null)
					continue;
				o = _map[i];
				keys[o.name] = false;
				o.current = 0;
				o.last = 0;
			}
			downKeys.length = 0;
		}

		/**
		 * 长按
		 * @param Key
		 * @return
		 *
		 */
		public function pressed(keyCode : uint) : Boolean
		{
			if (!keyCode)
				return false;
			var keyName : String = _reverseLookup[keyCode];
			return keys[keyName];
		}

		public function pressedByName(keyName : String) : Boolean
		{
			if (!keyName)
				return false;
			return keys[keyName];
		}

		/**
		 * 短按
		 * @param Key
		 * @return
		 *
		 */
		public function justPressed(keyCode : uint) : Boolean
		{
			if (!keyCode)
				return false;
			return _map[keyCode].current == 2;
		}

		/**
		 * Check to see if this key is just released.
		 *
		 * @param	Key		One of the key constants listed above (e.g. "LEFT" or "A").
		 *
		 * @return	Whether the key is just released.
		 */
		public function justReleased(keyCode : uint) : Boolean
		{
			if (!keyCode)
				return false;
			return _map[keyCode].current == -1;
		}

		public function justPressedByName(keyName : String) : Boolean
		{
			if (!keyName)
				return false;
			return _map[_lookup[keyName]].current == 2;
		}

		public function justReleasedByName(keyName : String) : Boolean
		{
			if (!keyName)
				return false;
			return _map[_lookup[keyName]].current == -1;
		}

		/**
		 * Event handler so FlxGame can toggle keys.
		 *
		 * @param	event	A <code>KeyboardEvent</code> object.
		 */
		public function handleKeyDown(keyCode : uint) : void
		{
			var o : Object = _map[keyCode];
			if (o == null)
				return;
			if (o.current > 0)
				o.current = 1;
			else
				o.current = 2;
			keys[o.name] = true;

			if (downKeys.indexOf(keyCode) == -1)
				downKeys.push(keyCode);
		}

		/**
		 * Event handler so FlxGame can toggle keys.
		 *
		 * @param	event	A <code>KeyboardEvent</code> object.
		 */
		public function handleKeyUp(keyCode : uint) : void
		{
			var o : Object = _map[keyCode];
			if (o == null)
				return;
			if (o.current > 0)
				o.current = -1;
			else
				o.current = 0;
			keys[o.name] = false;

			var index : int = downKeys.indexOf(keyCode);
			if (index > -1)
				downKeys.splice(index, 1);
		}

		/**
		 * An internal helper function used to build the key array.
		 *
		 * @param	KeyName		String name of the key (e.g. "LEFT" or "A")
		 * @param	KeyCode		The numeric Flash code for this key.
		 */
		public function addKey(keyName : String, keyCode : uint) : void
		{
			keys[keyName] = false;
			_lookup[keyName] = keyCode;
			_reverseLookup[keyCode] = keyName;
			_map[keyCode] = {name: keyName, current: 0, last: 0};
		}

		public function get hasKeyDown() : Boolean
		{
			return downKeys && downKeys.length > 0;
		}
	}
}
