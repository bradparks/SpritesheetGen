package com.pdev.utils 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author P Svilans
	 */
	public class MovieClipControl 
	{
		
		/**
		 * Recursive stop.
		 * @param	movieclip
		 */
		
		public static function stop( movieclip:MovieClip):void
		{
			movieclip.stop();
			
			for ( var i:int = 0; i < movieclip.numChildren; i++)
			{
				var c:DisplayObject = movieclip.getChildAt(i);
				if ( c is MovieClip) stop( c as MovieClip);
			}
		}
		
		/**
		 * Recursive reset to Frame 1.
		 * @param	movieclip
		 */
		
		public static function reset( movieclip:MovieClip):void
		{
			movieclip.gotoAndStop( 1);
			
			for ( var i:int = 0; i < movieclip.numChildren; i++)
			{
				var c:DisplayObject = movieclip.getChildAt(i);
				if ( c is MovieClip) reset( c as MovieClip);
			}
		}
		
		/**
		 * Recursive play.
		 * @param	movieclip
		 */
		
		public static function play( movieclip:MovieClip):void
		{
			movieclip.play();
			
			for ( var i:int = 0; i < movieclip.numChildren; i++)
			{
				var c:DisplayObject = movieclip.getChildAt(i);
				if ( c is MovieClip) play( c as MovieClip);
			}
		}
		
	}

}