package com.sunny.game.engine.pattern.subject
{
	import com.sunny.game.engine.core.SObject;
	import com.sunny.game.engine.lang.destroy.SDestroyUtil;
	import com.sunny.game.engine.lang.destroy.SIDestroy;
	import com.sunny.game.engine.lang.exceptions.SNullPointerException;

	import flash.utils.Dictionary;

	public class Subject extends SObject implements SIDestroy
	{
		private var _observers : Dictionary /*key IObserver, value IObserver*/ = null;
		protected var _isDisposed : Boolean;

		public function Subject()
		{
			super();
			_isDisposed = false;
			_observers = new Dictionary();
		}

		public function addObserver(observer : IObserver) : void
		{
			if (observer == null)
			{
				throw new SNullPointerException("Null observer");
			}

			_observers[observer] = observer;
		}

		public function removeObserver(observer : IObserver) : IObserver
		{
			delete _observers[observer];
			return observer;
		}

		public function containsObserver(observer : IObserver) : Boolean
		{
			return _observers[observer] != null;
		}

		public function notify(data : INofityData = null) : void
		{
			// 记录已经被update过的观察者
			// 如果在观察者的update方法中执行了removeObserver方法，就会发生某个obsever被update两次
			// 这个变量就是这个作用的，避免一个observer被重复update两次
			var alreadyUpdate : Dictionary = new Dictionary();

			for each (var observer : IObserver in _observers)
			{
				if (alreadyUpdate[observer] == null)
				{
					alreadyUpdate[observer] = observer;
					observer.update(data);
				}
			}
		}

		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}

		public function destroy() : void
		{
			SDestroyUtil.breakMap(_observers);
			_observers = null;
			_isDisposed = true;
		}
	}
}