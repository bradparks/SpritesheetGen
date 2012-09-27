package com.pdev.gui 
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.HBox;
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;
	import com.pdev.core.notify.Alert;
	import com.pdev.core.notify.AlertManager;
	import com.pdev.export.IExport;
	import com.pdev.swf.SWFSpriteSheet;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	/**
	 * ...
	 * @author P Svilans
	 */
	public class ExportWindow extends Window
	{
		
		private var spritesheet:SWFSpriteSheet;
		
		private var items:VBox;
		
		private var exportTypes:HBox;
		private var checkboxes:/*CheckBox*/Array;
		
		private var savePath:HBox;
		private var saveURL:InputText;
		private var browse_btn:PushButton;
		private var file:File;
		
		private var options:HBox;
		private var export_btn:PushButton;
		private var cancel_btn:PushButton;
		
		private var exporters:/*IExport*/Array;
		
		public function ExportWindow( spritesheet:SWFSpriteSheet, exporters:/*IExport*/Array, parent:DisplayObjectContainer = null)
		{
			super( parent);
			this.spritesheet = spritesheet;
			this.exporters = exporters;
			
			setSize( 500, 400);
			
			title = "Spritesheet Exporter ( " + spritesheet.name + " )";
			
			items = new VBox( this, 10, 10);
			items.alignment = VBox.CENTER;
			
			exportTypes = new HBox( items);
			exportTypes.alignment = HBox.MIDDLE;
			
			checkboxes = new Array();
			for ( var i:int = 0; i < exporters.length; i++)
			{
				var cb:CheckBox = new CheckBox( exportTypes, 0, 0, exporters[i].getName());
				checkboxes.push( cb);
			}
			
			savePath = new HBox( items);
			savePath.alignment = HBox.MIDDLE;
			
			saveURL = new InputText( savePath);
			saveURL.setSize( 200, saveURL.height);
			browse_btn = new PushButton( savePath, 0, 0, "Browse", onBrowse);
			
			options = new HBox( items);
			options.alignment = HBox.MIDDLE;
			export_btn = new PushButton( options, 0, 0, "Export", onExport);
			cancel_btn = new PushButton( options, 0, 0, "Cancel", onCancel);
			
			items.draw();
			
			setSize( items.width + 20, items.height + 40);
		}
		
		private function close():void
		{
			this.parent.removeChild( this);
		}
		
		private function onCancel( e:MouseEvent):void 
		{
			close();
		}
		
		private function onExport( e:MouseEvent):void
		{
			var url:String = saveURL.text;
			if ( url.length == 0)
			{
				var a:Alert = new Alert( "Invalid Save Directory!", "This is an invalid save directory. Please choose a valid one!", false);
				AlertManager.alert( a);
				
				return;
			}
			
			var c:String = url.charAt( url.length - 1);
			if ( c != "/") url = url + "/";
			
			for ( var i:int = 0; i < checkboxes.length; i++)
			{
				if ( checkboxes[i].selected)
				{
					var file:File = new File( url + exporters[i].getName() + "/");
					file.createDirectory();
					exporters[i].export( spritesheet, file);
				}
			}
			
			var f:File = new File( url);
			f.openWithDefaultApplication();
			
			close();
		}
		
		private function onBrowse( e:MouseEvent):void
		{
			var url:String = saveURL.text;
			if ( url == "") url = stage.loaderInfo.url;
			file = new File( url);
			file.addEventListener(Event.SELECT, function ( e:Event):void
			{
				saveURL.text = file.url;
			});
			file.browseForDirectory( "Export location");
		}
		
	}

}