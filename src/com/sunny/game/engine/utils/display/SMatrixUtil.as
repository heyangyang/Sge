package com.sunny.game.engine.utils.display
{
	import com.sunny.game.engine.lang.errors.SAbstractClassError;

	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;

	/**
	 * 矩阵转换类，主要用于draw方法的矩阵转换参数
	 * 一种含有的矩阵类的相关方法的实用类。
	 *
	 */
	public final class SMatrixUtil
	{
		/** @private */
		public function SMatrixUtil()
		{
			throw new SAbstractClassError();
		}

		/**
		 * 通过一组属性来创建Matrix
		 * @param obj
		 * @return
		 *
		 */
		public static function createFromObject(obj : Object) : Matrix
		{
			var m : Matrix = new Matrix();
			m.createBox(obj.scaleX, obj.scaleY, obj.rotation / 180 * Math.PI, obj.x, obj.y);
			return m;
		}

		/**
		 * 从Matrix中输出一组属性
		 * @param m
		 * @return
		 *
		 */
		public static function toObject(m : Matrix) : Object
		{
			var rotate : Number = Math.atan(m.b / m.a);
			return {x: m.tx, y: m.ty, rotation: rotate * 180 / Math.PI, scaleX: m.b / Math.sin(rotate), scaleY: m.d / Math.cos(rotate)};
		}

		/**
		 * 获得对象到另一个对象的Matrix
		 * var m : Matrix = MatrixUtil.getMatrixAt(textField, this);
		 * if (m)
		 * textField.transform.matrix = m;
		 * addChild(textField);
		 * @param obj
		 * @param contain
		 * @return
		 *
		 */
		public static function getMatrixAt(obj : DisplayObject, container : DisplayObject) : Matrix
		{
			if (obj == container)
				return new Matrix();

			if (obj.stage) //有stage
			{
				var m1 : Matrix = obj.transform.concatenatedMatrix;
				var m2 : Matrix = container.transform.concatenatedMatrix;
				m2.invert();
				m1.concat(m2);
			}
			else
			{
				m1 = obj.transform.matrix;
				var cur : DisplayObject = obj.parent;
				while (cur != container)
				{
					if (!cur)
						return null;

					m1.concat(cur.transform.matrix);

					if (cur != cur.parent)
						cur = cur.parent;
					else
						return null;
				}
			}
			return m1;
		}


		/**
		 * 创建按缩放比的矩阵
		 * @param width
		 * @param height
		 * @param rotation
		 * @param tx
		 * @param ty
		 * @return
		 *
		 */
		public static function createBox(scaleX : Number, scaleY : Number, rotation : Number = 0, tx : Number = 0, ty : Number = 0) : Matrix
		{
			var m : Matrix = new Matrix();
			m.createBox(scaleX, scaleY, rotation, tx, ty);
			return m;
		}

		/**
		 * 创建用于填充的矩阵
		 * @param width
		 * @param height
		 * @param rotation
		 * @param tx
		 * @param ty
		 *
		 */
		public static function createGradientBox(width : Number, height : Number, rotation : Number = 0, tx : Number = 0, ty : Number = 0) : Matrix
		{
			var m : Matrix = new Matrix();
			m.createGradientBox(width, height, rotation, tx, ty);
			return m;
		}

		/**
		 * 矩阵相加
		 * @param m1
		 * @param m2
		 * @return
		 *
		 */
		public static function concat(m1 : Matrix, m2 : Matrix) : Matrix
		{
			var m : Matrix = m1.clone();
			m.concat(m2);
			return m;
		}

		/**
		 * 矩阵取反
		 * @param m
		 * @return
		 *
		 */
		public static function invert(m : Matrix) : Matrix
		{
			var newMatrix : Matrix = m.clone();
			newMatrix.invert();
			return m;
		}

		private static var _rawData : Vector.<Number> = new <Number>[1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];

		/**
		 * 转换2D矩阵到3D矩阵
		 * @param matrix
		 * @param resultMatrix
		 * @return
		 *
		 */
		public static function convertTo3D(matrix : Matrix, resultMatrix : Matrix3D = null) : Matrix3D
		{
			if (resultMatrix == null)
				resultMatrix = new Matrix3D();

			_rawData[0] = matrix.a;
			_rawData[1] = matrix.b;
			_rawData[4] = matrix.c;
			_rawData[5] = matrix.d;
			_rawData[12] = matrix.tx;
			_rawData[13] = matrix.ty;

			resultMatrix.copyRawDataFrom(_rawData);
			return resultMatrix;
		}

		/**
		 * 用一个矩阵变换2D坐标到不同的空间坐标
		 * @param matrix
		 * @param x
		 * @param y
		 * @param resultPoint
		 * @return
		 *
		 */
		public static function transformCoords(matrix : Matrix, x : Number, y : Number, resultPoint : Point = null) : Point
		{
			if (resultPoint == null)
				resultPoint = new Point();

			resultPoint.x = matrix.a * x + matrix.c * y + matrix.tx;
			resultPoint.y = matrix.d * y + matrix.b * x + matrix.ty;

			return resultPoint;
		}

		/** Appends a skew transformation to a matrix (angles in radians).
		 *  追加一个斜变换矩阵（角弧度）。斜矩阵具有如下形式:
		 *  <pre>
		 *  | cos(skewY)  -sin(skewX)  0 |
		 *  | sin(skewY)   cos(skewX)  0 |
		 *  |     0            0       1 |
		 *  </pre>
		 */
		public static function skew(matrix : Matrix, skewX : Number, skewY : Number) : void
		{
			var sinX : Number = Math.sin(skewX);
			var cosX : Number = Math.cos(skewX);
			var sinY : Number = Math.sin(skewY);
			var cosY : Number = Math.cos(skewY);

			matrix.setTo( //
				matrix.a * cosY - matrix.b * sinX, //
				matrix.a * sinY + matrix.b * cosX, //
				matrix.c * cosY - matrix.d * sinX, //
				matrix.c * sinY + matrix.d * cosX, //
				matrix.tx * cosY - matrix.ty * sinX, //
				matrix.tx * sinY + matrix.ty * cosX //
				);
		}

		/**
		 * Prepends a matrix to 'base' by multiplying it with another matrix.
		 * 前置一个矩阵'base'由它与另一个矩阵相乘
		 * @param base
		 * @param prep
		 *
		 */
		public static function prependMatrix(base : Matrix, prep : Matrix) : void
		{
			base.setTo( //
				base.a * prep.a + base.c * prep.b, //
				base.b * prep.a + base.d * prep.b, //
				base.a * prep.c + base.c * prep.d, //
				base.b * prep.c + base.d * prep.d, //
				base.tx + base.a * prep.tx + base.c * prep.ty, //
				base.ty + base.b * prep.tx + base.d * prep.ty //
				);
		}

		/** Prepends an incremental translation to a Matrix object. */
		public static function prependTranslation(matrix : Matrix, tx : Number, ty : Number) : void
		{
			matrix.tx += matrix.a * tx + matrix.c * ty;
			matrix.ty += matrix.b * tx + matrix.d * ty;
		}

		/** Prepends an incremental scale change to a Matrix object. */
		public static function prependScale(matrix : Matrix, sx : Number, sy : Number) : void
		{
			matrix.setTo( //
				matrix.a * sx, matrix.b * sx, //
				matrix.c * sy, matrix.d * sy, //
				matrix.tx, matrix.ty //
				);
		}

		/** Prepends an incremental rotation to a Matrix object (angle in radians). */
		public static function prependRotation(matrix : Matrix, angle : Number) : void
		{
			var sin : Number = Math.sin(angle);
			var cos : Number = Math.cos(angle);

			matrix.setTo( //
				matrix.a * cos + matrix.c * sin, //
				matrix.b * cos + matrix.d * sin, //
				matrix.c * cos - matrix.a * sin, //
				matrix.d * cos - matrix.b * sin, //
				matrix.tx, matrix.ty //
				);
		}

		/** Prepends a skew transformation to a Matrix object (angles in radians). The skew matrix
		 *  has the following form:
		 *  <pre>
		 *  | cos(skewY)  -sin(skewX)  0 |
		 *  | sin(skewY)   cos(skewX)  0 |
		 *  |     0            0       1 |
		 *  </pre>
		 */
		public static function prependSkew(matrix : Matrix, skewX : Number, skewY : Number) : void
		{
			var sinX : Number = Math.sin(skewX);
			var cosX : Number = Math.cos(skewX);
			var sinY : Number = Math.sin(skewY);
			var cosY : Number = Math.cos(skewY);

			matrix.setTo( //
				matrix.a * cosY + matrix.c * sinY, //
				matrix.b * cosY + matrix.d * sinY, //
				matrix.c * cosX - matrix.a * sinX, //
				matrix.d * cosX - matrix.b * sinX, //
				matrix.tx, matrix.ty //
				);
		}
	}
}