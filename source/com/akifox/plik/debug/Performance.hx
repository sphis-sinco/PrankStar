package com.akifox.plik.debug;

import haxe.Timer;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.FPS;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.system.System;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * Performance.hx
 * Haxe/OpenFL class to display memory usage.
 *
 * More informations here
 * https://github.com/yupswing/plik/tree/master/com/akifox/plik/debug
 *
 * @author Simone Cingano (yupswing) PLIK Studio
 * @licence MIT
 *
 * Based on this post written by Kirill Poletaev
 * http://haxecoder.com/post.php?id=24
 */
class Performance extends Sprite
{
	private var performanceText:TextField;
	private var appText:TextField;

	private var fpsHistory:Array<Int>;

	private static inline var fpsHistoryLen:Int = 30;

	private var skipped = 0;
	private var skip = 10;
	private var times:Array<Float>;

	private var padding:Int = 10;
	private var paddingY:Int = 3;

	public var graphBarTickness = 3;
	public var graphBarPadding = 1;

	private var barHeight = 30;

	private var memPeak:Float = 0;

	private var bound:Bitmap;
	private var graph:Shape;
	private var boundData:BitmapData;
	private var logo:Bitmap;

	private var fullHeight:Int = 50;

	private var showGraph:Bool;

	public function new(showGraph:Bool = false)
	{
		super();

		this.showGraph = showGraph;

		x = 0;
		y = 0;

		// Setup arrays
		fpsHistory = [];
		for (i in 0...fpsHistoryLen)
			fpsHistory.push(0);
		times = [];

		/// ###################################

		/// ### PERFORMANCE TEXT
		performanceText = new TextField();
		performanceText.y = paddingY;
		performanceText.width = 500;
		performanceText.selectable = false;
		performanceText.defaultTextFormat = new TextFormat(openfl.text.Font.fromFile('assets/data/nokiafc22.ttf').fontName, 12, 0xededed);
		performanceText.text = "FPS: 0 || MEM: 0 MB || MPK: 0 MB";
		performanceText.embedFonts = true;

		fullHeight = Std.int(performanceText.textHeight + paddingY * 3);
		barHeight = Std.int(performanceText.textHeight) - paddingY;

		/// ###################################

		var nextX:Float = padding;

		/// ### GRAPH
		if (showGraph)
		{
			graph = new Shape();
			graph.x = nextX;
			graph.y = paddingY * 2;
			nextX = graph.x + (graphBarTickness + graphBarPadding) * (fpsHistoryLen - 2) + graphBarTickness + padding;
		}

		/// ### PERFORMANCE TEXT
		performanceText.x = nextX;

		/// ###################################

		bound = new Bitmap();
		onResize(null);
		addChild(bound);
		if (showGraph)
			addChild(graph);
		addChild(performanceText);

		/// ###################################

		Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnter);
		Lib.current.stage.addEventListener(Event.RESIZE, onResize);
	}

	private function onEnter(_):Void
	{
		var now = Timer.stamp();
		times.push(now);

		while (times[0] < now - 1)
			times.shift();

		if (skipped == skip)
		{
			skipped = 0;
			var mem:Float = Math.round(System.totalMemory / 1024 / 1024 * 100) / 100;
			if (mem > memPeak)
				memPeak = mem;

			if (visible)
			{
				var fps:Int = times.length;
				if (showGraph)
					drawGraph(fps);
				performanceText.text = "FPS: " + fps + " || MEM: " + mem + " MB || MPK: " + memPeak + " MB";
			}
		}
		skipped++;
	}

	private function drawGraph(fps:Int):Void
	{
		var color:Int;
		fpsHistory.push(fps);
		fpsHistory.shift();
		graph.graphics.clear();
		for (i in 0...fpsHistoryLen)
		{
			graph.graphics.moveTo(graphBarTickness * i + i * graphBarPadding, barHeight);
			if (fpsHistory[i] > 55)
				color = 0x9fe198;
			else if (fpsHistory[i] > 40)
				color = 0xefdea2;
			else if (fpsHistory[i] > 30)
				color = 0xefbda2;
			else
				color = 0xeda0a4;
			graph.graphics.lineStyle(graphBarTickness, color, 0.5);
			graph.graphics.lineTo(graphBarTickness * i + i * graphBarPadding, barHeight - barHeight * fpsHistory[i] / 60);
		}
	}

	private function onResize(_):Void
	{
		boundData = new BitmapData(Lib.current.stage.stageWidth, fullHeight);
		boundData.fillRect(new Rectangle(0, 0, Lib.current.stage.stageWidth, fullHeight), 0x88000000);
		bound.bitmapData = boundData;
	}
}
