

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


# Weird bugs and Patterns 


    glEnableVertexAttribArray(0) 
MUST BE in side either
 
    func update(){
            //enable vertex attri
        
    }
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
            //enable vertex attri
    }
    
if is not there it will not draw...maybe I can figure out why later     
 
# coordinates

1. local space (you imported model point values)

2. world space

3. view space (where  you look at the world)

# linear algebea basic 4D matrix that does stuff to your point (order of opertation matters)
(M1 * M2.... * a)  where a is the point will be at the end of the operation

identiy use this to setup matrix

        [1 0 0 0 ]
        [0 1 0 0 ]
        [0 0 1 0 ]
        [0 0 0 1 ]
        
//trasnslation Matrix moves your point

        [1 0 0 X ]
        [0 1 0 Y ]
        [0 0 1 Z ]
        [0 0 0 1 ]
        
//notice if point (1,0,0,1)   1 is W...so basically this is where w comes in W serve as a place holder
//to be used to do this... 1(1) + 0y + 0z + Xw  so if w = 1  X = 2
// 1 + 2 ..move x  by 2
        
//scale  make it bigger or smaller

 //to scale 
 //GLKMatrix4Scale(modelViewMatrix, 2, 2, 2) this function allow you to pass in a b c
 
        [1*a 0   0  0  ]
        [0  1*b  0  0  ] 
        [0   0  1*c 0  ]
        [0   0   0  1 ]
        
        
//rotate with respect to x, y , z axis

//it will not help you at all to derive these matrix, is just simple busy work
//there are the baisc tri facts that will help with the algebra
// sin(theta) = opposite/hypotenuse
// in 2D coordinate space point P = (cos Thea, sin Theta)

        //rotate x  a is radian
        //[1   0       0       0]
        //[0 cos(-a) -sin(-a)  0]
        //[0 sin(-a)  cos(-a)  0]
        //[0   0       0       1]
        
        //rotate y
        //[cos(-a)   0   -sin(-a)    0]
        //[0         1       0       0]
        //[sin(-a)   0   cos(-a)     0]
        //[0         0       0       1]
        
        //rotate z
        //[cos(-a)   -sin(-a)   0    0]
        //[sin(-a)   cos(-a)    0    0]
        //[0         0          0    0]
        //[0         0          0    1]
        

#  Barycentric Coordinates
P=uA+vB+wC
u+v+w=1  (normalized := it is equal to 1)

if we know u , v we can find w
w = 1 - u + v
which implies  u+v≤ 1

" any 2 baycentric coordinates is less than or equal to 1 "


<p align="center">
  <img src="https://github.com/ericyu423/openGLES2/blob/master/Group.png" width="200"/> 
</p>

 
 u =  u area / large triangle
 v =  v area / large trinagle
 w  = w area / large triangle
 
 so basically they are ratios
