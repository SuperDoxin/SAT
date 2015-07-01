import std.stdio;
import derelict.sdl2.sdl;
import std.conv:to;

import sat;

SDL_Window* window;
SDL_Renderer* renderer;

void render_line(Vertex vert1,Vertex vert2,ubyte r,ubyte g,ubyte b)
    {
    renderer.SDL_SetRenderDrawColor(r,g,b,255);
    renderer.SDL_RenderDrawLine(to!int(vert1.x),to!int(vert1.y),to!int(vert2.x),to!int(vert2.y));
    }

void render_polygon(Polygon poly,ubyte r,ubyte g,ubyte b)
    {
    for(size_t i=0;i<poly.vertices.length;i++)
        {
        Vertex v1=poly.vertices[i];
        Vertex v2=poly.vertices[(i+1)%poly.vertices.length];
        render_line(v1,v2,r,g,b);
        }
    }

int main()
    {
    
    writeln("loading SDL2...");
	DerelictSDL2.load();
	SDL_Init(SDL_INIT_VIDEO);
    writeln("creating window");
    window=SDL_CreateWindow("SAT Test",SDL_WINDOWPOS_UNDEFINED,SDL_WINDOWPOS_UNDEFINED,640,480,0);
    renderer=SDL_CreateRenderer(window,-1,0);
    
    auto poly1=new Polygon();
    auto poly2=new Polygon();
    
    poly1.vertices~=Vertex(640/2-128,480/2-128);
    poly1.vertices~=Vertex(640/2+128,480/2-128);
    poly1.vertices~=Vertex(640/2-128,480/2+128);
    
    poly2.vertices~=Vertex(640/3-128,480/2-128);
    poly2.vertices~=Vertex(640/3+128,480/2-128);
    poly2.vertices~=Vertex(640/3+128,480/2+128);
    poly2.vertices~=Vertex(640/3-128,480/2+128);
    
    while(true)
        {
        SDL_Event event;
        while(SDL_PollEvent(&event))
            {
            if(event.type==SDL_QUIT)
                {
                SDL_Quit();
                return 0;
                }
            }
        
        
        renderer.SDL_SetRenderDrawColor(0,0,0,255);
        renderer.SDL_RenderClear();
        
        int mouse_x;
        int mouse_y;
        SDL_GetMouseState(&mouse_x,&mouse_y);
        
        Vector projection=poly1.overlap(Vertex(mouse_x,mouse_y));
        
        if(projection.zero)
            render_polygon(poly1,255,0,0);
        else
            {
            render_polygon(poly1,255,255,255);
            
            render_line(Vertex(mouse_x,mouse_y),Vertex(mouse_x,mouse_y)+projection,255,255,0);
            }
        
        renderer.SDL_RenderPresent();
        SDL_Delay(16);
        }
    
    //SDL_Quit();
    //return 0;
    }
