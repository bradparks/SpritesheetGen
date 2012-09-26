package com.pdev.gui 
{
	import com.bit101.components.HBox;
	import com.bit101.components.PushButton;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;
	import com.pdev.swf.SWFFrame;
	import com.pdev.swf.SWFSpriteSheet;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author P Svilans
	 */
	public class AnimationPreviewPanel extends Window
	{
		
		private var current:SWFSpriteSheet;
		private var _currentFrame:int;
		private var totalFrames:int;
		
		private var canvas:BitmapData;
		private var render:Bitmap;
		
		private var offset:Point;
		
		private var vbox:VBox;
		private var hbox:HBox;
		private var play_btn:PushButton;
		private var pause_btn:PushButton;
		private var stop_btn:PushButton;
		
		public function AnimationPreviewPanel( parent:DisplayObjectContainer) 
		{
			super( parent, 0, 0, "Live Preview");
			
			render = new Bitmap( new BitmapData( 2, 2, true, 0));
			
			vbox = new VBox( this);
			vbox.addChild( render);
			
			hbox = new HBox( vbox);
			
			play_btn = new PushButton( hbox, 0, 0, "Play", onPlay);
			play_btn.setSize( 65, play_btn.height);
			pause_btn = new PushButton( hbox, 0, 0, "Pause", onPause);
			pause_btn.setSize( 65, pause_btn.height);
			stop_btn = new PushButton( hbox, 0, 0, "Stop", onStop);
			stop_btn.setSize( 65, stop_btn.height);
		}
		
		private function onPlay( e:MouseEvent):void
		{
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function onPause( e:MouseEvent):void
		{
			removeEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function onStop( e:MouseEvent):void
		{
			currentFrame = 1;
			removeEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		public function preview( spritesheet:SWFSpriteSheet):void
		{
			current = spritesheet;
			canvas = new BitmapData( spritesheet.globalRect.width, spritesheet.globalRect.height, true, 0);
			render.bitmapData = canvas;
			var scale:Number = Math.min( 200 / canvas.width, ( this.height - 50) / canvas.height);
			render.scaleX = render.scaleY = scale;
			
			offset = new Point( spritesheet.globalRect.x, spritesheet.globalRect.y);
			currentFrame = 0;
			totalFrames = spritesheet.frames.length;
		}
		
		private function enterFrame( e:Event):void
		{
			currentFrame++;
		}
		
		private function drawFrame():void
		{
			if ( current != null)
			{
				var frame:SWFFrame = current.frames[ currentFrame];
				
				canvas.fillRect( canvas.rect, 0);
				canvas.copyPixels( frame.bd, frame.bd.rect, new Point( frame.rect.x, frame.rect.y).subtract( offset));
			}
		}
		
		public function get currentFrame():int 
		{
			return _currentFrame;
		}
		
		public function set currentFrame(value:int):void 
		{
			if ( value >= totalFrames) value = 0;
			_currentFrame = value;
			drawFrame();
		}
		
	}

}