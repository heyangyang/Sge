package com.sunny.game.engine.lang.exceptions
{
	public class IllegalStateException extends Error
	{
		public function IllegalStateException(message:*="", id:*=0)
		{
			super(message, id);
			name = "IllegalStateException";
		}
	}
}