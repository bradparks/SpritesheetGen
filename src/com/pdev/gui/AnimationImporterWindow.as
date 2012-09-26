package com.pdev.gui 
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.ScrollPane;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;
	import com.pdev.data.ImportSettings;
	import com.pdev.events.AnimationLoadEvent;
	import com.pdev.utils.getFileName;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author P Svilans
	 */
	public class AnimationImporterWindow extends Window
	{
		
		[Event(name="load", type="com.pdev.events.AnimationLoadEvent")]
		
		private var currentSWF:Label;
		
		private var _swfName:String;
		
		private var vbox:VBox;
		private var scrollPane:ScrollPane;
		private var scrollBox:VBox;
		private var import_btn:PushButton;
		
		private var objects:/*ImporterSettings*/Array;
		
		private var framerate:int;
		
		public function AnimationImporterWindow( parent:DisplayObjectContainer, loaderInfo:LoaderInfo) 
		{
			super( parent);
			
			objects = new Array();
			
			framerate = loaderInfo.frameRate;
			
			currentSWF = new Label( this, 5, 5);
			
			vbox = new VBox( this, 10, 50);
			vbox.alignment = VBox.CENTER;
			
			scrollPane = new ScrollPane( vbox);
			scrollPane.autoHideScrollBar = true;
			
			scrollBox = new VBox( scrollPane, 10, 10);
			
			import_btn = new PushButton( vbox, 0, 0, "Import", onImport);
			
			setSize( 500, 400);
			
			title = "Animation Importer";
			
			swfName = getFileName( loaderInfo.url) + ".swf";
			
			var container:DisplayObjectContainer = loaderInfo.content as DisplayObjectContainer;
			parseChildren( container, swfName);
		}
		
		private function parseChildren( root:DisplayObjectContainer, name:String = null):void
		{
			if ( root is MovieClip)
			{
				var id:String;
				if ( name == null) id = root.name;
				else id = name;
				
				var setting:ImporterSettingsUI = new ImporterSettingsUI( scrollBox, id, root as MovieClip);
				objects.push( setting);
			}
			
			for ( var i:int = 0; i < root.numChildren; i++)
			{
				var child:DisplayObject = root.getChildAt( i);
				
				if ( child is DisplayObjectContainer) parseChildren( child as DisplayObjectContainer);
			}
		}
		
		override public function setSize(w:Number, h:Number):void 
		{
			super.setSize(w, h);
			
			if ( scrollPane != null) scrollPane.setSize( w - 20, h - 140);
			if ( scrollBox != null) scrollBox.setSize( scrollPane.width - 20, scrollPane.height - 20);
			if ( vbox != null) vbox.setSize( w - 20, h);
		}
		
		private function onImport( e:MouseEvent):void 
		{
			var settings:/*ImportSettings*/Array = [];
			
			for ( var i:int = 0; i < objects.length; i++)
			{
				if ( objects[i].checkBox.selected)
				{
					var setting:ImportSettings = new ImportSettings( objects[i].nameChange.text, objects[i].movieclip, objects[i].scale.value);
					setting.framerate = framerate;
					settings.push( setting);
				}
			}
			
			dispatchEvent( new AnimationLoadEvent( AnimationLoadEvent.LOAD, settings));
			
			this.visible = false;
		}
		
		public function get swfName():String 
		{
			return _swfName;
		}
		
		public function set swfName(value:String):void 
		{
			_swfName = value;
			currentSWF.text = value;
		}
		
	}

}