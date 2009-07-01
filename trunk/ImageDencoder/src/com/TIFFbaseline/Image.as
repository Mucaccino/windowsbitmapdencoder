// ==================================================================
// Module:			Image.as
//
// Description:		Image content for Adobe TIFF file v6.0
//
// Author(s):		C.T. Yeung
//
// History:
// 23Feb09			start coding								cty
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:

// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
// ==================================================================
package com.TIFFbaseline
{
	import flash.utils.ByteArray;
	import flash.display.BitmapData;
	
	public class Image
	{
		public static const BPP_1:int = 1;
		public static const BPP_4:int = 4;
		public static const BPP_8:int = 8;
		public static const BPP_24:int = 24;
		public static const BPP_32:int = 32;
		
		public var bitmapData:BitmapData;
		protected var hdr:Header;
		protected var info:ImageInfo;
		protected var bytes:ByteArray;
		
/////////////////////////////////////////////////////////////////////
// initialization

		public function Image(hdr:Header=null,
							  info:ImageInfo=null)
		{
			this.hdr = hdr;
			this.info = info;
		}

		public function empty():void
		{
			if(bitmapData)
				bitmapData.dispose();
			bitmapData = null;
		}
		
		public function isEmpty():Boolean
		{
			if(bitmapData)
				return false;
			return true;
		}
		
		public function setRef(hdr:Header=null,
							  info:ImageInfo=null):void
		{
			this.hdr = hdr;
			this.info = info;
		}

/////////////////////////////////////////////////////////////////////
// public

		public function encode():Boolean
		{
			return true;
		}
		
		public function decode(bytes:ByteArray):Boolean
		{
			empty();
			
			this.bytes = bytes;
			bitmapData = new BitmapData(info.imageWidth, info.imageLength);
			switch(info.bitsPerPixel)
			{
				case BPP_1:
				return decode1bpp();
				
				case BPP_4:
				return decode4bpp();
				
				case BPP_8:
				return decode8bpp();
				
				case BPP_24:
				return decode24bpp();
				
				case BPP_32:
				return decode32bpp();
			}
			return false;
		}

/////////////////////////////////////////////////////////////////////
// protected decoding
		
		protected function decode1bpp():Boolean
		{
			// non - functional
			var so:Array = info.stripOffset;
			var rps:Array = info.rowsPerStrip;
			var offsetList:Array = new Array();
			var lineWidth:int = info.imageWidth;
			var y:int=0;
			for( var i:int = 0; i<so.length; i++) {
				for(var j:int = 0; j<rps[i]; j++) {
					var pos:int = so[i] + lineWidth * j; 
					y ++;
					for( var x:int = 0; x<lineWidth; x++) {
						var clr:uint = uint(bytes[pos+x]);
						clr += uint(bytes[pos+x])<<8;
						clr += uint(bytes[pos+x])<<(8*2);
						bitmapData.setPixel(x,y, clr);
					}
				}
			}
			return true;
		}
		
		protected function decode4bpp():Boolean
		{
			// non - functional
			var so:Array = info.stripOffset;
			var rps:Array = info.rowsPerStrip;
			var offsetList:Array = new Array();
			var lineWidth:int = info.imageWidth;
			var y:int=0;
			for( var i:int = 0; i<so.length; i++) {
				for(var j:int = 0; j<rps[i]; j++) {
					var pos:int = so[i] + lineWidth * j; 
					y ++;
					for( var x:int = 0; x<lineWidth; x++) {
						var clr:uint = uint(bytes[pos+x]);
						clr += uint(bytes[pos+x])<<8;
						clr += uint(bytes[pos+x])<<(8*2);
						bitmapData.setPixel(x,y, clr);
					}
				}
			}
			return true;
		}
		
		protected function decode8bpp():Boolean
		{
			// need look up table
			var so:Array = info.stripOffset;
			var rps:Array = info.rowsPerStrip;
			var offsetList:Array = new Array();
			var lineWidth:int = info.imageWidth;
			var y:int=0;
			for( var i:int = 0; i<so.length; i++) {
				for(var j:int = 0; j<rps[i]; j++) {
					var pos:int = so[i] + lineWidth * j; 
					y ++;
					for( var x:int = 0; x<lineWidth; x++) {
						var clr:uint = uint(bytes[pos+x]);
						clr += uint(bytes[pos+x])<<8;
						clr += uint(bytes[pos+x])<<(8*2);
						bitmapData.setPixel(x,y, clr);
					}
				}
			}
			return true;
		}
		
		protected function decode24bpp():Boolean
		{
			var so:Array = info.stripOffset;
			var rps:Array = info.rowsPerStrip;
			var offsetList:Array = new Array();
			var lineWidth:int = info.imageWidth * 3;
			var y:int=0;
			for( var i:int = 0; i<so.length; i++) {
				for(var j:int = 0; j<rps[i]; j++) {
					var pos:int = so[i] + lineWidth * j; 
					y ++;
					for( var x:int = 0; x<lineWidth; x+=3) {
						var clr:uint = uint(bytes[pos+x])<<(8*2);
						clr += uint(bytes[pos+x+1])<<8;
						clr += uint(bytes[pos+x+2]);
						bitmapData.setPixel(x/3,y, clr);
					}
				}
			}
			return true;
		}
		
		//***Need to perform CMYK to RGB conversion
		protected function decode32bpp():Boolean
		{
			// non - functional
			var so:Array = info.stripOffset;
			var rps:Array = info.rowsPerStrip;
			var offsetList:Array = new Array();
			var lineWidth:int = info.imageWidth * 4;
			var y:int=0;
			for( var i:int = 0; i<so.length; i++) {
				for(var j:int = 0; j<rps[i]; j++) {
					var pos:int = so[i] + lineWidth * j; 
					y ++;
					for( var x:int = 0; x<lineWidth; x+=4) {
						var clr:uint = uint(bytes[pos+x]);
						clr += uint(bytes[pos+x+1])<<8;
						clr += uint(bytes[pos+x+2])<<(8*2);
					//	clr += uint(bytes[pos+x+3])<<(8*3);
						bitmapData.setPixel(x,y, clr);
					}
				}
			}
			return true;
		}
	}
}