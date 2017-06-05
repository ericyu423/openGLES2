
attribute vec4 a_Position;

void main()
{
    gl_Position = a_Position;
    //gl_Position = vec4 (a_Position.x,a_Position.y,0,1);
}
