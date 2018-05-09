package com.sunny.game.engine.transition.tween.props
{
	import com.sunny.game.engine.ns.sunny_engine;

	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	use namespace sunny_engine;
	use namespace flash_proxy;

	/**
	 *
	 * <p>
	 * SunnyGame的一个缓动属性
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
	dynamic public class STweenProps extends Proxy
	{
		sunny_engine var propertyList : Dictionary;
		/**
		 * 在缓动开始时想要执行某个函数，就将函数的引用（通常是函数名）放
						 到这里。如果缓动是带延迟的，那么在缓动开始前该函数不会被执行。
		 */
		private var _onStart : Function = null;
		/**
		 * 为缓动开始时要执行的函数传递参数。(可选的)
		 */
		private var _onStartParams : Array = null;
		/**
		 * 缓动结束时执行的函数。
		 */
		private var _onComplete : Function = null;
		/**
		 * 给 onComplete 参数指定的函数传递参数 (可选的)
		 */
		private var _onCompleteParams : Array = null;
		/**
		 * 缓动过程中，每次更新时调用这里指定的函数(缓动开始后，每一帧被
							触发一次)
		 */
		private var _onUpdate : Function = null;
		/**
		 * 给 onUpdate 参数指定的函数传递参数 (可选的)
		 */
		private var _onUpdateParams : Array = null;
		/**
		 * 缓动函数. 例如，fl.motion.easing.Elastic.easeOut 函数。默认的是
					 SQuad.easeOut函数。
		 */
		private var _ease : Function = null;
		/**
		 * 用来存贮缓动公式所需要的额外数据. 当使用 Elastic 公式并且希望控
							  制一些额外的参数，比如放大系数和缓动时间。大多数的缓动公式是不需要参数
							  的，因此，你不需要给其它的缓动公式传递参数。
		 */
		private var _easeParams : Array = null;

		private var _invert : Boolean = false;
		private var _repeat : uint = 0;
		private var _repeatDelay : Number = 0;
		/**
		 * 延迟缓动 (以秒为单位).
		 */
		private var _delay : Number = 0;
		private var _immediateRender : Boolean = false;
		private var _useFrames : Boolean = false;
		/**
		 * 当前的缓动被创建以后，通过这个参数可以限制作用于同一个对象的其它缓动
						 可选的参数值有：
					  - 0 (没有): 没有缓动被重写。这种模式下，运行速度是最快的，但是需要注意避免创
									   建一些控制相同属性的缓动，否则这些缓动效果间将出现冲突。
					  - 1 (全部): (这是默认值，除非 OverwriteManager.init() 被调用过)对于同一对象的
									   所有缓动在创建时将会被完全的覆盖掉。
							 TweenLite.to(mc, 1, {x:100, y:200});
							 TweenLite.to(mc, 1, {x:300, delay:2}); //后创建的缓动将会覆盖掉先前创
								  建的缓动（可以起到这样的作用：缓动进行到一半时被中断，执行新的缓动）
					 -2 (自动): (当 OverwriteManager.init() 被执行后,会根据具体的属性值进行选择) 只
										覆盖对同一属性的缓动。
								TweenLite.to(mc, 1, {x:100, y:200});
								TweenLite.to(mc, 1, {x:300}); //only  "x" 属性的缓动将被覆盖
					 - 3 (同时发生): 缓动开始时，覆盖全部的缓动。
								  TweenLite.to(mc, 1, {x:100, y:200});
								  TweenLite.to(mc, 1, {x:300, delay:2});
								  //不会覆盖先前的缓动，因为每二个缓动开始时，第一个缓动已经结束了。
		 */
		private var _overwriteType : int = 0;
		private var _startAt : STweenProps = null;

		//不确定有没有用的参数 可以改成retain 
		//persist : Boolean - 值为 true 时，TweenLite 实例将不会自动被系统的垃圾收集器给收走。
		//但是当新的缓动出现时，它还是会被重写（overwritten）默认值为 false.

		public function STweenProps(vars : Object = null)
		{
			super();
			propertyList = new Dictionary(true);
			if (vars)
			{
				for (var p : String in vars)
				{
					this[p] = vars[p];
				}
			}
		}

		flash_proxy override function callProperty(methodName : *, ... args) : *
		{
			var metrod : * = propertyList[methodName];
			(metrod as Function).apply(null, args);
		}

		flash_proxy override function getProperty(property : *) : *
		{
			return propertyList[property];
		}

		flash_proxy override function setProperty(property : *, value : *) : void
		{
			propertyList[property] = value;
		}

		flash_proxy override function deleteProperty(property : *) : Boolean
		{
			return delete(propertyList[property]);
		}

		public function get onStart() : Function
		{
			return _onStart;
		}

		public function set onStart(value : Function) : void
		{
			_onStart = value;
			setProperty("onStart", value);
		}

		public function get onStartParams() : Array
		{
			return _onStartParams;
		}

		public function set onStartParams(value : Array) : void
		{
			_onStartParams = value;
			setProperty("onStartParams", value);
		}

		public function get onComplete() : Function
		{
			return _onComplete;
		}

		public function set onComplete(value : Function) : void
		{
			_onComplete = value;
			setProperty("onComplete", value);
		}

		public function get onCompleteParams() : Array
		{
			return _onCompleteParams;
		}

		public function set onCompleteParams(value : Array) : void
		{
			_onCompleteParams = value;
			setProperty("onCompleteParams", value);
		}

		public function get onUpdate() : Function
		{
			return _onUpdate;
		}

		public function set onUpdate(value : Function) : void
		{
			_onUpdate = value;
			setProperty("onUpdate", value);
		}

		public function get onUpdateParams() : Array
		{
			return _onUpdateParams;
		}

		public function set onUpdateParams(value : Array) : void
		{
			_onUpdateParams = value;
			setProperty("onUpdateParams", value);
		}

		public function get ease() : Function
		{
			return _ease;
		}

		public function set ease(value : Function) : void
		{
			_ease = value;
			setProperty("ease", value);
		}

		public function get invert() : Boolean
		{
			return _invert;
		}

		public function set invert(value : Boolean) : void
		{
			_invert = value;
			setProperty("invert", value);
		}

		public function get repeat() : uint
		{
			return _repeat;
		}

		public function set repeat(value : uint) : void
		{
			_repeat = value;
			setProperty("repeat", value);
		}

		public function get repeatDelay() : Number
		{
			return _repeatDelay;
		}

		public function set repeatDelay(value : Number) : void
		{
			_repeatDelay = value;
			setProperty("repeatDelay", value);
		}

		public function get delay() : Number
		{
			return _delay;
		}

		public function set delay(value : Number) : void
		{
			_delay = value;
			setProperty("delay", value);
		}

		public function get immediateRender() : Boolean
		{
			return _immediateRender;
		}

		public function set immediateRender(value : Boolean) : void
		{
			_immediateRender = value;
			setProperty("immediateRender", value);
		}

		public function get useFrames() : Boolean
		{
			return _useFrames;
		}

		public function set useFrames(value : Boolean) : void
		{
			_useFrames = value;
			setProperty("useFrames", value);
		}

		public function get overwriteType() : int
		{
			return _overwriteType;
		}

		public function set overwriteType(value : int) : void
		{
			_overwriteType = value;
			setProperty("overwriteType", value);
		}

		public function get startAt() : STweenProps
		{
			return _startAt;
		}

		public function set startAt(value : STweenProps) : void
		{
			_startAt = value;
			setProperty("startAt", value);
		}

		public function get easeParams() : Array
		{
			return _easeParams;
		}

		public function set easeParams(value : Array) : void
		{
			_easeParams = value;
			setProperty("easeParams", value);
		}

		/**
		 * 复制
		 * @return
		 *
		 */
		public function clone() : STweenProps
		{
			var tweenProps : STweenProps = new STweenProps();
			for (var p : String in tweenProps.propertyList)
			{
				tweenProps[p] = this[p];
			}
			return tweenProps;
		}
	}
}