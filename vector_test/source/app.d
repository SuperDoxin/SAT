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

int main()
    {
    
    writeln("loading SDL2...");
	DerelictSDL2.load();
	SDL_Init(SDL_INIT_VIDEO);
    writeln("creating window");
    window=SDL_CreateWindow("SAT Test",SDL_WINDOWPOS_UNDEFINED,SDL_WINDOWPOS_UNDEFINED,640,480,0);
    renderer=SDL_CreateRenderer(window,-1,0);
    
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
        
        Vertex vert1={640/2,480/2};
        Vertex vert2={mouse_x,mouse_y};
        Vector mousevec=vert2-vert1;
        render_line(vert1,vert2,255,0,0);
        
        Vector vec2={0,0};
        
        Vector vec1={1,0};
        vec1=vec1*to!real(64);
        vec1=mousevec.project(vec1);
        vert2=vert1+vec1;
        render_line(vert1,vert2,0,0,255);
        
        vec1.x=0;
        vec1.y=1;
        vec1=vec1*to!real(64);
        vec1=mousevec.project(vec1);
        vert2=vert1+vec1;
        render_line(vert1,vert2,0,255,0);
        
        renderer.SDL_RenderPresent();
        SDL_Delay(16);
        }
    
    //SDL_Quit();
    //return 0;
    }
