module vertex;
import math=std.math;

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

    /**
    check if offset lies inside this range and returns the smallest offset
    needed to make it lie outside this range.
    */
    real overlap(real offset)
        {
        if (offset<start || offset>stop)
            return 0;
        return math.fmin(offset-start,stop-offset);
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

    /**
    return the scalar projection of this vector onto other vector
    */
    real project_scalar(Vector other)
        {
        return this.dot(other.unit);
        }
    
    /**
    return the vector projection of this vector onto other vector
    */
    Vector project(Vector other)
        {
        return other.unit*this.project_scalar(other);
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

        ///vector magnitude
        real length()
            {
            return math.sqrt(this.dot(this));
            }
            
        ///unit vector of this vector
        Vector unit()
            {
            real ln=this.length;
            Vector v={this.x/ln,this.y/ln};
            return v;
            }
        
        ///this vector rotated 90 degrees
        Vector rot90()
            {
            return Vector(-this.y,this.x);
            }
        }
    }
