package com.sunny.game.engine.loader.types
{
	import com.sunny.game.engine.loader.SResourceLoader;
	import com.sunny.game.engine.loader.events.SProgressEvent;
	import com.sunny.game.engine.loader.utils.SmartURL;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.utils.getTimer;

	public class LoadingItem extends EventDispatcher
	{

		public static const STATUS_STOPPED : String = "stopped";

		public static const STATUS_STARTED : String = "started";

		public static const STATUS_FINISHED : String = "finished";

		public static const STATUS_ERROR : String = "error";


		public var _type : String;

		public var url : URLRequest;

		public var _id : String;

		public var _uid : String;

		public var _additionIndex : int;

		public var _priority : int = 0;

		public var _isLoaded : Boolean;

		public var _isLoading : Boolean;

		public var status : String;

		public var maxTries : int = 3;

		public var numTries : int = 0;


		public var weight : int = 1;

		public var preventCache : Boolean;


		public var _bytesTotal : int = -1;


		public var _bytesLoaded : int = 0;


		public var _bytesRemaining : int = int.MAX_VALUE;


		public var _percentLoaded : Number;


		public var _weightPercentLoaded : Number;


		public var _addedTime : int;


		public var _startTime : int;

		public var _responseTime : Number;


		public var _latency : Number;


		public var _totalTime : int;


		public var _timeToDownload : Number;


		public var _speed : Number;


		public var _content : *;


		public var _httpStatus : int = -1;


		public var _context : * = null;


		public var _parsedURL : SmartURL;


		public var specificAvailableProps : Array;

		public var propertyParsingErrors : Array;

		public var errorEvent : ErrorEvent;

		protected var progressEvent : SProgressEvent;

		public function LoadingItem(url : URLRequest, type : String, _uid : String)
		{
			this._type = type;
			this.url = url;
			_parsedURL = new SmartURL(url.url);
			if (!specificAvailableProps)
			{
				specificAvailableProps = [];
			}
			this._uid = _uid;
		}


		public function _parseOptions(props : Object) : Array
		{
			preventCache = props[SResourceLoader.PREVENT_CACHING];
			_id = props[SResourceLoader.ID];
			_priority = int(props[SResourceLoader.PRIORITY]) || 0;
			maxTries = props[SResourceLoader.MAX_TRIES] || 3;
			weight = int(props[SResourceLoader.WEIGHT]) || 1;

			var allowedProps : Array = SResourceLoader.GENERAL_AVAILABLE_PROPS.concat(specificAvailableProps);
			propertyParsingErrors = [];
			for (var propName : String in props)
			{
				if (allowedProps.indexOf(propName) == -1)
				{
					propertyParsingErrors.push(this + ": got a wrong property name: " + propName + ", with value:" + props[propName]);
				}
			}
			return propertyParsingErrors;
		}


		public function get content() : *
		{
			return _content;
		}

		public function load() : void
		{
			if (preventCache)
			{
				var cacheString : String = "BulkLoaderNoCache=" + _uid + "_" + int(Math.random() * 100 * getTimer());
				if (url.url.indexOf("?") == -1)
				{
					url.url += "?" + cacheString;
				}
				else
				{
					url.url += "&" + cacheString;
				}
			}
			_isLoading = true;
			_startTime = getTimer();
		}


		public function onHttpStatusHandler(evt : HTTPStatusEvent) : void
		{
			_httpStatus = evt.status;
			dispatchEvent(evt);
		}


		public function onProgressHandler(evt : ProgressEvent) : void
		{
			_bytesLoaded = evt.bytesLoaded;
			_bytesTotal = evt.bytesTotal;
			_bytesRemaining = _bytesTotal - bytesLoaded;
			if (_bytesRemaining < 0)
			{
				_bytesRemaining = int.MAX_VALUE;
			}
			if (_bytesTotal < 4 && _bytesLoaded > 0)
			{
				_bytesTotal = int.MAX_VALUE;
			}
			_percentLoaded = _bytesLoaded / _bytesTotal;
			_weightPercentLoaded = _percentLoaded * weight;
			if (progressEvent == null)
				progressEvent = new SProgressEvent(SResourceLoader.PROGRESS, false, false);
			progressEvent._percentLoaded = _percentLoaded;
			progressEvent.bytesTotal = _bytesTotal;
			progressEvent.bytesLoaded = _bytesLoaded;
			evt.stopImmediatePropagation();
			dispatchEvent(progressEvent);
		}


		public function onCompleteHandler(evt : Event) : void
		{
			_totalTime = getTimer();
			_timeToDownload = ((_totalTime - _responseTime) / 1000);
			if (_timeToDownload == 0)
			{
				_timeToDownload = 0.1;
			}
			_bytesTotal = _bytesLoaded;
			_bytesRemaining = 0;
			_speed = SResourceLoader.truncateNumber((bytesTotal / 1024) / (_timeToDownload));
			status = STATUS_FINISHED;
			_isLoaded = true;
			cleanListeners();
			dispatchEvent(evt);
			evt.stopPropagation();
		}


		public function onErrorHandler(evt : ErrorEvent) : void
		{
			numTries++;

			evt.stopPropagation();
			if (numTries < maxTries)
			{
				status = null
				load();
			}
			else
			{
				status = STATUS_ERROR;
				errorEvent = evt;
				_dispatchErrorEvent(errorEvent);
			}
		}


		public function _dispatchErrorEvent(evt : ErrorEvent) : void
		{
			// we are dispatching here so we can have all error events catched by addEventListener("error"), regardless of event type.
			status = STATUS_ERROR;
			dispatchEvent(new ErrorEvent(SResourceLoader.ERROR, true, false, evt.text));

		}


		public function _createErrorEvent(e : Error) : ErrorEvent
		{
			return new ErrorEvent(SResourceLoader.ERROR, false, false, e.message);
		}


		public function onSecurityErrorHandler(e : ErrorEvent) : void
		{
			status = STATUS_ERROR;
			errorEvent = e as ErrorEvent;
			e.stopPropagation();
			_dispatchErrorEvent(errorEvent);
		}


		public function onStartedHandler(evt : Event) : void
		{
			_responseTime = getTimer();
			_latency = SResourceLoader.truncateNumber((_responseTime - _startTime) / 1000);
			status = STATUS_STARTED;
			dispatchEvent(evt);
		}


		public function stop() : void
		{
			if (_isLoaded)
				return;
			status = STATUS_STOPPED;
			_isLoading = false;
		}


		public function cleanListeners() : void
		{

		}

		public function isVideo() : Boolean
		{
			return false;
		}


		public function isSound() : Boolean
		{
			return false;
		}


		public function isText() : Boolean
		{
			return false;
		}


		public function isXML() : Boolean
		{
			return false;
		}


		public function isImage() : Boolean
		{
			return false;
		}


		public function isSWF() : Boolean
		{
			return false;
		}


		public function isLoader() : Boolean
		{
			return false;
		}


		public function isStreamable() : Boolean
		{
			return false;
		}


		public function destroy() : void
		{
			_content = null;
			progressEvent = null;
			_parsedURL = null;
			errorEvent = null;
			specificAvailableProps = null;
			propertyParsingErrors = null;
			url = null;
		}

		public function get bytesTotal() : int
		{
			return _bytesTotal;
		}


		public function get bytesLoaded() : int
		{
			return _bytesLoaded;
		}


		public function get bytesRemaining() : int
		{
			return _bytesRemaining;
		}


		public function get percentLoaded() : Number
		{
			return _percentLoaded;
		}


		public function get weightPercentLoaded() : Number
		{
			return _weightPercentLoaded;
		}


		public function get priority() : int
		{
			return _priority;
		}


		public function get type() : String
		{
			return _type;
		}


		public function get isLoaded() : Boolean
		{
			return _isLoaded;
		}


		public function get addedTime() : int
		{
			return _addedTime;
		}


		public function get startTime() : int
		{
			return _startTime;
		}


		public function get responseTime() : Number
		{
			return _responseTime;
		}



		public function get latency() : Number
		{
			return _latency;
		}


		public function get totalTime() : int
		{
			return _totalTime;
		}


		public function get timeToDownload() : int
		{
			return _timeToDownload;
		}


		public function get speed() : Number
		{
			return _speed;
		}


		public function get httpStatus() : int
		{
			return _httpStatus;
		}


		public function get id() : String
		{
			return _id;
		}

		public function get humanFiriendlySize() : String
		{
			var kb : Number = _bytesTotal / 1024;
			if (kb < 1024)
			{
				return Math.ceil(kb) + " kb"
			}
			else
			{
				return (kb / 1024).toPrecision(3) + " mb"
			}
		}

		public function getStats() : String
		{
			return "Item url: " + url.url + "(s), total time: " + (_totalTime / 1000).toPrecision(3) + "(s), download time: " + (_timeToDownload).toPrecision(3) + "(s), latency:" + _latency + "(s), speed: " + _speed + " kb/s, size: " + humanFiriendlySize;
		}
	}
}
