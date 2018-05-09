package com.sunny.game.engine.utils
{
	import flash.utils.ByteArray;

	/**
	 * 列表排序
	 * @author 劉黎明$Sunrise
	 */
	public class SortData
	{
		/**
		 * 列表排序
		 * @param arr 原数组
		 * @param property 属性
		 * @param asc 是否升序
		 * @return 新数组
		 * @author 劉黎明$Sunrise
		 */
		public static function sort(arr : Array, property : String, asc : Boolean = true) : Array
		{
			if (arr.length > 0)
			{
				if (!asc)
					arr.sortOn(property, [Array.DESCENDING | Array.NUMERIC]);
				else
					arr.sortOn(property, [Array.NUMERIC]);
				if (arr[0] && isNaN(parseInt(arr[0][property])))
				{
					var byte : ByteArray = new ByteArray();
					var sortedArr : Array = [];
					var returnArr : Array = [];
					var str : String = null;
					//中英文组排序
					for (var m : int = 0; m < arr.length; m++)
					{
						str = arr[m][property];
						if (str)
						{
							if (str.charCodeAt(0) < 123)
							{
								returnArr[returnArr.length] = arr[m];
								arr[m] = null;
								continue;
							}
							byte.writeMultiByte(str.charAt(0), "gb2312");
						}
						else
						{
							returnArr[returnArr.length] = arr[m];
							arr[m] = null;
							continue;
						}
					}
					for (var n : int = 0; n < arr.length; n++)
					{
						if (String(arr[n]) == "null")
						{
							arr.splice(n, 1);
							n--;
							continue;
						}
					}
					byte.position = 0;
					var len : int = byte.length / 2;
					for (var i : int = 0; i < len; i++)
					{
						sortedArr[sortedArr.length] = {a: byte[i * 2], b: byte[i * 2 + 1], c: arr[i]};
					}
					sortedArr.sortOn(["a", "b"], [Array.DESCENDING | Array.NUMERIC]);
					//for each(var obj:Object in sortedArr) 
					//中文和英文单独排序
					if (asc)
					{
						for (var j : int = 0; j < sortedArr.length; j++)
						{
							returnArr[returnArr.length] = sortedArr[j].c;
						}
					}
					else
					{
						for (var t : int = sortedArr.length - 1; t >= 0; t--)
						{
							returnArr[returnArr.length] = sortedArr[t].c;
						}
					}
					byte.clear();
					return returnArr;
				}
				else
					return arr;
			}
			return arr;
		}
	}
}

