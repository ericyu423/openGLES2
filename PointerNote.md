# VBO Detail Example


                 let vertices: [Vertex] = [
                    Vertex( 1.0, -1.0, 0, 1.0, 0.0, 0.0, 1.0),
                    Vertex( 1.0,  1.0, 0, 0.0, 1.0, 0.0, 1.0),
                    Vertex(-1.0,  1.0, 0, 0.0, 0.0, 1.0, 1.0),
                    Vertex(-1.0, -1.0, 0, 1.0, 1.0, 0.0, 1.0)
                 ]  //Float

                let indices: [GLubyte] = [
                      0, 1, 2,
                      2, 3, 0
                ]



               memSizeVertices = MemoryLayout.size(ofValue: vertices[0]) * vertices.count
               
                 // vertices.count = 4
                 // MemoryLayout.size(ofValue: vertices[0]) = 28
                 // each element in vertices in an 7-tuple (4 bit Float each) 7*4 = 28
                 //mmSzieVertices = 4 * 28 = 112
      
               memSizeIndices = MemoryLayout.size(ofValue: indices[0]) * indices.count
               
                //indices.count = 6
                //po MemoryLayout<GLubyte>.size = MemoryLayout.size(ofValue: indices[0]) = 1
                //memSizeIndices = 1 * 6 = 6


              //EAGLContext.setCurrent(self.context)

              glGenBuffers(1, &vertexBuffer)
              glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
              glBufferData(GLenum(GL_ARRAY_BUFFER), memSizeVertices, vertices, GLenum(GL_STATIC_DRAW))
              
              //make a buffer with size of 112 bits


              glGenBuffers(1, &indexBuffer)
              glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
              glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), memSizeIndices, indices, GLenum(GL_STATIC_DRAW))
              
              //make a buffer with size of 6 bits
              
              
              
# Using VBO Detail Example

                  //prepare for use
                  glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
                  glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
                

                  //GLKVertexAttrib.position.rawValue = 0 
                  glEnableVertexAttribArray(GLuint(GLKVertexAttrib.position.rawValue))
                  glVertexAttribPointer(GLuint(GLKVertexAttrib.position.rawValue), 3,GLenum(GL_FLOAT), GLboolean(GL_FALSE), 
                  GLsizei(MemoryLayout.size(ofValue: vertices[0])),nil)
                  
#Stride: For position:  GLsizei(MemoryLayout.size(ofValue: vertices[0]))

   GLsizei(MemoryLayout.size(ofValue: vertices[0])) = 28
   
   read it 28 bits at a time, in other words read one vertices than go to another vertices ( 7-tuple 4 bit each)


#Stride -------------------------------------------------

                  //each stride is an vertice array than move get 3 of them

                  let offset =  BUFFER_OFFSET(memSizeVertices)

                  //GLKVertexAttrib.color.rawValue = 2
                  glEnableVertexAttribArray(GLuint(GLKVertexAttrib.color.rawValue))
                  glVertexAttribPointer(GLuint(GLKVertexAttrib.color.rawValue), 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE),  
#Stride: For Color:  GLsizei(MemoryLayout.size(ofValue: vertices[0]))
   (x,y,z, r,g,b,a)

   GLsizei(MemoryLayout.size(ofValue: vertices[0])) = 28
   
   read it 28 bits at a time, in other words read one vertices than go to another vertices ( 7-tuple 4 bit each)


#Stride -------------------------------------------------

                       GLsizei(MemoryLayout.size(ofValue: vertices[0])),BUFFER_OFFSET(12))
                       
#BUFFER_OFFSET: For Color:  GLsizei(MemoryLayout.size(ofValue: vertices[0]))

                  glDrawElements(GLenum(GL_TRIANGLES), GLsizei(memSizeIndices/MemoryLayout.size(ofValue: indices[0])), 
                  GLenum(GL_UNSIGNED_BYTE), nil)
                  
# GLsizei: GLsizei(memSizeIndices/MemoryLayout.size(ofValue: indices[0]))
    memSizeIndices = 6   // indices.count = 6, each count is 1 bit
    
    MemoryLayout.size(ofValue: indices[0]) = 1

    memSizeIndices/MemoryLayout.size(ofValue: indices[0]) = 6

                   func BUFFER_OFFSET(_ i: Int) -> UnsafeRawPointer? {
                       return UnsafeRawPointer(bitPattern: i)
                        //create unsafe with a value
                   }
                  



