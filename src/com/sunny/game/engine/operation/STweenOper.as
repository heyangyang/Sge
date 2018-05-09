package com.sunny.game.engine.operation
{
	import com.sunny.game.engine.operation.effect.SIEffectOper;
	import com.sunny.game.engine.utils.SReflectUtil;
	import com.sunny.game.engine.utils.easing.STweenUtil;
	import com.sunny.game.engine.utils.easing.TweenEvent;

	/**
	 *
	 * <p>
	 * SunnyGame的一个与内部Tween对应的Oper
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
	public class STweenOper extends SOperation implements SIEffectOper
	{
		protected var _target : *;

		/**
		 * 目标
		 * @return
		 *
		 */
		public function get target() : *
		{
			return _target;
		}

		public function set target(v : *) : void
		{
			_target = v;
		}

		/**
		 * 持续时间
		 */
		public var duration : int;
		/**
		 * 参数
		 */
		public var params : Object;

		/**
		 * 是否在倒放开始的时候立即确认属性
		 */
		public var updateWhenInvent : Boolean = true;

		/**
		 * 是否清除原有的Tween效果（-1:不清除 1:立即完成 其他:中断）
		 */
		public var clearTarget : *;

		/**
		 * 缓动实例
		 */
		public var tween : STweenUtil;

		public function STweenOper(target : * = null, duration : int = 100, params : Object = null, invert : Boolean = false, clearTarget : * = 0, immediately : Boolean = false)
		{
			super();

			this._target = target;
			this.duration = duration;
			this.params = params;
			this.immediately = immediately;

			if (invert)
				this.invert = invert;

			this.clearTarget = clearTarget;
		}

		/**
		 * 是否倒放
		 * @return
		 *
		 */
		public function get invert() : Boolean
		{
			return this.params ? this.params.invert : false;
		}

		public function set invert(v : Boolean) : void
		{
			if (!params)
				params = new Object()
			this.params.invert = v;
		}

		/** @inheritDoc*/
		public override function execute() : void
		{
			super.execute();

			if (_target is String)
				_target = SReflectUtil.eval(_target);

			if (clearTarget is Boolean)
				STweenUtil.removeTween(_target, clearTarget);
			else if (clearTarget >= 0)
				STweenUtil.removeTween(_target, clearTarget == 1);

			tween = new STweenUtil(_target, duration, params);
			tween.addEventListener(TweenEvent.TWEEN_END, result);

			if (invert && updateWhenInvent)
				tween.update(); //执行update确认属性
		}

		/** @inheritDoc*/
		protected override function end(event : * = null) : void
		{
			if (tween)
			{
				tween.removeEventListener(TweenEvent.TWEEN_END, result);
				tween.remove(false);
			}
			super.end(event);
		}

		/**
		 * 让缓动立即到达最后一帧并结束
		 *
		 */
		public function submit() : void
		{
			if (tween)
				tween.remove(true);
		}
	}
}