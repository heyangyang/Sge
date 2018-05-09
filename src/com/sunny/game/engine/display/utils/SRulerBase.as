package com.sunny.game.engine.display.utils
{
	import com.sunny.game.engine.display.SLineSprite;
	import com.sunny.game.engine.display.SSprite;
	import com.sunny.game.engine.display.STextSprite;
	
	import flash.display.Bitmap;

	/**
	 *
	 * <p>
	 * SunnyGame的一个标尺基类
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
	public class SRulerBase extends SSprite
	{
		protected var _text : STextSprite;
		protected var _bmp : Bitmap;
		protected var _positiveSize : uint = 200;
		protected var _negativeSize : uint = 200;
		protected var _overflow : uint = 20;
		protected var _textHeight : uint = 16;
		/**
		 * 游标位置
		 */
		protected var _vernierPosition : int = 0;
		protected var _vernier : SLineSprite;
		
		protected var _direction:String;
		protected var _showZero:Boolean;
		
		public function SRulerBase()
		{
			super();
			this.mouseEnabled = false;
			this.mouseChildren = false;
			_text = new STextSprite();
			_bmp = new Bitmap();
			_vernier = new SLineSprite();
			_vernier.lineColor = 0x95ffa4;
			_showZero=true;
		}
		
		override public function render() : void
		{
			super.render();
			generate();
		}
		
		protected function generate() : void
		{
			clear();
			addChild(_bmp);
		}
		
		override public function clear() : void
		{
			super.clear();
			if (_bmp.bitmapData)
			{
				_bmp.bitmapData.dispose();
				_bmp.bitmapData = null;
			}
		}
		
		public function get negativeSize() : uint
		{
			return _negativeSize;
		}
		
		public function set negativeSize(value : uint) : void
		{
			if (_negativeSize == value)
				return;
			_negativeSize = value;
			dirty();
		}
		
		public function get positiveSize() : uint
		{
			return _positiveSize;
		}
		
		public function set positiveSize(value : uint) : void
		{
			if (_positiveSize == value)
				return;
			_positiveSize = value;
			dirty();
		}
		
		public function get vernierPosition() : int
		{
			return _vernierPosition;
		}
		
		public function set vernierPosition(value : int) : void
		{
			if (_vernierPosition == value)
				return;
			_vernierPosition = value;
			if (_vernierPosition < -_negativeSize)
				_vernierPosition = -_negativeSize;
			else if (_vernierPosition > _positiveSize)
				_vernierPosition = _positiveSize;
		}
		
		public function set direction(value:String):void
		{
			if(_direction == value)
				return;
			_direction = value;
			dirty();
		}
		
		public function showZero(value:Boolean):void
		{
			_showZero = value;
		}
	}
}