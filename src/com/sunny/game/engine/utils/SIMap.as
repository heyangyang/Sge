package com.sunny.game.engine.utils
{
	public interface SIMap
	{
		function clear() : void;
		function containsKey(key : Object) : Boolean;
		function containsValue(value : Object) : Boolean;
		function get(key : Object) : Object;
		function put(key : Object, value : Object) : Object;
		function remove(key : Object) : Object;
		function putAll(map : SIMap) : void;
		function size() : uint;
		function isEmpty() : Boolean;
		function values() : Array;
		function get keys() : Array;
		function get length() : uint;
	}
}