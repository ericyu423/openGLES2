
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
              
              
              
