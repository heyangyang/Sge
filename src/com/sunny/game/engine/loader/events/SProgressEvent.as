package com.sunny.game.engine.loader.events
{
	import com.sunny.game.engine.loader.SResourceLoader;

	import flash.events.Event;
	import flash.events.ProgressEvent;

	
	public class SProgressEvent extends ProgressEvent
	{
		
		public static const EVENT_PROGRESS : String = "EVENT_PROGRESS";
		public static const EVENT_COMPLETE : String = "EVENT_COMPLETE";

		
		public var bytesTotalCurrent : int;
		
		public var _ratioLoaded : Number;
		

		public var _percentLoaded : Number;
		
		public var _weightPercent : Number;
		
		public var itemsLoaded : int;
		
		public var itemsTotal : int;

		public var name : String;

		public function SProgressEvent(name : String, bubbles : Boolean = true, cancelable : Boolean = false)
		{
			super(name, bubbles, cancelable);
			this.name = name;
		}

		
		public function setInfo(bytesLoaded : int, bytesTotal : int, bytesTotalCurrent : int, itemsLoaded : int, itemsTotal : int, weightPercent : Number) : void
		{
			this.bytesLoaded = bytesLoaded;
			this.bytesTotal = bytesTotal;
			this.bytesTotalCurrent = bytesTotalCurrent;
			this.itemsLoaded = itemsLoaded;
			this.itemsTotal = itemsTotal;
			this.weightPercent = weightPercent;
			this.percentLoaded = bytesTotal > 0 ? (bytesLoaded / bytesTotal) : 0;
			ratioLoaded = itemsTotal == 0 ? 0 : itemsLoaded / itemsTotal;
		}

		
		override public function clone() : Event
		{
			var b : SProgressEvent = new SProgressEvent(name, bubbles, cancelable);
			b.setInfo(bytesLoaded, bytesTotal, bytesTotalCurrent, itemsLoaded, itemsTotal, weightPercent);
			return b;
		}

		
		public function loadingStatus() : String
		{
			var names : Array = [];
			names.push("bytesLoaded: " + bytesLoaded);
			names.push("bytesTotal: " + bytesTotal);
			names.push("itemsLoaded: " + itemsLoaded);
			names.push("itemsTotal: " + itemsTotal);
			names.push("bytesTotalCurrent: " + bytesTotalCurrent);
			names.push("percentLoaded: " + SResourceLoader.truncateNumber(percentLoaded));
			names.push("weightPercent: " + SResourceLoader.truncateNumber(weightPercent));
			names.push("ratioLoaded: " + SResourceLoader.truncateNumber(ratioLoaded));
			return "SProgressEvent " + names.join(", ") + ";";
		}

		
		public function get weightPercent() : Number
		{
			return truncateToRange(_weightPercent);
		}


		public function set weightPercent(value : Number) : void
		{
			if (isNaN(value) || !isFinite(value))
			{
				value = 0;
			}
			_weightPercent = value;
		}

		
		public function get percentLoaded() : Number
		{
			return truncateToRange(_percentLoaded);
		}

		public function set percentLoaded(value : Number) : void
		{
			if (isNaN(value) || !isFinite(value))
				value = 0;
			_percentLoaded = value;
		}

		
		public function get ratioLoaded() : Number
		{
			return truncateToRange(_ratioLoaded);
		}

		public function set ratioLoaded(value : Number) : void
		{
			if (isNaN(value) || !isFinite(value))
				value = 0;
			_ratioLoaded = value;
		}

		public function truncateToRange(value : Number) : Number
		{
			if (value < 0)
			{
				value = 0;
			}
			else if (value > 1)
			{
				value = 1
			}
			else if (isNaN(value) || !isFinite(value))
			{
				value = 0;
			}
			return value;
		}

		override public function toString() : String
		{
			return super.toString();
		}
	}
}
