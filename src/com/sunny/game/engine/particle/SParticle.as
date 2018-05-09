package com.sunny.game.engine.particle
{
	import com.sunny.game.engine.lang.destroy.SIDestroy;
	import com.sunny.game.engine.lang.memory.SIRecyclable;

	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;

	/**
	 *
	 * <p>
	 * SunnyGame的一个粒子基类
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
	public class SParticle extends Bitmap implements SIRecyclable, SIDestroy
	{
		protected var _parent : DisplayObjectContainer;
		protected var _isDisposed : Boolean;

		public function SParticle(parent : DisplayObjectContainer)
		{
			_parent = parent;
			_isDisposed = false;
			super();
			//this.cacheAsBitmap = true;
		}

		public function hide() : void
		{
			if (_parent && _parent.contains(this))
				_parent.removeChild(this);
		}

		public function show() : void
		{
			if (_parent && !_parent.contains(this))
				_parent.addChild(this);
		}

		public function free() : void
		{
			hide();
		}

		public function destroy() : void
		{
			if (_isDisposed)
				return;
			_parent = null;
			_isDisposed = true;
		}

		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}
	}
}