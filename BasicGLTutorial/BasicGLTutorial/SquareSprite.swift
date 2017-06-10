//
//  SquareSprite.swift
//  BasicGLTutorial
//
//  Created by eric yu on 6/9/17.
//  Copyright © 2017 eric yu. All rights reserved.
//
import Foundation
import GLKit

//Blue (-1,1)     Green(1,1)
//Black(-1,-1)     Red(1,-1)

class SquareSprite {
    var memSizeVertices: Int = 0
    var memSizeIndices: Int = 0
    private var vertexBuffer: GLuint = 0
    private var indexBuffer: GLuint = 0
    var rotation: Float = 0
    var timeSinceLastUpdate: TimeInterval = 0
    
    let vertices: [Vertex] = [
        Vertex( 1.0, -1.0, 0, 1.0, 0.0, 0.0, 1.0),
        Vertex( 1.0,  1.0, 0, 0.0, 1.0, 0.0, 1.0),
        Vertex(-1.0,  1.0, 0, 0.0, 0.0, 1.0, 1.0),
        Vertex(-1.0, -1.0, 0, 1.0, 1.0, 0.0, 1.0)
    ]

    let indices: [GLubyte] = [
        0, 1, 2,
        2, 3, 0
    ]
    
    func setupVBO(){//will have to think about where to put this
        
        let memSizeVertices = MemoryLayout.size(ofValue: vertices[0]) * vertices.count
        let memSizeIndices = MemoryLayout.size(ofValue: indices[0]) * indices.count
        
       
        //EAGLContext.setCurrent(self.context)
    
        glGenBuffers(1, &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        glBufferData(GLenum(GL_ARRAY_BUFFER), memSizeVertices, vertices, GLenum(GL_STATIC_DRAW))
        
        
        glGenBuffers(1, &indexBuffer)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), memSizeIndices, indices, GLenum(GL_STATIC_DRAW))
    }
    
    func tearDownGL(){
        //EAGLContext.setCurrent(self.context)
    
        glDeleteBuffers(1, &vertexBuffer)
        glDeleteBuffers(1, &indexBuffer)
    }
    
    func draw(){
        
        //do these only once
       
        
        
      
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
       // there were bounded already if no other buffer are used
        
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.position.rawValue))
        glVertexAttribPointer(GLuint(GLKVertexAttrib.position.rawValue), 3,GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout.size(ofValue: vertices[0])),nil)
        
        //each stride is an vertice array than move get 3 of them
       
        let offset =  BUFFER_OFFSET(MemoryLayout.size(ofValue: vertices[0])/7 * 3)
        
        // divide 7 because 7 element per vertices
        // and we need only the lenght of one element
        // move pointer foward 3 steps x y z r g b a
        // x(0) y(1) z(2) r(3)
        
        
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.color.rawValue))
        glVertexAttribPointer(GLuint(GLKVertexAttrib.color.rawValue), 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout.size(ofValue: vertices[0])), offset)
      
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(16), GLenum(GL_UNSIGNED_BYTE), nil)
        //memSizeIndices
        //each stride is an vertice array than move get 4 of them
        //start from offset

    }
    
    func setDefaultShaders()//before draw tea pot
    {
        let effect = GLKBaseEffect()
        
        //projection
        let aspectRatio: GLfloat = (GLfloat) (UIScreen.main.bounds.size.width) / (GLfloat) (UIScreen.main.bounds.size.height)
        let projectionMatrix: GLKMatrix4 = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspectRatio, 4.0, 10.0)
        effect.transform.projectionMatrix = projectionMatrix
        

        
        var modelViewMatrix: GLKMatrix4 = GLKMatrix4MakeTranslation(0.0, 0.0, -6.0)
        rotation += Float(90 * timeSinceLastUpdate)
        modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(rotation), 0, 0, 1);
        
        effect.transform.modelviewMatrix = modelViewMatrix
        effect.prepareToDraw()
    }
    
    
    func BUFFER_OFFSET(_ i: Int) -> UnsafeRawPointer? {
        return UnsafeRawPointer(bitPattern: i)
        
        //create unsafe with a value
    }
}


