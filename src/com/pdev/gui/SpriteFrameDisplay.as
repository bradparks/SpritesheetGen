package com.pdev.gui 
{
	import com.bit101.components.ScrollPane;
	import com.pdev.swf.SWFFrame;
	import com.pdev.swf.SWFSpriteSheet;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author P Svilans
	 */
	public class SpriteFrameDisplay extends Sprite
	{
		
		private var canvas:BitmapData;
		private var render:Bitmap;
		
		private var screen:Rectangle;
		public var displayPane:ScrollPane;
		
		private var renderContainer:Sprite;
		
		private var current:SWFSpriteSheet;
		
		public var padding:Point;
		
		public function SpriteFrameDisplay() 
		{
			canvas = new BitmapData( 10, 10, true, 0);
			render = new Bitmap( canvas);
			renderContainer = new Sprite();
			
			screen = new Rectangle( 0, 0, 600, 480);
			
			padding = new Point( 2, 2);
			
			displayPane = new ScrollPane( this, 200, 120);
			displayPane.autoHideScrollBar = true;
			displayPane.dragContent = false;
			
			renderContainer.addChild( render);
			displayPane.addChild( renderContainer);
			
			this.renderContainer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			var content:Sprite = displayPane.content;
			content.startDrag( false, new Rectangle( 0, 0, Math.min( 0, displayPane.width - content.width - 12), Math.min( 0, displayPane.height - content.height - 12)));
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			displayPane.hScroll = -displayPane.content.x;
			displayPane.vScroll = -displayPane.content.y;
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			displayPane.content.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		public function setSize( w:Number, h:Number):void
		{
			displayPane.setSize( w, h);
			screen.width = w - 15 - padding.x;
			screen.height = h - 15 - padding.y;
		}
		
		private function resizeCanvas( w:Number, h:Number):void
		{
			canvas = new BitmapData( w, h, true, 0);
			render.bitmapData = canvas;
			
			displayPane.update();
		}
		
		public function rerender():void
		{
			display( current);
		}
		
		public function display( spritesheet:SWFSpriteSheet):void
		{
			current = spritesheet;
			
			var i:int;
			var frame:SWFFrame;
			
			var w:Number = padding.x;
			var h:Number = padding.y;
			var mh:Number = 0.0;
			var mw:Number = 0.0;
			
			for ( i = 0; i < spritesheet.frames.length; i++)
			{
				frame = spritesheet.frames[i];
				
				if ( w + frame.rect.width > screen.width)
				{
					mw = Math.max( mw, w);
					
					w = padding.x;
					h += mh + padding.y;
					mh = 0.0;
				}
				
				w += frame.rect.width + padding.x;
				mh = Math.max( mh, frame.rect.height);
			}
			
			mh = h + mh;
			
			resizeCanvas( mw + padding.x, mh + padding.y);
			
			renderFrames();
		}
		
		public function renderFrames():void
		{
			var spritesheet:SWFSpriteSheet = current;
			
			var i:int;
			var frame:SWFFrame;
			
			var w:Number = padding.x;
			var h:Number = padding.y;
			var mh:Number = 0.0;
			
			for ( i = 0; i < spritesheet.frames.length; i++)
			{
				frame = spritesheet.frames[i];
				
				if ( w + frame.rect.width > screen.width)
				{
					w = padding.x;
					h += mh + padding.y;
					mh = 0.0;
				}
				
				canvas.copyPixels( frame.bd, frame.bd.rect, new Point( w, h));
				w += frame.rect.width + padding.x;
				mh = Math.max( mh, frame.rect.height);
			}
		}
		
	}

}