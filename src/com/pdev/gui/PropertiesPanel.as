package com.pdev.gui 
{
	import com.bit101.components.HBox;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.VBox;
	import com.pdev.events.LibraryEvent;
	import com.pdev.swf.SWFSpriteSheet;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	/**
	 * ...
	 * @author P Svilans
	 */
	public class PropertiesPanel extends Panel
	{
		
		[Event(name="export", type="com.pdev.events.LibraryEvent")]
		
		private var items:VBox;
		
		private var dimensions:HBox;
		private var dimX:NumericStepper;
		private var dimY:NumericStepper;
		
		private var current:SWFSpriteSheet;
		
		private var save_btn:PushButton;
		private var export_btn:PushButton;
		
		private var frameDisplay:SpriteFrameDisplay;
		
		public function PropertiesPanel( frameDisplay:SpriteFrameDisplay) 
		{
			super();
			
			items = new VBox( this, 10, 10);
			
			dimensions = new HBox( items, 0, 0);
			dimX = new NumericStepper( dimensions);
			dimY = new NumericStepper( dimensions);
			
			save_btn = new PushButton( items, 0, 0, "Save", save);
			export_btn = new PushButton( items, 0, 0, "Export", export);
			this.frameDisplay = frameDisplay;
		}
		
		private function export( e:Event):void
		{
			if ( current) dispatchEvent( new LibraryEvent( LibraryEvent.EXPORT, current));
		}
		
		/**
		 * Pushes all property changes to the spritesheet and regenerates it.
		 * @param	e
		 */
		
		private function save( e:Event):void
		{
			current.canvasSize.width = dimX.value;
			current.canvasSize.height = dimY.value;
			
			current.pack();
			frameDisplay.display( current);
		}
		
		public function load( spritesheet:SWFSpriteSheet):void
		{
			current = spritesheet;
			dimX.value = current.canvasSize.width;
			dimY.value = current.canvasSize.height;
		}
		
	}

}