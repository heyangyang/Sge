package com.sunny.game.engine.operation.quest
{
	import com.sunny.game.engine.utils.data.SBitArray;

	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;

	[Event(name="quest_start", type="com.sunny.game.engine.operation.quest.SOperQuestEvent")]
	[Event(name="quest_complete", type="com.sunny.game.engine.operation.quest.SOperQuestEvent")]

	/**
	 * 任务组
	 *
	 *
	 *
	 */
	public class SOperQuestGroup extends EventDispatcher
	{
		/**
		 * 开始列表
		 */
		public var startList : SBitArray;

		/**
		 * 完成列表
		 */
		public var finishList : SBitArray;

		/**
		 * 任务定义列表
		 */
		public var quests : Array = [];

		/**
		 * 任务进度列表
		 * @return
		 *
		 */
		public function get stepList() : Array
		{
			var result : Array = [];
			for (var i : int = 0; i < quests.length; i++)
				result.push((quests[i] as SOperQuest).step)

			return result;
		}

		public function SOperQuestGroup()
		{
			startList = new SBitArray();
			finishList = new SBitArray();
		}

		/**
		 * 载入任务
		 *
		 * @param quests	任务定义列表
		 * @param startList	是否开始列表
		 * @param finishList	是否结束列表
		 * @param stepList	任务进度列表
		 *
		 */
		public function load(quests : Array, startList : SBitArray = null, finishList : SBitArray = null, stepList : Array = null) : void
		{
			this.quests = quests;
			this.startList = startList;
			this.finishList = finishList;

			for (var i : int = 0; i < quests.length; i++)
			{
				var q : SOperQuest = quests[i] as SOperQuest;
				q.addEventListener(SOperQuestEvent.QUEST_START, questStartHandler);
				q.addEventListener(SOperQuestEvent.QUEST_COMPLETE, questCompleteHandler);

				if (stepList)
					q.step = stepList[i];

				if (startList.getValue(q.id))
					q.start();
			}
		}

		/**
		 * 从一个二进制数据中载入
		 *
		 * @param quests	任务定义列表
		 * @param bytes	数据
		 *
		 */
		public function loadFromByteArray(quests : Array, bytes : ByteArray) : void
		{
			var i : int;
			var arr : Array;
			var len : int = bytes.readUnsignedInt();
			arr = [];
			for (i = 0; i < len; i++)
				arr.push(bytes.readUnsignedInt());

			var startList : SBitArray = new SBitArray();
			startList.createFromIntArray(arr);

			len = bytes.readUnsignedInt();
			arr = [];
			for (i = 0; i < len; i++)
				arr.push(bytes.readUnsignedInt());

			var finishList : SBitArray = new SBitArray();
			finishList.createFromIntArray(arr);

			len = bytes.readUnsignedInt();
			var stepList : Array = [];
			for (i = 0; i < len; i++)
				stepList.push(bytes.readUnsignedInt());

			load(quests, startList, finishList, stepList);
		}

		/**
		 * 获得可保存的数据
		 * @return
		 *
		 */
		public function getByteArray() : ByteArray
		{
			var bytes : ByteArray = new ByteArray();
			var arr : Array;
			var i : int;
			arr = startList.toIntArray();
			bytes.writeUnsignedInt(arr.length);
			for (i = 0; i < arr.length; i++)
				bytes.writeUnsignedInt(arr[i]);

			arr = finishList.toIntArray();
			bytes.writeUnsignedInt(arr.length);
			for (i = 0; i < arr.length; i++)
				bytes.writeUnsignedInt(arr[i]);

			arr = stepList.concat();
			bytes.writeUnsignedInt(arr.length);
			for (i = 0; i < arr.length; i++)
				bytes.writeUnsignedInt(arr[i]);

			return bytes;
		}

		/**
		 * 由ID获得任务
		 *
		 * @param id
		 * @return
		 *
		 */
		public function getQuestById(id : int) : SOperQuest
		{
			for (var i : int = 0; i < quests.length; i++)
			{
				var q : SOperQuest = finishList[i] as SOperQuest;
				if (q.id == id)
					return q;
			}
			return null;
		}

		private function questStartHandler(event : SOperQuestEvent) : void
		{
			startList.setValue(event.id, true);
			dispatchEvent(event);
		}

		private function questCompleteHandler(event : SOperQuestEvent) : void
		{
			finishList.setValue(event.id, true);
			dispatchEvent(event);
		}

		/**
		 * 销毁
		 *
		 */
		public function destory() : void
		{
			for each (var q : SOperQuest in quests)
				q.destory();
		}
	}
}