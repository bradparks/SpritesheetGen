package com.pdev.gui 
{
	import com.bit101.components.ListItem;
	import com.pdev.data.LibraryData;
	import com.pdev.swf.SWFSpriteSheet;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.events.ProgressEvent;
	/**
	 * ...
	 * @author P Svilans
	 */
	public class LibraryItem extends ListItem
	{
		
		private var progressBar:Bitmap;
		
		private var _progress:Number;
		
		public function LibraryItem( parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, data:Object = null)
		{
			super( parent, xpos, ypos, data);
		}
		
		private function getData():void
		{
			var libItem:LibraryData = _data as LibraryData;
			
			if ( libItem != null)
			{
				if ( libItem.label != null) _label.text = libItem.label;
				if ( !isNaN( libItem.progress)) progress = libItem.progress;
				
				if ( libItem.onProgress != null) libItem.spritesheet.removeEventListener( ProgressEvent.PROGRESS, libItem.onProgress);
				
				if ( libItem.spritesheet != null)
				{
					libItem.onProgress = onProgress;
					libItem.spritesheet.addEventListener( ProgressEvent.PROGRESS, libItem.onProgress);
				}
			}
		}
		
		private function onProgress( e:ProgressEvent):void
		{
			progress = e.bytesLoaded / e.bytesTotal;
		}
		
		override protected function addChildren():void 
		{
			progressBar = new Bitmap( new BitmapData( 1, 1, false, 0x4586BA));
			progressBar.alpha = 0.2;
			
			addChild( progressBar);
			
			super.addChildren();
			
			getData();
		}
		
		override public function draw():void 
		{
			super.draw();
			updateProgressBar();
		}
		
		public function get progress():Number 
		{
			return _progress;
		}
		
		public function set progress(value:Number):void 
		{
			_progress = value;
			_data.progress = value;
			
			updateProgressBar();
		}
		
		private function updateProgressBar():void
		{
			progressBar.width = _progress * width;
			progressBar.height = height;
		}
		
	}

}