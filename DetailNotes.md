

# pipeline:  data points(array of float) -> draw

vertex/vertices = points

vertex shader   = The things that take a point to another point in space (3D)

primitive assembly = take all the points and draw simple shapes. bunch of triangles

geometry shader  = take more points and draw more triangles...//usually just use default

rasterization stage  = draw stuff on screen/printer..ect

Clipping = ignore shape that is out side of the screen

fragment shader = like what is say tiny pixels, give all the information it need to color it (shade,shadow ect)

alpha test and blending stage. = see how color/opacity change when shape are mix together

Normalized Device Coordinates (NDC)display coordinate 
basically it takes in x [-1,1] , y [-1,1]
physically y axis will be longer if device is vertically displayed

# shader (geometric/pixel)-  pixel is the result from geometric data..obviously
samll programs that run on all gpu units (single instruction multiple data)
all process are running the same program at the same time, but use different data (that is why is fast)

example: if gemoetric shade draw a big triangle, than depends on how many pixels is inside the triangle
that is how many times the fragment shader is going to run.

two type of variables inside shader
* uniform Variables
* attribute Arrays


# vertex buffer objects (VBO) 

sent points(vertex) to gpu to make things faster

# Barycentric coordinates (basically is a trinagle coordinate system)
definition:
L1 + L2 + L3 = 1
0=< Lx =< 1 // all lamda are in range of [0,1], positive values less than 1

long story short basically
given 3 points we are going to have an matrix to solve

P(x,y) given A(a,b) B(c,d) C(e,f) 
solve for t1,t2,t3

t1a + t2c + t3e = x
t1b + t2d + t3f = y
t1 + t2 + t3 = 1

more detail can be read: http://2000clicks.com/MathHelp/GeometryTriangleBarycentricCoordinates.aspx
fun problem can be solve using baycentric coordinates http://2000clicks.com/MathHelp/PuzzleTPS200709BucketsAndSpringsAnswer.aspx


# GL_TRIANGLES(_STRIP,_FAN), GL_LINES (_STRIP, _LOOP)

_STRIP, reuse previous 3 points, basically they are triangle that are next to eachother
points - 2 = # triangles
_FAN

# vertex shader /point shader

takes point and modfy it (move them before you draw)

we use langauge glsl (similiar to c to write shaders)

ex.

attribute vec2 position;
uniform vec2 tranlate;
void main()
{
    gl_Position = vec4(position.x + tranlate.x, position.y + tranlate.y, 0.0,1.0);
}


position is your input, the points you put in
v4 position w is a scaling as w -> 0 (x,y) -> infinity

and you get to pass in a uniform vector to do stuff the poistion vectors

# Rasterization

raster - a rectangular pattern of parallel scanning lines followed by the electron beam on a 
television screen or computer monitor.

vector vs raster
vector have clear define outside edges
raster represent in small tiny boxes

and on every pixel cover, fragment shader is called to color in stuff



