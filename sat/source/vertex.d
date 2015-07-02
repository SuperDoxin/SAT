import math=std.math;

struct Range
    {
    real start;
    real stop;
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
    real overlap(real offset)
        {
        if (offset<start || offset>stop)
            return 0;
        return math.fmin(offset-start,stop-offset);
        }
    }

struct Vertex
    {
    real x;
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

struct Vector
    {
    real x;
    real y;
    
    Vector opBinary(string op)(real rhs)
        {
        mixin("Vector v={x"~op~"rhs,y"~op~"rhs};");
        return v;
        }

    real project_scalar(Vector other)
        {
        return this.dot(other.unit);
        }
    
    Vector project(Vector other)
        {
        return other.unit*this.project_scalar(other);
        }
    
    real dot(Vector other)
        {
        return this.x*other.x+this.y*other.y;
        }

    @property
        {
        bool zero()
            {
            return (this.x==0&&this.y==0);
            }
        real length()
            {
            return math.sqrt(this.dot(this));
            }
        Vector unit()
            {
            real ln=this.length;
            Vector v={this.x/ln,this.y/ln};
            return v;
            }
        Vector rot90()
            {
            return Vector(-this.y,this.x);
            }
        }
    }
