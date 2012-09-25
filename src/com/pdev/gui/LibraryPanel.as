package com.pdev.gui 
{
	import com.bit101.components.Component;
	import com.bit101.components.List;
	import com.bit101.components.ListItem;
	import com.bit101.components.Panel;
	import com.bit101.components.Window;
	import com.pdev.data.LibraryData;
	import com.pdev.events.SWFLoadEvent;
	import com.pdev.swf.SWFSpriteSheet;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragActions;
	import flash.desktop.NativeDragManager;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author P Svilans
	 */
	public class LibraryPanel extends EventDispatcher
	{
		
		[Event(name="swfLoad", type="com.pdev.events.SWFLoadEvent")]
		
		public var display:Component;
		
		private var swfList:List;
		
		private var frameDisplay:SpriteFrameDisplay;
		
		public function LibraryPanel( display:Component, frameDisplay:SpriteFrameDisplay):void
		{
			this.frameDisplay = frameDisplay;
			
			this.display = display;
			display.addEventListener(Event.SELECT, updateWindow);
			
			swfList = new List( display, 0, 0);
			swfList.addEventListener(Event.SELECT, onListSelect);
			swfList.listItemClass = LibraryItem;
			
			display.addEventListener( NativeDragEvent.NATIVE_DRAG_ENTER, onDragEnter);
			display.addEventListener( NativeDragEvent.NATIVE_DRAG_DROP, onDragDrop);
		}
		
		private function onDragEnter(e:NativeDragEvent):void 
		{
			NativeDragManager.acceptDragDrop( display);
			NativeDragManager.dropAction = NativeDragActions.LINK;
		}
		
		private function onDragDrop(e:NativeDragEvent):void 
		{
			var urls:/*File*/Array = e.clipboard.getData( ClipboardFormats.FILE_LIST_FORMAT) as Array;
			var swfs:/*File*/Array = [];
			
			for ( var i:int = 0; i < urls.length; i++)
			{
				if ( urls[i].extension == "swf")
				{
					swfs.push( urls[i]);
				}
			}
			
			dispatchEvent( new SWFLoadEvent( SWFLoadEvent.SWF_LOAD, swfs));
		}
		
		public function addLibraryItem( spritesheet:SWFSpriteSheet):void
		{
			var libraryData:LibraryData = new LibraryData( spritesheet);
			swfList.addItem( libraryData);
			var swfItem:LibraryItem = swfList.getItemAt( swfList.numItems - 1) as LibraryItem;
		}
		
		public function removeLibraryItem( name:String):void
		{
			
		}
		
		private function onListSelect(e:Event):void 
		{
			var libraryData:LibraryData = swfList.selectedItem as LibraryData;
			frameDisplay.display( libraryData.spritesheet);
		}
		
		private function updateWindow( e:Event):void
		{
			update();
		}
		
		public function update():void
		{
			if ( display.stage != null)
			{
				swfList.setSize( display.width, display.height - 40);
			}
		}
		
	}

}