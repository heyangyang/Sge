package com.sunny.game.engine.core
{
	import com.sunny.game.engine.ns.sunny_engine;

	use namespace sunny_engine;

	/**
	 *
	 * <p>
	 * SunnyGame的一个节点
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
	public class SNode extends SObject implements SINode
	{
		protected var _parent : SINode;
		protected var _children : Vector.<SINode>;
		protected var _name : String;
		protected var _isDisposed : Boolean;

		public function SNode()
		{
			_children = new <SINode>[];
			_name = null;
			_parent = null;
			_isDisposed = false;
		}

		public function removeFromParent() : void
		{
			if (_parent)
				_parent.removeChild(this);
		}

		public function get root() : SINode
		{
			var currentNode : SINode = this;
			while (currentNode.parent)
				currentNode = currentNode.parent;
			return currentNode;
		}

		public function get isRoot() : Boolean
		{
			return root == this;
		}

		public function addChild(child : SINode) : SINode
		{
			addChildAt(child, numChildren);
			return child;
		}

		internal function setParent(value : SINode) : void
		{
			//检查递归
			var ancestor : SINode = value;
			while (ancestor != this && ancestor != null)
				ancestor = ancestor.parent;
			if (ancestor == this)
				throw new ArgumentError("不能添加自身或子节点作为父节点！");
			else
				_parent = value;
		}

		public function addChildAt(child : SINode, index : int) : SINode
		{
			var numChildren : int = _children.length;

			if (index >= 0 && index <= numChildren)
			{
				if (child.parent == this)
				{
					setChildIndex(child, index);
				}
				else
				{
					child.removeFromParent();
					if (index == numChildren)
						_children[numChildren] = child;
					else
						_children.splice(index, 0, child);
					(child as SNode).setParent(this);
				}
				if (_addChildFunction != null)
					_addChildFunction(child);
				return child;
			}
			else
			{
				throw new RangeError("Invalid child index!");
			}
		}

		private var _addChildFunction : Function;

		/**
		 * 设置该方法在添加子节点时会执行指向的方法
		 * @param func function(child:SINode):void
		 *
		 */
		public function setAddChildFunction(func : Function) : void
		{
			_addChildFunction = func;
		}

		public function removeChild(child : SINode) : SINode
		{
			var childIndex : int = getChildIndex(child);
			if (childIndex != -1)
				removeChildAt(childIndex);
			return child;
		}

		public function removeChildAt(index : int) : SINode
		{
			if (index >= 0 && index < numChildren)
			{
				var child : SINode = _children[index];
				(child as SNode).setParent(null);
				if (index != -1)
					_children.splice(index, 1);
				return child;
			}
			else
			{
				throw new RangeError("Invalid child index");
			}
		}

		public function removeChildren(beginIndex : int = 0, endIndex : int = -1) : void
		{
			if (endIndex < 0 || endIndex >= numChildren)
				endIndex = numChildren - 1;
			for (var i : int = beginIndex; i <= endIndex; ++i)
				removeChildAt(beginIndex);
		}

		public function getChildAt(index : int) : SINode
		{
			if (index >= 0 && index < numChildren)
				return _children[index];
			else
				throw new RangeError("Invalid child index");
		}

		public function getChildByName(name : String) : SINode
		{
			var numChildren : int = _children.length;
			for (var i : int = 0; i < numChildren; ++i)
			{
				var node : SINode = _children[i];
				if (node.name == name)
					return node;
			}
			return null;
		}

		public function getChildIndex(child : SINode) : int
		{
			if (_children)
				return _children.indexOf(child);
			return -1;
		}

		public function setChildIndex(child : SINode, index : int) : void
		{
			var oldIndex : int = getChildIndex(child);
			if (oldIndex == index)
				return;
			if (oldIndex == -1)
				throw new ArgumentError("Not a child of this container");
			_children.splice(oldIndex, 1);
			_children.splice(index, 0, child);
		}

		public function swapChildren(child1 : SINode, child2 : SINode) : void
		{
			var index1 : int = getChildIndex(child1);
			var index2 : int = getChildIndex(child2);
			if (index1 == -1 || index2 == -1)
				throw new ArgumentError("Not a child of this container");
			swapChildrenAt(index1, index2);
		}

		public function swapChildrenAt(index1 : int, index2 : int) : void
		{
			var child1 : SINode = getChildAt(index1);
			var child2 : SINode = getChildAt(index2);
			_children[index1] = child2;
			_children[index2] = child1;
		}

		public function contains(child : SINode) : Boolean
		{
			while (child)
			{
				if (child == this)
					return true;
				else
					child = child.parent;
			}
			return false;
		}

		public function get numChildren() : int
		{
			return _children.length;
		}

		public function destroy() : void
		{
			if (_isDisposed)
				return;
			removeFromParent();
			if (_children)
			{
				_children.length = 0;
				_children = null;
			}
			_name = null;
			_addChildFunction = null;
			_isDisposed = true;
		}

		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}

		public function addToParent(parent : SINode, index : int = -1) : void
		{
			if (index < 0)
				parent.addChild(this);
			else
				parent.addChildAt(this, index);
		}

		public function get name() : String
		{
			return _name;
		}

		public function get parent() : SINode
		{
			return _parent;
		}

		public function set name(value : String) : void
		{
			_name = value;
		}

		public function equals(value : Object) : Boolean
		{
			return (value == this);
		}

		public function sort(compareFunction : *) : void
		{
			_children = _children.sort(compareFunction);
		}

		public static function destroyTree(root : SNode) : void
		{
			if (!root)
				return;
			destroyChildNode(root);
			root.destroy();
		}

		private static function destroyChildNode(node : SNode) : SNode
		{
			if (!node)
				return null;
			var childe : SNode;
			for each (var child : SNode in node.children)
			{
				childe = destroyChildNode(child);
				if (childe)
					childe.destroy();
			}
			return null;
		}

		sunny_engine function get children() : Vector.<SINode>
		{
			return _children;
		}
	}
}