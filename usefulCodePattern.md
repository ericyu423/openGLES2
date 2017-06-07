# Basic VertexBuffer setup

    func setupVertexBuffer() {
          glGenBuffers(GLsizei(1), &vertexBuffer)
          glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
          glBufferData(GLenum(GL_ARRAY_BUFFER), 24, quad, GLenum(GL_STATIC_DRAW)) 
          glVertexAttribPointer(0,3,GLenum(GL_FLOAT),GLboolean(GL_FALSE),4, nil)  
          glUseProgram(program)
     }
     
     
//same as above but is more "readable"...
//MemoryLayout<Float>.size this till you what is the size of each number that is represented
// we have Float so is 4 bits, if is GL_Float it will be 8 bits

      func setupVertexBuffer() {
            glGenBuffers(GLsizei(1), &vertexBuffer)
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
            glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<Float>.size * quad.count, quad, GLenum(GL_STATIC_DRAW)) 
            glVertexAttribPointer(0,3,GLenum(GL_FLOAT),GLboolean(GL_FALSE),GLsizei(MemoryLayout<Float>.size), nil)  
            glUseProgram(program)
       }
       
# To Draw

       glEnableVertexAttribArray(0)// can be insdie update or override func glkView
  
       //setup your drawings
       //glUniform2f(glGetUniformLocation(program, "translate"), translateX, translateY)
       //glUniform4f(glGetUniformLocation(program, "color"), 1,1,0,1)
       
       glDrawArrays(GLenum(GL_TRIANGLES), 0, 3)
       
# 3 is number of points in your model, DO NOT CONFUSED IT WITH array.count

for (x,y,z) every 3 is a point (x,y) every 2 is a point 
       
       
       //optional
       //glDisableVertexAttribArray 


#stride

the folowing are the same


            glVertexAttribPointer(
            0,
            2,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Float>.size), 
            nil)
            
 
            
            glVertexAttribPointer(
            0,
            2,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            0,
            nil)




