package com.sunny.game.engine.utils.serialize 
{
	
	public interface ISerializable 
	{
		function serialize():*;
		
		function deserialize(data:Object):Boolean;
	}
	
}