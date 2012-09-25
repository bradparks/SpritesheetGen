package com.pdev.data 
{
	import com.pdev.swf.SWFSpriteSheet;
	/**
	 * ...
	 * @author P Svilans
	 */
	public class LibraryData 
	{
		
		public var label:String;
		public var progress:Number;
		public var spritesheet:SWFSpriteSheet;
		
		public var onProgress:Function;
		
		public function LibraryData( spritesheet:SWFSpriteSheet) 
		{
			this.label = spritesheet.name;
			this.spritesheet = spritesheet;
			
			this.progress = 0.0;
			this.onProgress = null;
		}
		
	}

}