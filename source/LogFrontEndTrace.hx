import flixel.system.debug.log.LogStyle;
import haxe.PosInfos;

class LogFrontEndTrace
{
	public static function traceLog(data:Any, ?style:LogStyle, ?pos:PosInfos)
	{
		trace('${style.prefix}$data');
	}
}
