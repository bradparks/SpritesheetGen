package com.pdev.events 
{
	import flash.events.Event;
	import flash.filesystem.File;
	
	/**
	 * ...
	 * @author P Svilans
	 */
	public class SWFLoadEvent extends Event 
	{
		
		public static const SWF_LOAD:String = "swfLoad";
		
		public var files:/*File*/Array;
		
		/**
		 * New SWFLoadEvent
		 * @param	type
		 * @param	files An Array of File objects.
		 * @param	bubbles
		 * @param	cancelable
		 */
		
		public function SWFLoadEvent(type:String, files:Array = null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
			this.files = files;
		} 
		
		public override function clone():Event 
		{ 
			return new SWFLoadEvent(type, files, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SWFLoadEvent", "type", "files", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}