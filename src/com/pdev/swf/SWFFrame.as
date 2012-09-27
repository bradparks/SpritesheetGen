package com.pdev.swf 
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author P Svilans
	 */
	public class SWFFrame 
	{
		
		public var rect:Rectangle;
		public var matrix:Matrix;
		public var bd:BitmapData;
		
		public var index:int;
		public var fit:Rectangle;
		
		public var valid:Boolean;
		
		public function SWFFrame( bd:BitmapData, matrix:Matrix, rect:Rectangle) 
		{
			this.bd = bd;
			this.matrix = matrix;
			this.rect = rect;
			
			this.valid = true;
		}
		
		public function get size():Number 
		{
			return rect.width * rect.height;
		}
		
	}

}