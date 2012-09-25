package com.pdev.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author P Svilans
	 */
	public class AnimationLoadEvent extends Event 
	{
		
		public static const LOAD:String = "load";
		
		public var importSettings:Array;
		
		public function AnimationLoadEvent(type:String, movieclips:Array, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
			this.importSettings = movieclips;
		} 
		
		public override function clone():Event 
		{ 
			return new AnimationLoadEvent(type, importSettings, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("AnimationLoadEvent", "type", "movieclips", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}