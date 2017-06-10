//
//  Vertex.swift
//  BasicGLTutorial
//
//  Created by eric yu on 6/9/17.
//  Copyright © 2017 eric yu. All rights reserved.
//

import Foundation
import GLKit

enum VertexAttributes : GLuint {
    case vertexAttribPosition = 0
}

struct Vertex {
    var x : Float = 0.0
    var y : Float = 0.0
    var z : Float = 0.0
    
    var r : Float = 0.0
    var g : Float = 0.0
    var b : Float = 0.0
    var a : Float = 1.0
    
    init(_ x : Float, _ y : Float, _ z : Float, _ r : Float = 0.0, _ g : Float = 0.0, _ b : Float = 0.0, _ a : Float = 1.0) {
        self.x = x
        self.y = y
        self.z = z
        
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
}
 
