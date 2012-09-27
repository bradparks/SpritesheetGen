package com.pdev.data 
{
	import com.pdev.swf.SWFSpriteSheet;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author P Svilans
	 */
	public class PackData 
	{
		
		public var spritesheet:SWFSpriteSheet;
		public var canvas:Rectangle;
		
		public function PackData( spritesheet:SWFSpriteSheet, canvas:Rectangle) 
		{
			this.spritesheet = spritesheet;
			this.canvas = canvas;
		}
		
	}

}