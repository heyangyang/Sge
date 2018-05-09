package com.sunny.game.engine.render
{
	import com.sunny.game.engine.component.camera.SBorderCameraComponent;
	import com.sunny.game.engine.component.camera.SCameraComponent;
	import com.sunny.game.engine.core.SMapConfig;
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.entity.SRenderableEntity;
	import com.sunny.game.engine.events.SEvent;
	import com.sunny.game.engine.events.SEventPool;
	import com.sunny.game.engine.lang.errors.SunnyGameEngineError;
	import com.sunny.game.engine.profile.SMonitor;
	import com.sunny.game.engine.utils.SCommonUtil;
	import com.sunny.game.engine.weather.SWeatherManager;

	import flash.display.Sprite;

	/**
	 *
	 * <p>
	 * SunnyGame的场景渲染器
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
	public class SSceneRenderManagaer extends SBaseRenderManager
	{
		private var _sceneUniqueId : int = int(int.MAX_VALUE / 2);
		private var _mapContainer : Sprite;

		protected var _originalViewX : Number = 0;
		protected var _originalViewY : Number = 0;

		/**
		 * 当前屏幕的焦点对象
		 */
		public var cameraFocus : SRenderableEntity;

		private static var _singleton : Boolean = true;
		private static var _instance : SSceneRenderManagaer;

		public static function getInstance() : SSceneRenderManagaer
		{
			if (!_instance)
			{
				_singleton = false;
				_instance = new SSceneRenderManagaer();
				_singleton = true;
			}
			return _instance;
		}

		public function SSceneRenderManagaer()
		{
			super(null, SShellVariables.supportDirectX);
			if (_singleton)
				throw new SunnyGameEngineError("只能通过getInstance()来获取SSceneRender实例");

			frameTimes = 200;
		}

		public function init(mapContainer : Sprite) : void
		{
			_mapContainer = mapContainer;
			SEventPool.addEventListener(SEvent.RESIZE, onResize);
			SMonitor.getInstance().watchProperty(_renders, "length", "renderCount", 0xff0000);
		}

		public function reset() : void
		{
			zoom(1);
			_cameraComp = null;
		}

		private var _zoomScale : Number = 1;

		public function zoom(scale : Number) : void
		{
			if (scale <= 0)
				return;
			if (_zoomScale == scale)
				return;
			_zoomScale = scale;
			_container.scaleX = _container.scaleY = scale;
			_mapContainer.scaleX = _mapContainer.scaleY = scale;

			if (_zoomScale != 1)
			{
				var halfViewWidth : int = (SShellVariables.gameWidth * 0.5) * (_zoomScale - 1) * 0.5;
				var halfViewHeight : int = (SShellVariables.gameHeight * 0.5) * (_zoomScale - 1) * 0.5;
				moveView(_originalViewX + halfViewWidth, _originalViewY + halfViewHeight);
			}
			else
			{
				moveView(_originalViewX, _originalViewY);
			}
		}

		override public function updateCamera(viewX : Number, viewY : Number) : void
		{
			var halfViewWidth : int = SShellVariables.gameWidth >> 1;
			var halfViewHeight : int = SShellVariables.gameHeight >> 1;
			viewX = viewX - halfViewWidth;
			viewY = viewY - halfViewHeight;
			if (_viewX == viewX && _viewY == viewY)
				return;

			if (viewX < SMapConfig.leftBorder)
				viewX = SMapConfig.leftBorder;
			if (viewX > SMapConfig.rightBorder - SMapConfig.viewWidth)
				viewX = SMapConfig.rightBorder - SMapConfig.viewWidth;
			if (viewY < SMapConfig.topBorder)
				viewY = SMapConfig.topBorder;
			if (viewY > SMapConfig.bottomBorder - SMapConfig.viewHeight)
				viewY = SMapConfig.bottomBorder - SMapConfig.viewHeight;

			setViewPosition(viewX, viewY);
		}

		public function setViewPosition(viewX : Number, viewY : Number) : void
		{
			_originalViewX = viewX;
			_originalViewY = viewY;
			if (_zoomScale != 1)
			{
				var halfViewWidth : int = (SShellVariables.gameWidth * 0.5) * (_zoomScale - 1) * 0.5;
				var halfViewHeight : int = (SShellVariables.gameHeight * 0.5) * (_zoomScale - 1) * 0.5;
				viewX = _originalViewX + halfViewWidth;
				viewY = _originalViewY + halfViewHeight;
			}
			moveView(viewX, viewY);
		}

		override protected function moveView(viewX : Number, viewY : Number) : void
		{
			super.moveView(viewX, viewY);
			SWeatherManager.getInstance().scroll(_viewX, _viewY);
		}

		private function onResize(e : SEvent) : void
		{
			if (_mapContainer)
			{
				_mapContainer.graphics.clear();
				_mapContainer.graphics.beginFill(0, 0);
				_mapContainer.graphics.drawRect(0, 0, SShellVariables.gameWidth, SShellVariables.gameHeight);
				_mapContainer.graphics.endFill();
			}
			SWeatherManager.getInstance().resize(SShellVariables.gameWidth, SShellVariables.gameHeight);
		}

		override public function destroy() : void
		{
			super.destroy();
		}

		/**
		 * 摄像机焦点
		 * @param sceneObj
		 * @param cameraType 摄像机类型
		 */
		public function cameraFocusAt(focuser : SRenderableEntity, cameraType : Class = null, priority : int = 0) : void
		{
			if (!focuser)
				return;
			cameraType = cameraType || SBorderCameraComponent;
			if (cameraFocus && cameraFocus.isActive)
			{
				cameraFocus.removeComponentByType(SCameraComponent);
				cameraFocus.priority = 0;
			}
			cameraFocus = focuser;
			var cameraComp : SCameraComponent = new cameraType();
			cameraFocus.addComponent(cameraComp, priority);
			cameraComp.update();
		}

		/**
		 * 判断一个目标是否在屏幕之内
		 * @param sceneObj
		 * @return
		 *
		 */
		public function isSceneObjectInScreen(entity : SRenderableEntity) : Boolean
		{
			return isInScreenByMapPoint(entity.mapX, entity.mapY, entity.width, entity.height);
		}

		/**
		 * 判断一个点是否在屏幕之内
		 * @return
		 */
		public function isInScreenByMapPoint(mapX : int, mapY : int, width : int = 0, height : int = 0) : Boolean
		{
			var screenX : int = mapX - viewX;
			var screenY : int = mapY - viewY;
			return SCommonUtil.isInScreenByScreenPoint(screenX, screenY, width, height);
		}

		private var _cameraComp : SCameraComponent = null;

		/**
		 * 获取当前的摄相头插件
		 * @return
		 */
		public function getCamera() : SCameraComponent
		{
			if (cameraFocus)
			{
				if (!_cameraComp || _cameraComp.isDisposed)
					_cameraComp = cameraFocus.getComponent(SCameraComponent) as SCameraComponent;
				return _cameraComp;
			}
			return null;
		}

		public function getSceneUniqueId() : int
		{
			_sceneUniqueId++;
			if (_sceneUniqueId > int.MAX_VALUE - 100000000)
				_sceneUniqueId = int.MAX_VALUE / 2;
			return _sceneUniqueId;
		}

		public function get zoomScale() : Number
		{
			return _zoomScale;
		}
	}
}