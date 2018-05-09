package starling.base
{
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.render.base.SDirectContainer;
	
	import starling.core.Starling;
	import starling.events.TouchEvent;

	/**
	 * 启动类
	 * @author Administrator
	 *
	 */
	public class Game3D extends SSprite
	{
		/**
		 * 地图容器
		 */
		public static var mapContainer : SDirectContainer = new SDirectContainer();
		/**
		 * 实体容器
		 */
		public static var entityContainer : SDirectContainer = new SDirectContainer();
		/**
		 * 天气容器
		 */
		public static var weatherContainer : SDirectContainer = new SDirectContainer();

		public function Game3D()
		{
			super();
		}

		public function start() : void
		{
			addChild(mapContainer);
			addChild(entityContainer);
			addChild(weatherContainer);
			entityContainer.touchable = false;
			weatherContainer.touchable = false;
			if (SShellVariables.supportDirectX)
				Starling.current.showStatsAt("center", "top", 1);
		}

		public static function mouseHandler(fun : Function) : void
		{
			mapContainer.addEventListener(TouchEvent.TOUCH, fun);
		}
	}
}