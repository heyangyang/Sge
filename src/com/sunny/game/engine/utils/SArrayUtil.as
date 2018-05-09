package com.sunny.game.engine.utils
{
	import com.sunny.game.engine.lang.exceptions.IllegalParameterException;
	import com.sunny.game.engine.lang.exceptions.IndexOutOfBoundsException;
	import com.sunny.game.engine.lang.exceptions.SNullPointerException;
	import com.sunny.game.engine.pattern.iterator.ArrayIterator;
	import com.sunny.game.engine.pattern.iterator.IIterator;
	
	import flash.utils.Dictionary;

	/**
	* 数组类。
	*
	* 数组助手ArrayUtil 。
	* 文件描述:
	*		一些关于数组的静态方法
	* 		稀疏数组的压缩与解压缩
	*  修改标识：peter 20090921
	* 			为了不改变原有的框架，采用添加自己的方法的方式解决行列式创建相反的情况
	* @example
	* 		var source:Array = new Array();
	* 		for (var  i:int = 0; i < 10; i++)
	* 		{
	* 			var temp:Array = new Array();
	* 			for (var  j:int = 0; j < 10; j++)
	* 			{
	* 				if (Math.random() * 10 > 1)
	* 				{
	* 					temp.push(1);
	* 				}
	* 				else
	* 				{
	* 					temp.push(0);
	* 				}
	* 			}
	* 			source.push(temp);
	* 		}
	* 		trace(source);
	* 		trace("------------------");
	* 		var str:String = Arrayutil.sparseArr2String(source);
	* 		trace(str);
	* 		var ret:Array = Arrayutil.resetSparseArr(str);
	* 		trace("------------------");
	* 		trace(ret);
	* 		trace("--------------------");
	* 		trace(Arrayutil.sparseArr2String(ret))
	*/
	public class SArrayUtil
	{
		public static function changePos(source : Array, index1 : uint, index2 : uint) : void
		{
			var temp : Object = source[index1];
			source[index1] = source[index2];
			source[index2] = temp;
		}

		/**
		 * 将XMLList转化成一个obj类型的数组
		 * @param	xml
		 * @return
		 */
		public static function xmlListToArr(xml : XMLList) : Array
		{
			var re : Array = new Array();
			for each (var item : XML in xml)
			{
				var obj : Object = {};
				for each (var it : XML in item.attributes())
				{
					obj[String(it.name())] = it;
				}
				re.push(obj);
			}
			return re;
		}

		//稀疏数组压缩格式;
		//rowcount#Compression(0,1:压缩过)#000001111222233334445556666
		/**
		 * 将稀疏数组转换为压缩的字符串
		 * @author 	johnny
		 * @param	source:Array	需要转换的源数组对象：二维数组
		 * @return	String			返回转换后的字符串
		 *
		 */
		public static function sparseArrToString(source : Array) : String
		{
			//trace("source: " + source);
			var rowcount : int = (source[0] as Array).length;
			var oldstr : String = "";
			var oldstr_blank : String = "";
			var compressstr : String = "";
			var oneflag : Boolean = true;

			for (var m : int = 0; m < source.length; m++)
			{
				var _arr : Array = source[m] as Array;

				for (var n : int = 0; n < _arr.length; n++)
				{
					if (_arr[n] == "")
						_arr[n] = 0;
					if ((String(_arr[n])).length > 1)
					{
						oneflag = false;
					}
				}
				source[m] = _arr.join(",");
			}

			oldstr = source.join(","); //用,连接的源数据字符串
			var myPattern : RegExp = /,/g;
			oldstr_blank = oldstr.replace(myPattern, ""); //用空格连接的源数据字符串

			var temparray : Array = oldstr.split(",");
			var num : int = 1;
			for (var i : int = 0; i < temparray.length; i++)
			{
				if (i == 0)
				{
					compressstr = temparray[0];
				}
				else
				{
					if (temparray[i] == temparray[i - 1])
					{
						num++;
					}
					else
					{
						compressstr = compressstr + "," + num + "|" + temparray[i];
						num = 1;
					}
				}
			}
			compressstr = compressstr + "," + num;
			if (oneflag)
			{ //全部是一位的数据
				if (oldstr_blank.length <= compressstr.length)
				{

					return rowcount + "#0#" + oldstr_blank;
				}
				else
				{
					return rowcount + "#1#" + compressstr;
				}
			}
			else
			{
				if (oldstr.length <= compressstr.length)
				{
					return rowcount + "#0#" + oldstr;
				}
				else
				{
					return rowcount + "#1#" + compressstr;
				}
			}
		}

		/**
		 * 将压缩的字符串转换为数组
		 * @author	johnny
		 * @param	source:String		压缩后的字符串
		 * @return	Array			返回还原的数组
		 */
		//rowcount#Compression(0,1:压缩过)#0,3|1,4|
		public static function resetSparseArr(source : String) : Array
		{
			//trace("resetSparseArr", source);

			var _temp : Array = source.split("#");
			var rowcount : int = int(_temp[0]); //rowcount:列长
			var compressflag : int = int(_temp[1]); //压缩标志
			var data : String = _temp[2]; //数据
			var _dataArr : Array = null;
			var retArray : Array = new Array(); //输出数组
			var i : int = 0;
			var j : int = 0;
			if (compressflag == 0)
			{
				//没有压缩过的数据
				//检查是否用,连接的数据
				if (data.indexOf(",") == -1)
				{
					_dataArr = data.split("");
				}
				else
				{
					_dataArr = data.split(",");
				}
			}
			else
			{
				//压缩数据
				//还原字符串
				var _tempstr : String = "";
				_dataArr = data.split("|");
				for (i = 0; i < _dataArr.length; i++)
				{
					var _node : Array = (String(_dataArr[i])).split(",");

					for (j = 0; j < int(_node[1]); j++)
					{
						_tempstr = _tempstr + (String(_node[0])) + ",";
					}
				}
				_tempstr = _tempstr.substr(0, _tempstr.length - 1);
				_dataArr = _tempstr.split(",");

			}

			//trace("_dataArr", _dataArr)
			//---一维转二维
			//还原数组数据
			var temp : Array = new Array();
			j = 0;
			for (i = 0; i < _dataArr.length; i++)
			{
				temp.push(_dataArr[i]);
				j++;
				if (j == rowcount)
				{
					retArray.push(temp);
					temp = new Array();
					j = 0;
				}
			}

			//trace("retArray.length",retArray.length)
			return retArray;
		}

		////peter 自己的方法--------------------------------------------------------------------------------------------------
		/**
		 * 解析二维数组成字符串
		 * @param	source
		 * @return
		 */
		public static function twoDimensionalArrayToString(source : Array) : String
		{
			//trace("source: " + source);
			var rowcount : int = source.length; ////与原来的不同
			var oldstr : String = "";
			var oldstr_blank : String = "";
			var compressstr : String = "";
			var oneflag : Boolean = true;

			for (var m : int = 0; m < rowcount; m++)
			{
				var _arr : Array = source[m] as Array;

				for (var n : int = 0; n < _arr.length; n++)
				{
					if (_arr[n] == "")
						_arr[n] = 0;
					if ((String(_arr[n])).length > 1)
					{
						oneflag = false;
					}
				}
				source[m] = _arr.join(",");
			}

			oldstr = source.join(","); //用,连接的源数据字符串
			var myPattern : RegExp = /,/g;
			oldstr_blank = oldstr.replace(myPattern, ""); //用空格连接的源数据字符串

			var temparray : Array = oldstr.split(",");
			var num : int = 1;
			for (var i : int = 0; i < temparray.length; i++)
			{
				if (i == 0)
				{
					compressstr = temparray[0];
				}
				else
				{
					if (temparray[i] == temparray[i - 1])
					{
						num++;
					}
					else
					{
						compressstr = compressstr + "," + num + "|" + temparray[i];
						num = 1;
					}
				}
			}
			compressstr = compressstr + "," + num;
			if (oneflag)
			{ //全部是一位的数据
				if (oldstr_blank.length <= compressstr.length)
				{

					return rowcount + "#0#" + oldstr_blank;
				}
				else
				{
					return rowcount + "#1#" + compressstr;
				}
			}
			else
			{
				if (oldstr.length <= compressstr.length)
				{
					return rowcount + "#0#" + oldstr;
				}
				else
				{
					return rowcount + "#1#" + compressstr;
				}
			}
		}

		/**
		 * 将压缩的字符串转换为数组
		 * @author	johnny
		 * @param	source:String		压缩后的字符串
		 * @return	Array			返回还原的数组
		 */
		//rowcount#Compression(0,1:压缩过)#0,3|1,4|
		/**
		 * 字符串转换成二维数组
		 * @param	source
		 * @return
		 */
		public static function stringToTwoDimensionalArray(source : String) : Array
		{
			//trace("resetSparseArr", source);

			var _temp : Array = source.split("#");
			var rowcount : int = int(_temp[0]); //rowcount:列长
			var compressflag : int = int(_temp[1]); //压缩标志
			var data : String = _temp[2]; //数据
			var _dataArr : Array = null;
			var retArray : Array = new Array(); //输出数组
			var i : int = 0;
			var j : int = 0;
			if (compressflag == 0)
			{
				//没有压缩过的数据
				//检查是否用,连接的数据
				if (data.indexOf(",") == -1)
				{
					_dataArr = data.split("");
				}
				else
				{
					_dataArr = data.split(",");
				}
			}
			else
			{
				//压缩数据
				//还原字符串
				var _tempstr : String = "";
				_dataArr = data.split("|");
				for (i = 0; i < _dataArr.length; i++)
				{
					var _node : Array = (String(_dataArr[i])).split(",");

					for (j = 0; j < int(_node[1]); j++)
					{
						_tempstr = _tempstr + (String(_node[0])) + ",";
					}
				}
				_tempstr = _tempstr.substr(0, _tempstr.length - 1);
				_dataArr = _tempstr.split(",");

			}
			///peter modefy
			var len : int = _dataArr.length; /////一维数组的总长度
			trace("一维数组的总长度：" + len);
			var list : int = Math.ceil(_dataArr.length / rowcount); /////列长
			trace("列的长度：" + list);
			for (var p : int = 0; p < rowcount; p++)
			{
				var tempArray : Array = [];
				tempArray = _dataArr.slice(p * list, (p + 1) * list);
				retArray.push(tempArray); ////把单个的一维数组放入而维数组中
			}
			return retArray;
		}

		//模拟二维数组
		public static function constructTwoDimensionalArray(rows : uint, cols : uint = 0, num : int = 0) : Array
		{
			var arr : Array = new Array();
			for (var i : uint = 0; i < rows; i++)
			{
				var arr2 : Array = new Array();
				for (var j : uint = 0; j < cols; j++)
				{
					arr2.push(num);
				}
				arr.push(arr2);
			}
			return arr;
		}

		//将一维数组转换成二维数组
		public static function oneToTwoDimensionalArray(arr : Array, R : int, C : int) : Array
		{
			var re : Array = new Array();
			for (var i : uint = 0; i < R; i++)
			{
				var arr2 : Array = new Array();
				for (var j : uint = 0; j < C; j++)
				{
					arr2.push(arr[i * C + j]);
				}
				re.push(arr2);
			}
			return re;
		}

		/**
		 * 创建一个数组
		 * @param length 长度
		 * @param fill 填充
		 *
		 */
		public static function create(len : Array, fill : * = null) : Array
		{
			len = len.concat();

			var arr : Array = [];
			var l : int = len.shift();
			for (var i : int = 0; i < l; i++)
			{
				if (len.length)
					arr[i] = create(len, fill);
				else
					arr[i] = fill;
			}
			return arr;
		}

		/**
		 * 将一个数组附加在另一个数组之后
		 *
		 * @param arr	目标数组
		 * @param value	附加的数组
		 *
		 */
		public function append(arr : Array, value : Array) : void
		{
			arr.push.apply(null, value);
		}

		/**
		 * 获得两个数组的共用元素
		 *
		 * @param array1	数组对象1
		 * @param array2	数组对象2
		 * @param result	共有元素
		 * @param array1only	数组1独有元素
		 * @param array2only	数组2独有元素
		 * @return 	共有元素
		 *
		 */
		public static function hasShare(array1 : Array, array2 : Array, result : Array = null, array1only : Array = null, array2only : Array = null) : Array
		{
			if (result == null)
				result = [];

			var array2dict : Dictionary = new Dictionary();
			var obj : *;
			for each (obj in array2)
				array2dict[obj] = null;

			if (array2only != null)
				var resultDict : Dictionary = new Dictionary();

			for each (obj in array1)
			{
				if (array2dict.hasOwnProperty(obj))
				{
					result[result.length] = obj;
					if (resultDict)
						resultDict[obj] = null;
				}
				else if (array1only != null)
				{
					array1only[array1only.length] = obj;
				}
			}

			if (array2only != null)
			{
				for each (obj in array2)
				{
					if (!resultDict.hasOwnProperty(obj))
						array2only[array2only.length] = obj;
				}
			}

			return result;
		}

		/**
		 * 获得数组中特定标示的对象
		 *
		 * getMapping([{x:0,y:0},{x:-2,y:4},{x:4,y:2}],"x",-2) //{x:-2:y:4}(x = -2)
		 * getMapping([[1,2],[3,4],[5,6]],0,3) //[3,4](第一个元素为3)
		 *
		 * @param arr	数组
		 * @param value	值
		 * @param field	键
		 * @return
		 *
		 */
		public static function getMapping(arr : Array, field : *, value : *) : Object
		{
			for (var i : int = 0; i < arr.length; i++)
			{
				var o : * = arr[i];

				if (o[field] == value)
					return o;
			}
			return null;
		}

		/**
		 * 获得数组中某个键的所有值
		 *
		 * getFieldValues([{x:0,y:0},{x:-2,y:4},{x:4,y:2}],"x")	//[0,-2,4]
		 *
		 * @param arr	数组
		 * @param field	键
		 * @return
		 *
		 */
		public static function getFieldValues(arr : Array, field : *) : Array
		{
			var result : Array = [];
			for (var i : int = 0; i < arr.length; i++)
			{
				var o : * = arr[i];

				result[i] = o[field];
			}
			return result;
		}

		static public function dictionaryToArray(dictionary : Dictionary, array : Array) : void
		{
			for each (var obj : Object in dictionary)
			{
				array.push(obj);
			}
		}
		
		/**
		 * 创建指定数组的一个副本
		 * 
		 * @param	arr
		 * 
		 * @return 
		 */
		public static function copyArray(arr:Array):Array
		{
			return arr == null ? null : arr.concat();
		}
		
		/**
		 * 创建指定 vector 的一个副本
		 * 
		 * @param	v
		 * 
		 * @return
		 */
		public static function copyVector(v:Object):*
		{
			if (v == null)
			{
				return null;
			}
			else
			{
				return v.concat();
			}
		}
		
		/**
		 * 连接两个数组
		 * 
		 * @param	arr1
		 * @param	arr2
		 * 
		 * @return
		 */
		public static function concatArray(arr1:Array, arr2:Array):Array
		{
			if (arr1 != null && arr2 != null)
			{
				return arr1.concat(arr2);
			}
			else if (arr1 == null && arr2 == null)
			{
				return null;
			}
			else if (arr1 != null)
			{
				return arr1.concat();
			}
				// else if(arr2 != null)
			else
			{
				return arr2.concat();
			}
		}
		
		/**
		 * 连接两个 vector
		 * 
		 * @param	v1
		 * @param	v2
		 * 
		 * @return
		 */
		public static function concatVector(v1:Object, v2:Object):*
		{
			if (v1 != null && v2 != null)
			{
				return v1.concat(v2);
			}
			else if (v1 == null && v2 == null)
			{
				return null;
			}
			else if (v1 != null)
			{
				return v1.concat();
			}
				// else if(v2 != null)
			else
			{
				return v2.concat();
			}
		}
		
		/**
		 * 获得一个数组，每个项是map对象的每个值对象。
		 * 获得的值数组不保证顺序。
		 * 
		 * @param map	指定的map对象。
		 * 
		 * @return	 返回一个数组，数组中的每一项是map的值。如果入参是null，则返回null。
		 */		
		public static function getValuesArrayOfMap(map:Object):Array
		{
			if (map != null)
			{
				var array:Array = new Array();
				for each(var item:Object in map)
				{
					array.push(item);
				}
				
				return array;
			}
			else
			{
				return null;
			}	
		}
		
		/**
		 * 获得一个数组，每个项是map对象的每个键对象。
		 * 获得的键数组不保证顺序
		 * 
		 * @param map 指定的map对象
		 * 
		 * @return 返回一个数组，每一项是map对象的键对象。如果入参是null，则返回null。
		 */		
		public static function getKeysArrayOfMap(map:Object):Array
		{
			if (map != null)
			{
				var array:Array = new Array();
				for(var pName:Object in map)
				{
					array.push(pName);
				}
				
				return array;
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * 获得map对象的值迭代器。
		 * 获得的值迭代器的不保证顺序。
		 * 
		 * @param map 指定的map对象。
		 * 
		 * @return 返回map对象的值迭代器。如果入参是null，则返回null。
		 */		
		public static function getValuesIteratorOfMap(map:Object):IIterator
		{
			return map == null ? null : new ArrayIterator(getValuesArrayOfMap(map));
		}
		
		/**
		 * 获得map对象的键迭代器。
		 * 获得的键迭代器的不保证顺序。
		 * 
		 * @param map 指定的map对象
		 * 
		 * @return 返回map对象的键迭代器。如果入参是null，则返回null
		 */
		public static function getKeysIteratorOfMap(map:Object):IIterator
		{
			return map == null ? null : new ArrayIterator(getKeysArrayOfMap(map));
		}
		
		/**
		 * 数组转换成 Vector
		 * 
		 * @param	array
		 * 
		 * @return
		 */
		public static function arrayToVector(array:Array):*
		{
			if (array == null)
			{
				return null;
			}
			else
			{
				var length:int = array.length;
				var v:Vector.<Object> = new Vector.<Object>(length);
				for (var i:int = 0; i < length; i++)
				{
					v[i] = array[i];
				}
				
				return v;
			}
		}
		
		/**
		 * Vector 转换成数组
		 * 
		 * @param	v
		 * 
		 * @return
		 */
		public static function vectorToArray(v:Object):Array
		{
			if (v == null)
			{
				return null;
			}
			else
			{
				var length:int = v.length;
				var array:Array = new Array(length);
				for (var i:int = 0; i < length; i++)
				{
					array[i] = v[i];
				}
				
				return array;
			}
		}
		
		/**
		 * 在一个一维的集合中通过行列这样的二维参数找到指定的元素
		 * 
		 * @param	collection 指定的一维集合。可以是Vector或者Array
		 * @param	rows 总行数
		 * @param	cols 总列数
		 * @param	row 指定的行，从0开始
		 * @param	col 指定的列，从0开始
		 * 
		 * @return	返回要找的元素。
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.IndexOutOfBoundsException 
		 * 指定的行列索引超出了范围
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的集合是null
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalParameterException 
		 * 指定的row超过了rows或者指定的col超过了cols
		 */
		public static function getItemByRowCol(collection:Object, row:uint, col:uint, rows:uint, cols:uint):*
		{
			if(collection == null)
			{
				throw new SNullPointerException("Null collection");
			}
			if(row >= rows)
			{
				throw new IllegalParameterException("Row index \"" + row +　"\" cannot >= rows \"" + rows + "\"");
			}
			if(col >= cols)
			{
				throw new IllegalParameterException("Col index \"" + col + "\" cannot >= cols \"" + cols + "\"");
			}
			
			var index:uint = cols * row + col;
			if(index >= rows * cols)
			{
				throw new IndexOutOfBoundsException("Index \"" + index + "\" out of bounds \"" + (rows * cols) + "\"");
			}
			
			return collection[index];
		}
		
		/**
		 * 在一个一维的集合中通过行列这样的二维参数设定元素
		 * 
		 * @param collection	一维集合。可以是Vector或者是Array
		 * @param value	要设定的值
		 * @param row	设定的值所在的行
		 * @param col	设定的值所在的列
		 * @param rows	模拟的行总数
		 * @param cols	模拟的列总数
		 */
		public static function setItemByRowCol(collection:Object, value:Object, row:uint, col:uint, rows:uint, cols:uint):void
		{
			if(collection)
			{
				throw new SNullPointerException("Null collection");
			}
			if(row >= rows)
			{
				throw new IllegalParameterException("Row index \"" + row +　"\" cannot >= rows \"" + rows + "\"");
			}
			if(col >= cols)
			{
				throw new IllegalParameterException("Col index \"" + col + "\" cannot >= cols \"" + cols + "\"");
			}
			
			var index:uint = row * cols + col;
			if(index >= rows * cols)
			{
				throw new IndexOutOfBoundsException("Index \"" + index + "\" out of bounds \"" + (rows * cols) + "\"");
			}
			
			collection[index] = value;
		}
		
		/**
		 * 通过二维的行列参数，获得对应一维的索引值
		 * 
		 * @param row
		 * @param col
		 * @param rows
		 * @param cols
		 * 
		 * @return 返回得到的索引值。失败返回-1
		 */
		public static function getIndexByRowCol(row:uint, col:uint, rows:uint, cols:uint):uint
		{
			if(row >= rows)
			{
				throw new IllegalParameterException("Row index \"" + row +　"\" cannot >= rows \"" + rows + "\"");
			}
			if(col >= cols)
			{
				throw new IllegalParameterException("Col index \"" + col + "\" cannot >= cols \"" + cols + "\"");
			}
			
			return row * cols + col;
		}
		
		/**
		 * 在一个一维集合中找到属性值和指定值相等的元素
		 * 
		 * @param	collection 一维集合。可以是Vector或Array或键值对
		 * @param	propName 指定的属性名称
		 * @param	equalValue 指定的比较值
		 * 
		 * @return 返回找到的元素。如果没有找到返回null
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的集合是null
		 */
		public static function getItemByProperty(collection:Object, propName:String, equalValue:Object):*
		{
			if(collection == null)
			{
				throw new SNullPointerException("Null collection");
			}
			
			for each(var item:Object in collection)
			{
				if (item != null)
				{
					if (item[propName] == equalValue)
					{
						return item;
					}
				}
			}
			
			return null;
		}
		
		/**
		 * 在一个一维集合中找到方法返回值和指定值相等的元素
		 * 
		 * @param	collection 一维集合。可以是Vector或Array或键值对
		 * @param	methodName 方法的名称
		 * @param	equalValue 指定的和方法返回值进行比较的值
		 * @param	getMethodArgs 获得的方法的入参。null表示方法没有入参。func(item:Object):Array
		 * 
		 * @return	返回找到的元素。没有找到返回null
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的集合是null
		 */
		public static function getItemByMethodReturnValue(collection:Object, methodName:String, equalValue:Object, getMethodArgs:Function = null):*
		{
			if(collection == null)
			{
				throw new SNullPointerException("Null collection");
			}
			
			for each(var item:Object in collection)
			{
				if (item != null)
				{
					if (getMethodArgs == null)
					{
						if (item[methodName]() == equalValue)
						{
							return item;
						}
					}
					else
					{
						if (item[methodName].apply(item, getMethodArgs(item)) == equalValue)
						{
							return item;
						}
					}
				}
			}
			
			return null;
		}
		
		/**
		 * 获取矩形螺旋数组（顺时针向外）  
		 * @param centerX
		 * @param centerY
		 * @param radius
		 * @param reject 剔除函数 function(centerX:Number,centerY:Number,x:int,y:int):Boolean
		 * @param process 处理函数 function(centerX:Number,centerY:Number,x:int,y:int):void
		 * @return 
		 * 
		 */		
		public static function getRectangularSpiralArray(centerX : Number,centerY : Number,radius:Number,reject:Function,process:Function):Array
		{
			radius=Math.ceil(radius);//向上取半径值
			var result:Array=[];
			var resultSet:Array=[];
			var key:String;
			var i : int;
			var j : int;
			
			for (i = 0; i <= radius; i++)
			{
				//上
				for (j = -i; j <= i; j++)
				{
					pushResult(j,-i);
				}
				
				//右
				for (j = -i; j <= i; j++)
				{
					pushResult(i,j);
				}
				
				//下
				for (j = i; j >= -i; j--)
				{
					pushResult(j,i);
				}
				
				//左
				for (j = i; j >= -i; j--)
				{
					pushResult(-i,j);
				}
			}
			
			function pushResult(x:int,y:int):void
			{
				key = x + "_" + y;
				if (resultSet.indexOf(key) == -1 && (reject ==null || !reject(centerX,centerY,x,y)))
				{
					result.push([x,y]);
					resultSet.push(key);
					if(process != null)
						process(centerX,centerY,x,y);
				}
			}
			
			return result;
		}
	}
}