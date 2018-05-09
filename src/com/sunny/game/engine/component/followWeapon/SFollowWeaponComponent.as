package com.sunny.game.engine.component.followWeapon
{
	import com.sunny.game.engine.component.SUpdatableComponent;
	import com.sunny.game.engine.entity.SEffectEntity;
	import com.sunny.game.engine.entity.SRenderableEntity;
	import com.sunny.game.engine.utils.SCommonUtil;
	import com.sunny.game.rpg.utils.SEffectUtil;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class SFollowWeaponComponent extends SUpdatableComponent
	{
		private var followEntity : SRenderableEntity;
		private var _followAvatar : Array;
		private var _followEntityDic : Dictionary;
		private var _followHeightGrids : int;
		private var _entityMapX : Number;
		private var _entityMapY : Number;
		private var _isMove : Boolean = false;
		private var _elapsedTime : int = 0;
		private var _posArray : Array;
		private var _follow : SEffectEntity;
		private var result : Array;
		private var start : Point = new Point();
		private static var startRotationConstArray : Array = [0, 90, 270, 180, 0, 135, 45, 225, 270];
		public static const FOLLOW_WEAPON_ENTITY_CONST : uint = 4987123;

		/**
		 * 跟随武器组件
		 * @param type
		 * @author Mandragora 2015年3月17日15:43:37
		 *
		 */
		public function SFollowWeaponComponent()
		{
			super(SFollowWeaponComponent);
		}

		override public function notifyAdded() : void
		{
			followEntity = owner as SRenderableEntity;
			_followAvatar = [];
			_followEntityDic = new Dictionary();
		}

		public function dataInit(followAvatar : Array, followLen : int = 150) : void
		{
			_entityMapX = followEntity.mapX;
			_entityMapY = followEntity.mapY;
			for each (var effect : SEffectEntity in _followEntityDic)
			{
				if (effect)
					effect.destroy();
				effect = null;
			}
			_followEntityDic = new Dictionary();
			_followAvatar = followAvatar;
			_followHeightGrids = followLen;
			createFollowEntity();
		}

		public function createFollowEntity() : void
		{
			if (!_followAvatar)
			{
				destroy();
				return;
			}
			for (var i : int = 0; i < _followAvatar.length; i++)
			{
				_followEntityDic[_followAvatar[i]] = SEffectUtil.createSceneEffect(followEntity.id + SFollowWeaponComponent.FOLLOW_WEAPON_ENTITY_CONST, _followAvatar[i], followEntity.mapX, followEntity.mapY, followEntity.direction);
			}
		}

		override public function destroy() : void
		{
			for each (var effect : SEffectEntity in _followEntityDic)
			{
				if (effect)
					effect.destroy();
				effect = null;
			}
			super.destroy();
		}

		override public function update() : void
		{
			if (_followAvatar.length == 0)
				return;
			_elapsedTime = elapsedTimes;
			if (_elapsedTime >= 1000)
				_elapsedTime = 25; //强制矫正
			start.x = followEntity.mapX;
			start.y = followEntity.mapY;
			if (_entityMapX != followEntity.mapX || _entityMapY != followEntity.mapY)
			{
				//行走时跟随者的位置队列
				_posArray = getWalkPointArray(_followAvatar.length);
				_isMove = true;
			}
			else
			{
				//时跟随者的位置队列
				_posArray = resetPosition(_followAvatar.length);
				_isMove = false;
			}
			var len : int = _followAvatar.length;
			for (var i : int = 0; i < len; i++)
			{
				_follow = _followEntityDic[_followAvatar[i]];
				if (_follow)
				{
					wait(_follow, _posArray[i]);
					checkFollowHeight(elapsedTimes, _follow);
				}
			}
		}

		private function getWalkPointArray(len : int) : Array
		{
			result = [];
			var rotation : int = SCommonUtil.getAngleByDir(SCommonUtil.getReverseDirByDir(followEntity.direction));
			var p : Point;
			for (var i : int = 1; i <= len; i++)
			{
				p = SCommonUtil.getPointByPointAndRotation(start, rotation, _followHeightGrids * i * 0.5);
				result.push(p);
			}
			return result;
		}

		private function wait(entity : SEffectEntity, point : Point) : void
		{
			var aroundDist : int;
			var distance : int = SCommonUtil.getDistance(point.x, point.y, entity.mapX, entity.mapY);
			if (distance <= 30)
			{
				entity.mapX = point.x;
				entity.mapY = point.y;
				_entityMapX = followEntity.mapX;
				_entityMapY = followEntity.mapY;
				return;
			}
			else
			{
				if (distance >= 1500)
				{
					entity.mapX = followEntity.mapX;
					entity.mapY = followEntity.mapY;
					return;
				}
				if (_isMove)
					aroundDist = _elapsedTime * followEntity.moveSpeed * 1.2;
				else
					aroundDist = _elapsedTime * followEntity.moveSpeed * 2;
				var angle : int = SCommonUtil.getAngle(entity.mapX, entity.mapY, point.x, point.y);
				var dx : Number = SCommonUtil.getDxByAngle(aroundDist, angle);
				var dy : Number = SCommonUtil.getDyByAngle(aroundDist, angle);
				entity.mapX += dx;
				entity.mapY += dy;
			}
		}

		private function getRotationPos(entityLen : int, startRotation : Number, rotation : Number = 30) : Array
		{
			var result : Array = new Array();
			for (var i : int = 1; i <= entityLen; i++)
			{
				var point : Point = SCommonUtil.getPointByPointAndRotation(start, startRotation + rotation * i, _followHeightGrids);
				result.push(point);
			}
			return result;
		}

		private function resetPosition(entityLen : int) : Array
		{
			var result : Array = new Array();
			var rotation : Number = 180 / (entityLen + 1);
			var startRatation : Number;
			startRatation = startRotationConstArray[followEntity.direction];
			result = getRotationPos(entityLen, startRatation, rotation);
			return result;
		}

		/**
		 * 用来划分层级结构的
		 * @param elapsedTime
		 *
		 */
		private function checkFollowHeight(elapsedTime : int, followEntity : SEffectEntity) : void
		{
			if (_followHeightGrids > 0)
			{
				var centerOffsetZ : int = followEntity.centerOffsetZ - followEntity.centerOffsetY + SCommonUtil.getPixelYByGrid(_followHeightGrids);
				if (followEntity.centerOffsetZ != centerOffsetZ)
				{
					var actualSpeed : Number = followEntity.moveSpeed * elapsedTime;
					if (centerOffsetZ > followEntity.centerOffsetZ)
					{
						if (followEntity.centerOffsetZ + actualSpeed > centerOffsetZ)
							followEntity.centerOffsetZ = centerOffsetZ;
						else
							followEntity.centerOffsetZ += actualSpeed;
					}
					else if (centerOffsetZ < followEntity.centerOffsetZ)
					{
						if (followEntity.centerOffsetZ + actualSpeed < centerOffsetZ)
							followEntity.centerOffsetZ = centerOffsetZ;
						else
							followEntity.centerOffsetZ -= actualSpeed;
					}
				}
			}
		}
	}
}
