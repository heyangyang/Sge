package com.sunny.game.engine.render
{
	import com.sunny.game.engine.core.SIResizable;
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.core.SUpdatable;
	import com.sunny.game.engine.render.interfaces.SIContainer;
	import com.sunny.game.engine.render.interfaces.SIRenderData;
	
	import starling.base.Game3D;

	/**
	 *
	 * <p>
	 * SunnyGame的基础渲染器
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
	public class SBaseRenderManager extends SUpdatable implements SIResizable
	{
		private static const BATCH_UPDATABLE_COUNT : int = 200;

		protected var _viewX : Number = 0;
		protected var _viewY : Number = 0;

		public var viewWidth : int;
		public var viewHeight : int;

		protected var _container : SIContainer;

		protected var _renders : Vector.<SIRenderData> = new Vector.<SIRenderData>();

		private var _currBatchIndex : uint = 0;

		protected var isDirect : Boolean;

		public function SBaseRenderManager(container : SIContainer, isDirect : Boolean)
		{
			_container = container;
			if (_container == null)
				_container = isDirect ? Game3D.entityContainer : SShellVariables.entityContainer;
			this.isDirect = isDirect;
			super();
		}

		public function get viewY() : Number
		{
			return _viewY;
		}

		public function get viewX() : Number
		{
			return _viewX;
		}

		public function resize(w : int, h : int) : void
		{
			viewWidth = w;
			viewHeight = h;
		}

		public function addRender(render : SIRenderData) : Boolean
		{
			if (render == null || render.isDisposed)
				return false;
			if (_renders.indexOf(render) == -1)
			{
				insert(render);
				render.notifyAddedToRender();
				var index : int = _renders.indexOf(render);
				addToContainer(render, index);
				return true;
			}
			return false;
		}

		public function removeRender(render : SIRenderData) : Boolean
		{
			if (render == null || render.isDisposed)
				return false;
			var index : int = _renders.indexOf(render);
			if (index != -1)
			{
				render.notifyRemovedFromRender();
				_renders.splice(index, 1);
				removeFromContainer(render);
				return true;
			}
			return false;
		}

		public function updateCamera(viewX : Number, viewY : Number) : void
		{
			var halfViewWidth : int = SShellVariables.gameWidth * 0.5;
			var halfViewHeight : int = SShellVariables.gameHeight * 0.5;
			viewX = viewX - halfViewWidth;
			viewY = viewY - halfViewHeight;
			if (_viewX == viewX && _viewY == viewY)
				return;
			moveView(viewX, viewY);
		}

		protected function moveView(viewX : Number, viewY : Number) : void
		{
			_viewX = viewX;
			_viewY = viewY;
		}

		override public function update() : void
		{
			sort();
			updateChildIndex();
		}

		public function sort() : void
		{
			_renders = _renders.sort(sortIndex);
		}

		protected function sortIndex(renderData1 : SIRenderData, renderData2 : SIRenderData) : int
		{
			if (renderData1.depth < renderData2.depth) //深度越大越往前排
				return -1;
			else if (renderData1.depth > renderData2.depth)
				return 1;
			else
			{ //第2个层次排序
				if (renderData1.layer < renderData2.layer) //层数越大越往前排
					return -1;
				else if (renderData1.layer > renderData2.layer)
					return 1;
				else
				{
					if (renderData1.order < renderData2.order) //排序越大越往前排
						return -1;
					else if (renderData1.order > renderData2.order)
						return 1;
				}
			}
			return 0;
		}

		protected function updateChildIndex() : void
		{
			var len : int = _renders.length;
			var startIndex : int = _currBatchIndex;
			var endIndex : int = startIndex + BATCH_UPDATABLE_COUNT;
			var endIndex2 : int = -1;
			if (len > BATCH_UPDATABLE_COUNT)
			{
				_currBatchIndex = endIndex + 1;
				if (endIndex >= len)
				{
					endIndex2 = endIndex - len;
					endIndex = len - 1;
					if (endIndex2 >= len)
						endIndex2 = len - 1;
					_currBatchIndex = endIndex2 + 1;
				}
				if (_currBatchIndex >= len)
					_currBatchIndex = 0;
			}
			else
			{
				_currBatchIndex = 0;
				startIndex = _currBatchIndex;
				endIndex = len - 1;
			}

			var index : int = 0;
			var i : int = 0;
			var render : SIRenderData;
			index = startIndex;
			for (i = startIndex; i <= endIndex; i++)
			{
				render = _renders[i];
				if (!render)
					continue;
				index = updateRenderIndex(render, index);
			}
			index = 0;
			for (i = 0; i < endIndex2; i++)
			{
				render = _renders[i];
				if (!render)
					continue;
				index = updateRenderIndex(render, index);
			}
		}

		protected function updateRenderIndex(render : SIRenderData, index : int) : int
		{
			if (render.render && render.render.sparent != null)
			{
				if (index >= _container.numChildren) //防止溢出
					index = _container.numChildren - 1;
				render.render.sparent.setGameChildIndex(render.render, index++);
			}
			var child : SIRenderData;
			for (var i : int = 0; i < render.numChildren; i++)
			{
				child = render.getChildAt(i);
				if (child)
					index = updateRenderIndex(child, index);
			}
			return index;
		}

		/**
		 * 插入一个新的对象到数组中相应的位置
		 * @param newRender
		 * @return
		 */
		public function insert(newRender : SIRenderData) : void
		{
			var index : int = 0;
			var len : int = _renders.length;
			var render : SIRenderData;
			//这里的数组是已经排过序的，所以找到比Index更大的
			for (var i : int = len - 1; i >= 0; i--)
			{
				render = _renders[i];
				if (render.depth < newRender.depth)
				{
					index = i + 1;
					break;
				}
			}
			index = index < 0 ? 0 : index;
			insertAt(newRender, index);
		}

		public function insertAt(newRender : SIRenderData, index : int) : void
		{
			_renders.splice(index, 0, newRender);
			var len : int = _renders.length;
			var render : SIRenderData;
			for (var i : int = index; i < len; i++)
			{
				render = _renders[i];
				render.order = i;
			}
		}

		public function get numRenders() : int
		{
			return _renders.length;
		}

		private function addToContainer(render : SIRenderData, index : int) : int
		{
			if (render.render != null && !render.rendable) //如果指定为不需要添加到渲染列表
			{
				if (index > _container.numChildren) //防止超出范围
					index = _container.numChildren;
				_container.addGameChildAt(render.render, index++);
			}
			var child : SIRenderData;
			for (var i : int = 0; i < render.numChildren; i++)
			{
				child = render.getChildAt(i);
				if (child != null)
					index = addToContainer(child, index);
			}
			return index;
		}

		private function removeFromContainer(render : SIRenderData) : void
		{
			if (render.render && render.render.sparent != null)
			{
				render.render.sparent.removeGameChild(render.render);
			}
			var child : SIRenderData;
			for (var i : int = render.numChildren - 1; i >= 0; i--)
			{
				child = render.getChildAt(i);
				if (child != null)
					removeFromContainer(child);
			}
		}

		override public function destroy() : void
		{
			while (_container.numChildren > 0)
				_container.removeGameChildAt(0);
			_renders.length = 0;
			_viewX = 0;
			_viewY = 0;
			super.destroy();
		}
	}
}