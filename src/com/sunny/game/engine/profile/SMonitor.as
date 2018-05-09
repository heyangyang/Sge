package com.sunny.game.engine.profile
{
	import com.sunny.game.engine.animation.SAnimationManager;
	import com.sunny.game.engine.core.SGlobalConstants;
	import com.sunny.game.engine.core.SShellVariables;
	import com.sunny.game.engine.core.SUpdatable;
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.events.SEvent;
	import com.sunny.game.engine.lang.errors.SunnyGameEngineError;
	import com.sunny.game.engine.manager.SReferenceManager;
	import com.sunny.game.engine.manager.SSynchroManager;
	import com.sunny.game.engine.manager.SUpdatableManager;
	import com.sunny.game.engine.ns.sunny_engine;
	import com.sunny.game.engine.ns.sunny_game;
	import com.sunny.game.engine.system.SMemoryChecker;
	import com.sunny.game.engine.ui.SUIStyle;
	import com.sunny.game.engine.utils.SCommonUtil;
	import com.sunny.game.engine.utils.SFilterUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	use namespace sunny_engine;
	use namespace sunny_game;

	/**
	 *
	 * <p>
	 * SunnyGame的一个监视器
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
	public class SMonitor extends SUpdatable
	{
		public static const DEFAULT_UPDATE_RATE : Number = 2;

		private static const DEFAULT_PADDING : uint = 10;
		private static const DEFAULT_BACKGROUND : uint = 0x66000000;

		private static const DEFAULT_COLOR : uint = 0xffffffff;

		private static var _instance : SMonitor = null;
		private static var _singleton : Boolean = true;

		private var _container : Sprite;

		public static function getInstance() : SMonitor
		{
			if (!_instance)
			{
				_singleton = false;
				_instance = new SMonitor();
				_singleton = true;
			}
			return _instance;
		}

		public static function toggleShowMonitor() : void
		{
			SDebug.createDebugContainer();

			if (_instance.container.parent)
				_instance.container.parent.removeChild(_instance.container);
			else
				SDebug.debugContainer.addChild(_instance.container);

			_instance.watchProperty(SAnimationManager.getInstance(), "lazyAnimationInstanceCount", "animationCount", 0x00ff00);
			_instance.watchProperty(SAnimationManager.getInstance(), "animationFrameInstanceCount", "frame____Count", 0x00ff00);
			_instance.watchProperty(SAnimationManager.getInstance(), "effectResourceInstanceCount", "effect___Count", 0x00ff00);
			_instance.watchProperty(SAnimationManager.getInstance(), "avatarResourceInstanceCount", "avatar___Count", 0x00ff00);
			_instance.watchProperty(SMemoryChecker.getInstance(), "status", "mem_status", 0xff0000);
			_instance.watchProperty(SMemoryChecker.getInstance(), "clearNum", "clearNum", 0xff0000);
			_instance.watchProperty(SReferenceManager.getInstance(), "total_reference", "total_reference", 0x00ff00);
			_instance.watchProperty(SReferenceManager.getInstance(), "status", "status", 0x00ff00);

			_instance.watchProperty(SShellVariables, "serverUrl", "serverUrl", 0x00ffff);
			_instance.watchProperty(SShellVariables, "serverPort", "serverPort", 0x00ffff);

			_instance.watchProperty(SUpdatableManager.getInstance(), "highUpdateTime", "highUpdateTime", 0x00ff00);
			_instance.watchProperty(SUpdatableManager.getInstance(), "mediumUpdateTime", "mediumUpdateTime", 0x00ff00);
			_instance.watchProperty(SUpdatableManager.getInstance(), "lowUpdateTime", "lowUpdateTime", 0x00ff00);
			_instance.watchProperty(SUpdatableManager.getInstance(), "passedTime", "passedTime", 0x00ff00);
			_instance.watchProperty(SUpdatableManager.getInstance(), "validHighPriorCount", "validHighPriorCount", 0x00ff00);
			_instance.watchProperty(SUpdatableManager.getInstance(), "validMediumPriorCount", "validMediumPriorCount", 0x00ff00);
			_instance.watchProperty(SUpdatableManager.getInstance(), "validLowPriorCount", "validLowPriorCount", 0x00ff00);
			_instance.watchProperty(SUpdatableManager.getInstance(), "quickenTime", "quickenTime", 0x00ff00);
			_instance.watchProperty(SUpdatableManager.getInstance(), "quickenDate", "quickenDate", 0x00ff00);

			_instance.watchProperty(SSynchroManager.getInstance(), "pingDelayTime", "PING", 0xffff00);
			_instance.watchProperty(SSynchroManager.getInstance(), "serverDelayTime", "serverDelayTime", 0xffff00);
			_instance.watchProperty(SSynchroManager.getInstance(), "serverTime", "serverTime", 0xffff00);
			_instance.watchProperty(SSynchroManager.getInstance(), "svrClientDeltaTime", "clientTime", 0xffff00);
		}

		private var _defaultColor : uint = DEFAULT_COLOR;

		private var _updateRate : Number = 0.;

		/**
		 * 帧数由<code>diagram</code>中更新的FPS值决定.
		 * @see #diagram
		 */
		private var fpsUpdatePeriod : int = 10;

		/**
		 * 帧数由<code>diagram</code>中更新的MS值决定.
		 * @see #diagram
		 */
		private var timerUpdatePeriod : int = 10;

		private var _intervalId : int = 0;

		private var _targets : Dictionary = new Dictionary();
		private var _xml : XML;
		private var _colors : Object = new Object();

		private var _scales : Object = new Object();
		private var _overflow : Object = new Object();
		private var _style : StyleSheet = new StyleSheet();
		private var _label : TextField;

		private var _numFrames : int = 0;
		private var _updateTime : int = 0;
		private var _framerate : Number = 0.0;
		private var _maxMemory : int = 0;

		private var _background : uint = 0;

		private var shape : Shape;
		private var bitmap : Bitmap;
		//private var _debugTxt : STextArea;
		private var _isDebug : Boolean = true;
		private var _debugInfo : String = "";

		public function get defaultColor() : uint
		{
			return _defaultColor;
		}

		public function get framerate() : int
		{
			return _framerate;
		}

		public function set defaultColor(value : uint) : void
		{
			_defaultColor = value;
		}

		public function set updateRate(value : Number) : void
		{
			_updateRate = value;
		}

		public function get updateRate() : Number
		{
			return _updateRate;
		}

		public function set backgroundColor(value : uint) : void
		{
			_background = value;
			updateBackground();
		}

		public function get backgroundColor() : uint
		{
			return _background;
		}

		/**
		 * Create a new Monitor object.
		 * @param myUpdateRate The number of update per second the monitor will perform.
		 *
		 */
		public function SMonitor(updateRate : Number = DEFAULT_UPDATE_RATE)
		{
			super();
			if (_singleton)
				throw new SunnyGameEngineError("只能通过getInstance()来获取SMonitor实例");

			_updateRate = updateRate;

			_xml = <monitor>
					<copyright/>
					<header/>
					<version/>
					<framerate>framerate:</framerate>
					<memory>memory:</memory>
				</monitor>;
			// diagram initialization
			setStyle("monitor", {fontSize: "14px", fontFamily: SUIStyle.TEXT_FONT, leading: "2px"});
			//FPS(FPS:)
			setStyle("framerate", {color: "#CCCCCC", fontFamily: SUIStyle.TEXT_FONT, fontSize: 14, leading: 2});
			//Frame time - time of frame(TME:)
			setStyle("frameTime", {color: "#CCCCCC", fontFamily: SUIStyle.TEXT_FONT, fontSize: 14, leading: 2});
			//Time of method performing - time of method execution(MS:)
			setStyle("methodTime", {color: "#0066FF", fontFamily: SUIStyle.TEXT_FONT, fontSize: 14, leading: 2});
			//Memory(MEM:)
			setStyle("memory", {color: "#CCCC00", fontFamily: SUIStyle.TEXT_FONT, fontSize: 14, leading: 2});

			setStyle("copyright", {color: "#999999", fontFamily: SUIStyle.TEXT_FONT, fontSize: 14, leading: 2});
			setStyle("version", {color: "#999999", fontFamily: SUIStyle.TEXT_FONT, fontSize: 14, leading: 2});
			setStyle("header", {color: "#999999", fontFamily: SUIStyle.TEXT_FONT, fontSize: 14, leading: 2});

			_xml.copyright = SGlobalConstants.COPYRIGHT + " " + SGlobalConstants.VERSION;
			_xml.header = SShellVariables.applicationName + " " + SShellVariables.applicationVersion;
			_xml.version = Capabilities.version + (Capabilities.isDebugger ? " (debug)" : "");

			_background = DEFAULT_BACKGROUND;

			_container = new Sprite();
			_container.mouseEnabled = false;
			_container.mouseChildren = false;
			_container.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			_container.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		private function createDiagram() : void
		{
			_label = new TextField();
			_label.styleSheet = _style;
			_label.condenseWhite = true;
			_label.selectable = false;
			_label.mouseEnabled = false;
			_label.mouseWheelEnabled = false;
			_label.autoSize = TextFieldAutoSize.LEFT;
			_label.filters = SFilterUtil.blackFilters;

			_container.addChild(_label);
			_label.x = 2;
			_label.y = 2;
		}

		// Deinitialization of diagram
		private function disposeDiagram() : void
		{
			_container.removeChild(_label);
			if (bitmap && bitmap.parent)
				bitmap.parent.removeChild(bitmap);
			shape = null;
			_label = null;
		}

		public function setStyle(styleName : String, value : Object) : void
		{
			_style.setStyle(styleName, value);

			if (value.color)
				_colors[styleName] = 0xff000000 | parseInt(value.color.substr(1), 16);
		}

		private function updateDiagram() : void
		{
			++_numFrames;

			var value : Number;
			var mod : int;
			var time : int = getTimer();
			var stageFrameRate : int = SShellVariables.frameRate;

			// FPS text
			if (++fpsUpdateCounter == fpsUpdatePeriod)
			{
				value = 1000 * fpsUpdatePeriod / (time - previousPeriodTime);
				if (value > stageFrameRate)
					value = stageFrameRate;
				mod = value * 100 % 100;
				_xml.framerate = "FPS: " + int(value) + "." + ((mod >= 10) ? mod : ((mod > 0) ? ("0" + mod) : "00"));
				value = 1000 / value;
				mod = value * 100 % 100;
				_xml.frameTime = "TME: " + int(value) + "." + ((mod >= 10) ? mod : ((mod > 0) ? ("0" + mod) : "00"));
				previousPeriodTime = time;
				fpsUpdateCounter = 0;
			}

			// FPS plot
			if ((time - _updateTime) >= 1000 / _updateRate)
			{
				if (!_container.visible || !_container.stage)
				{
					_updateTime = time;
					_numFrames = 0;
					return;
				}
				// framerate
				_framerate = _numFrames / ((time - _updateTime) / 1000);


				value = 1000 / (time - previousFrameTime);
				if (value > stageFrameRate)
					value = stageFrameRate;

				previousFrameTime = time;

				// time text
				if (++timerUpdateCounter == timerUpdatePeriod)
				{
					if (methodTimeCount > 0)
					{
						value = methodTimeSum / methodTimeCount;
						mod = value * 100 % 100;
						_xml.methodTime = "MS: " + int(value) + "." + ((mod >= 10) ? mod : ((mod > 0) ? ("0" + mod) : "00"));
					}
					else
					{
						_xml.methodTime = "";
					}
					if (_cpuTimeCount > 0)
					{
						value = _cpuTimeSum / _cpuTimeCount;
						mod = value * 100 % 100;
						_xml.methodTime = "MS: " + int(value) + "." + ((mod >= 10) ? mod : ((mod > 0) ? ("0" + mod) : "00"));
					}
					else
					{
						_xml.methodTime = "";
					}
					timerUpdateCounter = 0;
					methodTimeSum = 0;
					methodTimeCount = 0;
					_cpuTimeSum = 0;
					_cpuTimeCount = 0;
				}

				// memory
				var totalMemory : int = System.totalMemory;
				if (totalMemory > _maxMemory)
					_maxMemory = totalMemory;
				_xml.memory = "MEM: " + SCommonUtil.bytesToString(totalMemory);

				// properties
				var properties : Array;
				var numProperties : int;
				var property : String;
				var label : String;
				var object : Object;
				var scale : Number;
				var scaledValue : Number;

				for (var target : Object in _targets)
				{
					properties = _targets[target];
					numProperties = properties.length;

					for (var i : int = 0; i < numProperties; ++i)
					{
						property = properties[i].property;
						label = properties[i].label;
						object = target[property];
						scale = _scales[label];

						_xml[label] = label + ": " + object;
					}
				}

				_numFrames = 0;
				_updateTime = time;

				if (_container.stage)
				{
					_label.htmlText = _xml;
					updateBackground();
					resizeDiagram();
				}
			}
		}

		private function addedToStageHandler(e : Event) : void
		{
			_maxMemory = System.totalMemory;
			createDiagram();
			if (_isDebug)
			{
				shape = new Shape();
				bitmap = new Bitmap(new BitmapData(100, 100, false, 0x0));
				_container.parent.addChild(bitmap);
			}
			register(SUpdatableManager.PRIORITY_LAYER_LOW, -1000);
			resizeDiagram();
		}

		private function removedFromStageHandler(e : Event) : void
		{
			unregister();
			disposeDiagram();
		}

		public function setColor(property : String, color : int) : void
		{
			_colors[property] = color;
		}

		public function getColor(property : String) : int
		{
			return _colors[property];
		}

		public function getScale(property : String) : Number
		{
			return _scales[property];
		}

		public function setScale(property : String, scale : Number) : void
		{
			_scales[property] = scale;
		}

		public function getOverflow(property : String) : Boolean
		{
			return _overflow[property];
		}

		public function setOverflow(property : String, overflow : Boolean) : void
		{
			_overflow[property] = overflow;
		}

		/**
		 * Watch a property of a specified object.
		 *
		 * @param myTarget The object containing the property to watch.
		 * @param myProperty The name of the property to watch.
		 * @param myColor The color of the displayed label/chart.
		 * @param myScale The scale used to display the chart. Use "0" to disable the chart.
		 * @param myOverflow If true, the modulo operator is used to make
		 * sure the value can be drawn on the chart.
		 */
		public function watchProperty(target : Object, property : String, label : String, color : int = 0, scale : Number = 0., overflow : Boolean = false) : SMonitor
		{
			if (!_targets[target])
				_targets[target] = new Array();

			color ||= _defaultColor;

			_targets[target].push({property: property, label: label});

			var object : Object = target[property];
			if (object is int)
				object = formatInt(object as int);

			_xml[label] = label + ": " + object;

			_colors[label] = color;
			_scales[label] = scale;
			_overflow[label] = overflow;

			_style.setStyle(label, {color: "#" + (color as Number & 0xffffff).toString(16), fontFamily: SUIStyle.TEXT_FONT, fontSize: 14, leading: 2});

			return this;
		}

		public function watch(target : Object, properties : Array, labels : Array, colors : Array = null, scales : Array = null, overflows : Array = null) : SMonitor
		{
			var numProperties : int = properties.length;

			for (var i : int = 0; i < numProperties; ++i)
			{
				watchProperty(target, properties[i], labels[i], colors ? colors[i] : _defaultColor, scales && scales[i] ? scales[i] : 0., overflows ? overflows[i] : false);
			}

			return this;
		}

		public function watchObject(target : Object) : SMonitor
		{
			for (var property : String in target)
				watchProperty(target, property, property);

			return this;
		}

		private function updateBackground() : void
		{
			if (_label.textWidth == _container.width && _label.textHeight == _container.height)
				return;

			_container.graphics.clear();
			_container.graphics.beginFill(_background & 0xffffff, 1);
			_container.graphics.drawRect(0, 0, _container.width, _container.height);
			_container.graphics.endFill();

			bitmap.x = _container.x;
			bitmap.y = _container.height;
		}

		private function resizeDiagram(e : SEvent = null) : void
		{
			_container.x = 0; // Math.round(_container.stage.stageWidth - _container.width);
		}

		private function formatInt(num : int) : String
		{
			var n : int;
			var s : String;
			if (num < 1000)
			{
				return "" + num;
			}
			else if (num < 1000000)
			{
				n = num % 1000;
				if (n < 10)
				{
					s = "00" + n;
				}
				else if (n < 100)
				{
					s = "0" + n;
				}
				else
				{
					s = "" + n;
				}
				return int(num / 1000) + " " + s;
			}
			else
			{
				n = (num % 1000000) / 1000;
				if (n < 10)
				{
					s = "00" + n;
				}
				else if (n < 100)
				{
					s = "0" + n;
				}
				else
				{
					s = "" + n;
				}
				n = num % 1000;
				if (n < 10)
				{
					s += " 00" + n;
				}
				else if (n < 100)
				{
					s += " 0" + n;
				}
				else
				{
					s += " " + n;
				}
				return int(num / 1000000) + " " + s;
			}
		}



		override public function update() : void
		{
			updateDiagram();

			// Animate spinner
			if (shape && bitmap)
			{
				var t : Number = getTimer();
				// Fade to black
				shape.graphics.clear();
				shape.graphics.beginFill(0x0, 0.05);
				shape.graphics.drawRect(0, 0, 100, 100);
				bitmap.bitmapData.draw(shape);
				// Draw red circle/line
				shape.graphics.clear();
				shape.graphics.lineStyle(3, 0x00ff00, 1, true);
				shape.graphics.drawCircle(50, 50, 46);
				shape.graphics.moveTo(50, 50);
				shape.graphics.lineTo(50 + 45 * Math.cos(t / 300), 50 + 45 * Math.sin(t / 300));
				bitmap.bitmapData.draw(shape);
			}
		}



		private var fpsUpdateCounter : int;
		private var previousFrameTime : int;
		private var previousPeriodTime : int;

		private var maxMemory : int;

		private var timerUpdateCounter : int;
		private var methodTimeSum : int;
		private var methodTimeCount : int;
		private var methodTimer : int;
		private var _cpuTimeSum : int = 0;
		private var _cpuTimeCount : int = 0;
		private var _cpuTimer : int = -1;

		public function startCPUTimer() : void
		{
			_cpuTimer = getTimer();
		}

		/**
		 * Starts time count. <code>startTimer()</code>and <code>stopTimer()</code> are necessary to measure time for code part executing.
		 * The result is displayed in the field MS of the diagram.
		 *
		 * @see #diagram
		 * @see #stopTimer()
		 */
		public function startTimer() : void
		{
			methodTimer = getTimer();
		}

		/**
		 * Stops time count. <code>startTimer()</code> and <code>stopTimer()</code> are necessary to measure time for code part executing.
		 * The result is displayed in the field MS of the diagram.
		 * @see #diagram
		 * @see #startTimer()
		 */
		public function stopTimer() : void
		{
			methodTimeSum += getTimer() - methodTimer;
			methodTimeCount++;
		}

		public function get cpuTimer() : int
		{
			return _cpuTimer;
		}

		public function set cpuTimer(value : int) : void
		{
			_cpuTimer = value;
		}

		public function get cpuTimeSum() : int
		{
			return _cpuTimeSum;
		}

		public function set cpuTimeSum(value : int) : void
		{
			_cpuTimeSum = value;
		}

		public function get cpuTimeCount() : int
		{
			return _cpuTimeCount;
		}

		public function set cpuTimeCount(value : int) : void
		{
			_cpuTimeCount = value;
		}

		public function get container() : Sprite
		{
			return _container;
		}

		override public function destroy() : void
		{
			unregister();
			if (_container && _container.parent)
				_container.parent.removeChild(_container);
			super.destroy();
		}
	}
}