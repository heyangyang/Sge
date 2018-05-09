package com.sunny.game.engine.loader
{
	

	public class SLoadNode implements SILoadNode
	{
		protected var compelete : Function;

		public function SLoadNode()
		{
		}

		public function startLoad() : void
		{
		}

		public function forceComplete() : void
		{
		}

		public function setOnCompleteNotify(fun : Function) : void
		{
			compelete = fun;
		}

		protected function excuteHandler() : void
		{
			compelete != null && compelete();
			compelete = null;
		}

		public function getState() : String
		{
			return null;
		}
	}
}