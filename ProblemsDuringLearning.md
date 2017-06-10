# MEMORY AND POINTER SWIFT

#  The 2nd glGenBuffer overwrote the first one
        glGenBuffers(GLsizei(1), &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        glBufferData(GLenum(GL_ARRAY_BUFFER),Sprite.totalVertexBits, Sprite.quad, GLenum(GL_STATIC_DRAW))
        
        
        
        glGenBuffers(GLsizei(1), &textureBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), textureBuffer)
        glBufferData(GLenum(GL_ARRAY_BUFFER),Sprite.totalTextureBits, Sprite.quadTextureCoordinate, GLenum(GL_STATIC_DRAW))
        
# To make this work we need vboBuffer pointer object and and the pointer once we add in more stuff

step1) glGenBuf make a buffer
step2) Bind to context
step3) create a buffer big enough for sprite.totalVertexBits
step4) create vboBuffer pointer (I think this point to the first element of GL_ARRAY_BUFFER)
step5) use memcpy and write sprite.squad point information to where vboBuffer is pointing to, and also tell
       the copy function how many bits the information is
step6) vboBuffer?.advanced (swift) in ObjecC code +=.  it move the pointer the size of the information you just copy in
step7) you copy in new info texturecoordinate and tell it the size
  
        glGenBuffers(GLsizei(1), &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        glBufferData(GLenum(GL_ARRAY_BUFFER),Sprite.totalVertexBits, nil, GLenum(GL_STATIC_DRAW))
        
        var vboBuffer = glMapBufferOES(GLenum(GL_ARRAY_BUFFER), GLenum(GL_WRITE_ONLY_OES))
        memcpy(vboBuffer,Sprite.quad,Sprite.totalVertexBits)
        vboBuffer = vboBuffer?.advanced(by: Sprite.totalVertexBits!)
        memcpy(vboBuffer,Sprite.quadTextureCoordinate,Sprite.totalTextureBits)


now the buffer is read to use

to get it to position use glEnableVertexAttribArray(0) 0 was define in glbindAttribute
to get it to texture use glEnableVertexAttribArray(1), where 1 was also define in glbind
glVertexAttribPointer(1) point to the first element of arraybuffer, meaing last field you can give it a nil or 0 in objectiveC

glVertexAttribPointer(2) this will give it to texture, move the pointer 32 bit to the right because this is where the texture
information is.

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


# This work only because the first GenBuffer wrote to GL_ARRAY_BUFFER
# The 2nd one write to GL_ELEMENT_ARRAY_BUFFER

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
                  
# Stride: For position:  GLsizei(MemoryLayout.size(ofValue: vertices[0]))

   GLsizei(MemoryLayout.size(ofValue: vertices[0])) = 28
   
   read it 28 bits at a time, in other words read one vertices than go to another vertices ( 7-tuple 4 bit each)


# Stride -------------------------------------------------

                  //each stride is an vertice array than move get 3 of them

                  let offset =  BUFFER_OFFSET(memSizeVertices)

                  //GLKVertexAttrib.color.rawValue = 2
                  glEnableVertexAttribArray(GLuint(GLKVertexAttrib.color.rawValue))
                  glVertexAttribPointer(GLuint(GLKVertexAttrib.color.rawValue), 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE),  
# Stride: For Color:  GLsizei(MemoryLayout.size(ofValue: vertices[0]))
   (x,y,z, r,g,b,a)

   GLsizei(MemoryLayout.size(ofValue: vertices[0])) = 28
   
   read it 28 bits at a time, in other words read one vertices than go to another vertices ( 7-tuple 4 bit each)


# Stride -------------------------------------------------

                       GLsizei(MemoryLayout.size(ofValue: vertices[0])),BUFFER_OFFSET(12))
                       
# BUFFER_OFFSET: For Color:  GLsizei(MemoryLayout.size(ofValue: vertices[0]))

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
                  



#  Color draw on top of eachother

 forgot to glClear(GL_COLOR_BUFFER_BIT); bofore drawing something new. 
 
 

