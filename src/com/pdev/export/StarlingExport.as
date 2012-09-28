package com.pdev.export 
{
	import com.adobe.images.PNGEncoder;
	import com.pdev.swf.SWFFrame;
	import flash.display.Shape;
	import flash.filesystem.File;
	import com.pdev.swf.SWFSpriteSheet;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.System;
	import flash.utils.ByteArray;
	import mx.utils.StringUtil;
	/**
	 * ...
	 * @author P Svilans
	 */
	public class StarlingExport implements IExport
	{
		
		private var current:SWFSpriteSheet;
		private var url:String;
		
		private var directory:File;
		
		private var s:Shape;
		
		public function StarlingExport() 
		{
			
		}
		
		/* INTERFACE com.pdev.export.IExport */
		
		public function getName():String 
		{
			return "starling";
		}
		
		public function export( spritesheet:SWFSpriteSheet, file:File):void 
		{
			
			directory = file;
			url = directory.url;
			trace ( url);
			current = spritesheet;
			var f:File;
			var frame:SWFFrame;
			var fname:String;
			
			var bytes:ByteArray = PNGEncoder.encode( spritesheet.canvas);
			
			var newline:String 
			var atlas:XML = <TextureAtlas imagePath={spritesheet.name + ".png"}>
							</TextureAtlas>;
			
			trace ( atlas);
			
			for ( var i:int = 0 ; i < current.frames.length; i++)
			{
				frame = current.frames[i];
				if ( frame.fit)
				{
					var index:int = frame.index + 1000 - 1;
					var index_str:String = index.toString().substr( 1);
					
					var subTex:XML = <SubTexture name={frame.name + "_" + index_str} />
					subTex.@x = frame.fit.x;
					subTex.@y = frame.fit.y;
					subTex.@width = frame.rect.width + current.settings.padding.x * 2;
					subTex.@height = frame.rect.height + current.settings.padding.x * 2;
					subTex.@frameX = -frame.rect.x;
					subTex.@frameY = -frame.rect.y;
					subTex.@frameWidth = spritesheet.globalRect.width;
					subTex.@frameHeight = spritesheet.globalRect.width;
					
					atlas.appendChild( subTex);
				}
			}
			
			var fstream:FileStream;
			
			fname = spritesheet.name + ".png";
			f = new File( url + "/" + fname);
			fstream = new FileStream();
			fstream.open( f, FileMode.WRITE);
			fstream.writeBytes( bytes);
			fstream.close();
			
			fname = spritesheet.name + ".xml";
			f = new File( url + "/" + fname);
			fstream = new FileStream();
			fstream.open( f, FileMode.WRITE);
			fstream.writeUTFBytes( atlas);
			fstream.close();
		}
		
	}

}