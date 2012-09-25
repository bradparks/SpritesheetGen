package com.pdev.gui 
{
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.pdev.core.SWFLoader;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	/**
	 * ...
	 * @author P Svilans
	 */
	public class MainPanel 
	{
		
		public var display:Panel;
		
		private var renderFrames:PushButton;
		private var loadSWF:PushButton;
		
		private var frameDisplay:SpriteFrameDisplay;
		private var swfLoader:SWFLoader;
		
		private var file:File;
		
		public function MainPanel( frameDisplay:SpriteFrameDisplay, swfLoader:SWFLoader) 
		{
			display = new Panel();
			display.height = 120;
			
			renderFrames = new PushButton( display, 400, 100, "Render", onRender);
			loadSWF = new PushButton( display, 20, 100, "Load", onLoad);
			
			this.frameDisplay = frameDisplay;
			this.swfLoader = swfLoader;
		}
		
		private function onRender( e:MouseEvent):void 
		{
			frameDisplay.rerender();
		}
		
		private function onLoad( e:MouseEvent):void
		{
			file = new File();
			file.addEventListener(FileListEvent.SELECT_MULTIPLE, onFileSelect);
			
			file.browseForOpenMultiple( "Load SWF Libraries", [ new FileFilter( "SWF Library File", "*.swf")]);
		}
		
		private function onFileSelect(e:FileListEvent):void 
		{
			for ( var i:int = 0; i < e.files.length; i++)
			{
				swfLoader.load( e.files[i]);
			}
		}
		
		public function resize():void
		{
			if ( display.stage != null)
			{
				display.width = display.stage.stageWidth;
			}
		}
		
	}

}