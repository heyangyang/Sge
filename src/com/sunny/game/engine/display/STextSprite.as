package com.sunny.game.engine.display
{
	import com.sunny.game.engine.enum.STextMode;
	import com.sunny.game.engine.ui.SUIStyle;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;


	public class STextSprite extends SSprite
	{
		// vertical anchors

		public static const TOP : int = 0;

		public static const MIDDLE : int = 1;

		public static const BOTTOM : int = 2;

		// horizontal anchors

		public static const LEFT : int = 0;

		public static const CENTER : int = 1;

		public static const RIGHT : int = 2;

		private var _mode : int = -1;
		private var _bmap : Bitmap;
		private var _tf : TextField;
		private var _fmt : TextFormat;

		private var _hAnchor : int = LEFT;
		private var _vAnchor : int = TOP;


		public function STextSprite(text : String = null, format : TextFormat = null, mode : int = 2) //STextMode.BITMAP
		{
			_tf = new TextField();
			_tf.selectable = false; // not selectable by default
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.defaultTextFormat = (_fmt = format ? format : new TextFormat(SUIStyle.TEXT_FONT, SUIStyle.TEXT_SIZE));
			if (text != null)
				_tf.text = text;
			_bmap = new Bitmap();
			setMode(mode);
			dirty();
		}


		public function get textField() : TextField
		{
			return _tf;
		}


		public function get bitmap() : Bitmap
		{
			return _bmap;
		}


		public function get textMode() : int
		{
			return _mode;
		}

		public function set textMode(mode : int) : void
		{
			setMode(mode);
		}


		public function get textFormat() : TextFormat
		{
			return _fmt;
		}

		public function set textFormat(fmt : TextFormat) : void
		{
			_tf.defaultTextFormat = (_fmt = fmt);
			_tf.setTextFormat(_fmt);
			if (_mode == STextMode.BITMAP)
				dirty();
		}


		public function get text() : String
		{
			return _tf.text;
		}

		public function set text(txt : String) : void
		{
			if (_tf.text != txt)
			{
				_tf.text = (txt == null ? "" : txt);
				if (_fmt != null)
					_tf.setTextFormat(_fmt);
				dirty();
			}
		}


		public function get htmlText() : String
		{
			return _tf.htmlText;
		}

		public function set htmlText(txt : String) : void
		{
			if (_tf.htmlText != txt)
			{
				_tf.htmlText = (txt == null ? "" : txt);
				dirty();
			}
		}


		public function get font() : String
		{
			return String(_fmt.font);
		}

		public function set font(f : String) : void
		{
			_fmt.font = f;
			_tf.setTextFormat(_fmt);
			if (_mode == STextMode.BITMAP)
				dirty();
		}


		public function get color() : uint
		{
			return uint(_fmt.color);
		}

		public function set color(c : uint) : void
		{
			_fmt.color = c;
			_tf.setTextFormat(_fmt);
			if (_mode == STextMode.BITMAP)
				dirty();
		}


		public function get size() : Number
		{
			return Number(_fmt.size);
		}

		public function set size(s : Number) : void
		{
			_fmt.size = s;
			_tf.setTextFormat(_fmt);
			if (_mode == STextMode.BITMAP)
				dirty();
		}


		public function get bold() : Boolean
		{
			return Boolean(_fmt.bold);
		}

		public function set bold(b : Boolean) : void
		{
			_fmt.bold = b;
			_tf.setTextFormat(_fmt);
			if (_mode == STextMode.BITMAP)
				dirty();
		}


		public function get italic() : Boolean
		{
			return Boolean(_fmt.italic);
		}

		public function set italic(b : Boolean) : void
		{
			_fmt.italic = b;
			_tf.setTextFormat(_fmt);
			if (_mode == STextMode.BITMAP)
				dirty();
		}


		public function get underline() : Boolean
		{
			return Boolean(_fmt.underline);
		}

		public function set underline(b : Boolean) : void
		{
			_fmt.underline = b;
			_tf.setTextFormat(_fmt);
			if (_mode == STextMode.BITMAP)
				dirty();
		}


		public function get kerning() : Boolean
		{
			return Boolean(_fmt.kerning);
		}

		public function set kerning(b : Boolean) : void
		{
			_fmt.kerning = b;
			_tf.setTextFormat(_fmt);
			if (_mode == STextMode.BITMAP)
				dirty();
		}


		public function get letterSpacing() : int
		{
			return int(_fmt.letterSpacing);
		}

		public function set letterSpacing(s : int) : void
		{
			_fmt.letterSpacing = s;
			_tf.setTextFormat(_fmt);
			if (_mode == STextMode.BITMAP)
				dirty();
		}


		public function get horizontalAnchor() : int
		{
			return _hAnchor;
		}

		public function set horizontalAnchor(a : int) : void
		{
			if (_hAnchor != a)
			{
				_hAnchor = a;
				layout();
			}
		}


		public function get verticalAnchor() : int
		{
			return _vAnchor;
		}

		public function set verticalAnchor(a : int) : void
		{
			if (_vAnchor != a)
			{
				_vAnchor = a;
				layout();
			}
		}

		// --------------------------------------------------------------------



		protected function setMode(mode : int) : void
		{
			if (mode == _mode)
				return; // nothing to do

			switch (_mode)
			{
				case STextMode.BITMAP:
					if (_bmap.bitmapData)
					{
						_bmap.bitmapData.dispose();
						_bmap.bitmapData = null;
					}
					removeChild(_bmap);
					break;
				case STextMode.EMBED:
					_tf.embedFonts = false;
					break;
				case STextMode.DEVICE:
					removeChild(_tf);
					break;
			}
			switch (mode)
			{
				case STextMode.BITMAP:
					rasterize();
					addChild(_bmap);
					break;
				case STextMode.EMBED:
					_tf.embedFonts = true;
					break;
				case STextMode.DEVICE:
					addChild(_tf);
					break;
			}
			_mode = mode;
		}


		public function applyFormat(fmt : TextFormat) : void
		{
			_fmt.align = fmt.align;
			_fmt.blockIndent = fmt.blockIndent;
			_fmt.bold = fmt.bold;
			_fmt.bullet = fmt.bullet;
			_fmt.color = fmt.color;
			_fmt.display = fmt.display;
			_fmt.font = fmt.font;
			_fmt.indent = fmt.indent;
			_fmt.italic = fmt.italic;
			_fmt.kerning = fmt.kerning;
			_fmt.leading = fmt.leading;
			_fmt.leftMargin = fmt.leftMargin;
			_fmt.letterSpacing = fmt.letterSpacing;
			_fmt.rightMargin = fmt.rightMargin;
			_fmt.size = fmt.size;
			_fmt.tabStops = fmt.tabStops;
			_fmt.target = fmt.target;
			_fmt.underline = fmt.underline;
			_fmt.url = fmt.url;
			_tf.setTextFormat(_fmt);
			if (_mode == STextMode.BITMAP)
				dirty();
		}


		public override function render() : void
		{
			super.render();
			if (_mode == STextMode.BITMAP)
			{
				rasterize();
			}
			layout();
		}


		protected function layout() : void
		{
			var d : DisplayObject = (_mode == STextMode.BITMAP ? _bmap : _tf);

			// horizontal anchor
			switch (_hAnchor)
			{
				case LEFT:
					d.x = 0;
					break;
				case CENTER:
					d.x = -d.width / 2;
					break;
				case RIGHT:
					d.x = -d.width;
					break;
			}
			// vertical anchor
			switch (_vAnchor)
			{
				case TOP:
					d.y = 0;
					break;
				case MIDDLE:
					d.y = -d.height / 2;
					break;
				case BOTTOM:
					d.y = -d.height;
					break;
			}
		}

		protected function rasterize() : void
		{
			var tw : Number = _tf.width + 1;
			var th : Number = _tf.height + 1;
			var bd : BitmapData = _bmap.bitmapData;
			if (bd == null || bd.width != tw || bd.height != th)
			{
				if (bd)
					bd.dispose();
				bd = new BitmapData(tw, th, true, 0x00ffffff);
				_bmap.bitmapData = bd;
			}
			else
			{
				bd.fillRect(new Rectangle(0, 0, tw, th), 0x00ffffff);
			}
			bd.draw(_tf);
		}

		override public function destroy() : void
		{
			super.destroy();
			if (_bmap && _bmap.bitmapData)
				_bmap.bitmapData.dispose();
		}
	}
}