package com.pdev.export 
{
	import com.pdev.swf.SWFSpriteSheet;
	import flash.filesystem.File;
	
	/**
	 * ...
	 * @author P Svilans
	 */
	public interface IExport 
	{
		function getName():String;
		function export( spritesheet:SWFSpriteSheet, file:File):void;
	}
	
}