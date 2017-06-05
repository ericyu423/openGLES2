//
//  Vector.swift
//  TeaPot
//
//  Created by eric yu on 6/3/17.
//  Copyright © 2017 eric yu. All rights reserved.
//

import Foundation

class Vector{
    var x: Float = 0.0
    var y: Float = 0.0
    
    convenience init(){
        self.init(px: 0.0,py: 0.0)
    }
    
    init(px: Float, py: Float) {
        x = px
        y = py
    }
    
    func add(v1: Vector,v2: Vector) -> Vector {
        return Vector(px: v1.x + v2.x, py: v1.y + v2.y)
    }
    
    func scaleMultiply(v: Vector, s: Float) -> Vector {
        return Vector(px: v.x * s, py: v.y * s)
    }

}
