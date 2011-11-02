// Note to self - aka TODO - I wrote Wedge in late 2005 and modified in early 2006 and modified again for this demo.  It
// was quickly hacked to create CSections and Arc.  Better approach is to use Arc as a base primitive and have Arc(s)
// composed into CSections and Wedge.  Will be done in next release.

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
	
  public class Wedge
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

    public function Wedge(_r:Number=0, _xC:Number=0, _yC:Number=0, _start:Number=0, _end:Number=0)
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
      // break total arc into an equal number of segments of at most PI/4 rad.
      var numSeg:Number = Math.ceil(Math.abs(__delta*PI4_INV));
	  var arc:Number    = __delta/numSeg;

      // p is the vector from the origin of the wedge to (p0X,p0Y)
      // q is the vector from the origin of the wedge to (p2X,p2Y)
      // the vector p+q bisects the angle between p and q.  The middle interpolation point is
      // 'radius' units along that bisector.
      var pX:Number    = __radius*Math.cos(__startAngle);
      var pY:Number    = __radius*Math.sin(__startAngle);
      __p0X            = __xC + pX;
      __p0Y            = __yC + pY;
      var qX:Number    = 0;
      var qY:Number    = 0;
      var angle:Number = __startAngle;
 
      // wedge begins with a line from starting point to initial p.
      _g.moveTo(__xC,__yC);
      _g.lineTo(__p0X,__p0Y);
      
      if( __delta == 0 )
        return;
      
      // approximate each arc with a quad. Bezier
      for( var i:uint=0; i<numSeg; ++i )
      {
        angle += arc;
        qX     = __radius*Math.cos(angle);
        qY     = __radius*Math.sin(angle);
        __p2X  = __xC + qX;
        __p2Y  = __yC + qY;

        // unit vector in direction of bisector - alternative approach is two more trig. calcs to compute the coordinates.
        // let's have some fun and do it a different way.
        var dX:Number = (pX+qX)*__radInv;
        var dY:Number = (pY+qY)*__radInv;
        var d:Number  = Math.sqrt(dX*dX + dY*dY);
        dX /= d;
        dY /= d;

        // middle interpolation point is a distance of 'radius' units along direction of bisecting unit vector
        __p1X  = __xC + __radius*dX;
        __p1Y  = __yC + __radius*dY;

        // compute control point so that quad. Bezier passes through (__p0X,__p0Y), (__p1X,__p1Y), and (__p2X,__p2Y) at t=0.5
        var cX:Number = 2.0*__p1X - 0.5*(__p0X + __p2X);
        var cY:Number = 2.0*__p1Y - 0.5*(__p0Y + __p2Y);

        // You can compute the control point directly with nothing but sin & cos, but if memory serves it takes four more trig comps. for a total of six per loop iteration.
        _g.curveTo(cX, cY, __p2X, __p2Y);

        // end point is start point for next iteration
        __p0X = __p2X;
        __p0Y = __p2Y;
        pX    = qX;
        pY    = qY;
      }
    
      // draw line from last point on the arc to the origin of the wedge
      _g.lineTo(__xC,__yC);
    }
  }
}