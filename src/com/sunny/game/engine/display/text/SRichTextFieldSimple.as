package com.sunny.game.engine.display.text
{
	import com.sunny.game.engine.display.SSprite;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class SRichTextFieldSimple extends SSprite
	{
		//the instance of textfield
		private var _textfield : TextField;
		//the default textformat of _textfield
		private var _defaultTextFormat : TextFormat;
		//the length of the _textfield.text
		private var _length : int;
		//store all sprite's indexes in _textfield
		private var _sprites : Array;
		//only contain sprites which are inserted in _textfield
		private var _spriteContainer : Sprite;
		//specify the sprite's vspace/hspace in _textfield
		private var _spriteVspace : int;
		private var _spriteHspace : int;
		//save the selection begin/end indexes of _textfield
		private var _selectBegin : int;
		private var _selectEnd : int;
		//save the scrollV of the _textfield
		private var _scrollV : int;
		//the mask of _spriteContainer
		private var _spriteMask : Shape;
		//use it to show the TextField.replaceText() time during addSprite
		private var _replacing : Boolean;

		/**
		 * trick, a sprite's placeholder
		 * special character: ﹒
		 * special font: 宋体
		 */
		private static const PLACEHOLDER : String = "﹒";
		private static const PLACEHOLDER_FONT : String = "宋体";
		//type of adjust
		private static const ADJUST_TYPE_INSERT : String = "adjust_type_insert";
		private static const ADJUST_TYPE_CHANGE : String = "adjust_type_change";
		//specify type of _textfield
		public static const DYNAMIC : String = "dynamic";
		public static const INPUT : String = "input";


		/**
		 * constructor
		 */
		public function SRichTextFieldSimple(width : Number, height : Number, type : String = DYNAMIC)
		{
			initTextField(width, height, type);
			addChild(_textfield);

			_spriteContainer = new Sprite();
			addChild(_spriteContainer);
			_sprites = [];
			//default scrollV is 1
			_scrollV = 1;
			//default sprite vspace/hspace is 2
			_spriteHspace = _spriteVspace = 2;

			_textfield.addEventListener(Event.CHANGE, changeHandler);
			_textfield.addEventListener(Event.SCROLL, scrollHandler);
			_textfield.addEventListener(TextEvent.TEXT_INPUT, inputHandler);
			//use MOUSE_UP and MOUSE_OUT event to get selection of _textfield
			_textfield.addEventListener(MouseEvent.MOUSE_UP, getSelectionHandler);
			_textfield.addEventListener(MouseEvent.MOUSE_OUT, getSelectionHandler);
		}

		/******************************************************************
		 ***** public method
		 ****************************************************************** /

		/**
		 * add a sprite with a placeholder to the right place
		 * @param target
		 * @param width
		 * @param height
		 */
		public function addSprite(target : *, width : Number, height : Number) : void
		{
			//insert a placeholder for target and format it
			var caret : int = _textfield.caretIndex;
			var format : TextFormat = new TextFormat();
			format.font = PLACEHOLDER_FONT;
			format.size = height + 2 * _spriteVspace;
			//format.letterSpacing = width - height/2 - 2 * _spriteVspace + 2 * _spriteHspace;   
			format.letterSpacing = width - height - 2 * _spriteVspace + 2 * _spriteHspace;

			//because if use replaceText method, the TextField will scroll incorrectly(scrollV=1)
			//we don't need to adjust the _spriteContainer's position in this scroll time
			//so use _replacing to split this time   
			_replacing = true;
			var oldScrollV : int = _textfield.scrollV;
			_textfield.replaceText(caret, caret, PLACEHOLDER);
			_textfield.setTextFormat(format, caret);
			_replacing = false;
			//srcoll back to the correct line.  
			_textfield.scrollV = oldScrollV;

			var newObj : * = target;
			//create a target sprite
			if (target is Class)
			{
				trace(1);
				newObj = new target() as Sprite;
			}
			else
			{
				trace(2);
				var className : String = getQualifiedClassName(target);
				trace(className)
				var targetClass : Class = getDefinitionByName(className) as Class;
				trace(targetClass);
				newObj = new targetClass() as Sprite;
			}
			newObj.width = width;
			newObj.height = height;
			_spriteContainer.addChild(newObj);
			_sprites.push(caret);
			_length++;
			adjustSprites(caret, 1, ADJUST_TYPE_INSERT);
		}


		/******************************************************************
		 ***** private method
		 ****************************************************************** /

		/**
		 * monitor the change of scrollV and adjust the _spriteContainer's coordinate
		 * @param evt
		 */
		private function scrollHandler(evt : Event) : void
		{
			if (_textfield.bottomScrollV <= 1)
				return;
			if (!_replacing)
			{
				var scrollDirection : int = _textfield.scrollV > _scrollV ? 1 : -1;
				var begin : int = scrollDirection > 0 ? (_textfield.scrollV - 2) : (_scrollV - 2);
				var end : int = scrollDirection > 0 ? (_scrollV - 2) : (_textfield.scrollV - 2);
				var scrollHeight : Number = 0;
				for (var i : int = begin; i > end; i--)
				{
					scrollHeight += _textfield.getLineMetrics(i).height;
				}
				_spriteContainer.y -= scrollDirection * scrollHeight;
				//trace("scroll", scrollDirection, _scrollV, _textfield.scrollV, scrollDirection * scrollHeight);
			}
			if (_replacing && _textfield.scrollV == 1)
				return;
			_scrollV = _textfield.scrollV;
			//trace("set _scrollV", _scrollV);
		}

		/**
		 * monitor the selection range of _textfield
		 * @param evt
		 */
		private function getSelectionHandler(evt : MouseEvent) : void
		{
			_selectBegin = _textfield.selectionBeginIndex;
			_selectEnd = _textfield.selectionEndIndex;
			//trace("get selection:", _selectBegin, _selectEnd);
		}

		/**
		 * monitor the input of _textfield
		 * @param evt
		 */
		private function inputHandler(evt : Event) : void
		{
			//recover the default textformat
			defaultTextFormat = _defaultTextFormat;
		}

		/**
		 * monitor the change of _textfield and adjust all sprites
		 * @param evt
		 */
		private function changeHandler(evt : Event) : void
		{
			var offset : int = _textfield.length - _length;
			//trace("CHANGE:", _length, _textfield.length, offset);
			_length = _textfield.length;
			var caretIndex : int = _textfield.caretIndex;
			//only delete text want to check whether the sprite is exist
			if (offset < 0)
				checkSpriteExist(_textfield.caretIndex, offset);
			adjustSprites(_textfield.caretIndex, offset, ADJUST_TYPE_CHANGE);
		}

		/**
		 * check if has sprite placeholders removed in specific careIndex
		 * @param caretIndex
		 * @param offset
		 */
		private function checkSpriteExist(caretIndex : int, offset : int) : void
		{
			var begin : int = caretIndex + offset + 1;
			var end : int = caretIndex + 1;
			//if is selection deleted, adjust begin and end   
			if (offset < -1 && _selectBegin != _selectEnd)
			{
				//trace("selection:", caretIndex, _selectBegin, _selectEnd);
				begin = _selectBegin;
				end = _selectEnd;
			}
			//check sprite status from begin to end
			for (var i : int = begin; i < end; i++)
			{
				var checkObj : Sprite = _spriteContainer.getChildByName(String(i)) as Sprite;
				if (checkObj)
				{
					var index : int = _spriteContainer.getChildIndex(checkObj);
					trace("remove ", i, _sprites[index], caretIndex, offset, begin, end);
					_spriteContainer.removeChild(checkObj);
					_sprites.splice(index, 1);
				}
			}
		}

		/**
		 * adjust the position of sprite if need
		 * @param caretIndex the caret index of the change place
		 * @param offset whether plus or minus
		 * @type default is ADJUST_TYPE_CHANGE
		 */
		private function adjustSprites(caretIndex : int, offset : int = 1, type : String = ADJUST_TYPE_CHANGE) : void
		{
			//if no _spriteMask, create it
			if (!_spriteMask)
			{
				_spriteMask = createSpritesMask(_textfield.x, _textfield.y, _textfield.width, _textfield.height);
				addChild(_spriteMask);
				_spriteContainer.mask = _spriteMask;
			}
			var insertStatus : Boolean = true;
			for (var i : int = 0, len : int = _sprites.length; i < len; i++)
			{
				var caret : int = _sprites[i];
				//trace("adjust: ", i, caret, caretIndex);   
				//these sprites before current sprite don't needed to adjust    
				if (caret < caretIndex - 1)
					continue;
				else if (caret == caretIndex && type == ADJUST_TYPE_CHANGE)
					caret = caret + offset;
				else if (caret == caretIndex - 1 && type == ADJUST_TYPE_CHANGE && offset < 0)
					continue;
				else if (caret == caretIndex - 1 && type == ADJUST_TYPE_CHANGE && offset > 0)
					caret = caret + offset;
				else if (caret == caretIndex - 1 && type == ADJUST_TYPE_INSERT)
					caret = caret;
				else if (caret == caretIndex && type == ADJUST_TYPE_INSERT)
				{
					if (insertStatus && _textfield.text.charAt(caretIndex + 1) == PLACEHOLDER)
					{
						caret = caret + offset;
						insertStatus = false;
					}
					else
					{
						insertStatus = true;
					}
				}
				else if (caret != caretIndex)
					caret = caret + offset;
				var adjustObj : Sprite = _spriteContainer.getChildAt(i) as Sprite;
				var rectPlaceholder : Rectangle = _textfield.getCharBoundaries(caret);
				if (!rectPlaceholder)
				{
					//because only display text can get getCharBoundaries in textfield
					//so we should scroll to the line of this PLACEHOLDER first
					//then calculate the boundary of this PLACEHOLDER, scroll back at last
					var objLine : int = _textfield.getLineIndexOfChar(caret);
					if (_textfield.bottomScrollV < objLine)
					{
						var oldScrollV : int = _textfield.scrollV;
						_textfield.scrollV = objLine;
						rectPlaceholder = _textfield.getCharBoundaries(caret);
						_textfield.scrollV = oldScrollV;
					}
				}
				//trace("rectPlaceholder: " + rectPlaceholder);
				if (adjustObj && rectPlaceholder)
				{
					//adjust name and coordinate
					_sprites[i] = caret;
					adjustObj.name = String(caret);
					setSpriteCoordinate(adjustObj, rectPlaceholder);
				}
			}
		}

		/**
		 * set target sprite to the right coordinate, according to the rectangle of it's placeholder
		 * @param target
		 * @param rectPlaceholder
		 */
		private function setSpriteCoordinate(target : Sprite, rectPlaceholder : Rectangle) : void
		{
			target.x = _spriteContainer.x + rectPlaceholder.left + _spriteHspace;
			target.y = rectPlaceholder.top + rectPlaceholder.height - target.height - _spriteVspace;
			//trace("setSpriteCoordinate", _spriteContainer.y, _textfield.textHeight, rectPlaceholder);
		}

		/**
		 * initialize the _textfield
		 * @param width
		 * @param height
		 * @param type
		 */
		private function initTextField(width : Number, height : Number, type : String) : void
		{
			_textfield = new TextField();
			_textfield.width = width;
			_textfield.height = height;
			_textfield.type = type;
			//default multiline and wordWrap are true
			_textfield.multiline = true;
			_textfield.wordWrap = true;
			//for test view
			_textfield.border = true;
			//restriction of inserting placeholder
			_textfield.restrict = "^" + PLACEHOLDER;
		}

		/**
		 * create a mask of _spriteContainer
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @return
		 */
		private function createSpritesMask(x : Number, y : Number, width : Number, height : Number) : Shape
		{
			var shape : Shape = new Shape();
			shape.graphics.beginFill(0xFF0000);
			shape.graphics.lineStyle(0, 0x000000);
			shape.graphics.drawRect(x, y, width, height);
			shape.graphics.endFill();
			return shape;
		}


		/******************************************************************
		 ***** getters & setters
		 ******************************************************************/

		public function get textfield() : TextField
		{
			return _textfield;
		}

		public function get spriteContainer() : Sprite
		{
			return _spriteContainer;
		}

		public function set spriteVspace(value : int) : void
		{
			_spriteVspace = value;
		}

		public function set spriteHspace(value : int) : void
		{
			_spriteHspace = value;
		}

		public function set defaultTextFormat(format : TextFormat) : void
		{
			//set the default textformat and effect immediately
			if (format.letterSpacing == null)
				format.letterSpacing = 0;
			_defaultTextFormat = format;
			_textfield.defaultTextFormat = format;
		}
	}
}
