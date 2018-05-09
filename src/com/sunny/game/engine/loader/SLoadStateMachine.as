package com.sunny.game.engine.loader
{
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.lang.errors.SunnyGameEngineError;

	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 *
	 * <p>
	 * SunnyGame的一个加载状态机
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
	public class SLoadStateMachine
	{
		private static var _instance : SLoadStateMachine;
		private var _stateDic : Dictionary;
		private var _preloadSet : Array;
		private var _currNode : SILoadNode;
		private var _startTime : Number;
		private var _isRunning : Boolean;

		public static function getInstance() : SLoadStateMachine
		{
			if (!_instance)
			{
				_instance = new SLoadStateMachine();
			}
			return _instance;
		}

		public function SLoadStateMachine()
		{
			_stateDic = new Dictionary();
			_preloadSet = [];
			_isRunning = false;
		}

		public function get isRunning() : Boolean
		{
			return _isRunning;
		}

		public function pushState(node : SILoadNode) : void
		{
			if (_stateDic[node.getState()])
				throw new SunnyGameEngineError("加载节点已存在！");
			_stateDic[node.getState()] = node;
		}

		public function addPreState(state : String) : void
		{
			var loadNode : SILoadNode = _stateDic[state];
			if (loadNode)
			{
				if (_preloadSet.indexOf(loadNode) == -1)
				{
					_preloadSet.push(loadNode);
				}
			}
		}

		public function insertPreState(state : String) : void
		{
			var loadNode : SILoadNode = _stateDic[state];
			if (loadNode)
			{
				if (_preloadSet.indexOf(loadNode) == -1)
				{
					var index : int = _preloadSet.indexOf(_currNode);
					_preloadSet.splice(index + 1, 0, loadNode);
				}
			}
		}

		public function run() : void
		{
			if (!_isRunning)
			{
				if (_preloadSet.length > 0)
				{
					_isRunning = true;
					nextNode();
				}
			}
		}

		public function free() : void
		{
			_preloadSet.length = 0;
			_currNode = null;
			_isRunning = false;
		}

		public function forceComplete() : void
		{
			if (_currNode)
				_currNode.forceComplete();
		}

		private function onCompleteNotify() : void
		{
			if (_currNode)
				laterCompleteNotify();
		}

		private function laterCompleteNotify() : void
		{
			var index : int = _preloadSet.indexOf(_currNode);
			if (index != -1)
				_preloadSet.splice(index, 1);
			if (SDebug.OPEN_INFO_TRACE)
				SDebug.debugPrint(this, "预加载：" + _currNode.getState(), "结束 耗时：" + (getTimer() - _startTime) + "ms");
			if (_preloadSet.length > 0)
			{
				nextNode();
			}
			else
			{
				free();
			}
		}

		private function nextNode() : void
		{
			var loadNode : SILoadNode = _preloadSet.shift() as SILoadNode;
			if (loadNode)
			{
				_currNode = loadNode;
				if (SDebug.OPEN_INFO_TRACE)
					SDebug.debugPrint(this, "预加载：" + _currNode.getState() + "开始...");
				_currNode.setOnCompleteNotify(onCompleteNotify);
				_startTime = getTimer();
				_currNode.startLoad();
			}
		}

		public function get currState() : String
		{
			return _currNode ? _currNode.getState() : null;
		}

		public function get currNode() : SILoadNode
		{
			return _currNode;
		}
	}
}