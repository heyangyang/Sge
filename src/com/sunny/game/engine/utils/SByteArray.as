package com.sunny.game.engine.utils
{
	import com.sunny.game.engine.debug.SDebug;
	import com.sunny.game.engine.lang.SByte;
	import com.sunny.game.engine.lang.SLessString;
	import com.sunny.game.engine.lang.SLong;
	import com.sunny.game.engine.lang.SShort;
	import com.sunny.game.engine.lang.SStringBytes;
	import com.sunny.game.engine.lang.memory.SIRecyclable;

	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 *
	 * <p>
	 * SunnyGame的一个字节数组
	 * 二进制数据流。发送和接受的数据格式
	 * </p>
	 * <p><strong><font color="#0000ff">Copyright © 2012 Sunny3D. All rights reserved.</font></strong><br>
	 * <font color="#0000ff">www.sunny3d.com</font></p>
	 * @langversion 3.0
	 * @playerversion Flash 11.2
	 * @playerversion AIR 3.2
	 * @productversion Flex 4.5
	 * @author <strong><font color="#0000ff">刘黎明</font></strong><br>
	 * <font color="#0000ff">www.liuliming.org</font>
	 *
	 */
	public class SByteArray extends ByteArray implements SIRecyclable
	{
		public static const POW_2_32 : Number = Math.pow(2, 32);

		/**
		 * 当前正在处理的错误
		 */
		public var prosessError : String = "";

		public function SByteArray()
		{
			super();
			endian = Endian.BIG_ENDIAN;
		}

		public function readUnsignedMedium() : int
		{
			return (readByte() & 0xff) << 16 | (readByte() & 0xff) << 8 | (readByte() & 0xff) << 0;
		}

		public function readMedium() : int
		{
			var value : int = readUnsignedMedium();
			if ((value & 0x800000) != 0)
			{
				value |= 0xff000000;
			}
			return value;
		}

		public function readLong() : Number
		{
			var high : int;
			var low : uint;
			if (endian == Endian.BIG_ENDIAN)
			{
				high = readInt();
				low = readUnsignedInt();
			}
			else
			{
				low = readUnsignedInt();
				high = readInt();
			}

			var long : Number = high * POW_2_32 + low;
			return long;
		}

		/**
		 * 客户端传入负数是无效的
		 * @return
		 */
		public function writeLong(long : Number) : void
		{
			var high : int = long / POW_2_32;
			var low : uint = long % POW_2_32;

			if (endian == Endian.BIG_ENDIAN)
			{
				writeInt(high);
				writeUnsignedInt(low);
			}
			else
			{
				writeUnsignedInt(low);
				writeInt(high);
			}
		}

		override public function readBoolean() : Boolean
		{
			if (bytesAvailable < 1)
			{
				if (SDebug.OPEN_ERROR_TRACE)
					SDebug.errorPrint(this, "有效字节数不足 Boolean At %s", prosessError);
				return false;
			}
			return super.readBoolean();
		}

		override public function readByte() : int
		{
			if (bytesAvailable < 1)
			{
				if (SDebug.OPEN_ERROR_TRACE)
					SDebug.errorPrint(this, "有效字节数不足 Byte At %s", prosessError);
				return 0;
			}
			return super.readByte();
		}

		override public function readBytes(bytes : ByteArray, offset : uint = 0, length : uint = 0) : void
		{
			if (bytesAvailable == 0 || bytesAvailable < length)
			{
				if (SDebug.OPEN_ERROR_TRACE)
					SDebug.errorPrint(this, "有效字节数不足 readBytes At %s", prosessError);
				return;
			}
			super.readBytes(bytes, offset, length);
		}

		override public function readDouble() : Number
		{
			if (bytesAvailable < 8)
			{
				if (SDebug.OPEN_ERROR_TRACE)
					SDebug.errorPrint(this, "有效字节数不足 readDouble At %s", prosessError);
				return 0;
			}
			return super.readDouble();
		}

		override public function readFloat() : Number
		{
			if (bytesAvailable < 4)
			{
				if (SDebug.OPEN_ERROR_TRACE)
					SDebug.errorPrint(this, "有效字节数不足 readFloat At %s", prosessError);
				return 0;
			}
			return super.readFloat();
		}

		override public function readInt() : int
		{
			if (bytesAvailable < 4)
			{
				if (SDebug.OPEN_ERROR_TRACE)
					SDebug.errorPrint(this, "有效字节数不足 readInt At %s", prosessError);
				return 0;
			}

			return super.readInt();
		}

		override public function readMultiByte(length : uint, charSet : String) : String
		{
			if (bytesAvailable < length)
			{
				if (SDebug.OPEN_ERROR_TRACE)
					SDebug.errorPrint(this, "有效字节数不足 readMultiBytes At %s", prosessError);
				return '';
			}
			return super.readMultiByte(length, charSet);
		}

		override public function readObject() : *
		{
			if (bytesAvailable < 0)
			{
				if (SDebug.OPEN_ERROR_TRACE)
					SDebug.errorPrint(this, "有效字节数不足 readObject At %s", prosessError);
				return null;
			}
			return super.readObject();
		}

		override public function readShort() : int
		{
			if (bytesAvailable < 2)
			{
				if (SDebug.OPEN_ERROR_TRACE)
					SDebug.errorPrint(this, "有效字节数不足 readShort At %s", prosessError);
				return 0;
			}

			return super.readShort();
		}

		override public function readUnsignedByte() : uint
		{
			if (bytesAvailable < 1)
			{
				if (SDebug.OPEN_ERROR_TRACE)
					SDebug.errorPrint(this, "有效字节数不足 UnsignedByte At %s", prosessError);
				return 0;
			}
			return super.readUnsignedByte();
		}

		override public function readUnsignedInt() : uint
		{
			if (bytesAvailable < 4)
			{
				if (SDebug.OPEN_ERROR_TRACE)
					SDebug.errorPrint(this, "有效字节数不足 UnsignedInt At %s", prosessError);
				return 0;
			}

			return super.readUnsignedInt();
		}

		override public function readUnsignedShort() : uint
		{
			if (bytesAvailable < 2)
			{
				if (SDebug.OPEN_ERROR_TRACE)
					SDebug.errorPrint(this, "有效字节数不足 UnsignedShort At %s", prosessError);
				return 0;
			}

			return super.readUnsignedShort();
		}

		override public function readUTF() : String
		{
			if (bytesAvailable < 2)
			{
				if (SDebug.OPEN_ERROR_TRACE)
					SDebug.errorPrint(this, "有效字节数不足 readUTF At %s", prosessError);
				return '';
			}
			return super.readUTF();
		}

		override public function readUTFBytes(length : uint) : String
		{
			if (bytesAvailable < length)
			{
				if (SDebug.OPEN_ERROR_TRACE)
					SDebug.errorPrint(this, "有效字节数不足 readUTFBytes At %s", prosessError);
				return '';
			}
			return super.readUTFBytes(length);
		}

		public function readUTFLess() : String
		{
			var len : uint = readUnsignedByte();
			return readUTFBytes(len);
		}

		public function writeUTFBytesLess(value : String) : void
		{
			var bytes : ByteArray = new ByteArray();
			bytes.writeUTFBytes(value);
			var len : uint = bytes.length;
			writeByte(len);
			writeUTFBytes(value);
		}

		/**
		 * 写入带结束符的UTF8字符串
		 */
		public function writeUTFBytesBlock(value : String) : void
		{
			writeUTFBytes(value);
			writeEnd();
		}

		/**
		 * 写入带结束符的字节
		 */
		public function writeByteBlock(value : int) : void
		{
			writeByte(value);
			writeEnd();
		}

		/**
		 * 写入带结束符的整型
		 *
		 */
		public function writeIntBlock(value : int) : void
		{
			writeInt(value);
			writeEnd();
		}

		/**
		 * 写入带结束符的双精度浮点数
		 */
		public function writeDoubleBlock(value : Number) : void
		{
			writeDouble(value);
			writeEnd();
		}

		/**
		 * 根据不同的数据类型写入数据流
		 *
		 */
		public function writeData(ver : *) : void
		{
			var type : String = typeof(ver);

			var tempByte : ByteArray = new ByteArray();
			switch (type)
			{
				case 'undefined':
					if (SDebug.OPEN_ERROR_TRACE)
						SDebug.errorPrint(this, '暂不支持undefined格式的数据发送');
					return;
					//writeByteBlock(0);
					break;
				case 'boolean':
					if (ver)
					{
						// true
						writeByteBlock(3);
					}
					else
					{
						// false
						writeByteBlock(2);
					}
					break;
				case 'object':
					if (ver == null)
					{
						writeByteBlock(1);
					}

					break;
				case 'number':
					if (ver % 1 == 0)
					{
						// 整型
						// 计算并写入占用长度
						tempByte.writeInt(ver);

						writeByte(4);
						writeByte(tempByte.length);
						writeIntBlock(ver);
					}
					else
					{
						// 双精
						// 计算并写入占用长度
						tempByte.writeDouble(ver);

						writeByte(5);
						writeByte(tempByte.length);
						writeDoubleBlock(ver);
					}
					break;
				case 'string':
					// 字符串
					// 计算并写入占用长度
					tempByte.writeUTFBytes(ver);

					writeByte(6);
					writeByte(tempByte.length);
					writeUTFBytesBlock(ver);
					break;
			}

			tempByte.clear();
		}

		override public function toString() : String
		{
			if (length == 0)
				return "[SByteArray]";

			var result : String = "";
			for (var i : uint = 0; i < length; i++)
			{
				result += this[i] + " ";
			}
			return result;
		}

		/**
		 * 写入结束符
		 */
		public function writeEnd() : void
		{
			writeByte(0);
		}

		/**
		 * 返回位长度。bitLength = ByteArray.length * 8 。
		 * @return
		 *
		 */
		public function get bitLength() : uint
		{
			return this.length * 8;
		}

		/**
		 * 返回由参数 index 指定位置处的位的值。1 为 true，0 为 false 。
		 * @param index 一个整数，指示位在 ByteArray 中的位置。第一个位由 0 指示，最后一个位由 BitArray.length * 8 - 1 指示。
		 * @return 指示索引处的位的值。或者，如果指定的索引不在该 ByteArray 的索引范围内，会抛出 RangeErroe 错误，并返回 false 。
		 *
		 */
		public function getBitAt(index : uint = 0) : Boolean
		{
			index++; // 索引值加 1 ，计算出长度

			if (index > this.length * 8)
			{
				throw new RangeError("数值不在可接受的范围内。可接受范围为：0 到 ByteArray.length*8-1 。");
				return false;
			}

			var byteIndex : uint = Math.ceil(index / 8) - 1; // 目标字节的索引
			var flag : uint = 1 << (this.length * 8 - index) % 8; // 计算标志位

			return Boolean(this[byteIndex] & flag);
		}

		/**
		 * 设置由参数 index 指定位置处的位的值。如果 index 指定位置处的长度大于当前长度，该字节数组的长度将设置为最大值，右侧多出的位将用零填充。
		 * @param index 一个整数，指示位在 ByteArray 中的位置。第一个位由 0 指示，最后一个位由 BitArray.length * 8 - 1 指示。
		 * @param value 要设置的值。true 为 1 ，false 为 0 。
		 *
		 */
		public function writeBitAt(index : uint, value : Boolean) : void
		{
			index++; // 索引值加 1 ，计算出长度

			// 如果 index 指定位置处的长度大于当前长度，该字节数组的长度将设置为最大值，右侧多出的位将用零填充。
			var len : uint = Math.ceil(index / 8);
			if (len > this.length)
			{
				this.length = len;
			}

			var byteIndex : uint = Math.ceil(index / 8) - 1;
			var flag : uint = 1 << (this.length * 8 - index) % 8; // 计算标志位
			if (value)
			{
				this[byteIndex] |= flag; // 设置位，即赋值 1
			}
			else
			{
				this[byteIndex] &= ~flag; // 取消位，即赋值 0
			}
		}

		public function writeParams(params : Array) : void
		{
			//写内容
			if (params != null && params.length > 0)
			{
				for each (var param : * in params)
				{
					if (param is int)
					{
						writeInt(param);
					}
					else if (param is Boolean)
					{
						writeBoolean(param);
					}
					else if (param is String)
					{
						writeUTF(param);
					}
					else if (param is Number)
					{
						writeDouble(param);
					}
					else if (param is ByteArray)
					{
						writeBytes(param);
					}
					else if (param is SByte)
					{
						var byte : SByte = param as SByte;
						writeByte(byte.getByte());
					}
					else if (param is SShort)
					{
						var short : SShort = param as SShort;
						writeShort(short.getShort());
					}
					else if (param is SLong)
					{
						var long : SLong = param as SLong;
						writeLong(long.getLong());
					}
					else if (param is SLessString)
					{
						var lessString : SLessString = param as SLessString;
						writeUTFBytesLess(lessString.getString());
					}
					else if (param is SStringBytes)
					{
						var stringBytes : SStringBytes = param as SStringBytes;
						writeUTFBytes(stringBytes.getString());
					}
					else if (param != null)
					{
						writeObject(param);
					}
				}
			}
		}

		/**
		 * 获取指定坐标处的值，x 轴方向的长度由 lengthX 指定。
		 * @param lengthX x 轴方向上的长度。
		 * @param x x 坐标。
		 * @param y y 坐标。
		 * @return 指定坐标处的值。
		 *
		 */
		public function getBitAtCoord(lengthX : uint, x : uint, y : uint) : Boolean
		{
			var i : uint = y * lengthX + x;
			return this.getBitAt(i);
		}

		public function clone(offset : uint = 0, length : uint = 0) : SByteArray
		{
			var bytes : SByteArray = new SByteArray();
			bytes.writeBytes(this, offset, length);
			bytes.position = 0;
			return bytes;
		}

		public function free() : void
		{
			this.clear();
		}
	}
}