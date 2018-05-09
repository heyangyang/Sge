package com.sunny.game.engine.display.text
{
	import com.sunny.game.engine.lang.destroy.SIDestroy;

	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	/**
	 *
	 * <p>
	 * SunnyGame的一个文本渲染器
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
	internal class STextRenderer extends TextField implements SIDestroy
	{
		private var _length : int = 0;
		private var _oldLength : int = 0;
		private var _scrollHeight : Number = 0;
		private var _defaultTextFormat : TextFormat;
		/**
		 * 一个布尔值，指示当追加内容到RichTextField后是否自动滚动到最底部。
		 * @default true
		 */
		public var autoScroll : Boolean;

		private var _scrollable : Boolean;
		protected var _isDisposed : Boolean;

		public function STextRenderer()
		{
			super();
			var format : TextFormat = new TextFormat("Arial", 12, 0x000000, false, false, false);
			format.letterSpacing = 0;
			this.defaultTextFormat = format;
			this.multiline = true;
			this.wordWrap = true;
			this.type = TextFieldType.DYNAMIC;
			autoScroll = false;
			_scrollable = true;
			_isDisposed = false;
		}

		public function get scrollable() : Boolean
		{
			return _scrollable;
		}

		public function set scrollable(value : Boolean) : void
		{
			_scrollable = value;
		}

		override public function set text(value : String) : void
		{
			super.text = value;
			_length = this.length;
			updateScroll();
		}

		override public function set htmlText(value : String) : void
		{
			super.htmlText = value;
			_length = this.length;
			updateScroll();
		}

		override public function replaceText(beginIndex : int, endIndex : int, newText : String) : void
		{
			super.replaceText(beginIndex, endIndex, newText);
			_length = this.length;
			updateScroll();
		}

		override public function get defaultTextFormat() : TextFormat
		{
			return _defaultTextFormat;
		}

		override public function set defaultTextFormat(value : TextFormat) : void
		{
			if (value.letterSpacing == null)
				value.letterSpacing = 0;
			_defaultTextFormat = value;
			super.defaultTextFormat = value;
			updateScroll();
		}

		override public function set type(value : String) : void
		{
			super.type = value;
			this.addEventListener(Event.SCROLL, onScroll);
			if (type == TextFieldType.INPUT)
			{
				this.addEventListener(Event.CHANGE, onTextChange);
				this.addEventListener(TextEvent.TEXT_INPUT, onTextInput);
			}
		}

		private function updateScroll() : void
		{
			if (_scrollable)
			{
				//auto scroll			
				if (autoScroll && scrollV != maxScrollV)
				{
					scrollV = maxScrollV;
				}
			}
			else
			{
				scrollV = 1;
			}
		}

		private function onScroll(e : Event) : void
		{
			//update _scrollHeight when scrolling
			if (_scrollable)
				calcScrollHeight();
		}

		private function onTextChange(e : Event) : void
		{
			//record old length before text has been changed
			_oldLength = _length;
			_length = this.length;
		}

		private function onTextInput(e : TextEvent) : void
		{
			recoverDefaultFormat();
		}

		private function calcScrollHeight() : void
		{
			//avoid the error #2006 when clear text
			if (this.length == 0)
			{
				_scrollHeight = 0;
				return;
			}

			var height : Number = 0;
			for (var i : int = 0; i < this.scrollV - 1; i++)
			{
				height += getLineMetrics(i).height;
			}
			_scrollHeight = height;
		}

		internal function recoverDefaultFormat() : void
		{
			//force to recover default textFormat
			this.defaultTextFormat = defaultTextFormat;
		}

		internal function get scrollHeight() : Number
		{
			return _scrollHeight;
		}

		/**
		 * 此属性用来获取事件Event.CHANGE发生前的文本字段的长度。
		 * 因此在Event.CHANGE事件处理器中获取它才正确且有意义。
		 * @private
		 */
		public function get oldLength() : int
		{
			return _oldLength;
		}

		internal function clear() : void
		{
			this.text = "";
			_oldLength = 0;
			_scrollHeight = 0;
		}

		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}

		public function destroy() : void
		{
			if (_isDisposed)
				return;
			if (this.parent)
				this.parent.removeChild(this);
			_isDisposed = true;
		}
	}
}