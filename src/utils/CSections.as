// Derived from my Singularity Wedge class, containing the following copyright
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
// This class draws C-sections with a specified width
//
package utils
{
  import flash.display.Graphics;
	
  public class CSections
  {
    public static const PI4_INV:Number = 4.0/Math.PI;

    private var __radius:Number;        // radius of circular arc
    private var __width:Number;         // width of c-section
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

    public function CSections(_r:Number=0, _w:Number=0, _xC:Number=0, _yC:Number=0, _start:Number=0, _end:Number=0)
    {
      radius    = _r;
      width     = _w;
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
    
    public function set width(_w:Number):void 
    { 
      __width = _w > 0 && !isNaN(_w) ? _w : 5; 
    }
    
    public function set startAngle(_n:Number):void { __startAngle = _n; }
    
    public function set endAngle(_n:Number):void   
    { 
      __endAngle = _n; 
      __delta    = __endAngle - __startAngle;  
    }

    public function draw( _g:Graphics ):void
    {
      var numSeg:Number  = Math.ceil(Math.abs(__delta*PI4_INV));
	  var arc:Number     = __delta/numSeg;
      var pX0:Number     = __radius*Math.cos(__startAngle);
      var pY0:Number     = __radius*Math.sin(__startAngle);
      var pX:Number      = (__radius+__width)*Math.cos(__startAngle);
      var pY:Number      = (__radius+__width)*Math.sin(__startAngle);
      __p0X              = __xC + pX;
      __p0Y              = __yC + pY;
      var qX:Number      = 0;
      var qY:Number      = 0;
      var angle:Number   = __startAngle;
 
      // leading edge of C-section
      _g.moveTo(pX0+__xC, pY0+__yC);
      _g.lineTo(__p0X,__p0Y);
      
      if( __delta == 0 )
        return;
      
      var inverse:Number = 1/(__radius+__width);
      
      // outer circular arc
      for( var i:uint=0; i<numSeg; ++i )
      {
        angle += arc;
        qX     = (__radius+__width)*Math.cos(angle);
        qY     = (__radius+__width)*Math.sin(angle);
        __p2X  = __xC + qX;
        __p2Y  = __yC + qY;

        var dX:Number = (pX+qX)*inverse;
        var dY:Number = (pY+qY)*inverse;
        var d:Number  = Math.sqrt(dX*dX + dY*dY);
        dX /= d;
        dY /= d;

        __p1X  = __xC + (__radius+__width)*dX;
        __p1Y  = __yC + (__radius+__width)*dY;

        var cX:Number = 2.0*__p1X - 0.5*(__p0X + __p2X);
        var cY:Number = 2.0*__p1Y - 0.5*(__p0Y + __p2Y);

        _g.curveTo(cX, cY, __p2X, __p2Y);
        
        __p0X = __p2X;
        __p0Y = __p2Y;
        pX    = qX;
        pY    = qY;
      }
    
      // trailing edge of the C-Section
      pX = __radius*Math.cos(__endAngle);
      pY = __radius*Math.sin(__endAngle);
      _g.lineTo(pX+__xC, pY+__yC);
      
      // here we go again with the inner arc of the C-section - I'll recode these some day to use an Arc class as a primitive
      // also, note that this *won't* work as-is if you are using a fill - a rogue line will be created by Flash - will address
      // that in a future implementation, by building a Vector or quads and then drawing the inner arc of the C-seciton in
      // reverse order.  then, all will be well with the universe.  right now, time is short :)
      pX    = __radius*Math.cos(__startAngle);
      pY    = __radius*Math.sin(__startAngle);
      __p0X = __xC + pX;
      __p0Y = __yC + pY;
      qX    = 0;
      qY    = 0;
      angle = __startAngle;
      
      // leading edge of C-section
      _g.moveTo(__p0X,__p0Y);
      
      // outer circular arc
      for( i=0; i<numSeg; ++i )
      {
        angle += arc;
        qX     = __radius*Math.cos(angle);
        qY     = __radius*Math.sin(angle);
        __p2X  = __xC + qX;
        __p2Y  = __yC + qY;
        
        dX  = (pX+qX)*__radInv;
        dY  = (pY+qY)*__radInv;
        d   = Math.sqrt(dX*dX + dY*dY);
        dX /= d;
        dY /= d;
        
        __p1X  = __xC + __radius*dX;
        __p1Y  = __yC + __radius*dY;
        
        cX = 2.0*__p1X - 0.5*(__p0X + __p2X);
        cY = 2.0*__p1Y - 0.5*(__p0Y + __p2Y);
        
        _g.curveTo(cX, cY, __p2X, __p2Y);
        
        __p0X = __p2X;
        __p0Y = __p2Y;
        pX    = qX;
        pY    = qY;
      }
    }
  }
}