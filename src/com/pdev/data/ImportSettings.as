package com.pdev.data 
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	/**
	 * ...
	 * @author P Svilans
	 */
	public class ImportSettings 
	{
		
		public var name:String;
		public var movieclip:MovieClip;
		public var scale:Number;
		public var padding:Point;
		
		public function ImportSettings( name:String, movieclip:MovieClip, scale:Number = 1.0, padding:Point = null) 
		{
			this.name = name;
			this.movieclip = movieclip;
			this.scale = scale;
			
			if ( padding == null) padding = new Point( 2, 2);
			
			this.padding = padding;
		}
		
	}

}