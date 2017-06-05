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
    
    /***************************************************/
    // create and compile vetex shaders
    /***************************************************/
    private static func setup(){
        
        /***************************************************/
        // get it to read .glsl files, you can do it here too
        //with NSString than you won't have to call it
        /***************************************************/
      let path1 = Bundle.main.path(forResource: "VertexShader", ofType: "glsl")
      let path2 = Bundle.main.path(forResource: "FragmentShader", ofType: "glsl")
   
       var vertexShaderSource: NSString!
       var fragmentShaderSource: NSString!
        do {
            vertexShaderSource = try NSString(contentsOfFile: path1!, encoding:String.Encoding.utf8.rawValue)
            fragmentShaderSource = try NSString(contentsOfFile: path2!, encoding:String.Encoding.utf8.rawValue)
        }catch{
            fatalError()
        }
   
        
        /***************************************************/
        // create a vetex shaders GLuint is typealias for (UInt32)
        // let vertexShader: UInt32  this will work too
        // GLenum = GLuint = UInt32...all those alias is making 
        // it more complex than it should be
        /***************************************************/
        let vertexShader: GLuint = glCreateShader(GLenum(GL_VERTEX_SHADER))
        
        //UnsafePointer<Int8>?
        /*This C string is a pointer to a structure inside the string object, which may have a lifetime shorter than the string object and will certainly not have a longer lifetime. Therefore, you should copy the C string if it needs to be stored outside of the memory context in which you use this property.*/
        
        var vertextShaderSourceUTF8: UnsafePointer? = vertexShaderSource.utf8String
        //.utf8String this baiscally return an unsafe <UInt8> pointer
        //basically we have a pointer to our shader
        
        
        
        //UnsafePointer<UnsafePointer<GLChar>?>!
        //swift doens't have point so we have to use a speical class
        //"&" is the address of vertextShaderSourceUTF8 
        
        //in C is Char** pointer to a pointer
        //might be a points to and array of pointers
        
        
        glShaderSource(GLuint(vertexShader), 1, &vertextShaderSourceUTF8, nil)
      
        // GLsizei = Int32..i really hate these aliases
      
        
        /***************************************************/
        //(shader, count: GLsizei, String: UnsafePointer,
        //length)  swift infers the length of pointer so we put nil at the end
        /***************************************************/
        
        glCompileShader(vertexShader)
        //this is it, pretty simple 
        
        /***************************************************/
        //  Error check
        /***************************************************/
        
        var vertexShaderComileStatus: GLint = GL_FALSE //Int32
        // this allocate memory because Shaderiv wants it
        // thhis variable pretty much fetch the compile status
        
        
        /***************************************************/
        //    get vector of intergers associated with vertextShader
        /***************************************************/
        glGetShaderiv(vertexShader, GLenum(GL_COMPILE_STATUS),&vertexShaderComileStatus )
        
        if vertexShaderComileStatus == GL_FALSE {
            
            
            //get the length
            var vertexShaderLogLength: GLint = 0
            glGetShaderiv(vertexShader,GLenum(GL_INFO_LOG_LENGTH), &vertexShaderLogLength)
            
            
            //allocate memory - swift deallocate it for u, when you out of the scope
            let vertexShaderLog = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(vertexShaderLogLength)) // this allocate bits
            glGetShaderInfoLog(vertexShader, vertexShaderLogLength,nil,vertexShaderLog)
            
            let vertexShaderLogString = String(utf8String: vertexShaderLog)
            
           // let vertexShaderLogString: NSString? = NSString(utf8String: vertexShaderLog)
            print("vertex shader compile fail error: \(vertexShaderLogString ?? "")")
   
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
            print("fragment shader compile fail error: \(fragmentShaderLogString ?? "")")
            
            // prevent drawining if fail error
        }
    
        //link shader(one program) into a program(a set of program)
        program = glCreateProgram()
        glAttachShader(program, vertexShader)
        glAttachShader(program, fragmentShader)
        glLinkProgram(program)
                                
        glBindAttribLocation(program,0,"a_Position")
        
        
        
        var programLinkStatus: GLint = GL_FALSE
        glGetProgramiv(program,GLenum(GL_LINK_STATUS),&programLinkStatus)
        if programLinkStatus == GL_FALSE {
            var programLogLength: GLint = 0
            glGetProgramiv(program,GLenum(GL_INFO_LOG_LENGTH), &programLogLength)
            let linklog = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(programLogLength))
            glGetProgramInfoLog(program, programLogLength, nil, linklog)
            let linkLogString: NSString? = NSString(utf8String: linklog)
            print("Program Link failed: error: \(linkLogString ?? "")")
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
