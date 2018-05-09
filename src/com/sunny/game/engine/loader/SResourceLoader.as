package com.sunny.game.engine.loader
{
	import com.sunny.game.engine.loader.events.SProgressEvent;
	import com.sunny.game.engine.loader.types.BinaryItem;
	import com.sunny.game.engine.loader.types.ImageItem;
	import com.sunny.game.engine.loader.types.LoadingItem;
	import com.sunny.game.engine.loader.types.SoundItem;
	import com.sunny.game.engine.loader.types.URLItem;
	import com.sunny.game.engine.loader.types.VideoItem;
	import com.sunny.game.engine.loader.types.XMLItem;

	import flash.display.AVM1Movie;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;


	public class SResourceLoader extends EventDispatcher
	{
		public static const VERSION : String = "$Id$";

		public static const TYPE_BINARY : String = "binary";

		public static const TYPE_IMAGE : String = "image";

		public static const TYPE_MOVIECLIP : String = "movieclip";

		public static const TYPE_SOUND : String = "sound";

		public static const TYPE_TEXT : String = "text";

		public static const TYPE_XML : String = "xml";

		public static const TYPE_VIDEO : String = "video";

		public static const AVAILABLE_TYPES : Array = [TYPE_VIDEO, TYPE_XML, TYPE_TEXT, TYPE_SOUND, TYPE_MOVIECLIP, TYPE_IMAGE, TYPE_BINARY];

		public static var AVAILABLE_EXTENSIONS : Array = ["swf", "jpg", "jpeg", "gif", "png", "flv", "mp3", "xml", "txt", "js"];

		public static var IMAGE_EXTENSIONS : Array = ["jpg", "jpeg", "gif", "png"];

		public static var MOVIECLIP_EXTENSIONS : Array = ['swf'];

		public static var TEXT_EXTENSIONS : Array = ["txt", "js", "php", "asp", "py"];

		public static var VIDEO_EXTENSIONS : Array = ["flv", "f4v", "f4p", "mp4"];

		public static var SOUND_EXTENSIONS : Array = ["mp3", "f4a", "f4b"];

		public static var XML_EXTENSIONS : Array = ["xml"];


		public static var _customTypesExtensions : Object;

		public static const PROGRESS : String = "progress";

		public static const COMPLETE : String = "complete";


		public static const HTTP_STATUS : String = "httpStatus";


		public static const ERROR : String = "error";


		public static const SECURITY_ERROR : String = "securityError";

		public static const OPEN : String = "open";


		public static const CAN_BEGIN_PLAYING : String = "canBeginPlaying";

		public static const CHECK_POLICY_FILE : String = "checkPolicyFile";

		public static const PREVENT_CACHING : String = "preventCache";

		public static const HEADERS : String = "headers";

		public static const CONTEXT : String = "context";

		public static const ID : String = "id";


		public static const PRIORITY : String = "priority";


		public static const MAX_TRIES : String = "maxTries";

		public static const WEIGHT : String = "weight";


		public static const PAUSED_AT_START : String = "pausedAtStart";

		public static const GENERAL_AVAILABLE_PROPS : Array = [WEIGHT, MAX_TRIES, HEADERS, ID, PRIORITY, PREVENT_CACHING, "type"];


		public var _name : String;

		public var _id : int;

		public static var _instancesCreated : int = 0;

		public var _items : Array = [];

		public var _contents : Dictionary = new Dictionary(true);

		public var _additionIndex : int = 0;

		public var _numConnections : int;

		public var _connections : Array = [];


		public var _loadedRatio : Number = 0;

		public var _itemsTotal : int = 0;

		public var _itemsLoaded : int = 0;

		public var _totalWeight : int = 0;

		public var _bytesTotal : int = 0;

		public var _bytesTotalCurrent : int = 0;

		public var _bytesLoaded : int = 0;

		public var _percentLoaded : Number = 0;


		public var _weightPercent : Number;


		public var avgLatency : Number;

		public var speedAvg : Number;

		public var _speedTotal : Number;

		public var _startTime : int;

		public var _endTIme : int;

		public var _lastSpeedCheck : int;

		public var _lastBytesCheck : int;


		public var _speed : Number;

		public var totalTime : Number;

		public var _isRunning : Boolean;

		public var _isFinished : Boolean;

		public var _isPaused : Boolean = true;


		public var _stringSubstitutions : Object;

		public static var _typeClasses : Object = {image: ImageItem, movieclip: ImageItem, xml: XMLItem, video: VideoItem, sound: SoundItem, text: URLItem, binary: BinaryItem};


		public function SResourceLoader(name : String, numConnections : int)
		{
			_numConnections = numConnections;
			_name = name;
			_instancesCreated++;
			_id = _instancesCreated;
			_additionIndex = 0;
			addEventListener(SResourceLoader.ERROR, _swallowError, false, 1, true);
		}

		public static function _hasItemInBulkLoader(key : *, atLoader : SResourceLoader) : Boolean
		{
			var item : LoadingItem = atLoader.get(key);
			if (item && item._isLoaded)
			{
				return true;
			}
			return false;
		}

		public function add(url : *, props : Object = null) : LoadingItem
		{
			if (!_name)
			{
				throw new Error("[SResourceLoader] Cannot use an instance that has been cleared from memory (.clear())");
			}
			if (!url || !String(url))
			{
				throw new Error("[SResourceLoader] Cannot add an item with a null url");
			}
			props = props || {};
			if (url is String)
			{
				url = new URLRequest(SResourceLoader.substituteURLString(url, _stringSubstitutions));
				if (props[HEADERS])
				{
					url.requestHeaders = props[HEADERS];
				}
			}
			else if (!url is URLRequest)
			{
				throw new Error("[SResourceLoader] cannot add object with bad type for url:'" + url.url);
			}
			var item : LoadingItem = get(props[ID]);
			if (item)
			{
				return item;
			}
			var type : String;
			if (props["type"])
			{
				type = props["type"].toLowerCase();
				// does this type exist?
				if (AVAILABLE_TYPES.indexOf(type) == -1)
				{
				}
			}
			if (!type)
			{
				type = guessType(url.url);

			}
			_additionIndex++;
			item = new _typeClasses[type](url, type, _instancesCreated + "_" + String(_additionIndex));
			if (!props["id"])
			{
				props["id"] = getFileName(url.url);
			}
			item._parseOptions(props);
			item._addedTime = getTimer();
			item._additionIndex = _additionIndex;
			item.addEventListener(Event.COMPLETE, _onItemComplete, false, int.MIN_VALUE, true);
			item.addEventListener(Event.COMPLETE, _incrementItemsLoaded, false, int.MAX_VALUE, true);
			item.addEventListener(ERROR, _onItemError, false, 0, true);
			item.addEventListener(Event.OPEN, _onItemStarted, false, 0, true);
			item.addEventListener(ProgressEvent.PROGRESS, _onProgress, false, 0, true);
			_items.push(item);
			_itemsTotal += 1;
			_totalWeight += item.weight;
			sortItemsByPriority();
			_isFinished = false;
			if (!_isPaused)
				_loadNext();
			return item;
		}


		public function start(withConnections : int = -1) : void
		{
			if (withConnections > 0)
			{
				_numConnections = withConnections;
			}
			_startTime = getTimer();
			_loadNext();
			_isRunning = true;
			_lastBytesCheck = 0;
			_lastSpeedCheck = getTimer();
			_isPaused = false;
		}

		public function _getLeastUrgentOpenedItem() : LoadingItem
		{
			_connections.sortOn(["priority", "bytesRemaining", "_additionIndex"], [Array.NUMERIC, Array.DESCENDING, Array.NUMERIC])
			var toRemove : LoadingItem = LoadingItem(_connections[0]);
			return toRemove;
		}

		public function _getNextItemToLoad() : LoadingItem
		{
			if (_connections.length >= _numConnections)
				return null;
			_connections.forEach(function(i : LoadingItem, ... rest) : void
				{
					if (i.status == LoadingItem.STATUS_ERROR && i.numTries >= i.maxTries)
					{
						_removeFromConnections(i);
					}
				});
			for each (var checkItem : LoadingItem in _items)
			{
				if (!checkItem._isLoading && checkItem.status != LoadingItem.STATUS_STOPPED)
				{
					return checkItem;
				}
			}
			return null;
		}

		public function _loadNext(toLoad : LoadingItem = null) : Boolean
		{
			if (_isFinished)
				return false;

			var next : Boolean = false;
			toLoad = toLoad || _getNextItemToLoad();
			if (toLoad)
			{
				next = true;
				_isRunning = true;
				_connections.push(toLoad);
				toLoad.load();
				//继续加载下一个
				_loadNext();
			}
			return next;
		}


		public function _onItemComplete(evt : Event) : void
		{
			var item : LoadingItem = evt.target as LoadingItem;
			_removeFromConnections(item);
			item.cleanListeners();
			_contents[item.url.url] = item.content;
			var next : Boolean = _loadNext();
			var allDone : Boolean = _isAllDoneP();

			if (allDone)
				_onAllLoaded();
			evt.stopPropagation();
		}


		public function _incrementItemsLoaded(evt : Event) : void
		{
			_itemsLoaded++;
		}


		public function _updateStats() : void
		{
			avgLatency = 0;
			speedAvg = 0;
			var totalLatency : Number = 0;
			var totalBytes : int = 0;
			_speedTotal = 0;
			var num : Number = 0;
			for each (var item : LoadingItem in _items)
			{
				if (item._isLoaded && item.status != LoadingItem.STATUS_ERROR)
				{
					totalLatency += item.latency;
					totalBytes += item.bytesTotal;
					num++;
				}
			}
			_speedTotal = (totalBytes / 1024) / totalTime;
			avgLatency = totalLatency / num;
			speedAvg = _speedTotal / num;
		}


		public function _removeFromItems(item : LoadingItem) : Boolean
		{
			var removeIndex : int = _items.indexOf(item);
			if (removeIndex > -1)
			{
				_items.splice(removeIndex, 1);
			}
			else
			{
				return false;
			}
			if (item._isLoaded)
			{
				_itemsLoaded--;
			}
			_itemsTotal--;
			_totalWeight -= item.weight;
			////SDebug.infoPrint(this, "Removing " + item);
			item.removeEventListener(Event.COMPLETE, _onItemComplete, false)
			item.removeEventListener(Event.COMPLETE, _incrementItemsLoaded, false)
			item.removeEventListener(ERROR, _onItemError, false);
			item.removeEventListener(Event.OPEN, _onItemStarted, false);
			item.removeEventListener(ProgressEvent.PROGRESS, _onProgress, false);
			return true;
		}


		public function _removeFromConnections(item : *) : Boolean
		{
			if (!_connections)
				return false;
			var removeIndex : int = _connections.indexOf(item);
			if (removeIndex > -1)
			{
				_connections.splice(removeIndex, 1);
				return true;
			}
			return false;
		}


		public function _onItemError(evt : ErrorEvent) : void
		{
			var item : LoadingItem = evt.target as LoadingItem;
			_removeFromConnections(item);
			_loadNext();
			dispatchEvent(evt);
		}




		public function _onItemStarted(evt : Event) : void
		{
			var item : LoadingItem = evt.target as LoadingItem;

			//SDebug.infoPrint(item, "Started loading");
			dispatchEvent(evt);
		}


		public function _onProgress(evt : Event = null) : void
		{
			// TODO: check these values are correct! tough _onProgress
			var e : SProgressEvent = getProgressForItems(_items);
			// update values:
			_bytesLoaded = e.bytesLoaded;
			_bytesTotal = e.bytesTotal;
			_weightPercent = e.weightPercent;
			_percentLoaded = e.percentLoaded;
			_bytesTotalCurrent = e.bytesTotalCurrent;
			_loadedRatio = e.ratioLoaded;
			dispatchEvent(e);
		}


		public function getProgressForItems(keys : Array) : SProgressEvent
		{
			_bytesLoaded = _bytesTotal = _bytesTotalCurrent = 0;
			var localWeightPercent : Number = 0;
			var localWeightTotal : int = 0;
			var itemsStarted : int = 0;
			var localWeightLoaded : Number = 0;
			var localItemsTotal : int = 0;
			var localItemsLoaded : int = 0;
			var localBytesLoaded : int = 0;
			var localBytesTotal : int = 0;
			var localBytesTotalCurrent : int = 0;
			var item : LoadingItem;
			var theseItems : Array = [];
			for each (var key : * in keys)
			{
				item = get(key);
				if (!item)
					continue;
				localItemsTotal++;
				localWeightTotal += item.weight;
				if (item.status == LoadingItem.STATUS_STARTED || item.status == LoadingItem.STATUS_FINISHED || item.status == LoadingItem.STATUS_STOPPED)
				{
					localBytesLoaded += item._bytesLoaded;
					localBytesTotalCurrent += item._bytesTotal;
					if (item._bytesTotal > 0)
					{
						localWeightLoaded += (item._bytesLoaded / item._bytesTotal) * item.weight;
					}
					if (item.status == LoadingItem.STATUS_FINISHED)
					{
						localItemsLoaded++;
					}
					itemsStarted++;
				}
			}

			if (itemsStarted != localItemsTotal)
				localBytesTotal = Number.POSITIVE_INFINITY;
			else
				localBytesTotal = localBytesTotalCurrent;
			localWeightPercent = localWeightLoaded / localWeightTotal;
			if (localWeightTotal == 0)
				localWeightPercent = 0;
			var e : SProgressEvent = new SProgressEvent(PROGRESS);
			e.setInfo(localBytesLoaded, localBytesTotal, localBytesTotal, localItemsLoaded, localItemsTotal, localWeightPercent);
			return e;
		}

		public function get contents() : Object
		{
			return _contents;
		}


		public function get items() : Array
		{
			return _items.slice();
		}


		public function get name() : String
		{
			return _name;
		}


		public function get loadedRatio() : Number
		{
			return _loadedRatio;
		}


		public function get itemsTotal() : int
		{
			return items.length;
		}


		public function get itemsLoaded() : int
		{
			return _itemsLoaded;
		}

		public function set itemsLoaded(value : int) : void
		{
			_itemsLoaded = value;
		}


		public function get totalWeight() : int
		{
			return _totalWeight;
		}


		public function get bytesTotal() : int
		{
			return _bytesTotal;
		}



		public function get bytesLoaded() : int
		{
			return _bytesLoaded;
		}


		public function get bytesTotalCurrent() : int
		{
			return _bytesTotalCurrent;
		}


		public function get percentLoaded() : Number
		{
			return _percentLoaded;
		}


		public function get weightPercent() : Number
		{
			return _weightPercent;
		}


		public function get isRunning() : Boolean
		{
			return _isRunning;
		}

		public function get isFinished() : Boolean
		{
			return _isFinished;
		}


		public function get highestPriority() : int
		{
			var highest : int = int.MIN_VALUE;
			for each (var item : LoadingItem in _items)
			{
				if (item.priority > highest)
					highest = item.priority;
			}
			return highest;
		}

		public function getNotLoadedItems() : Array
		{
			return _items.filter(function(i : LoadingItem, ... rest) : Boolean
				{
					return i.status != LoadingItem.STATUS_FINISHED;
				});
		}


		public function get speed() : Number
		{
			// TODO: test get speed
			var timeElapsed : int = getTimer() - _lastSpeedCheck;
			var bytesDelta : int = (bytesLoaded - _lastBytesCheck) / 1024;
			var speed : int = bytesDelta / (timeElapsed / 1000);
			_lastSpeedCheck = timeElapsed;
			_lastBytesCheck = bytesLoaded;
			return speed;
		}


		public function get id() : int
		{
			return _id;
		}


		public function get stringSubstitutions() : Object
		{
			return _stringSubstitutions;
		}

		public function set stringSubstitutions(value : Object) : void
		{
			_stringSubstitutions = value;
		}


		public function changeItemPriority(key : *, newPriority : int) : Boolean
		{
			var item : LoadingItem = get(key);
			if (!item)
			{
				return false;
			}
			item._priority = newPriority;
			sortItemsByPriority();
			return true;
		}


		public function sortItemsByPriority() : void
		{
			// addedTime might not be precise, if subsequent add() calls are whithin getTimer precision
			// range, so we use _additionIndex
			_items.sortOn(["priority", "_additionIndex"], [Array.NUMERIC | Array.DESCENDING, Array.NUMERIC]);
		}







		public function _getContentAsType(key : *, type : Class, clearMemory : Boolean = false) : *
		{
			if (!_name)
			{
				throw new Error("[SResourceLoader] Cannot use an instance that has been cleared from memory (.clear())");
			}
			var item : LoadingItem = get(key);
			if (!item)
			{
				return null;
			}
			if (item._isLoaded || item.isStreamable() && item.status == LoadingItem.STATUS_STARTED)
			{
				var res : * = item.content as type;
				if (res == null)
				{
					throw new Error("bad cast");
				}
				if (clearMemory)
				{
					remove(key);
					if (!_isPaused)
					{
						_loadNext();
					}
				}
				return res;
			}

			return null;
		}


		public function getContent(key : String, clearMemory : Boolean = false) : *
		{
			return _getContentAsType(key, Object, clearMemory);
		}


		public function getXML(key : *, clearMemory : Boolean = false) : XML
		{
			return XML(_getContentAsType(key, XML, clearMemory));
		}


		public function getText(key : *, clearMemory : Boolean = false) : String
		{
			return String(_getContentAsType(key, String, clearMemory));
		}


		public function getSound(key : *, clearMemory : Boolean = false) : Sound
		{
			return Sound(_getContentAsType(key, Sound, clearMemory));
		}


		public function getBitmap(key : String, clearMemory : Boolean = false) : Bitmap
		{
			return Bitmap(_getContentAsType(key, Bitmap, clearMemory));
		}


		public function getDisplayObjectLoader(key : String, clearMemory : Boolean = false) : Loader
		{
			if (!_name)
			{
				throw new Error("[SResourceLoader] Cannot use an instance that has been cleared from memory (.clear())");
			}
			var item : ImageItem = get(key) as ImageItem;
			if (!item)
			{
				return null;
			}
			var res : Loader = item.loader as Loader;
			if (!res)
			{
				throw new Error("bad cast");
			}
			if (clearMemory)
			{
				remove(key);
				if (!_isPaused)
				{
					_loadNext();
				}
			}
			return res;
		}


		public function getMovieClip(key : String, clearMemory : Boolean = false) : MovieClip
		{
			return MovieClip(_getContentAsType(key, MovieClip, clearMemory));
		}


		public function getSprite(key : String, clearMemory : Boolean = false) : Sprite
		{
			return Sprite(_getContentAsType(key, Sprite, clearMemory));
		}


		public function getAVM1Movie(key : String, clearMemory : Boolean = false) : AVM1Movie
		{
			return AVM1Movie(_getContentAsType(key, AVM1Movie, clearMemory));
		}



		public function getNetStream(key : String, clearMemory : Boolean = false) : NetStream
		{
			return NetStream(_getContentAsType(key, NetStream, clearMemory));
		}


		public function getNetStreamMetaData(key : String, clearMemory : Boolean = false) : Object
		{
			var netStream : NetStream = getNetStream(key, clearMemory);
			return (Boolean(netStream) ? (get(key) as Object).metaData : null);

		}


		public function getBitmapData(key : *, clearMemory : Boolean = false) : BitmapData
		{
			return getBitmap(key, clearMemory).bitmapData;
		}


		public function getBinary(key : *, clearMemory : Boolean = false) : ByteArray
		{
			return ByteArray(_getContentAsType(key, ByteArray, clearMemory));

		}


		public function getSerializedData(key : *, clearMemory : Boolean = false, encodingFunction : Function = null) : *
		{
			var raw : * = _getContentAsType(key, Object, clearMemory);
			var parsed : * = encodingFunction.apply(null, [raw]);
			return parsed;
		}


		public function getHttpStatus(key : *) : int
		{
			var item : LoadingItem = get(key);
			if (item)
			{
				return item.httpStatus;
			}
			return -1;
		}


		public function _isAllDoneP() : Boolean
		{
			return _items.every(function(item : LoadingItem, ... rest) : Boolean
				{
					return item._isLoaded;
				});
		}


		public function _onAllLoaded() : void
		{
			if (_isFinished)
			{
				return;
			}
			var eComplete : SProgressEvent = new SProgressEvent(COMPLETE);
			eComplete.setInfo(bytesLoaded, bytesTotal, bytesTotalCurrent, _itemsLoaded, itemsTotal, weightPercent);
			var eProgress : SProgressEvent = new SProgressEvent(PROGRESS);
			eProgress.setInfo(bytesLoaded, bytesTotal, bytesTotalCurrent, _itemsLoaded, itemsTotal, weightPercent);
			_isRunning = false;
			_endTIme = getTimer();
			totalTime = SResourceLoader.truncateNumber((_endTIme - _startTime) / 1000);
			_updateStats();
			_connections.length = 0;
			getStats();
			_isFinished = true;
			//SDebug.infoPrint(this, "Finished all");
			dispatchEvent(eProgress);
			dispatchEvent(eComplete);
		}


		public function getStats() : String
		{
			var stats : Array = [];
			stats.push("\n************************************");
			stats.push("All items loaded(" + itemsTotal + ")");
			stats.push("Total time(s):       " + totalTime);
			stats.push("Average latency(s):  " + truncateNumber(avgLatency));
			stats.push("Average speed(kb/s): " + truncateNumber(speedAvg));
			stats.push("Median speed(kb/s):  " + truncateNumber(_speedTotal));
			stats.push("KiloBytes total:     " + truncateNumber(bytesTotal / 1024));
			var itemsInfo : Array = _items.map(function(item : LoadingItem, ... rest) : String
				{
					return "\t" + item.getStats();
				});
			stats.push(itemsInfo.join("\n"))
			stats.push("************************************");
			var statsString : String = stats.join("\n");
			////SDebug.infoPrint(this, statsString);
			return statsString;
		}


		public function get(key : *) : LoadingItem
		{
			if (!key)
				return null;
			if (key is LoadingItem)
				return key;
			for each (var item : LoadingItem in _items)
			{
				if (item._id == key || item._parsedURL.rawString == key || item.url == key || (key is URLRequest && item.url.url == key.url))
				{
					return item;
				}
			}
			return null;
		}


		public function remove(key : *, internalCall : Boolean = false) : Boolean
		{
			var item : LoadingItem = get(key);
			if (!item)
			{
				return false;
			}
			_removeFromItems(item);
			_removeFromConnections(item);
			item.destroy();
			delete _contents[item.url.url];
			// this has to be checked, else a removeAll will trigger events for completion
			if (internalCall)
			{
				return true;
			}
			item = null;
			// checks is removing this item we are done?
			_onProgress();
			var allDone : Boolean = _isAllDoneP();
			if (allDone)
			{
				_onAllLoaded();
			}
			return false;

		}


		public function removeAll() : void
		{
			for each (var item : LoadingItem in _items.slice())
			{
				remove(item, true);
			}
			_items = [];
			_connections.length = 0;
			_contents = new Dictionary(true);
			_percentLoaded = _weightPercent = _loadedRatio = 0;
		}


		public function clear() : void
		{
			removeAll();
			_name = null;
		}


		public function removePausedItems() : Boolean
		{
			var stoppedLoads : Array = _items.filter(function(item : LoadingItem, ... rest) : Boolean
				{
					return (item.status == LoadingItem.STATUS_STOPPED);
				});
			stoppedLoads.forEach(function(item : LoadingItem, ... rest) : void
				{
					remove(item);
				});
			_loadNext();
			return stoppedLoads.length > 0;
		}


		public function removeFailedItems() : int
		{
			var numCleared : int = 0;
			var badItems : Array = _items.filter(function(item : LoadingItem, ... rest) : Boolean
				{
					return (item.status == LoadingItem.STATUS_ERROR);
				});
			numCleared = badItems.length;
			badItems.forEach(function(item : LoadingItem, ... rest) : void
				{
					remove(item);
				});
			_loadNext();
			return numCleared;
		}


		public function getFailedItems() : Array
		{
			return _items.filter(function(item : LoadingItem, ... rest) : Boolean
				{
					return (item.status == LoadingItem.STATUS_ERROR);
				});
		}


		public function pause(key : *, loadsNext : Boolean = false) : Boolean
		{
			var item : LoadingItem = get(key);
			if (!item)
			{
				return false;
			}
			if (item.status && item.status != LoadingItem.STATUS_FINISHED)
			{
				item.stop();
			}
			//SDebug.infoPrint(item, "STOPPED ITEM:");
			var result : Boolean = _removeFromConnections(item);
			if (loadsNext)
			{
				_loadNext();
			}
			return result;
		}


		public function pauseAll() : void
		{
			for each (var item : LoadingItem in _items)
			{
				pause(item);
			}
			_isRunning = false;
			_isPaused = true;
			//SDebug.infoPrint(this, "Stopping all items");
		}

		public function resume(key : *) : Boolean
		{
			var item : LoadingItem = key is LoadingItem ? key : get(key);
			_isPaused = false;
			if (item && item.status == LoadingItem.STATUS_STOPPED)
			{
				item.status = null;
				_loadNext();
				return true;
			}
			return false;
		}


		public function resumeAll() : Boolean
		{
			//SDebug.infoPrint(this, "Resuming all items");
			var affected : Boolean = false;
			_items.forEach(function(item : LoadingItem, ... rest) : void
				{
					if (item.status == LoadingItem.STATUS_STOPPED)
					{
						resume(item);
						affected = true;
					}
				});
			_loadNext();
			return affected;
		}


		public static function truncateNumber(raw : Number, decimals : int = 2) : Number
		{
			var power : int = Math.pow(10, decimals);
			return Math.round(raw * (power)) / power;
		}


		override public function toString() : String
		{
			return "[SResourceLoader] name:" + name + ", itemsTotal: " + itemsTotal + ", itemsLoaded: " + _itemsLoaded;
		}


		public static function guessType(urlAsString : String) : String
		{
			var searchString : String = urlAsString.indexOf("?") > -1 ? urlAsString.substring(0, urlAsString.indexOf("?")) : urlAsString;
			var finalPart : String = searchString.substring(searchString.lastIndexOf("/"));
			var extension : String = finalPart.substring(finalPart.lastIndexOf(".") + 1).toLowerCase();
			var type : String;
			if (!Boolean(extension))
			{
				extension = SResourceLoader.TYPE_TEXT;
			}
			if (extension == SResourceLoader.TYPE_IMAGE || SResourceLoader.IMAGE_EXTENSIONS.indexOf(extension) > -1)
			{
				type = SResourceLoader.TYPE_IMAGE;
			}
			else if (extension == SResourceLoader.TYPE_SOUND || SResourceLoader.SOUND_EXTENSIONS.indexOf(extension) > -1)
			{
				type = SResourceLoader.TYPE_SOUND;
			}
			else if (extension == SResourceLoader.TYPE_VIDEO || SResourceLoader.VIDEO_EXTENSIONS.indexOf(extension) > -1)
			{
				type = SResourceLoader.TYPE_VIDEO;
			}
			else if (extension == SResourceLoader.TYPE_XML || SResourceLoader.XML_EXTENSIONS.indexOf(extension) > -1)
			{
				type = SResourceLoader.TYPE_XML;
			}
			else if (extension == SResourceLoader.TYPE_MOVIECLIP || SResourceLoader.MOVIECLIP_EXTENSIONS.indexOf(extension) > -1)
			{
				type = SResourceLoader.TYPE_MOVIECLIP;
			}
			else
			{
				// is this on a new extension?
				for (var checkType : String in _customTypesExtensions)
				{
					for each (var checkExt : String in _customTypesExtensions[checkType])
					{
						if (checkExt == extension)
						{
							type = checkType;
							break;
						}
						if (type)
							break;
					}
				}
				if (!type)
					type = SResourceLoader.TYPE_TEXT;
			}
			return type;
		}


		public static function substituteURLString(raw : String, substitutions : Object) : String
		{
			if (!substitutions)
				return raw;
			var subRegex : RegExp = /(?P<var_name>\{\s*[^\}]*\})/g;
			var result : Object = subRegex.exec(raw);
			var var_name : String = result ? result.var_name : null;
			var matches : Array = [];
			var numRuns : int = 0;
			while (Boolean(result) && Boolean(result.var_name))
			{
				if (result.var_name)
				{
					var_name = result.var_name;
					var_name = var_name.replace("{", "");
					var_name = var_name.replace("}", "");
					var_name = var_name.replace(/\s*/g, "");
				}
				matches.push({start: result.index, end: result.index + result.var_name.length, changeTo: substitutions[var_name]});
				// be paranoid so we don't hang the player if the matching goes cockos
				numRuns++;
				if (numRuns > 400)
				{
					break;
				}
				result = subRegex.exec(raw);
				var_name = result ? result.var_name : null;
			}
			if (matches.length == 0)
			{
				return raw;
			}
			var buffer : Array = [];
			var lastMatch : Object, match : Object;
			// beggininf os string, if it doesn't start with a substitition
			var previous : String = raw.substr(0, matches[0].start);
			var subs : String;
			for each (match in matches)
			{
				// finds out the previous string part and the next substitition
				if (lastMatch)
				{
					previous = raw.substring(lastMatch.end, match.start);
				}
				buffer.push(previous);
				buffer.push(match.changeTo);
				lastMatch = match;
			}
			// buffer the tail of the string: text after the last substitution
			buffer.push(raw.substring(match.end));
			return buffer.join("");
		}


		public static function getFileName(text : String, allowExtension : Boolean = false) : String
		{
			if (text.lastIndexOf("/") == text.length - 1)
			{
				return getFileName(text.substring(0, text.length - 1));
			}
			var startAt : int = text.lastIndexOf("/") + 1;
			//if (startAt == -1) startAt = 0;
			var croppedString : String = text.substring(startAt);
			var lastIndex : int = allowExtension ? croppedString.length : croppedString.indexOf(".");
			if (lastIndex == -1)
			{
				if (croppedString.indexOf("?") > -1)
				{
					lastIndex = croppedString.indexOf("?");
				}
				else
				{
					lastIndex = croppedString.length;
				}
			}

			var finalPath : String = croppedString.substring(0, lastIndex);
			return finalPath;
		}


		public function _swallowError(e : Event) : void
		{
		}

	}
}
