import math=std.math;

struct Range
    {
    real start;
    real stop;
    bool inside(real offset)
        {
        return (offset>=start && offset<=stop);
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
        }
    }
