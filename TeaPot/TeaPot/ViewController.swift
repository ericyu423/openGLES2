//
//  ViewController.swift
//  TeaPot
//
//  Created by eric yu on 6/3/17.
//  Copyright © 2017 eric yu. All rights reserved.
//

import UIKit
import GLKit

class ViewController: GLKViewController {
   
    private let teaPotSprite = TeaPotSprite()
   // private var lastUpdate = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        let glkView: GLKView = view as! GLKView
        glkView.context = EAGLContext(api: .openGLES2)
        glkView.drawableColorFormat = .RGBA8888 //8 bit each true color
        EAGLContext.setCurrent(glkView.context)
        setup()
    }

    private func setup(){
        glClearColor(0.0, 1, 0, 1)
        setMatrices()
    }

    func update(){
       // let now = Date()
       // let elapsed = now.timeIntervalSince(lastUpdate)
       // lastUpdate = now
        
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
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

