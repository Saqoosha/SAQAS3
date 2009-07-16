package net.saqoosha.net {
	
	import com.adobe.utils.DateUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.xml.XMLNode;

	[Event( name="complete", type="flash.events.Event" )]

	public class PlistLoader extends EventDispatcher {
		
		private var _loader:URLLoader;
		private var _data:Object;
		
		public function PlistLoader() {
			super();
		}
		
		public function load(url:String):void {
			this._loader = new URLLoader();
			this._loader.dataFormat = URLLoaderDataFormat.TEXT;
			this._loader.addEventListener(Event.COMPLETE, this._onLoaded);
			this._loader.load(new URLRequest(url));
		}
		
		private function _onLoaded(e:Event):void {
			var root:XML = new XML(this._loader.data);
			this._data = this.parseNode(root.child(0));
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function parseNode(node:*):* {
			var ret:*;
			switch (node.name().toString()) {
				case 'string':
					ret = node.toString();
					break;
				case 'integer':
					ret = parseInt(node.toString());
					break;
				case 'real':
					ret = parseFloat(node.toString());
					break;
				case 'true':
					ret = true;
					break;
				case 'false':
					ret = false;
					break;
				case 'date':
					ret = parseW3CDTF(node.toString());
					break;
				case 'array':
					ret = this.parseArray(node);
					break;
				case 'dict':
					ret = this.parseDict(node);
					break;
			}
			return ret;
		}
		
		private function parseArray(node:*):Array {
			var ret:Array = [];
			for each(var n:XML in node.children()) {
				ret.push(this.parseNode(n));
			}
			return ret;
		}
		
		private function parseDict(node:*):Dictionary {
			var ret:Dictionary = new Dictionary();
			var key:String;
			for each(var n:XML in node.children()) {
				switch (n.name().toString()) {
					case 'key':
						key = n.children().toString();
						break;
					default:
						ret[key] = this.parseNode(n);
						break;
				}
			}
			return ret;
		}
		
		public function get data():* {
			return this._data;
		}
		
		public function dump():void {
			this.dumpElement(this._data);
		}
		
		private function dumpElement(e:*, pad:String = ''):void {
			if (e is String) {
				trace(pad + '[String] ' + e);
			} else if (e is int) {
				trace(pad + '[Integer] ' + e);
			} else if (e is Number) {
				trace(pad + '[Number] ' + e);
			} else if (e is Boolean) {
				trace(pad + '[Boolean] ' + (e ? 'true' : 'false'));
			} else if (e is Date) {
				trace(pad + '[Date] ' + e);
			} else if (e is Dictionary) {
				trace(pad + '[Dictionary]');
				this.dumpList(e, pad + '    ');
			} else if (e is Array) {
				trace(pad + '[Array]');
				this.dumpList(e, pad + '    ');
			} else {
				trace(pad + '[Object]');
				this.dumpList(e, pad + '    ');
			}
		}
		
		private function dumpList(list:*, pad:String = ''):void {
			for (var key:String in list) {
				trace(pad + key + ' -->');
				this.dumpElement(list[key], pad + '  ');
			}
		}
		
	}
	
}


function parseW3CDTF(str:String):Date
{
    var finalDate:Date;
	try
	{
		var dateStr:String = str.substring(0, str.indexOf("T"));
		var timeStr:String = str.substring(str.indexOf("T")+1, str.length);
		var dateArr:Array = dateStr.split("-");
		var year:Number = Number(dateArr.shift());
		var month:Number = Number(dateArr.shift());
		var date:Number = Number(dateArr.shift());
		
		var multiplier:Number;
		var offsetHours:Number;
		var offsetMinutes:Number;
		var offsetStr:String;
		
		if (timeStr.indexOf("Z") != -1)
		{
			multiplier = 1;
			offsetHours = 0;
			offsetMinutes = 0;
			timeStr = timeStr.replace("Z", "");
		}
		else if (timeStr.indexOf("+") != -1)
		{
			multiplier = 1;
			offsetStr = timeStr.substring(timeStr.indexOf("+")+1, timeStr.length);
			offsetHours = Number(offsetStr.substring(0, offsetStr.indexOf(":")));
			offsetMinutes = Number(offsetStr.substring(offsetStr.indexOf(":")+1, offsetStr.length));
			timeStr = timeStr.substring(0, timeStr.indexOf("+"));
		}
		else // offset is -
		{
			multiplier = -1;
			offsetStr = timeStr.substring(timeStr.indexOf("-")+1, timeStr.length);
			offsetHours = Number(offsetStr.substring(0, offsetStr.indexOf(":")));
			offsetMinutes = Number(offsetStr.substring(offsetStr.indexOf(":")+1, offsetStr.length));
			timeStr = timeStr.substring(0, timeStr.indexOf("-"));
		}
		var timeArr:Array = timeStr.split(":");
		var hour:Number = Number(timeArr.shift());
		var minutes:Number = Number(timeArr.shift());
		var secondsArr:Array = (timeArr.length > 0) ? String(timeArr.shift()).split(".") : null;
		var seconds:Number = (secondsArr != null && secondsArr.length > 0) ? Number(secondsArr.shift()) : 0;
		var milliseconds:Number = (secondsArr != null && secondsArr.length > 0) ? Number(secondsArr.shift()) : 0;
		var utc:Number = Date.UTC(year, month-1, date, hour, minutes, seconds, milliseconds);
		var offset:Number = (((offsetHours * 3600000) + (offsetMinutes * 60000)) * multiplier);
		finalDate = new Date(utc - offset);

		if (finalDate.toString() == "Invalid Date")
		{
			throw new Error("This date does not conform to W3CDTF.");
		}
	}
	catch (e:Error)
	{
		var eStr:String = "Unable to parse the string [" +str+ "] into a date. ";
		eStr += "The internal error was: " + e.toString();
		throw new Error(eStr);
	}
    return finalDate;
}
