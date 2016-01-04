import vertex;

///
class Polygon
    {
    Vertex[] vertices;
    /**
    return the scalar projection of this polygon onto vec
    
    this function returns a Range of the bounds of this polygons projection
    */
    Range project_scalar(Vector vec)
        {
        Range range;
        bool first=true;
        foreach(Vertex v; vertices)
            {
            real projected=(cast(Vector)v).project_scalar(vec);
            if(first)
                {
                range.start=projected;
                range.stop=projected;
                first=false;
                }
            
            if(projected<range.start)
                range.start=projected;
            if(projected>range.stop)
                range.stop=projected;
            }
        return range;
        }
    
    ///
    unittest
        {
        Polygon p1=new Polygon();
        p1.vertices=[Vertex(0,0),Vertex(32,0),Vertex(32,32),Vertex(0,32)]; //a 32x32 square
        Vector v1=Vector(1,0);
        
        assert(p1.project_scalar(v1)==Range(0,32));
        }
    
    /**
    returns a new polygon offset by offset
    */
    Polygon offset(Vector offset)
        {
        auto npoly=new Polygon();
        foreach(Vertex vertex; this.vertices)
            {
            npoly.vertices~=vertex+offset;
            }
        return npoly;
        }
    
    /**
    checks if this and other polygon overlap. returns the smallest vector to
    make them not overlap or a zero vector if they don't overlap.
    */
    Vector overlap(Polygon other)
        {
        Vector[] directions=this.vectors~other.vectors;
        real min_offset=real.infinity;
        Vector min_direction;
        foreach(Vector direction; directions)
            {
            direction=direction.rot90;
            Range proj_self=this.project_scalar(direction);
            Range proj_other=other.project_scalar(direction);
            real offset=proj_self.overlap(proj_other);
            if(offset==0)
                return Vector(0,0);
            
            if(math.abs(offset)<min_offset)
                {
                min_offset=math.abs(offset);
                min_direction=direction.unit*offset;
                }
            }
        return min_direction.rot90.rot90;
        }
    
    /**
    checks if pos lies within this polygon and returns the smallest offset to
    make it lie outside this polygon.
    */
    Vector overlap(Vertex pos)
        {
        Vector vecpos=cast(Vector)pos;
        real min_offset=real.infinity;
        Vector min_direction;
        foreach(Vector direction; this.vectors)
            {
            direction=direction.rot90;
            real proj_vecpos=vecpos.project_scalar(direction);
            Range proj_self=this.project_scalar(direction);
            real offset=proj_self.overlap(proj_vecpos);
            if(offset==0)
                return Vector(0,0);
            if(math.abs(offset)<min_offset)
                {
                min_offset=math.abs(offset);
                min_direction=direction.unit*offset;
                }
            }
        return min_direction.rot90.rot90;
        }
        
    @property
        {
        /**
        an array of vectors between vertices in this polygon.
        */
        Vector[] vectors()
            {
            Vector[] v;
            for(size_t i=0;i<this.vertices.length;i++)
                {
                v~=this.vertices[(i+1)%this.vertices.length]-this.vertices[i];
                }
            return v;
            }
        
        /**
        the center of gravity for this polygon
        */
        Vertex COG()
            {
            Vector cog=Vector(0,0);
            for(size_t i=0;i<this.vertices.length;i++)
                {
                cog=(cast(Vector)this.vertices[i])+cog;
                }
            cog=cog/this.vertices.length;
            return cast(Vertex)cog;
            }
        }
    
    unittest
        {
        Polygon p1=new Polygon();
        p1.vertices=[Vertex(-32,-32),Vertex(32,-32),Vertex(32,32),Vertex(-32,32)];
        assert(p1.COG==Vertex(0,0));
        p1=p1.offset(Vector(16,8));
        assert(p1.COG==Vertex(16,8));
        }
    }
