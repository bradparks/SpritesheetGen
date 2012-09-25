package com.pdev.swf 
{
	import com.pdev.data.ImportSettings;
	import com.pdev.utils.MovieClipControl;
	import flash.display.BitmapData;
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
				
				return;
			}
			
			var rect:Rectangle = display.getBounds( container);
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
		
		private function ply( obj:MovieClip):void
		{
			obj.play();
			for ( var i:int = 0; i < obj.numChildren; i++)
			{
				if ( obj.getChildAt( i) is MovieClip)
				{
					ply( obj.getChildAt( i) as MovieClip);
				}
			}
		}
		
	}

}