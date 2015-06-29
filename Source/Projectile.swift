//
//  Projectile.swift
//  NiceGuy
//
//  Created by James Sobieski on 6/27/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

enum Direction {
    case Left, Right
}

import UIKit

class Projectile: CCSprite {
    weak var flames:CCParticleSystem!
    
    
    
    var isOnFire = false {
        didSet {
            if isOnFire {
                flames.visible = true
                speed = 15
            } else {
                flames.visible = false
            }
        }
    }
    var direction:Direction = .Left {
        didSet {
            if direction == .Left {
                self.rotation = -90
            } else if direction == .Right {
                self.rotation = 90
            }
        }
    }
    var speed:CGFloat = CGFloat(5)
   
    
    func move() {
        if direction == .Left {
            self.position.x -= speed
        } else if direction == .Right {
            self.position.x += speed
        }
    }
}
