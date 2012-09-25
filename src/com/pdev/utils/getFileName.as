package com.pdev.utils 
{
	/**
	 * ...
	 * @author P Svilans
	 */
	
	public function getFileName( url:String):String 
	{
		var tokens:/*String*/Array = url.split( "/");
		return tokens.pop().split(".")[0];
	}

}