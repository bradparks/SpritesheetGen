package com.pdev.gui 
{
	import com.bit101.components.ScrollPane;
	import com.pdev.swf.SWFFrame;
	import com.pdev.swf.SWFSpriteSheet;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
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
		
		public var highlightContainer:Sprite;
		private var hlight:Graphics;
		
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
			
			highlightContainer = new Sprite();
			renderContainer.addChild( highlightContainer);
			hlight = highlightContainer.graphics;
			
			this.renderContainer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.renderContainer.addEventListener(MouseEvent.MOUSE_MOVE, frameBorderPreview);
		}
		
		private function frameBorderPreview( e:MouseEvent):void
		{
			if ( current)
			{
				hlight.clear();
				
				var mx:Number = renderContainer.mouseX;
				var my:Number = renderContainer.mouseY;
				
				var i:int;
				var f:SWFFrame;
				for ( i = 0; i < current.frames.length; i++)
				{
					f = current.frames[i];
					if ( f.fit != null && f.fit.contains( mx, my) && mx < f.fit.x + f.rect.width && my < f.fit.y + f.rect.height)
					{
						hlight.lineStyle( 4, 0x70BABA, 0.4);
						hlight.drawRect( f.fit.x, f.fit.y, f.rect.width, f.rect.height);
						break;
					}
				}
			}
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			var content:Sprite = displayPane.content;
			content.startDrag( false, new Rectangle( 0, 0, Math.min( 0, displayPane.width - content.width - 12), Math.min( 0, displayPane.height - content.height - 12)));
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			displayPane.hScroll = -displayPane.content.x;
			displayPane.vScroll = -displayPane.content.y;
		}
		
		private function onMouseUp(e:MouseEvent):void
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
			
			render.bitmapData = spritesheet.canvas;
			displayPane.update();
			
			/*var i:int;
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
			
			renderFrames();*/
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