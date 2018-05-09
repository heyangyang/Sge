package com.sunny.game.engine.lang.errors
{
    /** A MissingContextError is thrown when a Context3D object is required but not (yet) 
     *  available. */
    public class SMissingContextError extends Error
    {
        /** Creates a new MissingContextError object. */
        public function SMissingContextError(message:*="Starling context is missing", id:*=0)
        {
            super(message, id);
        }
    }
}