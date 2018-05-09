package com.sunny.game.engine.platform
{
	import com.sunny.game.engine.utils.SCommonUtil;
	import com.sunny.game.engine.utils.SWebUtil;
	import com.sunny.game.engine.utils.swffit.SSwfFit;
	
	import flash.utils.Dictionary;

	/**
	 *
	 * <p>
	 * SunnyGame的一个腾讯开放平台工具
	 * 签名值sig是将请求源串以及密钥根据一定签名方法生成的签名值，用来提高传输过程参数的防篡改性。
	 * 签名值的生成共有3个步骤：构造源串，构造密钥，生成签名值。
	 * http://wiki.open.qq.com/wiki/%E8%85%BE%E8%AE%AF%E5%BC%80%E6%94%BE%E5%B9%B3%E5%8F%B0%E7%AC%AC%E4%B8%89%E6%96%B9%E5%BA%94%E7%94%A8%E7%AD%BE%E5%90%8D%E5%8F%82%E6%95%B0sig%E7%9A%84%E8%AF%B4%E6%98%8E
	 * 例：var r : String = SOpenQQUtil.getSigInOpenAPI3_0("228bf094169a40a3bd188ba37ebe8723", "/v3/user/get_info", "openid=11111111111111111", "openkey=2222222222222222", "appid=123456", "pf=qzone", "format=json", "userip=112.90.139.30");
	 *     trace(r);
	 * HMAC-SHA1后得到"15d264883630323e408f5506d9150f73cde2a249"
	 * Base64后得到"FdJkiDYwMj5Aj1UG2RUPc83iokk="
	 * </p>
	 * <p>
	 * 例：var r : String = SOpenQQUtil.getSigInOpenAPI3_0("12345f9a47df4d1eaeb3bad9a7e54321", "/v3/pay/buy_goods", "amt=4", //
	 * "appid=600", //
	 * "appmode=1", //
	 * "format=json", //
	 * "goodsmeta=道具*测试描述信息！！！", //
	 * "goodsurl=http://qzonestyle.gtimg.cn/qzonestyle/act/qzone_app_img/app613_613_75.png", //
	 * "openid=0000000000000000000000000E111111", //
	 * "openkey=1111806DC5D1C52150CF405E42222222", //
	 * "payitem=50005*4*1", //
	 * "pf=qzone", //
	 * "pfkey=1B59A5C3D77C7C56D7AFC3E2C823105D", //
	 * "ts=1333674935", //
	 * "zoneid=0" //
	 * );
	 * trace(r);
	 * 则生成sig时构造的源串为：
	 * GET&%2Fv3%2Fpay%2Fbuy_goods&amt%3D4%26appid%3D600%26appmode%3D1%26format%3Djson%26
	 * goodsmeta%3D%E9%81%93%E5%85%B7%2A%E6%B5%8B%E8%AF%95%E6%8F%8F%E8%BF%B0%E4%BF%A1%E6%
	 * 81%AF%EF%BC%81%EF%BC%81%EF%BC%81%26goodsurl%3Dhttp%3A%2F%2Fqzonestyle.gtimg.cn%2F
	 * qzonestyle%2Fact%2Fqzone_app_img%2Fapp613_613_75.png%26openid%3D0000000000000000000000000E111111%26
	 * openkey%3D1111806DC5D1C52150CF405E42222222%26payitem%3D50005%2A4%2A1%26pf%3Dqzone%26
	 * pfkey%3D1B59A5C3D77C7C56D7AFC3E2C823105D%26ts%3D1333674935%26zoneid%3D0
	 * 生成sig时构造的密钥为：12345f9a47df4d1eaeb3bad9a7e54321&
	 * 生成的签名为： IC0ErTY2gpTbNq8f1hbh0tSu1CM=
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
	public class SOpenQQUtil
	{
		public function SOpenQQUtil()
		{
		}

		/**
		 * URL编码规则：
		 * 签名验证时，要求对字符串中除了“-”、“_”、“.”之外的所有非字母数字字符都替换成百分号(%)后跟两位十六进制数。
		 * 十六进制数中字母必须为大写。
		 * @param appkey
		 * @param uri
		 * @param params
		 * @return
		 *
		 */
		public static function getSigInOpenAPI3_0(appkey : String, uri : String, ... params) : String
		{
			//Step 1. 构造源串
			//第1步：将请求的URI路径进行URL编码（URI不含host，URI示例：/v3/user/get_info）。
			var uriCode : String = encodeURIComponent(uri);
			//第2步：将除“sig”外的所有参数按key进行字典升序排列。
			var paramsLen : int = params.length;
			var paramKeys : Array = [];
			var paramValues : Dictionary = new Dictionary();
			var i : int = 0;
			for (i = 0; i < paramsLen; i++)
			{
				var keyValue : String = params[i];
				var keyValueMap : Array = keyValue.split("=");
				paramKeys.push(keyValueMap[0]);
				paramValues[keyValueMap[0]] = keyValueMap[1];
			}
			paramKeys.sort(Array.CASEINSENSITIVE);
			//第3步：将第2步中排序后的参数(key=value)用&拼接起来，并进行URL编码。
			var paramsSource : String = "";
			for (i = 0; i < paramsLen; i++)
			{
				paramsSource += paramKeys[i] + "=" + paramValues[paramKeys[i]];
				if (i < paramsLen - 1)
					paramsSource += "&";
			}
			var paramsSourceCode : String = encodeURIComponent(paramsSource);
			//注意事项：
			//1. 某些系统方法，例如.NET系统方法HttpUtility.UrlEncode会将‘=’编码成‘%3d’，而不是%3D，导致加密签名通不过验证，请开发者注意检查。
			//2.Java 1.3和早期版本中，调用java.net.URLEncoder下的方法进行URL编码时，某些特殊字符并不会被编码，例如星号(*)。
			//由于URL编码规则中规定了星号(*)必须编码，因此在请求字符串中含星号(*)的情况下如果使用了上述方法，会导致生成的签名不能通过验证。
			//例如调用v3/pay/buy_goods接口时， payitem参数值中一定会含有* ，在使用类java.net.URLEncoder下的方法进行编码后，需开发人员手动将星号字符“*”替换为“%2A”，否则将导致加密签名一直通不过验证，请开发者注意检查。
			//3. 某些语言的urlencode方法会把“空格”编码为“+”，实际上应该编码为“%20”。这也将生成错误的签名，导致签名通不过验证。 
			//请开发者注意检查，手动将“+”替换为“%20”。
			//在PHP中，推荐用rawurlencode方法进行URL编码。
			paramsSourceCode = paramsSourceCode.replace(/\*/g, "%2A");
			//第4步：将HTTP请求方式（GET或者POST）以及第1步和第3步中的字符串用&拼接起来。
			var sourceStr : String = "GET&" + uriCode + "&" + paramsSourceCode;
			trace(sourceStr);

			//Step 2. 构造密钥
			//得到密钥的方式：在应用的appkey末尾加上一个字节的“&”，即appkey&
			var appkeyCode : String = appkey + "&";

			//3. 得到的签名值结果如下
			return sourceStr;
		}

		public static function getUrlEncode(url : String, ... params) : String
		{
			var paramsLen : int = params.length;
			var paramKeys : Array = [];
			var paramValues : Dictionary = new Dictionary();
			var i : int = 0;
			for (i = 0; i < paramsLen; i++)
			{
				var keyValue : String = params[i];
				var keyValueMap : Array = keyValue.split("=");
				paramKeys.push(keyValueMap[0]);
				paramValues[keyValueMap[0]] = keyValueMap[1];
			}
			paramKeys.sort(Array.CASEINSENSITIVE);

			var paramsSource : String = "";
			for (i = 0; i < paramsLen; i++)
			{
				var value : String = paramValues[paramKeys[i]];
				value = encodeURIComponent(value);
				value = value.replace(/\*/g, "%2A");
				paramsSource += paramKeys[i] + "=" + value;
				if (i < paramsLen - 1)
					paramsSource += "&";
			}
			var sourceStr : String = url + "?" + paramsSource;
			trace(sourceStr);

			return sourceStr;
		}

		/**
		 * URL编码前的请求： https://119.147.19.43/v3/pay/buy_goods?amt=4&appid=600&appmode=1&format=json&
		 * goodsmeta=道具*测试描述信息！！！&
		 * goodsurl=http://qzonestyle.gtimg.cn/qzonestyle/act/qzone_app_img/app613_613_75.png&
		 * openid=0000000000000000000000000E111111&openkey=1111806DC5D1C52150CF405E42222222&payitem=50005*4*1&
		 * pf=qzone&pfkey=1B59A5C3D77C7C56D7AFC3E2C823105D&ts=1333674935&zoneid=0&sig=IC0ErTY2gpTbNq8f1hbh0tSu1CM=
		 *
		 * URL编码后的请求： https://119.147.19.43/v3/pay/buy_goods?amt=4&appid=600&appmode=1&format=json&
		 * goodsmeta=%E9%81%93%E5%85%B7%2A%E6%B5%8B%E8%AF%95%E6%8F%8F%E8%BF%B0%E4%BF%A1%E6%81
		 * %AF%EF%BC%81%EF%BC%81%EF%BC%81&goodsurl=http%3A%2F%2Fqzonestyle.gtimg.cn%2Fqzonestyle
		 * %2Fact%2Fqzone_app_img%2Fapp613_613_75.png&openid=0000000000000000000000000E111111&
		 * openkey=1111806DC5D1C52150CF405E42222222&payitem=50005%2A4%2A1&pf=qzone&pfkey=1B59A5
		 * C3D77C7C56D7AFC3E2C823105D&ts=1333674935&zoneid=0&sig=IC0ErTY2gpTbNq8f1hbh0tSu1CM%3D
		 *
		 * @param url
		 * @return
		 *
		 */
		public static function getRequestUrl(host : String, uri : String, openid : String, openkey : String, appid : String, appkey : String, pf : String, userip : String, ... params) : String
		{
			var urlEncodeParams : Array = [host + uri];
			urlEncodeParams.push("openid=" + openid);
			urlEncodeParams.push("openkey=" + openkey);
			urlEncodeParams.push("appid=" + appid);
			urlEncodeParams.push("pf=" + pf);
			urlEncodeParams.push("format=json");
			urlEncodeParams.push("userip=" + userip);
			urlEncodeParams = urlEncodeParams.concat(params);
			var urlEncode : String = (getUrlEncode as Function).apply(null, urlEncodeParams);
			var sigInOpenParams : Array = [appkey, uri];
			sigInOpenParams = sigInOpenParams.concat(params);
			var sigCode : String = (getSigInOpenAPI3_0 as Function).apply(null, sigInOpenParams);
			sigCode = encodeURIComponent(sigCode);
			sigCode = sigCode.replace(/\*/g, "%2A");
			var sourceStr : String = urlEncode + "&sig=" + sigCode;
			trace(sourceStr);
			return sourceStr;
		}

		/**
		 *
		 * 参考http://wiki.open.qq.com/wiki/v3/pay/buy_goods
		 *
		 */
		public static function getV3PayBuyGoodsRequestUrl(host : String, openid : String, openkey : String, appid : String, appkey : String, pf : String, userip : String, pfkey : String, amt : String, amttype : String, ts : String, //
			goodsId : String, goodsPrice : int, goodsNum : int, appmode : String, max_num : int, goodsName : String, goodsDes : String, goodsurl : String, //
			zoneid : String, present : String, paymode : String) : String
		{
			var requestUrlParams : Array = [host, "/v3/pay/buy_goods", openid, openkey, appid, appkey, pf, userip];
			requestUrlParams.push("pfkey=" + pfkey);
			if (amt)
				requestUrlParams.push("amt=" + amt);
			if (amttype)
				requestUrlParams.push("amttype=" + amttype);
			requestUrlParams.push("ts=" + ts);
			var payitem : String = goodsId + "*" + goodsPrice + "*" + goodsNum;
			requestUrlParams.push("payitem=" + payitem);
			requestUrlParams.push("appmode=" + appmode);
			requestUrlParams.push("max_num=" + max_num);
			var goodsmeta : String = goodsName + "*" + goodsDes;
			requestUrlParams.push("goodsmeta=" + goodsmeta);
			requestUrlParams.push("goodsurl=" + goodsurl);
			requestUrlParams.push("zoneid=" + zoneid);
			requestUrlParams.push("present=" + present);
			if (paymode)
				requestUrlParams.push("paymode=" + paymode);

			var sourceStr : String = (getRequestUrl as Function).apply(null, requestUrlParams);
			trace(sourceStr);
			return sourceStr;
		}

		/**
		 *
		 * @param disturb 可选。仅当接入“道具寄售”模式的应用使用游戏币快捷支付功能时，必须传该参数。取值固定为“true”。 其他支付场景不需要传入该参数。
		 * @param param 必须。 表示购买物品的url参数，url_params是调用Q点直购接口v3/pay/buy_goods或道具寄售接口v3/pay/exchange_goods接口返回的参数。
		 * @param sandbox 必须。表示是否使用沙箱测试环境。应用发布前，请务必注释掉该行。sandbox值为布尔型。true：使用； false或不指定：不使用。（沙箱必须传sandbox : true，现网传sandbox : false或者注释）
		 * @param context 可选。前台使用的上下文变量，用于回调时识别来源。
		 * @param onSuccess 可选。用户购买成功时的回调方法，其中opt.context为上述context参数。如果用户购买成功，则立即回调JS中的onSuccess，当用户关闭对话框时再回调onClose。
		 * @param onCancel 可选。用户取消购买时的回调方法，其中opt.context为上述context参数。如果用户购买失败或没有购买，关闭对话框时将先回调onCancel再回调onClose。
		 * @param onSend 可选。如果在实现Q点直购功能时调用了发货通知接口，即需要实现本方法，其中opt.context为上述context参数。如果发货超时，则立即回调onSend。
		 * @param onClose 可选。对话框关闭时的回调方法，主要用于对话框关闭后进行UI方面的调整，onSuccess和onCancel则用于应用逻辑的处理，避免过度耦合。
		 *
		 */
		public static function requestFusion2DialogBuy(disturb : Boolean = true, param : String = "url_param", sandbox : Boolean = true, context : String = "context", onSuccess : Function = null, onCancel : Function = null, onSend : Function = null, onClose : Function = null) : void
		{
			if (onSuccess != null)
				SWebUtil.addCallback("onSuccess", onSuccess);
			if (onCancel != null)
				SWebUtil.addCallback("onCancel", onCancel);
			if (onSend != null)
				SWebUtil.addCallback("onSend", onSend);
			if (onClose != null)
				SWebUtil.addCallback("onClose", onClose);
			SWebUtil.eval("fusion2.dialog.buy({" + //
				(disturb ? "disturb : true," : "") + //
				"param : \"" + param + "\"," + //
				"sandbox : " + sandbox + "," + //
				"context : \"" + context + "\"" + //
				(onSuccess != null ? ",onSuccess : function (opt){document.getElementById(\"" + SSwfFit.target + "\").onSuccess(opt);}" : "") + //
				(onCancel != null ? ",onCancel : function (opt){document.getElementById(\"" + SSwfFit.target + "\").onCancel(opt);}" : "") + //
				(onSend != null ? ",onSend : function (opt){document.getElementById(\"" + SSwfFit.target + "\").onSend(opt);}" : "") + //
				(onClose != null ? ",onClose : function (opt){document.getElementById(\"" + SSwfFit.target + "\").onClose(opt);}" : "") + //
				"});");
		}

		/**
		 *
		 * @param json
		 * @return
		 * ret  返回码。具体返回码含义详见下文。
		 * msg  如果错误，返回错误信息。
		 * is_lost  数据是否丢失，如果应用不考虑cache可以完全不关心。
		 * 0或者不返回：完全没有丢失，可以缓存。
		 * 1：有一部分数据错误，不要缓存
		 *
		 */
		public static function getRequestReturn(json : String) : Object
		{
//			var result : Object = SJson.decode(json);
//			return result;
			return null;
		}

		public static function decodeParameter(value : String) : String
		{
			value = decodeURIComponent(value);
			value = value.replace(/%2A/g, "*");
			return value;
		}

		/**
		 * 弹框中的“开通黄钻”按钮对应的链接为（链接中的*****请使用appid替代）：http://pay.qq.com/qzone/index.shtml?aid=game*****.op。
		 * 弹框中的“开通年费黄钻”按钮对应的链接为（链接中的*****请使用appid替代）：
		 * http://pay.qq.com/qzone/index.shtml?aid=game*****.yop&paytime=year。
		 * @param appid
		 *
		 */
		public static function gotoOpenYellowDiamonds(appid : String) : void
		{
			SCommonUtil.gotoURL("http://pay.qq.com/qzone/index.shtml?aid=game" + appid + ".op");
		}
	}
}