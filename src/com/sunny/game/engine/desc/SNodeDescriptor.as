package com.sunny.game.engine.desc
{
	import com.sunny.game.engine.core.SINode;
	import com.sunny.game.engine.core.SNode;
	import com.sunny.game.engine.serialization.json.JSONEncoder;

	/**
	 *
	 * <p>
	 * SunnyGame的一个节点描述符
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
	public class SNodeDescriptor extends SNode implements SIDescriptor//, SISerializable
	{
		protected var _className : String;

		public function SNodeDescriptor()
		{
			super();
			_className = null; //getQualifiedClassName(this);
			_name = "Unnamed";
		}

		private function writeChildren() : Array
		{
			var children : Array = [];
			for (var i : int = 0; i < numChildren; i++)
			{
				var child : SINode = _children[i];
				children.push((child as SNodeDescriptor).writeProperties());
			}
			return children;
		}

		public function get className() : String
		{
			return _className;
		}

		public function set className(value : String) : void
		{
			_className = value;
		}

		public function readProperties(data : Object) : void
		{
			if (!data)
				return;
			name = data["name"];
		}

		public function writeProperties() : Object
		{
			var result : Object = new Object();
			result.name = this.name;
			result.children = this.writeChildren();
			return result;
		}

		public function readObject(data : Object) : void
		{
			readProperties(data);
		}

		public function writeObject() : Object
		{
			var result : Object = writeProperties();
			var encoder : JSONEncoder = new JSONEncoder(result);
			return encoder.getString();
		}
	}
}