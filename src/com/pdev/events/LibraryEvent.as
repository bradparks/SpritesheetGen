package com.pdev.events 
{
	import com.pdev.swf.SWFSpriteSheet;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author P Svilans
	 */
	public class LibraryEvent extends Event 
	{
		
		public static const SELECT:String = "select";
		public static const EXPORT:String = "export";
		
		public var spritesheet:SWFSpriteSheet;
		
		public function LibraryEvent(type:String, spritesheet:SWFSpriteSheet, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.spritesheet = spritesheet;
		} 
		
		public override function clone():Event 
		{ 
			return new LibraryEvent(type, spritesheet, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("LibraryEvent", "type", "spritesheet", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}