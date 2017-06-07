
attribute vec4 a_Position;
//layout (location = 0) in vec4 a_Position;
//attribute - storage qualifier
//a_Position data will be transfer by openGL

uniform highp mat4 model;
uniform highp mat4 projection;


//order of operation is very important wrong order will
//not draw anything

void main()
{
    gl_Position = projection * model * a_Position;
    //gl_Position = a_Position;

}
