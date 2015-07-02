import vertex;

class Polygon
    {
    Vertex[] vertices;
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
    Polygon offset(Vector offset)
        {
        auto npoly=new Polygon();
        foreach(Vertex vertex; this.vertices)
            {
            npoly.vertices~=vertex+offset;
            }
        return npoly;
        }
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
        Vector[] vectors()
            {
            Vector[] v;
            for(size_t i=0;i<this.vertices.length;i++)
                {
                v~=this.vertices[(i+1)%this.vertices.length]-this.vertices[i];
                }
            return v;
            }
        }
    }
