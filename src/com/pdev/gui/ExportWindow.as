package com.pdev.gui 
{
	import com.bit101.components.Window;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author P Svilans
	 */
	public class ExportWindow extends Window
	{
		
		public function ExportWindow( parent:DisplayObjectContainer)
		{
			super( parent);
			
			setSize( 500, 400);
			
			title = "Spritesheet Exporter";
		}
		
	}

}