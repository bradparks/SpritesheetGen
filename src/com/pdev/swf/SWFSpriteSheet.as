package com.pdev.swf 
{
	import com.pdev.data.ImportSettings;
	import com.pdev.utils.MovieClipControl;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author P Svilans
	 */
	public class SWFSpriteSheet extends EventDispatcher
	{
		
		[Event(name = "progress", type = "flash.events.ProgressEvent")]
		[Event(name="complete", type="flash.events.Event")]
		
		public var name:String;
		public var frames:/*SWFFrame*/Array;
		
		private var container:Sprite;
		
		public var globalRect:Rectangle;
		
		private var display:MovieClip;
		private var scale:Number;
		private var padding:Point;
		
		public var settings:ImportSettings;
		
		public function SWFSpriteSheet( importSettings:ImportSettings) 
		{
			this.settings = importSettings;
			frames = new Array();
			
			this.name = settings.name;
			
			this.display = settings.movieclip;
			display.x = 0;
			display.y = 0;
			this.scale = settings.scale;
			
			this.padding = settings.padding;
			
			container = new Sprite();
			container.addChild( display);
			
			stop();
			reset();
			
			display.addEventListener(Event.ENTER_FRAME, drawFrames);
			drawFrames();
			play();
		}
		
		private function drawFrames( e:Event = null):void
		{
			if ( display.currentFrame == 1 && frames.length > 0)
			{
				display.removeEventListener(Event.ENTER_FRAME, drawFrames);
				
				dispatchEvent( new ProgressEvent( ProgressEvent.PROGRESS, false, false, display.totalFrames, display.totalFrames));
				dispatchEvent( new Event( Event.COMPLETE));
				
				stop();
				
				return;
			}
			
			var rect:Rectangle = getRealBounds( display);
			
			if ( globalRect == null) globalRect = rect;
			else globalRect = globalRect.union( rect);
			
			if ( Math.floor( rect.width) == 0 || Math.floor( rect.height) == 0) return;
			
			rect.width *= scale;
			rect.height *= scale;
			
			var bd:BitmapData = new BitmapData( rect.width + padding.x * 2, rect.height + padding.y * 2, true, 0);
			var matrix:Matrix = new Matrix();
			matrix.translate( -rect.x + padding.x, -rect.y + padding.y);
			matrix.scale( scale, scale);
			bd.draw( display, matrix);
			
			var frame:SWFFrame = new SWFFrame( bd, matrix, rect);
			frames.push( frame);
			
			dispatchEvent( new ProgressEvent( ProgressEvent.PROGRESS, false, false, display.currentFrame, display.totalFrames));
		}
		
		public function reset():void
		{
			MovieClipControl.reset( display);
		}
		
		public function stop():void
		{
			MovieClipControl.stop( display);
		}
		
		public function play():void
		{
			MovieClipControl.play( display);
		}
		
		private function getRealBounds( clip:DisplayObject):Rectangle
		{
			var bounds:Rectangle = clip.getBounds(clip.parent);
			bounds.x = Math.floor(bounds.x);
			bounds.y = Math.floor(bounds.y);
			bounds.height = Math.ceil(bounds.height);
			bounds.width = Math.ceil(bounds.width);
			
			var realBounds:Rectangle = new Rectangle(0, 0, bounds.width + padding.x * 2, bounds.height + padding.y * 2);
			
			if (clip.filters.length > 0)
			{
				var j:int = 0;
				
				var clipFilters:Array = clip.filters;
				var clipFiltersLength:int = clipFilters.length;
				var tmpBData:BitmapData;
				var filterRect:Rectangle;
				
				tmpBData = new BitmapData(realBounds.width, realBounds.height, false);
				filterRect = tmpBData.generateFilterRect(tmpBData.rect, clipFilters[j]);
				tmpBData.dispose();
				
				while ( ++j < clipFiltersLength)
				{
					tmpBData = new BitmapData(filterRect.width, filterRect.height, true, 0);
					filterRect = tmpBData.generateFilterRect(tmpBData.rect, clipFilters[j]);
					realBounds = realBounds.union(filterRect);
					tmpBData.dispose();
				}
			}

			realBounds.offset( bounds.x, bounds.y);
			realBounds.width = Math.max(realBounds.width, 1);
			realBounds.height = Math.max(realBounds.height, 1);

			tmpBData = null;
			
			return realBounds;
		}
		
	}

}