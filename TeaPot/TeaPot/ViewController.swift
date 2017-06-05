//
//  ViewController.swift
//  TeaPot
//
//  Created by eric yu on 6/3/17.
//  Copyright © 2017 eric yu. All rights reserved.
//

import UIKit
import GLKit
/***************************************************/
//also need to add GLKIT framework to project
/***************************************************/

class ViewController: GLKViewController {
   
    private let teaPotSprite = TeaPotSprite()
   // private var lastUpdate = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let glkView: GLKView = view as! GLKView
        
        glkView.context = EAGLContext(api: .openGLES2)
        /***************************************************/
        //compatable with GLES3 but not GLES2
        //above line create the context but is not activated
        /***************************************************/
        
        glkView.drawableColorFormat = .RGBA8888 //8 bit each true color
        /***************************************************/
        //32 bit format
        /***************************************************/
        
        EAGLContext.setCurrent(glkView.context)
        /***************************************************/
        //this sets the context, because we might have mutiple context
        /***************************************************/
        
        setup()
    }
    /***************************************************/
    //putting glkview in a container view might be fun
    //thing to try
    /***************************************************/
    

    /***************************************************/
    //folowing run once, same in android
    /***************************************************/
    
    private func setup(){
        glClearColor(0.0, 1, 0, 1)
        /***************************************************/
        //glClearColor value get used in glClear to clear the color buffers. 
        //Values specified by glClearColor are clamped to the range  [0,1]
        /***************************************************/
        
        setMatrices()
    
    }

    /***************************************************/
    //update happen before display(glkView)
    /***************************************************/

    func update(){
       // let now = Date()
       // let elapsed = now.timeIntervalSince(lastUpdate)
       // lastUpdate = now
        
    }
    
    /***************************************************/
    //func glkView refreshed view 60 fps
    /***************************************************/
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        /***************************************************/
        //clear color and used the info from glClearColor
        /***************************************************/
        /***************************************************/
        // you pass in a mask it does bitwise operations Int32
        // po String(GL_COLOR_BUFFER_BIT, radix: 2)
        // "100000000000000" = 16384
        /***************************************************/
      
        
        teaPotSprite.draw()
    }

}

extension ViewController {
    func setMatrices()//before draw tea pot
    {
       let effect = GLKBaseEffect()
        let aspectRatio: GLfloat = (GLfloat)(view.bounds.size.width) / (GLfloat)(view.bounds.size.height)
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
}

