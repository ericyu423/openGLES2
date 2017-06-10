//
//  flashSprite.swift
//  BasicGLTutorial
//
//  Created by eric yu on 6/9/17.
//  Copyright © 2017 eric yu. All rights reserved.
//

import Foundation
import GLKit


class FlashSprite {
    
    var red: Float = 0
    var increasing: Bool = true
    let durationOfFlash : Double = 2.0
    var timeSinceFirstResume: TimeInterval = 0

   
    
    func draw(){
        glClearColor(red, 0, 0.0, 1.0)
    }
}
