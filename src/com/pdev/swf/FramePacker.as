package com.pdev.swf 
{
	import com.pdev.core.notify.Alert;
	import com.pdev.core.notify.AlertManager;
	import de.polygonal.ds.BinaryTreeNode;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author P Svilans
	 */
	public class FramePacker 
	{
		
		public function FramePacker() 
		{
			
		}
		
		public function pack( canvas:BitmapData, spritesheet:SWFSpriteSheet):void
		{
			var frames:/*SWFFrame*/Array = spritesheet.frames;
			var rect:Rectangle = canvas.rect;
			
			var sorted:/*SWFFrame*/Array = [];
			var frame:SWFFrame;
			
			var i:int;
			var j:int;
			for ( i = 0; i < frames.length; i++)
			{
				frame = frames[i];
				if ( !frame.valid) continue;
				for ( j = 0; j < sorted.length; j++) if ( frame.size > sorted[j].size) break;
				sorted.splice( j, 0, frame);
			}
			
			var root:BinaryTreeNode = new BinaryTreeNode( new NodeData( rect));
			var node:BinaryTreeNode;
			
			var isFit:Boolean = true;
			
			for ( i = 0; i < sorted.length; i++)
			{
				frame = sorted[i];
				node = findNode( root, frame.rect.width, frame.rect.height);
				if ( node != null)
				{
					frame.fit = splitNode( node, frame.rect.width, frame.rect.height).val.rect;
					
					canvas.copyPixels( frame.bd, frame.bd.rect, new Point( frame.fit.x, frame.fit.y), null, null, true);
				}
				else
				{
					isFit = false;
				}
			}
			
			if ( !isFit)
			{
				var a:Alert =  new Alert( "Spritesheet Pack Error! ( " + spritesheet.name + " )", "There is not enough room on the current canvas size to draw all frames of the animation! Try changing the size in the properties panel!", false);
				AlertManager.alert( a);
			}
		}
		
		private function findNode( node:BinaryTreeNode, w:Number, h:Number):BinaryTreeNode
		{
			var data:NodeData = node.val as NodeData;
			var next:BinaryTreeNode;
			if ( data.used)
			{
				if ( ( next = findNode( node.r, w, h)) != null) return next;
				else if ( ( next = findNode( node.l, w, h)) != null) return next;
			}
			else if ( w <= data.rect.width && h <= data.rect.height)
			{
				return node;
			}
			
			return null;
		}
		
		private function splitNode( node:BinaryTreeNode, w:Number, h:Number):BinaryTreeNode
		{
			var data:NodeData = node.val as NodeData;
			data.used = true;
			
			var rectLeft:Rectangle  = new Rectangle( data.rect.x,     data.rect.y + h, data.rect.width,     data.rect.height - h);
			var rectRight:Rectangle = new Rectangle( data.rect.x + w, data.rect.y,     data.rect.width - w, h                   );
			
			node.setL( new NodeData( rectLeft));
			node.setR( new NodeData( rectRight));
			
			return node;
		}
		
	}

}

class NodeData
{
	
	public var rect:flash.geom.Rectangle;
	public var used:Boolean;
	
	public function NodeData( rect:flash.geom.Rectangle)
	{
		this.rect = rect;
		used = false;
	}
}