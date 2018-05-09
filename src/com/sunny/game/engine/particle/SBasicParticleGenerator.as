package com.sunny.game.engine.particle
{
	import com.sunny.game.engine.core.SUpdatableSprite;
	import com.sunny.game.engine.manager.SUpdatableManager;
	import com.sunny.game.engine.utils.core.SAbstractUtil;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	/**
	 * 粒子生成器基类
	 *
	 */
	public class SBasicParticleGenerator extends SUpdatableSprite
	{
		protected var _parent : Sprite;
		protected var _viewRect : Rectangle;
		protected var _isRunning : Boolean;
		protected var _visible : Boolean;
		protected var _sizeChanged : Boolean;

		public function get contentWidth() : Number
		{
			return _viewRect.width;
		}

		public function get contentHeight() : Number
		{
			return _viewRect.height;
		}

		public var children : Array;
		public var childrenCache : Array;

		public function SBasicParticleGenerator(parent : Sprite, viewRect : Rectangle)
		{
			super();

			SAbstractUtil.preventConstructor(this, SBasicParticleGenerator)

			_parent = parent;
			mouseEnabled = false;
			mouseChildren = false;
			_viewRect = viewRect;

			scrollRect = new Rectangle(0, 0, _viewRect.width, _viewRect.height);
			x = _viewRect.x;
			y = _viewRect.y;

			this.children = [];
			this.childrenCache = [];
		}

		public function start() : void
		{
			if (_isRunning)
				return;
			SUpdatableManager.getInstance().register(this, SUpdatableManager.PRIORITY_LAYER_LOW);
			_isRunning = true;
			show();
		}

		public function stop() : void
		{
			if (isDisposed)
				return;
			if (!_isRunning)
				return;
			unregister();
			_isRunning = false;
			hide();
		}

		public function show() : void
		{
			if (_visible)
				return;
			if (!_parent.contains(this))
				_parent.addChild(this);
			_visible = true;
		}

		public function hide() : void
		{
			if (!_visible)
				return;
			if (_parent.contains(this))
				_parent.removeChild(this);
			_visible = false;
		}

		public function resize(w : int, h : int) : void
		{
			if (_viewRect.width == w && _viewRect.height == h)
				return;

			_sizeChanged = true;

			_viewRect.width = w;
			_viewRect.height = h;
			scrollRect = new Rectangle(0, 0, _viewRect.width, _viewRect.height);

			if (_isRunning)
				validuateChange();
		}

		protected function validuateChange() : void
		{
			_sizeChanged = false;
		}

		override public function update() : void
		{
			super.update();
			if (_sizeChanged)
				validuateChange();
		}

		protected function createNewChild() : DisplayObject
		{
			return null;
		}

		protected function placeNewChild(child : DisplayObject) : void
		{
			//
		}

		protected function destoryChild(child : DisplayObject) : void
		{
			//
		}

		public function add() : void
		{
			var child : DisplayObject;
			if (childrenCache.length)
				child = childrenCache.pop();
			else
				child = createNewChild();

			children.push(child);
			addChild(child);

			this.placeNewChild(child);
		}

		public function remove(child : DisplayObject) : void
		{
			removeChild(child);

			var index : int = children.indexOf(child);
			if (index != -1)
				children.splice(index, 1);

			childrenCache.push(child);
		}

		public function get isRunning() : Boolean
		{
			return _isRunning;
		}

		public function destory() : void
		{
			for each (var child : DisplayObject in children)
				destoryChild(child);

			for each (child in childrenCache)
				destoryChild(child);

			stop();
			super.destroy();
		}
	}
}