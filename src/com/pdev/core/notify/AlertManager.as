package com.pdev.core.notify 
{
	import com.bit101.components.HBox;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextArea;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;
	import flash.desktop.NotificationType;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author P Svilans
	 */
	public class AlertManager 
	{
		
		private static var _created:Boolean;
		private static var _instance:AlertManager;
		
		public var display:Sprite;
		
		private var YES:String = "Yes";
		private var NO:String = "No";
		private var OKAY:String = "Okay";
		
		private var stage:Stage;
		
		private var queue:/*AlertData*/Array;
		
		private var overlay:Bitmap;
		
		private var alert:Window;
		private var alertBox:VBox;
		
		private var message:TextArea;
		
		private var userChoice:HBox;
		private var userAlert:HBox;
		
		private var current:Alert;
		private var inProgress:Boolean;
		
		public function AlertManager( stage:Stage) 
		{
			if ( _created == false || _instance != null) throw new Error( "Cannot create an AlertManager manually!");
			
			this.stage = stage;
			
			queue = new Array();
			
			display = new Sprite();
			overlay = new Bitmap( new BitmapData( 1, 1, false, 0));
			overlay.alpha = 0.4;
			
			display.addChild( overlay);
			
			alert = new Window( display);
			alert.setSize( 380, 160);
			alertBox = new VBox( alert);
			alertBox.alignment = VBox.CENTER;
			alertBox.x = 10;
			
			message = new TextArea( alertBox);
			message.editable = false;
			message.selectable = false;
			message.opaqueBackground = null;
			message.autoHideScrollBar = true;
			message.setSize( alert.width - 20, alert.height - 50);
			
			userChoice = new HBox();
			var yes_btn:PushButton = new PushButton( userChoice, 0, 0, YES, onButtonPress);
			var no_btn:PushButton = new PushButton( userChoice, 0, 0, NO, onButtonPress);
			
			userAlert = new HBox();
			var okay_btn:PushButton = new PushButton( userAlert, 0, 0, OKAY, onButtonPress);
			
			resize();
			stage.addEventListener(Event.RESIZE, resize);
		}
		
		public function pushAlert( alert:Alert):void
		{
			queue.push( alert);
			
			if ( !inProgress)
			{
				stage.addChild( display);
				next();
			}
		}
		
		private function next():void
		{
			if ( queue.length > 0)
			{
				inProgress = true;
				current = queue.shift();
				
				alert.title = current.title;
				message.text = current.message;
				
				if ( current.isChoice) alertBox.addChild( userChoice);
				else alertBox.addChild( userAlert);
				
				stage.nativeWindow.notifyUser( NotificationType.INFORMATIONAL);
				stage.nativeWindow.alwaysInFront = true;
				stage.nativeWindow.alwaysInFront = false;
			}
			else
			{
				stage.removeChild( display);
			}
		}
		
		private function onButtonPress( e:MouseEvent):void
		{
			var btn:PushButton = e.target as PushButton;
			
			if ( btn.label == YES)
			{
				current.setResponse( Alert.YES);
			}
			else if ( btn.label == NO)
			{
				current.setResponse( Alert.NO);
			}
			else if ( btn.label == OKAY)
			{
				current.setResponse( Alert.CONFIRM);
			}
			
			if ( current.isChoice) alertBox.removeChild( userChoice);
			else alertBox.removeChild( userAlert);
			
			inProgress = false;
			next();
		}
		
		private function resize(e:Event = null):void 
		{
			overlay.width = stage.stageWidth;
			overlay.height = stage.stageHeight;
			
			alert.x = ( stage.stageWidth - alert.width) * 0.5;
			alert.y = ( stage.stageHeight - alert.height) * 0.5;
		}
		
		public static function alert( _alert:Alert):void
		{
			_instance.pushAlert( _alert);
		}
		
		public static function init( stage:Stage):void
		{
			if ( _instance == null)
			{
				_created = true;
				_instance = new AlertManager( stage);
			}
		}
		
	}
	
}
