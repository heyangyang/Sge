package com.sunny.game.engine.lang.errors
{
	import com.sunny.game.engine.lang.errors.SAbstractError;

	/** An AbstractMethodError is thrown when you attempt to call an abstract method. */
	public class SAbstractMethodError extends SAbstractError
	{
		/** Creates a new AbstractMethodError object. */
		public function SAbstractMethodError(message : * = "Method needs to be implemented in subclass", id : * = 0)
		{
			super(message, id);
		}
	}
}