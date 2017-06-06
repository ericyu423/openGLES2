
attribute vec4 a_Position;
//layout (location = 0) in vec4 a_Position;
//attribute - storage qualifier
//a_Position data will be transfer by openGL

void main()
{
    gl_Position = a_Position;
    //gl_Position = vec4 (a_Position.x,a_Position.y,0,1);
}
