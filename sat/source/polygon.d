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
    Vector inside(Vertex pos)
        {
        Vector vecpos=cast(Vector)pos;
        real min_offset=real.infinity;
        Vector min_direction;
        foreach(Vector direction; this.vectors)
            {
            direction=direction.rot90;
            real proj_vecpos=vecpos.project_scalar(direction);
            Range proj_self=this.project_scalar(direction);
            real offset=proj_self.inside(proj_vecpos);
            if(offset==0)
                return Vector(0,0);
            if(math.abs(offset)<min_offset)
                {
                min_offset=offset;
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
