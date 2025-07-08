import flixel.system.debug.log.LogStyle;
import haxe.PosInfos;

class LogFrontEndTrace
{
	public static function traceLog(data:Any, ?style:LogStyle, ?pos:PosInfos)
	{
		#if LOG_TO_TRACES
		trace('${style.prefix}$data');
		#end
	}
}
