module vertex;
import math=std.math;
import std.stdio;

/**
A range of reals, mainly used for 1d intersection testing.
*/
struct Range
    {
    /// start of range
    real start;
    
    ///stop of range
    real stop;
    
    /**
    checks if two ranges overlap and return the smallest offset that would make
    them not overlap.
    */
    real overlap(Range other)
        {
        real m1=(this.start+this.stop)/2;
        real r1=math.abs(this.start-this.stop)/2;
        
        real m2=(other.start+other.stop)/2;
        real r2=math.abs(other.start-other.stop)/2;
        
        if(math.abs(m1-m2)<(r1+r2))
            {
            real offset=(r1+r2)-math.abs(m1-m2);
            if(m1<m2)
                return -offset;
            return offset;
            }
        return 0;
        }
    
    ///
    unittest
        {
        Range r1=Range(0,32);
        Range r2=Range(16,48);
        
        assert(r1.overlap(r2)==-16);
        assert(r2.overlap(r1)==16);
        }

    /**
    check if offset lies inside this range and returns the smallest offset
    needed to make it lie outside this range.
    */
    real overlap(real offset)
        {
        if (offset<start || offset>stop)
            return 0;
        real offs1=start-offset;
        real offs2=stop-offset;
        if(math.abs(offs1)<math.abs(offs2))
            return offs1;
        else
            return offs2;
        }
    
    ///
    unittest
        {
        Range r1=Range(0,32);
        assert(r1.overlap(8)==-8);
        assert(r1.overlap(24)==8);
        }
    }

/**
A location in 2d space
*/
struct Vertex
    {
    ///
    real x;
    ///
    real y;
    Vector opBinary(string op)(Vertex rhs)
        {
        static if(op=="-")
            {
            Vector v={x-rhs.x,y-rhs.y};
            return v;
            }
        else static assert(0, "Operator "~op~" not implemented");
        }
    
    Vertex opBinary(string op)(Vector rhs)
        {
        mixin("Vertex v={x"~op~"rhs.x,y"~op~"rhs.y};");
        return v;
        }
    
    }

/**
a vector in 2d space
*/
struct Vector
    {
    ///
    real x;
    ///
    real y;
    
    Vector opBinary(string op)(real rhs)
        {
        mixin("Vector v={x"~op~"rhs,y"~op~"rhs};");
        return v;
        }
    Vector opBinary(string op)(Vector rhs)
        {
        mixin("Vector v={x"~op~"rhs.x,y"~op~"rhs.y};");
        return v;
        }
    
    unittest
        {
        Vector a=Vector(1,2);
        Vector b=Vector(3,4);
        Vector c=a+b;
        assert(c.x==4);
        assert(c.y==6);
        }
    
    /**
    return the scalar projection of this vector onto other vector
    */
    real project_scalar(Vector other)
        {
        return this.dot(other.unit);
        }
    
    ///
    unittest
        {
        Vector v1=Vector(1,0);
        Vector v2=Vector(0,1);
        
        assert(v2.project_scalar(v1)==0);
        assert(v1.project_scalar(v2)==0);
        assert(v1.project_scalar(v1)==1);
        assert(v2.project_scalar(v2)==1);
        }
    
    /**
    return the vector projection of this vector onto other vector
    */
    Vector project(Vector other)
        {
        return other.unit*this.project_scalar(other);
        }
            
    ///
    unittest
        {
        Vector v1=Vector(1,0);
        Vector v2=Vector(0,1);
        
        assert(v2.project(v1)==Vector(0,0));
        assert(v1.project(v2)==Vector(0,0));
        assert(v1.project(v1)==v1);
        assert(v2.project(v2)==v2);
        }
    
    /**
    return the dot product of this vector and other vector
    */
    real dot(Vector other)
        {
        return this.x*other.x+this.y*other.y;
        }

    @property
        {
        ///true if this vector has a length of exactly zero
        bool zero()
            {
            return (this.x==0&&this.y==0);
            }
        }
        
    ///
    unittest
        {
        Vector v1=Vector(0,0);
        Vector v2=Vector(7,2);
        
        assert(v1.zero==true);
        assert(v2.zero==false);
        }
    
    ///vector magnitude
    real length()
        {
        return math.sqrt(this.dot(this));
        }
    
    ///
    unittest
        {
        Vector v1=Vector(0,0);
        Vector v2=Vector(5,0);
        
        assert(v1.length==0);
        assert(v2.length==5);
        }
        
    ///unit vector of this vector
    Vector unit()
        {
        real ln=this.length;
        Vector v={this.x/ln,this.y/ln};
        return v;
        }
    
    ///
    unittest
        {
        Vector v1=Vector(5,0);
        assert(v1.unit==Vector(1,0));
        }
    
    ///this vector rotated 90 degrees
    Vector rot90()
        {
        return Vector(-this.y,this.x);
        }
    
    ///
    unittest
        {
        Vector v1=Vector(5,0);
        assert(v1.rot90==Vector(0,5));
        assert(v1.rot90.rot90==Vector(-5,0));
        assert(v1.rot90.rot90.rot90==Vector(0,-5));
        assert(v1.rot90.rot90.rot90.rot90==v1);
        }
    }
