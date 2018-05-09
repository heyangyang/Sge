package com.sunny.game.engine.lang.exceptions
{
	/**
	 * 非法的参数 
	 */	
	
	public class IllegalParameterException extends Error 
	{
		public function IllegalParameterException(message:*=null, id:*=0)
		{
			super(message, id);
			name = "IllegalParameterException";
		}
	}
}