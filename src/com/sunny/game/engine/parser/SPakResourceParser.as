package com.sunny.game.engine.parser
{
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.events.SThreadEvent;
	import com.sunny.game.engine.fileformat.pak.SAnimationDecoder;
	import com.sunny.game.engine.fileformat.pak.SDirectAnimationDecoder;
	import com.sunny.game.engine.loader.SLoadPriorityType;
	import com.sunny.game.engine.manager.SReferenceManager;
	import com.sunny.game.engine.manager.SResourceManager;
	import com.sunny.game.engine.ns.sunny_engine;
	import com.sunny.game.engine.render.base.SNormalBitmapData;

	import flash.geom.Point;
	import flash.utils.ByteArray;

	use namespace sunny_engine;

	/**
	 *
	 * <p>
	 * SunnyGame的pak资源解析器
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
	public class SPakResourceParser extends SSunnyResourceParser
	{
		/**
		 * 编辑器需要用到 
		 */
		public var dirs : Array;
		/**
		 * 正在加载的
		 */
		protected static var load_list : Array = [];
		/**
		 * 需要加载的
		 */
		protected static var need_send_list : Array = [];
		/**
		 * 最大加载的数量
		 */
		protected static const COUNT : int = 2;
		/**
		 * 是否需要排序
		 */
		protected static var isSort : Boolean;

		/**
		 * 每次加载完成，实行下一个加载
		 *
		 */
		public static function sendLoadMessage() : void
		{
			if (load_list.length < COUNT && need_send_list.length > 0)
			{
				if (isSort)
				{
					need_send_list.sort(load_sort);
					isSort = false;
				}
				var send_arr : Array = need_send_list.shift();
				load_list.push(send_arr)
				SThreadEvent.dispatchEvent(SThreadEvent.LOAD_SEND, send_arr);
			}
		}

		protected static function load_sort(a : Array, b : Array) : int
		{
			if (a[2] < b[2])
				return 1;
			if (a[2] > [2])
				return -1;
			return 0;
		}

		public static function removeLoadMessage(id : String) : void
		{
			var len : int = load_list.length;
			for (var i : int = 0; i < len; i++)
			{
				if (load_list[i][0] == id)
				{
					load_list.splice(i, 1);
					break;
				}
			}
		}

		protected var _decoder : SDirectAnimationDecoder;
		protected var _isDirect : Boolean;

		public function SPakResourceParser(id : String, version : String = null, priority : int = SLoadPriorityType.MAX, isDirect : Boolean = false)
		{
			super(id, version, priority);
			this._isDirect = isDirect;
		}

		public function get isDirect() : Boolean
		{
			return _isDirect;
		}

		override sunny_engine function parse(bytes : ByteArray) : void
		{
			if (!bytes)
				return;
			decoder = SReferenceManager.getInstance().createDirectAnimationDeocder(_id, _isDirect);
			_decoder.addNotify(onParseCompleted);
			_decoder.decode(bytes, false);
		}

		protected function set decoder(value : SDirectAnimationDecoder) : void
		{
			if (_decoder)
				_decoder.release();
			_decoder = value;
		}


		override protected function checkResource() : void
		{
			if (SShellVariables.isMultiThreadLoad && SResourceManager.getInstance().getResource(_id) == null)
				loadThreadResource();
			else
				loadResource();
		}

		protected function loadThreadResource() : void
		{
			decoder = SReferenceManager.getInstance().createDirectAnimationDeocder(_id, _isDirect);
			if (_decoder.isCompleted)
				parseComplete(_decoder);
			else
				_decoder.addNotify(parseComplete);
			if (!_decoder.isSend)
			{
				_decoder.isSend = true;

				if (load_list.length > COUNT)
				{
					need_send_list.push([_id, version, priority]);
					isSort = true;
				}
				else
				{
					var send_arr : Array = [_id, version, priority];
					load_list.push(send_arr);
					SThreadEvent.dispatchEvent(SThreadEvent.LOAD_SEND, send_arr);
				}
			}
		}

		/**
		 * 解析完成
		 * @param pak
		 *
		 */
		public function parseComplete(pak : SDirectAnimationDecoder) : void
		{
			onParseCompleted(null);
		}

		protected function onParseCompleted(decoder : SAnimationDecoder) : void
		{
			parseCompleted();
		}

		public function getLength() : int
		{
			if (_isDisposed) //已经被取消了
				return 0;
			if (_decoder)
				return _decoder.length;
			return 0;
		}

		public function get width() : int
		{
			if (_decoder)
				return _decoder.width;
			return 0;
		}

		public function get height() : int
		{
			if (_decoder)
				return _decoder.height;
			return 0;
		}

		/**
		 * 根据帧得到位图，帧指的是整个动画文件的帧序列号
		 * @param frame
		 * @return
		 *
		 */
		public function getBitmapDataByFrame(frame : int) : SNormalBitmapData
		{
			if (_isDisposed) //已经被取消了
				return null;
			if (_decoder)
				return _decoder.getResult(frame - 1);
			return null;
		}

		public function getOffset(index : int, dir : String = null) : Point
		{
			if (_isDisposed)
				return null;
			if (_decoder)
				return _decoder.getOffest(index);
			return null;
		}

		override protected function destroy() : void
		{
			if (_isDisposed)
				return;
			decoder = null;
			super.destroy();
		}
	}
}