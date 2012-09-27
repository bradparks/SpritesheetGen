package com.pdev.gui 
{
	import com.bit101.components.HBox;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.VBox;
	import com.pdev.swf.SWFSpriteSheet;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	/**
	 * ...
	 * @author P Svilans
	 */
	public class PropertiesPanel extends Panel
	{
		
		private var items:VBox;
		
		private var dimensions:HBox;
		private var dimX:NumericStepper;
		private var dimY:NumericStepper;
		
		private var current:SWFSpriteSheet;
		
		private var save_btn:PushButton;
		
		private var frameDisplay:SpriteFrameDisplay;
		
		public function PropertiesPanel( frameDisplay:SpriteFrameDisplay) 
		{
			super();
			
			items = new VBox( this);
			
			dimensions = new HBox( items, 5, 5);
			dimX = new NumericStepper( dimensions);
			dimY = new NumericStepper( dimensions);
			
			save_btn = new PushButton( items, 0, 0, "Save", save);
			this.frameDisplay = frameDisplay;
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