package com.pdev.gui 
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.HBox;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.VBox;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author P Svilans
	 */
	public class ImporterSettingsUI extends VBox
	{
		
		private var hboxtop:HBox;
		private var hboxbottom:HBox;
		
		public var checkBox:CheckBox;
		
		public var nameChange:InputText;
		public var scale:NumericStepper;
		
		public var xDim:NumericStepper;
		public var yDim:NumericStepper;
		
		public var movieclip:MovieClip;
		
		public function ImporterSettingsUI( parent:DisplayObjectContainer, label:String, movieclip:MovieClip) 
		{
			super( parent);
			this.alignment = VBox.LEFT;
			this.movieclip = movieclip;
			
			hboxtop     = new HBox();
			hboxbottom  = new HBox();
			
			checkBox = new CheckBox( hboxtop, 0, 0, label);
			nameChange = new InputText( hboxtop, 0, 0, label);
			scale = new NumericStepper( hboxtop);
			scale.step = 0.1;
			scale.value = 1.0;
			
			new Label( hboxbottom, 0, 0, "Dimensions:");
			xDim = new NumericStepper( hboxbottom, 0, 0);
			xDim.value = 512;
			new Label( hboxbottom, 0, 0, "x");
			yDim = new NumericStepper( hboxbottom, 0, 0);
			yDim.value = 512;
			
			this.addChild( hboxtop);
			this.addChild( hboxbottom);
		}
		
	}

}