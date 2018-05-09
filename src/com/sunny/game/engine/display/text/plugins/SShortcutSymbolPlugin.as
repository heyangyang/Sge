package com.sunny.game.engine.display.text.plugins
{
	import com.sunny.game.engine.display.text.SRichTextField;
	import com.sunny.game.engine.display.text.SShortcutSymbolElement;
	import com.sunny.game.engine.display.text.STextElement;
	import com.sunny.game.engine.enum.STextType;
	import com.sunny.game.engine.ns.sunny_plugin;
	import com.sunny.game.engine.plugin.SIPlugin;

	import flash.events.Event;

	/**
	 *
	 * <p>
	 * SunnyGame的一个显示元素快捷符号输入插件，方便显示元素的快速输入。一般适用于input类型的SRichTextField。
	 * @example 下面的例子演示了基本使用方法：
	 * <listing>
	   var input:RichTextField = new RichTextField();
	   input.type = RichTextField.INPUT;

	   var plugin:ShortcutPlugin = new ShortcutPlugin();
	   var shortcuts:Array = [
		 { shortcut:"/a", src:SpriteClassA },
		 { shortcut:"/b", src:SpriteClassB },
		 { shortcut:"/c", src:SpriteClassC }];
	   plugin.addShortcut(shortcuts);
	   input.addPlugin(plugin);</listing>
	 *
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
	public class SShortcutSymbolPlugin implements SIPlugin
	{
		private var _target : SRichTextField;
		private var _shortcuts : Array;
		private var _enabled : Boolean;
		protected var _isDisposed : Boolean;

		/**
		 * 构造函数。
		 */
		public function SShortcutSymbolPlugin()
		{
			_shortcuts = [];
			_enabled = false;
			_isDisposed = false;
		}

		/**
		 * @private
		 */
		public function setup(target : Object) : Boolean
		{
			if (target is SRichTextField)
			{
				_target = target as SRichTextField;
				this.enabled = true;
				return true;
			}
			return false;
		}

		/**
		 * 增加快捷项shortcut。
		 * @param	shortcuts 快捷项shortcut数组，每个元素必须包含src和shortcut两个属性，如：{src:smileClass, shortcut:":)"}。
		 */
		public function addShortcut(shortcuts : Array) : void
		{
			_shortcuts = _shortcuts.concat(shortcuts);
		}

		private function onTextChange(e : Event) : void
		{
			if (_target.type == STextType.DYNAMIC || _target.caretIndex > 0)
				convertShortcut();
		}

		private function convertShortcut() : void
		{
			var offset : int = _target.contentLength - _target.oldLength;
			//删除文本内容无需处理
			if (offset < 0)
				return;

			var caret : int = _target.type == STextType.DYNAMIC ? _target.contentLength : _target.caretIndex;
			for (var i : int = 0; i < _shortcuts.length; i++)
			{
				var item : SShortcutSymbolElement = _shortcuts[i];
				var len : int = item.shortcut.length;
				var index : int = _target.content.lastIndexOf(item.shortcut, caret);
				if (index > -1)
				{
					var element : STextElement = new STextElement();
					element.source = item.source;
					element.params = item.params;
					element.sunny_plugin::shortcut = item.shortcut;
					_target.sunny_plugin::replace(index, index + len, "", [element]);
					caret--;
					//当改变的文本长度为1时，只需匹配一次即可
					if (offset == 1)
						break;
				}
			}
			_target.caretIndex = caret;
		}

		/**
		 * 一个布尔值，指示插件是否启用。
		 */
		public function get enabled() : Boolean
		{
			return _enabled;
		}

		public function set enabled(value : Boolean) : void
		{
			_enabled = value;
			if (_target != null)
			{
				if (_enabled)
					_target.addEventListener(Event.CHANGE, onTextChange, false, 0, true);
				else
					_target.removeEventListener(Event.CHANGE, onTextChange);
			}
		}

		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}

		public function destroy() : void
		{
			if (_isDisposed)
				return;
			_target = null;
			if (_shortcuts)
			{
				_shortcuts.length = 0;
				_shortcuts = null;
			}
			_enabled = false;
			_isDisposed = true;
		}
	}
}