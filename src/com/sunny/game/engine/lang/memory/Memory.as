/**
 * Memory
 *
 * A class with a few memory-management methods, as much as
 * such a thing exists in a Flash player.
 * Copyright (c) 2007 Henri Torgemane
 *
 * See LICENSE.txt for full license information.
 */
package com.sunny.game.engine.lang.memory
{
	import flash.net.LocalConnection;
	import flash.system.System;

	public class Memory
	{
		/**
		 * garbageCollection
		 *
		 */
		public static function gc() : void
		{
			// force a GC
			try
			{
				(new LocalConnection()).connect("foo");
				(new LocalConnection()).connect("foo");
			}
			catch (e : Error)
			{
//				new LocalConnection().connect("gc");
//				new LocalConnection().connect("gc");
				//			CONFIG::debug
				//			{
				//				trace("Hack gc!!!");//CONFIG::release
				//			}
			}
		}

		public static function get used() : uint
		{
			return System.totalMemory;
		}
	}
}