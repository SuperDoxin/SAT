import vertex;

class Polygon
    {
    Vertex[] vertices;
    Range project(Vector vec)
        {
        Range range;
        bool first=true;
        foreach(Vertex v; vertices)
            {
            Vector projected=(cast(Vector)v).project(vec);
            if(first)
                {
                range.start=projected.length;
                range.stop=projected.length;
                first=false;
                }
            
            if(projected.length<range.start)
                range.start=projected.length;
            if(projected.length>range.stop)
                range.stop=projected.length;
            }
        return range;
        }
    bool inside(Vertex pos)
        {
        Vector vecpos=cast(Vector)pos;
        foreach(Vector direction; this.vectors)
            {
            real proj_vecpos=vecpos.project_scalar(direction);
            Range proj_self=this.project(direction);
            if(!proj_self.inside(proj_vecpos))
                return false;
            }
        return true;
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
