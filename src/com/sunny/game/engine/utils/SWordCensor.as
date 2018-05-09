package com.sunny.game.engine.utils
{

	/**
	 *
	 * <p>
	 * SunnyGame的一个敏感词汇审查器
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
	public class SWordCensor
	{
		private static var _instance : SWordCensor;

		public static function getInstance() : SWordCensor
		{
			if (_instance == null)
			{
				_instance = new SWordCensor();
			}
			return _instance;
		}

		/**
		 * 敏感词汇根节点
		 */
		private var _sensitiveWordsRoot : STreeNode;

		/**
		 * 解析词汇表
		 * @param value
		 */
		public function parseSensitiveWords(value : String) : void
		{
			_sensitiveWordsRoot = new STreeNode();
			_sensitiveWordsRoot.value = "";
			var lines : Array = value.split("\r\n");
			if (lines && lines.length > 0 && !lines[lines.length - 1])
				lines.pop(); //去掉最后的空白
			lines.shift(); //去掉第一行描述
			var textLine : String;
			var fieldArray : Array;
			var field : String;
			var j : int;
			var i : int;
			for (i = 0; i < lines.length; i++)
			{
				textLine = lines[i];
				if (textLine)
				{
					fieldArray = textLine.split(",");
					registerWords(fieldArray, _sensitiveWordsRoot);
				}
			}
		}

		/**
		 * 判断是否有敏感词
		 * @param info
		 * @return
		 */
		public function hasSensitive(info : String) : Boolean
		{
			return checkSensitiveWords(info, _sensitiveWordsRoot);
		}

		/**
		 * 过滤敏感词
		 * @param info
		 * @return
		 */
		public function filterWords(info : String) : String
		{
			return filterSensitiveWords(info, _sensitiveWordsRoot);
		}

		/**
		 * 注册词汇
		 * 这是一个预处理步骤，生成敏感词索引树，功耗大于查找时使用的方法，但只在程序开始时调用一次。
		 * @param words
		 * @param treeNode
		 */
		private function registerWords(words : Array, treeNode : STreeNode) : void
		{
			var wordsLen : int = words.length;
			var word : String;
			var len : int;
			var currentBranch : STreeNode;
			var char : String;
			var node : STreeNode;
			for (var i : int = 0; i < wordsLen; i++)
			{
				word = words[i];
				if (!word)
					continue;
				len = word.length;
				currentBranch = treeNode;
				for (var j : int = 0; j < len; j++)
				{
					currentBranch.isLeaf = false;
					char = word.charAt(j);
					node = currentBranch.getChild(char);
					if (node)
					{
						currentBranch = node;
						if (j == len - 1)
							currentBranch.isFullWords = true;
					}
					else
					{
						currentBranch = currentBranch.setChild(char);
						if (j == len - 1)
						{
							currentBranch.setChild("");
							currentBranch.isFullWords = true;
						}
					}
				}
			}
		}

		/**
		 * 查找并判断是否有敏感词
		 * @param og
		 * @param treeNode
		 * @return
		 */
		private function checkSensitiveWords(value : String, treeNode : STreeNode) : Boolean
		{
			var ptrs : Array = new Array(); //嫌疑列表，只要是前几个字匹配成功的节点都放在这里
			var len : int = value.length;
			var tmp : STreeNode;
			for (var c : int = 0; c < len; c++)
			{
				var char : String = value.charAt(c);
				//如果嫌疑列表内有数据，先对其进行检验，检查char是否是嫌疑列表中某节点的下一个字
				var p : int = ptrs.length;
				while (p--)
				{
					var node : STreeNode = ptrs.shift();
					tmp = node.getChild(char);
					if (tmp)
					{
						if (tmp.getChild(""))
						{
							return true;
						}
						ptrs.push(tmp);
					}
				}
				tmp = treeNode.getChild(char);
				if (tmp)
				{
					if (tmp.getChild(""))
					{
						return true;
					}
					ptrs.push(tmp);
				}
			}
			return false;
		}

		/**
		 * 过滤敏感词
		 * @param og
		 * @return
		 */
		private function filterSensitiveWords(value : String, treeNode : STreeNode) : String
		{
			var preList : Array = []; //嫌疑列表，只要是前几个字匹配成功的节点都放在这里
			var wordArr : Array = [];
			var len : int = value.length;
			var childNode : STreeNode;
			for (var c : int = 0; c < len; c++)
			{
				var char : String = value.charAt(c);
				if (char != " " && char != "*") //单个*
				{
					//如果嫌疑列表内有数据，先对其进行检验，检查char是否是嫌疑列表中某节点的下一个字
					var p : int = preList.length;
					//while (p--)
					for (var j : int = 0; j < p; j++)
					{
						var node : STreeNode = preList[j]; //ptrs.shift();
						childNode = node.getChild(char);
						if (childNode)
						{
							if (childNode.getChild("")) //单个字词
							{
								wordArr.push(childNode.getWords());
							}
							else
							{
								preList.push(childNode);
							}
						}
					}

					childNode = treeNode.getChild(char);
					if (childNode)
					{
						if (childNode.getChild("")) //单个字词
						{
							wordArr.push(childNode.getWords());
						}
						else
						{
							preList.push(childNode);
						}
					}
				}
			}

			if (wordArr.length > 0)
			{
				value = replaceWords(value, wordArr);
			}
			if (preList.length > 0)
			{
				wordArr.length = 0;
				for (var i : int = 0; i < preList.length; i++)
				{
					childNode = preList[i];
					if (childNode.isFullWords) //完整字词 
						wordArr.push(childNode.getWords());
				}
				if (wordArr.length > 0) //整个词组 
					value = replaceWords(value, wordArr);
			}
			return value;
		}

		private function replaceWords(value : String, words : Array) : String
		{
			var str : String;
			for (var i : int = words.length - 1; i >= 0; i--)
			{
				str = words[i];
				var rstr : String = "";
				var rstrLen : int = str.length;
				while (rstrLen)
				{
					rstr += "**";
					rstrLen--;
				}
				value = value.replace(str, rstr);

				//强化部分
				var frontIndex : int = value.toLowerCase().indexOf(str.charAt(0));
				var lastIndex : int = value.toLowerCase().indexOf(str.charAt(str.length - 1));

				if (frontIndex >= 0 && lastIndex >= 0 && lastIndex >= frontIndex)
				{
					var count : int = lastIndex - frontIndex - 1;
					var reg : RegExp = /^[a-zA-Z0-9\u4e00-\u9fa5]+$/;
					var testStr : String = value.substring(frontIndex + 1, lastIndex + 1);
					if (count <= 2 || !reg.test(testStr)) //用符号相隔的或是间隔文字少于2个的
					{
						rstr = "";
						rstrLen = lastIndex - frontIndex + 1;
						while (rstrLen)
						{
							rstr += "**";
							rstrLen--;
						}
						value = value.substring(0, frontIndex) + rstr + value.substring(lastIndex + 1);
					}
				}
			}
			return value;
		}
	}
}

class STreeNode
{
	private var data : Object;
	/**
	 * 是否叶节点
	 */
	public var isLeaf : Boolean;
	public var parent : STreeNode;
	public var value : String;
	public var isFullWords : Boolean;

	public function STreeNode()
	{
		data = {};
		isLeaf = true;
		isFullWords = false;
	}

	public function getChild(name : String) : STreeNode
	{
		name = name.toLowerCase();
		return data[name];
	}

	public function setChild(key : String) : STreeNode
	{
		key = key.toLowerCase();
		var node : STreeNode = new STreeNode;
		data[key] = node;
		node.value = key;
		node.parent = this;
		return node;
	}

	public function getWords() : String
	{
		var rt : String = this.value;
		var node : STreeNode = this.parent;
		while (node)
		{
			rt = node.value + rt;
			node = node.parent;
		}
		return rt;
	}
}