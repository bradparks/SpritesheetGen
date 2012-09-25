package com.pdev.core 
{
	import com.pdev.data.ImportSettings;
	import com.pdev.gui.LibraryPanel;
	import com.pdev.swf.SWFSpriteSheet;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author P Svilans
	 */
	public class AnimationLibrary 
	{
		
		private var library:/*SWFSpriteSheet*/Array;
		private var libraryPanel:LibraryPanel;
		
		public function AnimationLibrary( libraryPanel:LibraryPanel) 
		{
			library = new Array();
			this.libraryPanel = libraryPanel;
		}
		
		public function addAnimation( importSettings:ImportSettings):void
		{
			var spritesheet:SWFSpriteSheet = new SWFSpriteSheet( importSettings);
			
			libraryPanel.addLibraryItem( spritesheet);
			library.push( spritesheet);
		}
		
		public function exists( name:String):Boolean
		{
			for ( var i:int = 0; i < library.length; i++) if ( library[i].name == name) return true;
			return false;
		}
		
	}

}