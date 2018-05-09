package com.sunny.game.engine.events
{
	/**
	 *
	 * <p>
	 * SunnyGame的一个基本事件，包含常用事件类型(Event type)
	 * </p>
	 * <p><strong><font color="#0000ff">Copyright © 2012 Sunny3D. All rights reserved.</font></strong><br>
	 * <font color="#0000ff">www.sunny3d.com</font></p>
	 * @langversion 3.0
	 * @playerversion Flash 11.2
	 * @playerversion AIR 3.2
	 * @productversion Flex 4.5
	 * @see com.sunny.game.engine.gpu.display.Stage
	 * @author <strong><font color="#0000ff">刘黎明</font></strong><br>
	 * <font color="#0000ff">www.liuliming.org</font>
	 *
	 */
	public class SKeyboardEvent extends SEvent
	{
		/** Event type for a key that was released. */
		public static const KEY_UP : String = "keyUp";

		/** Event type for a key that was pressed. */
		public static const KEY_DOWN : String = "keyDown";

		private var _charCode : uint;
		private var _keyCode : uint;
		private var _keyLocation : uint;
		private var _altKey : Boolean;
		private var _ctrlKey : Boolean;
		private var _shiftKey : Boolean;

		public function SKeyboardEvent(type : String, charCode : uint = 0, keyCode : uint = 0, keyLocation : uint = 0, ctrlKey : Boolean = false, altKey : Boolean = false, shiftKey : Boolean = false)
		{
			super(type, keyCode);
			_charCode = charCode;
			_keyCode = keyCode;
			_keyLocation = keyLocation;
			_ctrlKey = ctrlKey;
			_altKey = altKey;
			_shiftKey = shiftKey;
		}

		// properties
		/** Contains the character code of the key. */
		public function get charCode() : uint
		{
			return _charCode;
		}

		/** The key code of the key. */
		public function get keyCode() : uint
		{
			return _keyCode;
		}

		/** Indicates the location of the key on the keyboard. This is useful for differentiating
		 *  keys that appear more than once on a keyboard. @see Keylocation */
		public function get keyLocation() : uint
		{
			return _keyLocation;
		}

		/** Indicates whether the Alt key is active on Windows or Linux;
		 *  indicates whether the Option key is active on Mac OS. */
		public function get altKey() : Boolean
		{
			return _altKey;
		}

		/** Indicates whether the Ctrl key is active on Windows or Linux;
		 *  indicates whether either the Ctrl or the Command key is active on Mac OS. */
		public function get ctrlKey() : Boolean
		{
			return _ctrlKey;
		}

		/** Indicates whether the Shift key modifier is active (true) or inactive (false). */
		public function get shiftKey() : Boolean
		{
			return _shiftKey;
		}
	}
}