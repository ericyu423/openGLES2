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
    /*
   let teapotVertices: Int =  36
    

    
    let teapotPositions:[Float] =
        
        [
            1, -1, -1,
            1, -1, 1,
            -1, -1, 1,
            1, -1, -1,
            -1, -1, 1,
            -1, -1, -1,
            1, 1, -0.999999,
            -1, 1, -1,
            -1, 1, 1,
            1, 1, -0.999999,
            -1, 1, 1,
            0.999999, 1, 1,
            1, -1, -1,
            1, 1, -0.999999,
            0.999999, 1, 1,
            1, -1, -1,
            0.999999, 1, 1,
            1, -1, 1,
            1, -1, 1,
            0.999999, 1, 1, 
            -1, 1, 1, 
            1, -1, 1, 
            -1, 1, 1, 
            -1, -1, 1, 
            -1, -1, 1, 
            -1, 1, 1, 
            -1, 1, -1, 
            -1, -1, 1, 
            -1, 1, -1, 
            -1, -1, -1, 
            1, 1, -0.999999, 
            1, -1, -1, 
            -1, -1, -1, 
            1, 1, -0.999999, 
            -1, -1, -1, 
            -1, 1, -1]*/
    
    var vbo: GLuint = 0
    
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
        /***************************************************/
        // index have to match glEnableVertexAttribArra(0)
        // default there are only 16 attribute arrays
        // only 0 works in this case I have no idea why
        //MARK: WHY ONLY 0 WORKS?
        /***************************************************/
       
        glBindAttribLocation(program,0,"a_Position")
        glLinkProgram(program)
        
        
        
        
        
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
        
    

     
    }
    
  

    var position: Vector = Vector()
    var width: Float = 1.0
    var height: Float = 1.0

    
    func draw(){
        if TeaPotSprite.program == 0{
            TeaPotSprite.setup()

            setupVertexBufferObject()
            setMatrices()
      
        }
  
        glEnableVertexAttribArray(0)

        /***************************************************/
        // glVertexAttribPointer(0, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE),12,teapotPositions)
        //teapotPositions, field before is 12 (each point represent by 4 bits 
        //4*3
        //
        // glVertexAttribPointer(0, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE),12, nil)
        /***************************************************/
        // commented out, because we are using buffer memory to
        //draw last field is nil
        
        
        
       // can be insdie update or override func glkView
        
       
        
        
        let aspectRatio: GLfloat = (GLfloat) (UIScreen.main.bounds.size.width) / (GLfloat) (UIScreen.main.bounds.size.height)
        
        let fieldView: GLfloat = GLKMathDegreesToRadians(90.0)
        // let projection:mat4 = SGLMath.ortho(0.0, 800.0, 0.0, 600.0, 0.1, 100.0)
        let projectionMatrix: GLKMatrix4 = GLKMatrix4MakePerspective(fieldView, aspectRatio, 0.1, 10.0)

        
        //var model = SGLMath.rotate(mat4(), radians(-55.0), vec3(1.0, 0.0, 0.0))
        var modelViewMatrix: GLKMatrix4 = GLKMatrix4Identity
        //[1 0 0 0 ]
        //[0 1 0 0 ]
        //[0 0 1 0 ]
        //[0 0 0 1 ]
        
        //trasnslatoni Matrix
        //[1 0 0 X ]
        //[0 1 0 Y ]
        //[0 0 1 Z ]
        //[0 0 0 1 ]
        
        //to scale
        //[1*s 0   0  0  ]
        //[0  1*s  0  0  ]  *  [x, y, z, 1 ] ^t
        //[0   0  1*s 0  ]
        //[0   0   0 1*s ]
        
        //to trasnlate
        //                       [x]
        // traanstation matrix * [y]    // (x,y,z,1)^t this is your point
        //                       [z]
        //                       [1]
        modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 0.0, 0.0, -5.0)
        
       
        //[1 0 0 0 ]
        //[0 1 0 0 ]
        //[0 0 1 -5 ]
        //[0 0 0 1 ]
        
        //modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, 2, 2, 2)
        
        modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, GLKMathDegreesToRadians(45)) //45
        //rotate x  a is radian
        //[1   0       0       0]
        //[0 cos(-a) -sin(-a)  0]
        //[0 sin(-a)  cos(-a)  0]
        //[0   0       0       1]
        
        //rotate y
        //[cos(-a)   0   -sin(-a)    0]
        //[0         1       0       0]
        //[sin(-a)   0   cos(-a)     0]
        //[0         0       0       1]
        
        //rotate z
        //[cos(-a)   -sin(-a)   0    0]
        //[sin(-a)   cos(-a)    0    0]
        //[0         0          0    0]
        //[0         0          0    1]
        
       // SGLMath.translate(mat4(), vec3(0.0, 0.0, -3.0))
        //TODO:
        
      // let p =  glGetUniformLocation(TeaPotSprite.program, "projection")
      // let m =  glGetUniformLocation(TeaPotSprite.program, "model")
   
        
       // glUniformMatrix4fv(p, 1, GLboolean(GL_FALSE), projectionMatrix.array)
        
        /***************************************************/
        // count is 1 if is not an array of matrices
        /***************************************************/
       // glUniformMatrix4fv(m, 1, GLboolean(GL_FALSE), modelViewMatrix.array)

       
        
        
        
       glDrawArrays(GLenum(GL_TRIANGLES), 0, GLsizei(teapotVertices))
 
        /***************************************************/
        //mode: how to draw it
        //GL_TRIANGLES
        //GL_TRIANGLES_STRIP  //not good for 3D u get extra lines
        //GL_TRIANGLES_FAN
        //first: which point do you draw first
        //count: how many points
        //  DO NOT BE CONFUSED POINTS WITH ARRAY IF FLOATS
        //  3 FLOATS = 1 POINT THIS IS ASKING FOR POINTS!!!
        /***************************************************/
       
        //glDrawArrays(GLenum(GL_TRIANGLES), 0, GLsizei(teapotPositions.count))
        //glEnable(GLenum(GL_CULL_FACE))
       
    }
   
    func setMatrices()//before draw tea pot
    {
        /***************************************************/
        //this function can be called to bind the effect to default
        //instead of calling custom shader using
        // let p =  glGetUniformLocation(TeaPotSprite.program, "projection")
        // let m =  glGetUniformLocation(TeaPotSprite.program, "model")
        // glUniformMatrix4fv(p, 1, GLboolean(GL_FALSE), projectionMatrix.array)
        
        /***************************************************/
        // count is 1 if is not an array of matrices
        /***************************************************/
        // glUniformMatrix4fv(m, 1, GLboolean(GL_FALSE), modelViewMatrix.array)
        //
        /***************************************************/
        
        
        let effect = GLKBaseEffect()
        
        //color stuff
         effect.constantColor = GLKVector4Make(0, 0, 1, 1)

        let aspectRatio: GLfloat = (GLfloat) (UIScreen.main.bounds.size.width) / (GLfloat) (UIScreen.main.bounds.size.height)
        
        
        //Projection Matrix
        let fieldView: GLfloat = GLKMathDegreesToRadians(90.0)
        let projectionMatrix: GLKMatrix4 = GLKMatrix4MakePerspective(fieldView, aspectRatio, 0.1, 10.0)
        effect.transform.projectionMatrix = projectionMatrix

        
        // ModelView Matrix
        var modelViewMatrix: GLKMatrix4 = GLKMatrix4Identity
        modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 0.0, 0.0, -5.0)
        modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, GLKMathDegreesToRadians(45.0)) //45
        effect.transform.modelviewMatrix = modelViewMatrix
        effect.prepareToDraw() //An effect binds a compiled shader program to the context and returns
    }

    func setupVertexBufferObject() {
        //vbo := vertexBufferObject
    
        glGenBuffers(GLsizei(1), &vbo)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo);
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<Float>.size * teapotPositions.count, teapotPositions, GLenum(GL_STATIC_DRAW))
        /***************************************************/
        //  MemoryLayout<Float>.size * teapotPositions.count
        //  this allocate memory for Buffer
        //  teapotPositions - this put in the whole 
        //  array of numbers in buffer
        //  float size = 4 bits, glfloat = 8
        /***************************************************/
        
        
        
         glVertexAttribPointer(0, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE),0, nil)
        
        /***************************************************/
        //index
        //size: dimensions 2,3 ect
        //type:  GLenum(GL_FLOAT)  what kind of bits
        //normalzied: GLboolean(GL_FALSE) size screen probably x[-1,1],y[-1,1]
        //stride: might be other things in betweeen, how many extra stuff
        //        is inbetween each point, a some model vectors are created
        //        with mixed data, not just 1 for model , 1 for shade ect
        //  so use skip, use skip
        // we are going to use 8 bit, skip 8 bit so
        //stride = 12, or 0 it will now is tighly packed if u give it zero value
        // 12 because 3 dimesnion each dimenion use up 4 bits
        //
        //ptr = nil if is from buffer or your vertex array if you don't use
        //buffer
        /***************************************************/
   
        
        
         
    }




}
