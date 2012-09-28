package com.pdev.export 
{
	import com.adobe.images.PNGEncoder;
	import com.pdev.swf.SWFFrame;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.filesystem.File;
	import com.pdev.swf.SWFSpriteSheet;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author P Svilans
	 */
	public class PNGSequenceExport implements IExport
	{
		
		private var current:SWFSpriteSheet;
		private var frameNumber:int;
		private var url:String;
		
		private var directory:File;
		
		private var s:Shape;
		
		public function PNGSequenceExport() 
		{
		}
		
		/* INTERFACE com.pdev.export.IExport */
		
		public function getName():String 
		{
			return "png";
		}
		
		public function export( spritesheet:SWFSpriteSheet, file:File):void 
		{
			directory = file;
			url = directory.url;
			trace ( url);
			frameNumber = 0;
			current = spritesheet;
			
			s = new Shape();
			s.addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function enterFrame( e:Event = null):void
		{
			var f:File;
			var frame:SWFFrame;
			var fname:String;
			
			frame = current.frames[ frameNumber];
			if ( frame == null)
			{
				s.removeEventListener(Event.ENTER_FRAME, enterFrame);
				s = null;
				
				return;
			}
			
			var bytes:ByteArray = PNGEncoder.encode( frame.bd);
			var index:int = frame.index + 1000;
			var index_str:String = index.toString().substr( 1);
			fname = frame.name + index_str + ".png";
			f = new File( url + "/" + fname);
			trace ( f.url);
			var fstream:FileStream = new FileStream();
			fstream.open( f, FileMode.WRITE);
			fstream.writeBytes( bytes);
			fstream.close();
			
			frameNumber++;
		}
		
	}

}