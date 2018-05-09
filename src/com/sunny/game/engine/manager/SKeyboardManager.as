package com.sunny.game.engine.manager
{
	import com.sunny.game.engine.core.SKeyboard;
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.core.SUpdatable;
	import com.sunny.game.engine.events.SEvent;
	import com.sunny.game.engine.events.SEventPool;
	import com.sunny.game.engine.events.SKeyboardEvent;
	import com.sunny.game.engine.events.SMouseEvent;
	import com.sunny.game.engine.lang.errors.SunnyGameEngineError;
	
	import flash.events.KeyboardEvent;
	import flash.system.Capabilities;
	import flash.system.IME;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	/**
	 *
	 * <p>
	 * 一个键盘管理器
	 * 使用的时候： Keyboards.getInstance.keys.pressed("A")
	 *             Keyboards.getInstance.keys.justPressed("A")
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
	public class SKeyboardManager extends SUpdatable
	{
		static public var moveUpKeyName : String = "W";
		static public var moveDownKeyName : String = "S";
		static public var moveLeftKeyName : String = "A";
		static public var moveRightKeyName : String = "D";
		static public var jumpKeyName : String = "K";

		public var commonAttackKeyName : String = "J";
		public var releaseSpellKeyName1 : String = "U";
		public var releaseSpellKeyName2 : String = "I";
		public var releaseSpellKeyName3 : String = "O";
		public var releaseSpellKeyName4 : String = "L";
		public var releaseSpellKeyName5 : String = "H";

		public var pickupKeyName : String = "SPACE";

		private var _keyboard : SKeyboard;

		private var _isListening : Boolean;
		private var _keyDownHandlers : Dictionary;
		private var _keyUpHandlers : Dictionary;

		private static var _instance : SKeyboardManager;
		private var keyUpKeys : Array = [];
		private var keyDownKeys : Array = [];
		private var isChange : Boolean = false;

		public function SKeyboardManager()
		{
			super();
			_keyboard = new SKeyboard();
			_isListening = false;
			_keyDownHandlers = new Dictionary();
			_keyUpHandlers = new Dictionary();

			SShellVariables.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
			SShellVariables.nativeStage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 0, true);
			SEventPool.addEventListener(SEvent.DEACTIVATE, onDeActive);
			SEventPool.addEventListener(SMouseEvent.RIGHT_CLICK, onRightClick);
		}

		public static function getInstance() : SKeyboardManager
		{
			if (!_instance)
			{
				_instance = new SKeyboardManager();
			}
			return _instance;
		}

		public function startListener() : void
		{
			reset();
			_isListening = true;
		}

		public function stopListener() : void
		{
			reset();
			_isListening = false;
		}

		private function onRightClick(e : SMouseEvent) : void
		{
			reset();
		}

		private function onDeActive(e : SEvent) : void
		{
			if (Capabilities.hasIME)
				IME.enabled = false;
			reset();
		}

		public function reset() : void
		{
			_keyboard.reset();
		}

		override public function update() : void
		{
			super.update();
			if (!_isListening || !isChange)
				return;
			if (!SShellVariables.stageIsActive)
			{
				reset();
				return;
			}
			_keyboard.update();

			if (_keyboard.hasKeyDown)
			{
				var downKeys : Vector.<uint> = _keyboard.downKeys;
				var downKeysLen : uint = downKeys.length;
				keyUpKeys.length = 0;
				keyDownKeys.length = 0;

				for (var i : int = 0; i < downKeysLen; i++)
				{
					var keyCode : uint = downKeys[i];
					if (_keyboard.justReleased(keyCode))
						keyUpKeys.push(keyCode);
					if (i == downKeysLen - 1) //最后一个按下的按键短按
					{
						if (_keyboard.justPressed(keyCode))
							keyDownKeys.push(keyCode);
					}
					else
					{
						if (_keyboard.pressed(keyCode))
							keyDownKeys.push(keyCode);
					}
				}

				var bindingKey : String;

				bindingKey = keyUpKeys.join(",");
				var handler : Function;
				handler = _keyUpHandlers[bindingKey];
				if (handler != null)
					handler();

				bindingKey = keyDownKeys.join(",");
				handler = _keyDownHandlers[bindingKey];
				if (handler != null)
					handler();
			}
		}

		private function enableKeyboardEvent(target : Object) : Boolean
		{
			return (!(target is TextField) || (target as TextField).type != TextFieldType.INPUT);
		}

		private function onKeyDown(event : KeyboardEvent) : void
		{
			event.stopImmediatePropagation();

			if (_isListening && SShellVariables.stageIsActive)
			{
				if (enableKeyboardEvent(event.target))
					_keyboard.handleKeyDown(event.keyCode);
				else
					_keyboard.handleKeyUp(event.keyCode);
			}
			else
				_keyboard.handleKeyUp(event.keyCode);

			var keyEvent : SKeyboardEvent = new SKeyboardEvent(SKeyboardEvent.KEY_DOWN, event.charCode, event.keyCode, event.keyLocation, event.ctrlKey, event.altKey, event.shiftKey);
			keyEvent.dispatch();

			if (SShellVariables.isDesktop())
			{
				if (event.keyCode == Keyboard.BACK)
				{
					var NativeApplication : Class = getDefinitionByName("flash.desktop.NativeApplication") as Class;
					NativeApplication.nativeApplication.exit();
				}
			}
			isChange = true;
		}

		private function onKeyUp(event : KeyboardEvent) : void
		{
			event.stopImmediatePropagation();
			_keyboard.handleKeyUp(event.keyCode);

			var keyEvent : SKeyboardEvent = new SKeyboardEvent(SKeyboardEvent.KEY_UP, event.charCode, event.keyCode, event.keyLocation, event.ctrlKey, event.altKey, event.shiftKey);
			keyEvent.dispatch();
			isChange = true;
		}

		override public function destroy() : void
		{
			SShellVariables.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false);
			SShellVariables.nativeStage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp, false);
			SEventPool.removeEventListener(SEvent.DEACTIVATE, onDeActive);
			SEventPool.removeEventListener(SMouseEvent.RIGHT_CLICK, onRightClick);
			reset();
			super.destroy();
		}

		public function get isListening() : Boolean
		{
			return _isListening;
		}

		public function bindingKeyDownHandler(handler : Function, ... keyCode) : void
		{
			var bindingKey : String = keyCode.join(",");
			if (_keyDownHandlers[bindingKey])
			{
				throw new SunnyGameEngineError("按键值" + bindingKey + "已经绑定按键按下处理方法！");
				return;
			}
			_keyDownHandlers[bindingKey] = handler;
		}

		public function bindingKeyUpHandler(handler : Function, ... keyCode) : void
		{
			var bindingKey : String = keyCode.join(",");
			if (_keyUpHandlers[bindingKey])
			{
				throw new SunnyGameEngineError("按键值" + bindingKey + "已经绑定按键弹起处理方法！");
				return;
			}
			_keyUpHandlers[bindingKey] = handler;
		}

		public function get keyboard() : SKeyboard
		{
			return _keyboard;
		}
	}
}