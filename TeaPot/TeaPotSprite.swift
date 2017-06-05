//
//  TeaPotSprite.swift
//  TeaPot
//
//  Created by eric yu on 6/4/17.
//  Copyright © 2017 eric yu. All rights reserved.
//

import Foundation
import GLKit

class TeaPotSprite{
    
    static private var program: GLuint = 0
    
       private static func setup(){
        
      let path = Bundle.main.path(forResource: "VertexShader", ofType: "glsl")
   
       var vertexShaderSource: NSString!
        var fragmentShaderSource: NSString!
        do {
            vertexShaderSource = try NSString(contentsOfFile: path!, encoding:String.Encoding.utf8.rawValue)
            fragmentShaderSource = try NSString(contentsOfFile: path!, encoding:String.Encoding.utf8.rawValue)
            
        }catch{
            fatalError()
        }
   
        
        let vertexShader: GLuint = glCreateShader(GLenum(GL_VERTEX_SHADER))
        
        var vertextShaderSourceUTF8 = vertexShaderSource.utf8String
 
        //& address so this behave like a pointer
        glShaderSource(GLuint(vertexShader), 1, &vertextShaderSourceUTF8, nil)
        glCompileShader(vertexShader)
        var vertexShaderComileStatus: GLint = GL_FALSE //int
        glGetShaderiv(vertexShader, GLenum(GL_COMPILE_STATUS),&vertexShaderComileStatus )
        if vertexShaderComileStatus == GL_FALSE {
            //allocate memory to store log
            var vertexShaderLogLength: GLint = 0
            glGetShaderiv(vertexShader,GLenum(GL_INFO_LOG_LENGTH), &vertexShaderLogLength)
            //give u space for the log
            let vertexShaderLog = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(vertexShaderLogLength))
            glGetShaderInfoLog(vertexShader, vertexShaderLogLength,nil,vertexShaderLog)
            let vertexShaderLogString: NSString? = NSString(utf8String: vertexShaderLog)
            print("vertex shader comile fail error: \(vertexShaderLogString)")
   
        }
    
      
        
        let fragmentShader: GLuint = glCreateShader(GLenum(GL_FRAGMENT_SHADER))
        var fragmentShaderSourceUTF8 = fragmentShaderSource.utf8String
        glShaderSource(GLuint(fragmentShader), 1, &fragmentShaderSourceUTF8, nil)
        glCompileShader(fragmentShader)
        var fragmentShaderComileStatus: GLint = GL_FALSE //int
        glGetShaderiv(fragmentShader, GLenum(GL_COMPILE_STATUS),&fragmentShaderComileStatus )
        if fragmentShaderComileStatus == GL_FALSE {
            var fragmentShaderLogLength: GLint = 0
            glGetShaderiv(fragmentShader,GLenum(GL_INFO_LOG_LENGTH), &fragmentShaderLogLength)
            let fragmentShaderLog = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(fragmentShaderLogLength))
            glGetShaderInfoLog(fragmentShader, fragmentShaderLogLength,nil,fragmentShaderLog)
            let fragmentShaderLogString: NSString? = NSString(utf8String: fragmentShaderLog)
            print("fragment shader comile fail error: \(fragmentShaderLogString)")
            
            // prevent drawining if fail error
        }
    
        //link shader(one program) into a program(a set of program)
        program = glCreateProgram()
        glAttachShader(program, vertexShader)
        glAttachShader(program, fragmentShader)

        glBindAttribLocation(program,0,"position")
        
        glLinkProgram(program)
        
        var programLinkStatus: GLint = GL_FALSE
        glGetProgramiv(program,GLenum(GL_LINK_STATUS),&programLinkStatus)
        if programLinkStatus == GL_FALSE {
            var programLogLength: GLint = 0
            glGetProgramiv(program,GLenum(GL_INFO_LOG_LENGTH), &programLogLength)
            let linklog = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(programLogLength))
            glGetProgramInfoLog(program, programLogLength, nil, linklog)
            let linkLogString: NSString? = NSString(utf8String: linklog)
            print("Program Link failed: error: \(linkLogString)")
        }
      
        glUseProgram(program)
        glEnableVertexAttribArray(0)

       
    }

    var position: Vector = Vector()
    var width: Float = 1.0
    var height: Float = 1.0

    
    func draw(){
        if TeaPotSprite.program == 0{
            TeaPotSprite.setup()
            setMatrices()
        }

        glVertexAttribPointer(0, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, teapotPositions)

        glDrawArrays(GLenum(GL_TRIANGLES), 0, GLsizei(teapotVertices))
        glEnable(GLenum(GL_CULL_FACE))
       
    }
   
    func setMatrices()//before draw tea pot
    {
        var effect = GLKBaseEffect()

        let aspectRatio: GLfloat = (GLfloat) (UIScreen.main.bounds.size.width) / (GLfloat) (UIScreen.main.bounds.size.height)
        
        let fieldView: GLfloat = GLKMathDegreesToRadians(90.0)
        let projectionMatrix: GLKMatrix4 = GLKMatrix4MakePerspective(fieldView, aspectRatio, 0.1, 10.0)
        effect.transform.projectionMatrix = projectionMatrix

        // ModelView Matrix
        var modelViewMatrix: GLKMatrix4 = GLKMatrix4Identity
        modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 0.0, 0.0, -5.0)
        modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, GLKMathDegreesToRadians(45.0)) //45
        effect.transform.modelviewMatrix = modelViewMatrix
        effect.prepareToDraw()
    }
    //MARK: Not used currently
    func setupVBOs() {
        //vbo := vertexBufferObject
        var vbo: GLuint = 0
        glGenBuffers(1, &vbo)
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo);
        glBufferData(GLenum(GL_ARRAY_BUFFER), teapotVertices, teapotPositions, GLenum(GL_STATIC_DRAW))
  
    }




}
