package com.pdev.core
{
	
	import com.bit101.components.Accordion;
	import com.bit101.components.PushButton;
	import com.bit101.components.ScrollPane;
	import com.bit101.components.Style;
	import com.pdev.core.notify.Alert;
	import com.pdev.core.notify.AlertManager;
	import com.pdev.data.ImportSettings;
	import com.pdev.events.AnimationLoadEvent;
	import com.pdev.events.LibraryEvent;
	import com.pdev.events.SWFLoadEvent;
	import com.pdev.export.IExport;
	import com.pdev.export.PNGSequenceExport;
	import com.pdev.export.StarlingExport;
	import com.pdev.gui.AnimationImporterWindow;
	import com.pdev.gui.AnimationPreviewPanel;
	import com.pdev.gui.ExportWindow;
	import com.pdev.gui.LibraryPanel;
	import com.pdev.gui.MainPanel;
	import com.pdev.gui.PropertiesPanel;
	import com.pdev.gui.SpriteFrameDisplay;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragActions;
	import flash.desktop.NativeDragManager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author P Svilans
	 */
	public class Main extends Sprite 
	{
		
		private var bg:Bitmap;
		private var mainPanel:MainPanel;
		private var libraryPanel:LibraryPanel;
		private var sideBar:Accordion;
		
		private var library:AnimationLibrary;
		
		private var swfLoader:SWFLoader;
		
		private var frameDisplay:SpriteFrameDisplay;
		private var previewPanel:AnimationPreviewPanel;
		private var propPanel:PropertiesPanel;
		
		private var exporters:/*IExport*/Array;
		
		public function Main():void 
		{
			Style.setStyle( Style.DARK);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			init();
			
			stage.addEventListener( Event.RESIZE, onResize);
		}
		
		private function init():void
		{
			AlertManager.init( stage);
			
			exporters = [ new StarlingExport(), new PNGSequenceExport()];
			
			bg = new Bitmap( new BitmapData( 1, 1, false, 0x333528));
			this.addChild( bg);
			
			frameDisplay = new SpriteFrameDisplay();
			this.addChild( frameDisplay);
			
			previewPanel = new AnimationPreviewPanel( this);
			
			propPanel = new PropertiesPanel( frameDisplay);
			propPanel.x = stage.stageWidth - 300;
			propPanel.y = 0;
			propPanel.setSize( 300, 120);
			propPanel.addEventListener(LibraryEvent.EXPORT, onExport);
			
			libraryPanel = new LibraryPanel( this);
			libraryPanel.x = 0;
			libraryPanel.y = 120;
			libraryPanel.addEventListener( SWFLoadEvent.SWF_LOAD, loadSWFS);
			libraryPanel.addEventListener(LibraryEvent.SELECT_ANIMATION, updateSelectedSpritesheet);
			
			swfLoader = new SWFLoader( importMovieClips);
			library = new AnimationLibrary( libraryPanel);

			mainPanel = new MainPanel( swfLoader);
			this.addChild( mainPanel.display);
			mainPanel.display.addChild( propPanel);
			
			//sideBar.getWindowAt(0).dispatchEvent( new Event( Event.SELECT));
			
			updateGUI();
		}
		
		private function onExport(e:LibraryEvent):void 
		{
			var exportWindow:ExportWindow = new ExportWindow( e.spritesheet, exporters, this);
			exportWindow.x = ( stage.stageWidth - exportWindow.width) * 0.5;
			exportWindow.y = ( stage.stageHeight - exportWindow.height) * 0.5;
		}
		
		private function updateSelectedSpritesheet( e:LibraryEvent):void
		{
			frameDisplay.display( e.spritesheet);
			previewPanel.preview( e.spritesheet);
			propPanel.load( e.spritesheet);
		}
		
		private function importMovieClips( loaderInfo:LoaderInfo):void
		{
			var importer:AnimationImporterWindow = new AnimationImporterWindow( this, loaderInfo);
			importer.x = ( stage.stageWidth - importer.width) * 0.5;
			importer.y = ( stage.stageHeight - importer.height) * 0.5;
			
			stage.nativeWindow.alwaysInFront = true;
			stage.nativeWindow.alwaysInFront = false;
			
			importer.addEventListener(AnimationLoadEvent.LOAD, processMovieClips);
		}
		
		private function processMovieClips( e:AnimationLoadEvent):void
		{
			e.target.removeEventListener(AnimationLoadEvent.LOAD, processMovieClips);
			
			var settings:/*ImportSettings*/Array = e.importSettings;
			
			for ( var i:int = 0; i < settings.length; i++)
			{
				if ( library.exists( settings[i].name))
				{
					var alert:Alert = new Alert( "Library Conflict!", "A name conflict exists between an existing animation in the library, and an animation you are trying to load.\n\nLoad anyway?", true);
					alert.setting = settings[i];
					
					alert.addEventListener(Event.COMPLETE, onAnimationAlert);
					
					AlertManager.alert( alert);
				}
				else
				{
					processClip( settings[i]);
				}
			}
		}
		
		private function onAnimationAlert( e:Event):void
		{
			var alert:Alert = e.target as Alert;
			if ( alert.response == Alert.YES) processClip( alert.setting);
		}
		
		private function processClip( setting:ImportSettings):void
		{
			library.addAnimation( setting);
		}
		
		private function loadSWFS( e:SWFLoadEvent):void
		{
			var swfs:/*File*/Array = e.files;
			for ( var i:int = 0; i < swfs.length; i++)
			{
				swfLoader.load( swfs[i]);
			}
		}
		
		private function onResize( e:Event):void 
		{
			updateGUI();
		}
		
		private function updateGUI():void
		{
			bg.width = stage.stageWidth;
			bg.height = stage.stageHeight;
			
			mainPanel.resize();
			
			previewPanel.y = stage.stageHeight - 250;
			previewPanel.setSize( 250, 250);
			libraryPanel.setSize( 250, ( stage.stageHeight - mainPanel.display.height - previewPanel.height));
			
			frameDisplay.x = libraryPanel.width;
			frameDisplay.y = mainPanel.display.height;
			frameDisplay.setSize( stage.stageWidth - libraryPanel.width, stage.stageHeight - mainPanel.display.height);
			
			propPanel.x = stage.stageWidth - 300;
		}
		
	}
	
}