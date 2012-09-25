package com.pdev.gui 
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.HBox;
	import com.bit101.components.InputText;
	import com.bit101.components.NumericStepper;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author P Svilans
	 */
	public class ImporterSettingsUI extends HBox
	{
		
		public var checkBox:CheckBox;
		
		public var nameChange:InputText;
		public var scale:NumericStepper;
		public var movieclip:MovieClip;
		
		public function ImporterSettingsUI( parent:DisplayObjectContainer, label:String, movieclip:MovieClip) 
		{
			super( parent);
			this.alignment = HBox.MIDDLE;
			this.movieclip = movieclip;
			
			checkBox = new CheckBox( this, 0, 0, label);
			nameChange = new InputText( this, 0, 0, label);
			scale = new NumericStepper( this);
			scale.step = 0.1;
			scale.value = 1.0;
		}
		
	}

}