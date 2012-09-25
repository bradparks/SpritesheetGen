package com.pdev.core.notify 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author P Svilans
	 */
	public dynamic class Alert extends EventDispatcher
	{
		
		[Event(name="complete", type="flash.events.Event")]
		
		public static const CONFIRM:int = -1;
		public static const NO:int = 0;
		public static const YES:int = 1;
		
		public var title:String;
		public var message:String;
		public var callback:Function;
		public var isChoice:Boolean;
		
		private var _response:int;
		
		public function Alert( title:String, message:String = "", isChoice:Boolean = true)
		{
			this.title = title;
			this.message = message;
			this.callback = callback;
			this.isChoice = isChoice;
		}
		
		public function get response():int
		{
			return _response;
		}
		
		internal function setResponse( value:int):void
		{
			_response = value;
			dispatchEvent( new Event( Event.COMPLETE));
		}
		
	}

}