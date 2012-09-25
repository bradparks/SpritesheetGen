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
		
		private var _rect:Rectangle;
		public var matrix:Matrix;
		public var bd:BitmapData;
		
		private var _size:Number;
		
		public function SWFFrame( bd:BitmapData, matrix:Matrix, rect:Rectangle) 
		{
			this.bd = bd;
			this.matrix = matrix;
			this.rect = rect;
		}
		
		public function get rect():Rectangle 
		{
			return _rect;
		}
		
		public function set rect(value:Rectangle):void 
		{
			_rect = value;
			_size = value.width * value.height;
		}
		
		public function get size():Number 
		{
			return _size;
		}
		
	}

}