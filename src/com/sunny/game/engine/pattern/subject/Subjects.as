package com.sunny.game.engine.pattern.subject
{
	import com.sunny.game.engine.core.SObject;
	import com.sunny.game.engine.lang.destroy.SDestroyUtil;
	import com.sunny.game.engine.lang.destroy.SIDestroy;
	import com.sunny.game.engine.lang.exceptions.NoSuchObjectException;
	import com.sunny.game.engine.lang.exceptions.SNullPointerException;

	import flash.utils.Dictionary;

	public class Subjects extends SObject implements SIDestroy
	{
		public var _subjects : Dictionary = null;

		private var _tempNotifyData : NotifyData = null;
		protected var _isDisposed : Boolean;

		public function Subjects()
		{
			super();
			_isDisposed = false;
			_subjects = new Dictionary();
			_tempNotifyData = new NotifyData();
		}

		public function addSubjectsCall(... subjectIDs) : void
		{
			for each (var subjectID : Object in subjectIDs)
			{
				addSubject(subjectID);
			}
		}

		public function addSubject(subjectID : Object, subject : Subject = null) : void
		{
			if (subjectID == null)
			{
				throw new SNullPointerException("Null subject id");
			}

			_subjects[subjectID] = subject == null ? new Subject() : subject;
		}

		public function removeSubject(subjectID : Object) : Subject
		{
			var subject : Subject = _subjects[subjectID];
			delete _subjects[subjectID];

			return subject;
		}

		public function contiansSubject(subjectID : Object) : Boolean
		{
			return _subjects[subjectID] != null;
		}

		public function getSubject(subjectID : Object) : Subject
		{
			return _subjects[subjectID];
		}

		public function notifySubject(subjectID : Object, data : INofityData = null) : void
		{
			var subject : Subject = _subjects[subjectID];
			if (subject == null)
			{
				throw new NoSuchObjectException("Has not the subject \"" + subjectID + "\"");
			}
			if (data == null)
			{
				_tempNotifyData.setSubjectID(subjectID);
				subject.notify(_tempNotifyData);
			}
			else
			{
				data.setSubjectID(subjectID);
				subject.notify(data);
			}
		}

		public function followSubject(observer : IObserver, subjectID : Object) : void
		{
			var subject : Subject = _subjects[subjectID];
			if (subject == null)
			{
				throw new NoSuchObjectException("Has not the subject \"" + subjectID + "\"");
			}
			subject.addObserver(observer);
		}

		public function unfollowSubject(observer : IObserver, subjectID : Object) : void
		{
			var subject : Subject = _subjects[subjectID];
			if (subject == null)
			{
				throw new NoSuchObjectException("Has not the subject \"" + subjectID + "\"");
			}
			subject.removeObserver(observer);
		}

		public function get isDisposed() : Boolean
		{
			return _isDisposed;
		}

		public function destroy() : void
		{
			SDestroyUtil.breakMap(_subjects);
			_subjects = null;

			_tempNotifyData = null;
			_isDisposed = true;
		}
	}
}