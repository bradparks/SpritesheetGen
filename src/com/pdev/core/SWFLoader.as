package com.pdev.core 
{
	import com.pdev.swf.SWFSpriteSheet;
	import com.pdev.utils.getFileName;
	import com.pdev.utils.MovieClipControl;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author P Svilans
	 */
	public class SWFLoader extends EventDispatcher
	{
		
		[Event(name = "complete", type = "flash.events.Event")]
		
		public var callback:Function;
		
		/**
		 * Creates a new SWFLoader to load SWFs
		 * @param	callback A Function object that must have 1 parameter ( a LoaderInfo)
		 */
		public function SWFLoader( callback:Function = null) 
		{
			this.callback = callback;
		}
		
		public function load( file:File):void
		{
			if ( file.extension == "swf")
			{
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onSWFLoad);
				loader.load( new URLRequest( file.url));
			}
		}
		
		private function onSWFLoad(e:Event):void
		{
			var loaderInfo:LoaderInfo = e.target as LoaderInfo;
			
			if ( loaderInfo.content is MovieClip)
			{
				// do the callback and pass LoaderInfo object.
				MovieClipControl.stop( loaderInfo.content as MovieClip);
				
				if ( callback != null) callback( loaderInfo);
			}
		}
		
	}

}