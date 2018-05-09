package com.sunny.game.engine.manager
{
	import com.sunny.game.engine.core.SUpdatable;
	import com.sunny.game.engine.events.SEvent;
	import com.sunny.game.engine.lang.STime;
	import com.sunny.game.engine.net.SNetManager;
	import com.sunny.game.engine.utils.SByteArray;
	
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 *
	 * <p>
	 * SunnyGame的同步管理器
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
	public class SSynchroManager extends SUpdatable
	{
		public static const EVENT_SYNC_PING : String = "EVENT_SYNC_PING";
		public static const EVENT_SYNC_TIME : String = "EVENT_SYNC_TIME";

		private static var _instance : SSynchroManager;

		/**
		 * 角色相关同步包
		 */
		private var _heroId2SyncMoveData : Dictionary = new Dictionary();
		private var _monsterId2SyncMoveData : Dictionary = new Dictionary();

		/**
		 * 请求同步时间差的客户端时间
		 */
		private var _requestDeltaClientTimes : Array = [];
		/**
		 * 请求延时时间
		 */
		private var _requestDelayTimes : Array = [];
		/**
		 * 服务器时间减去客户端时间的差额
		 */
		private var _svrClientDeltaTime : Number = 0;

		/**
		 * 从客户端发送命令到服务器收到命令之间的时间,即延时时间
		 */
		private var _pingDelayTime : Number = 0;

		/**
		 * 服务器同步时间结束回调函数
		 * signature: void complete(success : Boolean) : void
		 */
		private var _notifySyncTimeCompleted : Function;

		/**
		 * 当前已经同步的次数
		 */
		private var _syncDeltaCount : int;
		/**
		 * 需要和服务器同步时间的次数
		 */
		private var _syncDeltaMaxCount : int = 0;

		private var _syncTickElapsedTime : int = 0;
		private var _needSyncTicked : int = 60000; //一分钟同步一次

		private var _syncPingElapsedTime : int = 0;
		private var _syncPingTime : int = 5000; //1秒ping一次

		private var _processDeltaElapsedTime : int = 0;

		private var _nextFreezeTime : int;
		private var _freezeEnable : Boolean;

		public function SSynchroManager()
		{
			_syncTickElapsedTime = _needSyncTicked;
			_syncPingElapsedTime = _syncPingTime;
			frameTimes = 200;
			_nextFreezeTime = 0;
			_freezeEnable = true;
		}

		public static function getInstance() : SSynchroManager
		{
			if (!_instance)
			{
				_instance = new SSynchroManager();
			}
			return _instance;
		}

		public function run() : void
		{
			update();
			register(SUpdatableManager.PRIORITY_LAYER_HIGH);
		}

		override public function update() : void
		{
			//定期同步服务器与本地的时间
			_syncTickElapsedTime += elapsedTimes;
			if (_syncTickElapsedTime >= _needSyncTicked)
			{
				_syncTickElapsedTime = 0;
				syncDeltaTime();
				_processDeltaElapsedTime += elapsedTimes;
				if (_processDeltaElapsedTime >= 30000) //半分钟重置最小延时
				{
					_minDelay = int.MAX_VALUE;
					_processDeltaElapsedTime = 0;
				}
			}

			_syncPingElapsedTime += elapsedTimes;
			if (_syncPingElapsedTime >= _syncPingTime)
			{
				_syncPingElapsedTime = 0;
				syncDelayTime();
			}

			if (_nextFreezeTime > 0)
				_nextFreezeTime -= elapsedTimes;
			if (_nextFreezeTime < 0)
				_nextFreezeTime = 0;

			if (_pingDelayTime >= 1000000) //300,暂时屏蔽加大延迟
			{
				if (_freezeEnable)
				{
					if (_nextFreezeTime == 0)
					{
						SNetManager.getInstance().pause();
						_nextFreezeTime = _pingDelayTime;
						_freezeEnable = false;
					}
				}
				else
				{
					if (_nextFreezeTime == 0)
					{
						SNetManager.getInstance().resume();
						_nextFreezeTime = 300;
						_freezeEnable = true;
					}
				}
			}
			else
			{
				SNetManager.getInstance().resume();
				_nextFreezeTime = 0;
				_freezeEnable = true;
			}
		}

		override public function destroy() : void
		{
			unregister();
			super.destroy();
		}

		public function get pingDelayTime() : Number
		{
			return _pingDelayTime;
		}

		public function get serverDelayTime() : Number
		{
			return _pingDelayTime * 0.5;
		}

		/**
		 * 与服务器的时间差
		 * @return
		 */
		public function get svrClientDeltaTime() : Number
		{
			return _svrClientDeltaTime;
		}

		/**
		 * 预测的服务器时间
		 * @return
		 */
		public function get serverTime() : Number
		{
			var curDate : Date = new Date();
			return curDate.getTime() + _svrClientDeltaTime;
		}

		private var serverDate : Date = new Date();

		public function getServerDate() : Date
		{
			serverDate.setTime(serverTime);
			return serverDate;
		}

		public function getSyncMovementDatasByHeroId(roleId : int) : Array
		{
			var syncMovs : Array = _heroId2SyncMoveData[roleId];
			if (!syncMovs)
			{
				syncMovs = [];
				_heroId2SyncMoveData[roleId] = syncMovs;
			}
			return syncMovs;
		}

		public function getSyncMovementDatasByMonsterId(roleId : int) : Array
		{
			var syncMovs : Array = _monsterId2SyncMoveData[roleId];
			if (!syncMovs)
			{
				syncMovs = [];
				_monsterId2SyncMoveData[roleId] = syncMovs;
			}
			return syncMovs;
		}

		public function clearServerSyncDatas(roleId : int, isHero : Boolean) : void
		{
			if (isHero)
			{
				if (_heroId2SyncMoveData[roleId])
				{
					_heroId2SyncMoveData[roleId] = null;
					delete _heroId2SyncMoveData[roleId];
				}
			}
			else
			{
				if (_monsterId2SyncMoveData[roleId])
				{
					_monsterId2SyncMoveData[roleId] = null;
					delete _monsterId2SyncMoveData[roleId];
				}
			}
		}

		public function clearSyncDatas() : void
		{
			var syncMovs : Array;
			for each (syncMovs in _heroId2SyncMoveData)
			{
				if (syncMovs)
					syncMovs.length = 0;
			}
			_heroId2SyncMoveData = new Dictionary();
			for each (syncMovs in _monsterId2SyncMoveData)
			{
				if (syncMovs)
					syncMovs.length = 0;
			}
			_monsterId2SyncMoveData = new Dictionary();
		}

		//收到服务器消息15分一次时会将此值刷新为最大值
		private var _minDelay : int = int.MAX_VALUE;

		public function processSyncDeltaTime(buffer : SByteArray) : void
		{
			var serverTime : Number = buffer.readLong();
			//最先请求的消息会最早收到返回消息，则利用数组来存储请求的系统时间
			var requestSyncTime : Number = _requestDeltaClientTimes.shift();
			var curTime : Number = (new Date()).getTime();
			var delay : int = (curTime - requestSyncTime); //从客户端到服务器再回到客户端，往返时间一半
			var deltaTime : Number = serverTime - (requestSyncTime + delay / 2);

			if (_minDelay == int.MAX_VALUE)
			{ //第一次
				_svrClientDeltaTime = deltaTime;
			}
			else if (delay <= _minDelay)
			{ //取最小网络延时的时间差为准，网络延时越小，时间差应该是最精确的,当延时相等时则取小的延时差为准
				_svrClientDeltaTime = deltaTime;
			}
			//取当前所有同步次数的最小值
			_minDelay = Math.min(_minDelay, delay);
			var msg : String = "与服务器的延迟时间:" + _pingDelayTime + " ,当前与服务器的时间差:" + deltaTime + '使用的时间差：' + _svrClientDeltaTime + ',服务器时间:' + serverTime + ',客户端请求系统时间:' + requestSyncTime;
			trace(msg);
		}

		public function serverNotifySyncDeltaTime() : void
		{
			_minDelay = int.MAX_VALUE;
			requestSyncDeltaTime();
		}

		/**
		 * 同步服务器与客户端的时间差
		 * @param notifyCompleted
		 * @param count 次数
		 */
		public function syncDeltaTime(notifyCompleted : Function = null, count : int = 15) : void
		{
			_notifySyncTimeCompleted = notifyCompleted;
			_syncDeltaCount = 0;
			_syncDeltaMaxCount = count;
			requestSyncDeltaTime();
		}

		private function requestSyncDeltaTime() : void
		{
			var requestTime : Number = (new Date()).getTime();
			_requestDeltaClientTimes.push(requestTime);
			SEvent.dispatchEvent(EVENT_SYNC_TIME);
		}

		/**
		 * 同步延时
		 */
		public function syncDelayTime() : void
		{
			var requestTime : int = getTimer();
			_requestDelayTimes.push(requestTime);
			SEvent.dispatchEvent(EVENT_SYNC_PING);
		}

		/**
		 * 收到服务器返回延时消息
		 */
		public function notifySyncDelayTime() : void
		{
			var requestSyncTime : int = _requestDelayTimes.shift();
			var curTime : int = getTimer();
			var delayTime : int = (curTime - requestSyncTime); //从客户端到服务器再回到客户端的往返时间一半
			_pingDelayTime = delayTime;
		}

		private function invokeSyncTimeCompleted() : void
		{
			if (_notifySyncTimeCompleted != null)
			{
				_notifySyncTimeCompleted(true);
				_notifySyncTimeCompleted = null;
			}
		}

		public function toString() : String
		{
			return 'SSynchroManager';
		}
	}
}
