// Modified from my Singularity Wedge class, containing the following copyright
//
// Wedge.as - Simple pie-shaped wedge drawing class using a quad. Bezier as a primitive.
//
// copyright (c) 2006, Jim Armstrong.  All Rights Reserved.  For educational use only - commercial use strictly prohibited.
//
// This software program is supplied 'as is' without any warranty, express, implied, 
// or otherwise, including without limitation all warranties of merchantability or fitness
// for a particular purpose.  Jim Armstrong shall not be liable for any special
// incidental, or consequential damages, including, without limitation, lost
// revenues, lost profits, or loss of prospective economic advantage, resulting
// from the use or misuse of this software program.
//
// @author Jim Armstrong
// @version 1.0
//
package utils
{
  import flash.display.Graphics;
	
  public class Arc
  {
    public static const PI4_INV:Number = 4.0/Math.PI;

    private var __radius:Number;        // radius of circular arc
    private var __xC:Number;            // x-coordinate of center
    private var __yC:Number;            // y-coordinate of center
    private var __startAngle:Number;    // start-angle in radians
    private var __endAngle:Number;      // end-angle in radians
    private var __delta:Number;         // difference between start and end angles
    private var __radInv:Number;        // inverse of radius

    // quad. bezier fit through these points
    private var __p0X:Number = 0;
    private var __p0Y:Number = 0;
    private var __p1X:Number = 0;
    private var __p1Y:Number = 0;
    private var __p2X:Number = 0;
    private var __p2Y:Number = 0;

    public function Arc(_r:Number=0, _xC:Number=0, _yC:Number=0, _start:Number=0, _end:Number=0)
    {
      radius    = _r;
      xCenter   = _xC;
      yCenter   = _yC;

      startAngle = _start;
      endAngle   = _end;
    }

    public function set xCenter(_n:Number):void 
    { 
      __xC = _n >= 0 && !isNaN(_n) ? _n : 0; 
    }
    
    public function set yCenter(_n:Number):void 
    { 
      __yC = _n >= 0 && !isNaN(_n) ? _n : 0;  
    }
    
    public function set radius(_r:Number):void 
    { 
      __radius = _r > 0 && !isNaN(_r) ? _r : 10; 
      __radInv = 1.0/__radius;
    }
    
    public function set startAngle(_n:Number):void { __startAngle = _n; }
    
    public function set endAngle(_n:Number):void   
    { 
      __endAngle = _n; 
      __delta    = __endAngle - __startAngle;  
    }

    public function draw( _g:Graphics ):void
    {
      if( __delta == 0 )
        return;
      
      var numSeg:Number = Math.ceil(Math.abs(__delta*PI4_INV));
	  var arc:Number    = __delta/numSeg;
      var pX:Number     = __radius*Math.cos(__startAngle);
      var pY:Number     = __radius*Math.sin(__startAngle);
      __p0X             = __xC + pX;
      __p0Y             = __yC + pY;
      var qX:Number     = 0;
      var qY:Number     = 0;
      var angle:Number  = __startAngle;
 
      _g.moveTo(__p0X,__p0Y);
      
      for( var i:uint=0; i<numSeg; ++i )
      {
        angle += arc;
        qX     = __radius*Math.cos(angle);
        qY     = __radius*Math.sin(angle);
        __p2X  = __xC + qX;
        __p2Y  = __yC + qY;

        var dX:Number = (pX+qX)*__radInv;
        var dY:Number = (pY+qY)*__radInv;
        var d:Number  = Math.sqrt(dX*dX + dY*dY);
        dX /= d;
        dY /= d;

        __p1X  = __xC + __radius*dX;
        __p1Y  = __yC + __radius*dY;

        var cX:Number = 2.0*__p1X - 0.5*(__p0X + __p2X);
        var cY:Number = 2.0*__p1Y - 0.5*(__p0Y + __p2Y);

        _g.curveTo(cX, cY, __p2X, __p2Y);

        __p0X = __p2X;
        __p0Y = __p2Y;
        pX    = qX;
        pY    = qY;
      }
    }
  }
}