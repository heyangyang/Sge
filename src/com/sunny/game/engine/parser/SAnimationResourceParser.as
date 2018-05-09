package com.sunny.game.engine.parser
{
	import com.sunny.game.engine.animation.SAnimationDescription;
	import com.sunny.game.engine.events.SThreadEvent;
	import com.sunny.game.engine.loader.SLoadPriorityType;
	import com.sunny.game.engine.manager.SReferenceManager;
	import com.sunny.game.engine.ns.sunny_engine;
	import com.sunny.game.engine.render.base.SNormalBitmapData;
	import com.sunny.game.engine.render.interfaces.SIBitmapData;

	import flash.geom.Point;

	use namespace sunny_engine;

	/**
	 *
	 * <p>
	 * SunnyGame的动画资源解析器
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
	public class SAnimationResourceParser extends SPakResourceParser
	{
		protected var action_name : String;
		private var cur_dir : String;

		public function SAnimationResourceParser(desc : SAnimationDescription, priority : int = SLoadPriorityType.EFFECT, isDirect : Boolean = false)
		{
			super(desc.url, desc.version, priority, isDirect);
			cur_dir = desc.id.substring(desc.id.length - 1);
		}

		override protected function loadThreadResource() : void
		{
			var cur_id : String = _id;
			if (_isDirect)
			{
				var tmp : Array = id.split("/");
				tmp.pop();
				tmp[0] = "avatar_atf";
				tmp.push(tmp[1] + ".xtf");
				cur_id = tmp.join("/");
			}
			if (action_name == null)
				action_name = id.split("/").pop().split(".").shift();
			decoder = SReferenceManager.getInstance().createDirectAnimationDeocder(cur_id, _isDirect);
			if (!_decoder.isCompleted)
				_decoder.addNotify(parseComplete);
			else
				parseComplete(_decoder);
			if (!_decoder.isSend)
			{
				_decoder.isSend = true;

				//直接用使用atf加载，不经过多线程
				if (_isDirect)
				{
					_decoder.startXtfLoad(version, priority);
					return;
				}

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
		 * 根据帧得到位图，帧指的是整个动画文件的帧序列号
		 * @param frame
		 * @return
		 *
		 */
		override public function getBitmapDataByFrame(frame : int) : SNormalBitmapData
		{
			if (_isDisposed) //已经被取消了
				return null;
			if (_decoder)
				return _decoder.getResult(frame - 1, cur_dir);
			return null;
		}

		public function getBitmapDataByDir(frame : int, dir : String = null) : SIBitmapData
		{
			if (_isDisposed) //已经被取消了
				return null;
			if (dir == null)
				dir = cur_dir;
			if (_decoder)
				return _decoder.getDirResult(action_name, frame - 1, dir);
			return null;
		}

		override public function getOffset(index : int, dir : String = null) : Point
		{
			if (_isDisposed)
				return null;
			if (dir == null)
				dir = cur_dir;
			if (_decoder)
				return _decoder.getDirOffest(action_name, index, dir);
			return null;
		}
	}
}