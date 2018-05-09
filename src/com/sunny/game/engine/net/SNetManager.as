package com.sunny.game.engine.net
{
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.core.SUpdatable;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.lang.memory.SObjectPool;
	import com.sunny.game.engine.manager.SSynchroManager;
	import com.sunny.game.engine.manager.SUpdatableManager;
	import com.sunny.game.engine.ns.sunny_net;
	import com.sunny.game.engine.utils.SByteArray;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	use namespace sunny_net;

	/**
	 *
	 * <p>
	 * 一个网络管理器
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
	public class SNetManager extends SUpdatable
	{
		private static const MAX_QUEUE_LENGTH : uint = 20;

		private var _url : String;
		private var _port : int;

		private var _policyFileUrl : String;
		private var _policyFilePort : int;

		private static var _instance : SNetManager;

		private var _socket : SSocket;

		/**
		 * 禁止发送消息
		 * @param value
		 *
		 */
		public function set disabledSendMessage(value : Boolean) : void
		{
			_disabledSendMessage = value;
		}

		private var _notifyStartReconnect : Function;

		private var _notifyConnectCompleted : Function;

		private var _notifyDisconnected : Function;

		/**
		 * 模块化消息处理
		 */
		private var _notifiers : Dictionary = new Dictionary();

		private var _reconnectTick : int = 0;

		private var _reconnectTickAmount : int = 3;

		public var isDebug : Boolean;

		private var _disabledSendMessage : Boolean;

		private var _isPaused : Boolean;

		public function SNetManager()
		{
			_disabledSendMessage = false;
			_socket = new SSocket();
			_isPaused = false;
		}

		public function connect(url : String, port : int, policyFileUrl : String = null, policyFilePort : int = 843) : void
		{
			_url = url;
			_port = port;
			if (policyFileUrl)
				_policyFileUrl = policyFileUrl;
			else
				_policyFileUrl = _url;
			_policyFilePort = policyFilePort;
			Security.loadPolicyFile("xmlsocket://" + _policyFileUrl + ":" + _policyFilePort);
			_socket.addEventListener(Event.CONNECT, onConnect);
			_socket.addEventListener(Event.CLOSE, onClose);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			_socket.notifyMessageArrived(messageReceived);
			_socket.connect(_url, _port);

			if (SDebug.OPEN_INFO_TRACE)
				SDebug.infoPrint(this, "连接服务器...");
		}

		public static const DIS_CONNECT_TYPE_SPEED : String = "speed";
		public static const DIS_CONNECT_TYPE_WEB : String = "web";
		public static const DIS_CONNECT_TYPE_CLOSE : String = "close";
		public static const DIS_CONNECT_TYPE_ERROR : String = "error";
		public static const DIS_CONNECT_TYPE_RECONNECT : String = "reConnect";

		public function disconnect(type : String) : void
		{
			if (connected)
			{
				try
				{
					if (_socket)
						_socket.close();
					_disconnectedEvent = new Event(Event.CLOSE);
					invokeDisconnected(type);
				}
				catch (e : Error)
				{
					SDebug.errorPrint(this, e.getStackTrace());
				}
			}
			if (SDebug.OPEN_INFO_TRACE)
				SDebug.infoPrint(this, "断开服务器");
		}

		public function registerModule(module : String, notify : SINotifier) : Boolean
		{
			if (!notify)
				return false;
			_notifiers[module] = notify;
			return true;
		}

		public function unregisterModule(module : String) : Boolean
		{
			if (!module)
				return false;
			_notifiers[module] = null;
			delete _notifiers[module];
			return true;
		}

		public static function getInstance() : SNetManager
		{
			if (!_instance)
			{
				_instance = new SNetManager();
			}
			return _instance;
		}

		public function onNotifyConnected(notifyCompleted : Function) : SNetManager
		{
			_notifyConnectCompleted = notifyCompleted;
			return this;
		}

		public function onNotifyStartReconnect(startReconnect : Function) : SNetManager
		{
			_notifyStartReconnect = startReconnect;
			return this;
		}

		public function onNotifyDisconnected(notifyDisconnected : Function) : SNetManager
		{
			_notifyDisconnected = notifyDisconnected;
			return this;
		}

		private function invokeConnectCompleted(success : Boolean) : void
		{
			if (_notifyConnectCompleted != null)
			{
				_notifyConnectCompleted(success);
				_notifyConnectCompleted = null;
			}
			register(SUpdatableManager.PRIORITY_LAYER_HIGH);
		}

		private function invokeDisconnected(type : String) : void
		{
			if (SShellVariables.isSingleGame)
				return;
			if (_notifyDisconnected != null)
			{
				_notifyDisconnected(_disconnectedEvent, type);
				_notifyDisconnected = null;
			}
			unregister();
		}

		private function invokeStartReconnect() : void
		{
			if (_notifyStartReconnect != null)
			{
				_notifyStartReconnect();
				_notifyStartReconnect = null;
			}
		}

		/**
		 * 当前消息延迟，这个延迟值可以通过服务器发过来一个时间减去当前的同步时间得到
		 * 如果小于0，则说明服务上已经延迟
		 * @return
		 *
		 */
		public function get currMessageDelay() : int
		{
			return SSynchroManager.getInstance().serverDelayTime;
		}

		private function messageReceived(buffer : SByteArray) : void
		{
			if (!buffer)
				SDebug.errorPrint(this, "buffer 为空！");
			var id : int = buffer.readUnsignedShort();
			var notifyId : int = getNotifyId(id);
			var notify : SINotifier = getNotify(notifyId);
			if (notify)
			{
				var protocalId : int = getProtocalId(id);
				buffer.prosessError = notifyId + "," + protocalId;
				notify.onReceiveMessage(protocalId, buffer); //后11位消息号
				if (buffer.prosessError && buffer.bytesAvailable > 0)
				{
					buffer.prosessError = "消息模块为" + notifyId + "，协议为" + protocalId + "的消息剩余有效字节数" + buffer.bytesAvailable + "！";
					if (SDebug.OPEN_ERROR_TRACE)
						SDebug.errorPrint(this, buffer.prosessError);
				}
			}
			else
			{
				if (SDebug.OPEN_ERROR_TRACE)
					SDebug.errorPrint(this, "id为%s的消息模块未找到！", notifyId);
			}
		}

		/**
		 * 前五位模块号，后十一位消息号
		 * @param protocalId
		 * @return
		 *
		 */
		private function getNotify(notifyId : int) : SINotifier
		{
			return _notifiers[notifyId];
		}

		private function getNotifyId(id : int) : int
		{
			return id >> 10;
		}

		private function getProtocalId(id : int) : int
		{
			return id & 0x3ff;
		}

		public function send(buffer : ByteArray) : void
		{
			if (_socket.connected == false)
			{
				invokeDisconnected(DIS_CONNECT_TYPE_CLOSE + "1");
				return;
			}
			if (buffer.length == 0)
				return;
			_socket.writeBytes(buffer, 0, buffer.length);
			_socket.flush();
		}

		public function sendMessage(protocalId : int, ... params) : void
		{
			if (_disabledSendMessage)
				return;
			sendToSocket(protocalId, params);
		}

		/**
		 * 无视disabledSendMessage发送消息
		 * @param protocalId
		 * @param params
		 *
		 */
		public function forceSendMessage(protocalId : int, ... params) : void
		{
			sendToSocket(protocalId, params);
		}

		private static var _uniqueId : uint = 0;

		private function sendToSocket(protocalId : int, params : Array) : void
		{
			var buffer : SByteArray = SObjectPool.getObject(SByteArray);
			if (!buffer)
				buffer = new SByteArray();
			buffer.clear();
			//写协议号
			buffer.position = 2;
			buffer.writeShort(protocalId);

			/////////////////
			var uid : int = ++_uniqueId;
			if (uid == 255)
				_uniqueId = 0;
			var byteStrs : Array = uid.toString(2).split("");
			var strlen : uint = 8 - byteStrs.length;
			var VS : Array = [0, 0, 0, 0, 0, 0, 0, 0];
			for (var i : int = 7; i >= 0; i--)
			{
				var index : int = i - strlen;
				if (index >= 0)
					VS[i] = byteStrs[index];
				else
					break;
			}
			var V1 : String = VS[0] + "" + VS[1];
			var V2 : String = VS[2] + "" + VS[3];
			var V3 : String = VS[4] + "" + VS[5];
			var V4 : String = VS[6] + "" + VS[7];
			var valueStr : String = "";
			var mod : int = uid % 3;
			if (mod == 0)
				valueStr = V2 + V4 + V1 + V3;
			else if (mod == 1)
				valueStr = V4 + V2 + V3 + V1;
			else if (mod == 2)
				valueStr = V3 + V1 + V2 + V4;
			uid = parseInt(valueStr, 2);
			buffer.writeByte(uid);
			//////////////////

			buffer.writeParams(params);

			var len : int = buffer.position - 2;
			buffer.position = 0;
			//			//前2位写数据的长度
			buffer.writeShort(len);

			send(buffer);
			buffer.clear();
			SObjectPool.recycle(buffer, SByteArray);
		}

		private function onConnect(event : Event) : void
		{
			if (SDebug.OPEN_INFO_TRACE)
				SDebug.infoPrint(this, "服务器连接成功");
			invokeConnectCompleted(true);
		}

		private var _disconnectedEvent : Event;
		private var _isReconnectiong : Boolean;

		private function onSecurityError(event : SecurityErrorEvent) : void
		{
			_disconnectedEvent = event;
			reconnect();
		}

		private function onIoError(e : IOErrorEvent) : void
		{
			_disconnectedEvent = e;
			invokeDisconnected(DIS_CONNECT_TYPE_ERROR);
		}

		private function onClose(event : Event) : void
		{
			_disconnectedEvent = event;
			invokeDisconnected(DIS_CONNECT_TYPE_CLOSE);
		}

		private function reconnect() : void
		{
			if (_reconnectTick < _reconnectTickAmount)
			{
				if (_reconnectTick == 0)
				{
					invokeStartReconnect();
				}
				if (SDebug.OPEN_INFO_TRACE)
					SDebug.infoPrint(this, "正在尝试进行" + _reconnectTick + "次重新连接服务器");
				clearListener();
				_socket = new SSocket();
				connect(_url, _port, _policyFileUrl, _policyFilePort);
				_reconnectTick += 1;
			}
			else
			{
				_reconnectTick = 0;
				if (SDebug.OPEN_INFO_TRACE)
					SDebug.infoPrint(this, "尝试连接服务器" + _reconnectTick + "次失败");
				invokeDisconnected(DIS_CONNECT_TYPE_RECONNECT);
			}
		}

		private function clearListener() : void
		{
			_socket.removeEventListener(Event.CONNECT, onConnect);
			_socket.removeEventListener(Event.CLOSE, onClose);
			_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_socket.clearMessageNotify();
		}

		public function get connected() : Boolean
		{
			return _socket.connected;
		}

		public function pause() : void
		{
			_isPaused = true;
		}

		public function resume() : void
		{
			_isPaused = false;
		}
	}
}
