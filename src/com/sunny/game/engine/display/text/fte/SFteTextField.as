package com.sunny.game.engine.display.text.fte
{
	import com.sunny.game.engine.display.SSprite;
	import com.sunny.game.engine.utils.display.SDisplayUtil;

	import flash.display.DisplayObject;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;

	/**
	 *
	 * <p>
	 * SunnyGame的一个FTE(Flash Text Engine)的简单封装文本字段
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
	public class SFteTextField extends SSprite
	{
		private var _content : GroupElement;
		private var textBlock : TextBlock;
		private var groupVector : Vector.<ContentElement> = new Vector.<ContentElement>();

		public var textWidth : int = 20000;

		public function SFteTextField(defaultFormat : ElementFormat = null)
		{
			if (!defaultFormat)
				defaultFormat = new ElementFormat();

			_content = new GroupElement(null, defaultFormat);
			textBlock = new TextBlock(_content);
		}

		/**
		 * 获得文字数据
		 * @return
		 *
		 */
		public function get content() : GroupElement
		{
			return _content;
		}

		/**
		 * 添加一段文本
		 * @param text
		 * @param format
		 * @param textRotation
		 *
		 */
		public function addText(text : String, format : ElementFormat = null, textRotation : String = "rotate0") : void
		{
			if (!format)
				format = _content.elementFormat;

			var e : TextElement = new TextElement(text, format, null, textRotation);
			groupVector.push(e);
		}

		/**
		 * 添加一个图形
		 * @param graphics
		 * @param format
		 *
		 */
		public function addGraphics(graphics : DisplayObject, format : ElementFormat = null) : void
		{
			if (!format)
				format = content.elementFormat;

			var e : GraphicElement = new GraphicElement(graphics, graphics.width, graphics.height, format);
			groupVector.push(e);
		}

		/**
		 * 刷新显示
		 *
		 */
		public function refresh() : void
		{
			SDisplayUtil.removeAllChildren(this);
			_content.setElements(groupVector);
			createTextLines();
		}

		private function createTextLines() : void
		{
			var yPos : int = 0;
			var line_length : Number = textWidth;
			var textLine : TextLine = textBlock.createTextLine(null, line_length);

			while (textLine)
			{
				addChild(textLine);
				textLine.x = 15;
				yPos += textLine.height + 8;
				textLine.y = yPos;
				textLine = textBlock.createTextLine(textLine, line_length);
			}
		}

		public static function createTextLine(text : String, format : ElementFormat = null, textRotation : String = "rotate0") : TextLine
		{
			return new TextBlock(new TextElement(text, format, null, textRotation)).createTextLine();
		}
	}
}