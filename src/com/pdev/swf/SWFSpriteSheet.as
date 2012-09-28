package com.pdev.swf 
{
	import com.pdev.data.ImportSettings;
	import com.pdev.utils.MovieClipControl;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
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
		public var bdArray:/*BitmapData*/Array;
		
		private var container:Sprite;
		
		public var globalRect:Rectangle;
		
		private var display:MovieClip;
		private var scale:Number;
		public var padding:Point;
		
		public var settings:ImportSettings;
		
		public var packer:FramePacker;
		public var canvasSize:Rectangle;
		public var canvas:BitmapData;
		
		private var tempCanvas:BitmapData;
		
		public function SWFSpriteSheet() 
		{
			frames = new Array();
			bdArray = new Array();
			
			container = new Sprite();
			
			packer = new FramePacker();
			
			tempCanvas = new BitmapData( 1200, 1200, true, 0);
		}
		
		public function concat( spritesheet:SWFSpriteSheet):void
		{
			/* TODO somehow get packing to work, so that multiple spritesheets can be packed into 1!*/
			frames = frames.concat( spritesheet.frames);
			bdArray = bdArray.concat( spritesheet.bdArray);
		}
		
		public function importMovieClip( importSettings:ImportSettings):void
		{
			this.settings = importSettings;
			this.name = settings.name;
			
			this.display = settings.movieclip;
			display.x = 0;
			display.y = 0;
			container.addChild( display);
			
			this.scale = settings.scale;
			this.padding = settings.padding;
			
			this.canvasSize = settings.canvasSize;
			if ( this.canvasSize == null) this.canvasSize = new Rectangle( 0, 0, 512, 512);
			
			stop();
			reset();
			
			display.addEventListener(Event.ENTER_FRAME, drawFrames);
			
			drawFrames();
			
			play();
		}
		
		public function pack():void
		{
			canvas = new BitmapData( canvasSize.width, canvasSize.height, true, 0);
			
			packer.pack( canvas, this);
		}
		
		private function drawFrames( e:Event = null):void
		{
			if ( display.currentFrame == 1 && frames.length > 0)
			{
				display.removeEventListener(Event.ENTER_FRAME, drawFrames);
				
				pack();
				
				dispatchEvent( new ProgressEvent( ProgressEvent.PROGRESS, false, false, display.totalFrames, display.totalFrames));
				dispatchEvent( new Event( Event.COMPLETE));
				
				stop();
				
				return;
			}
			
			var rect:Rectangle
			//rect = getRealChildBounds( display);
			rect = display.getBounds( display.parent);
			var mid:Point = new Point( rect.x + rect.width * 0.5, rect.y + rect.height * 0.5);
			var mat:Matrix = new Matrix();
			mat.translate( 600 - mid.x, 600 - mid.y);
			tempCanvas.fillRect( tempCanvas.rect, 0);
			tempCanvas.draw( display, mat);
			tempCanvas.threshold( tempCanvas, tempCanvas.rect, new Point(), ">", 0x00000000, 0xFF000000, 0xFF000000, false);
			
			rect = tempCanvas.getColorBoundsRect( 0xFF000000, 0xFF000000);
			rect.x -= 600 - mid.x;
			rect.y -= 600 - mid.y;
			trace ( rect);
			
			if ( Math.floor( rect.width) == 0 || Math.floor( rect.height) == 0) return;
			if ( rect.x > 10000 || rect.y > 10000)
			{
				trace ( "fucking huge bounds...");
				return;
			}
			
			rect.x *= scale;
			rect.y *= scale;
			rect.width *= scale;
			rect.height *= scale;
			
			if ( globalRect == null) globalRect = rect;
			else globalRect = globalRect.union( rect);
			
			var bd:BitmapData = new BitmapData( rect.width + padding.x * 2, rect.height + padding.y * 2, true, 0);
			var matrix:Matrix = new Matrix();
			matrix.scale( scale, scale);
			matrix.translate( -rect.x + padding.x, -rect.y + padding.y);
			bd.draw( display, matrix);
			
			bdArray.push( bd);
			var frame:SWFFrame = new SWFFrame( bd, matrix, rect);
			frame.index = display.currentFrame;
			frame.name = name;
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
		
		private function getRealChildBounds( clip:DisplayObject):Rectangle
		{
			var rect:Rectangle = getRealBounds( clip);
			
			if ( clip is DisplayObjectContainer)
			{
				var cont:DisplayObjectContainer = clip as DisplayObjectContainer;
				
				for ( var i:int = 0; i < cont.numChildren; i++)
				{
					rect = rect.union( getRealBounds( cont.getChildAt( i)));
				}
			}
			
			return rect;
		}
		
		private function getRealBounds( clip:DisplayObject):Rectangle
		{
			var bounds:Rectangle = clip.getBounds( clip.parent);
			bounds.x = Math.floor(bounds.x);
			bounds.y = Math.floor(bounds.y);
			bounds.height = Math.ceil(bounds.height);
			bounds.width = Math.ceil(bounds.width);
			
			var realBounds:Rectangle = new Rectangle( 0, 0, bounds.width, bounds.height);
			
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
					filterRect.x = -( filterRect.width - bounds.width) * 0.5
					filterRect.y = -( filterRect.height - bounds.height) * 0.5
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