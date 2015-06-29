//
//  MainScene.swift
//  NiceGuy
//
//  Created by James Sobieski on 6/27/15.
//  Copyright (c) 2015 Apportable. All rights reserved.


import UIKit

class MainScene: CCNode, CCPhysicsCollisionDelegate {
    weak var defender:CCSprite!
    weak var myPhysicsNode:CCPhysicsNode!
    weak var arrows:CCNode!
    weak var heartOne:CCNode!
    weak var heartTwo:CCNode!
    weak var heartThree:CCNode!
    weak var scoreLabel:CCLabelTTF!
    weak var attacker:CCSprite!
    weak var timeTillNextShot:CCLabelTTF!
    weak var backgroundColor:CCNodeColor!
    //weak var gameOverScene:CCScene!
    
    var projectileArray:[Projectile] = []
    let arrowSpeed = 4
    let iphoneWidth:CGFloat = CGFloat(600)
    let scaleFactor = 35
    var timeSinceStart:Double = 0.0
    var lives:[Bool] = []
    var gameOver:Bool = false
    var timeDivided:Double = 1.0
    
    
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        loadRandomArrow()
        
        
        lives = [true, true, true]
        
    }
    
    func loadArrowAtLocationWithDirection(x:CGFloat, y: CGFloat, direction:Direction) {
        
        var random = arc4random_uniform(5)
        
        var temporaryArrow = CCBReader.load("Projectile") as! Projectile
        temporaryArrow.position.x = x
        temporaryArrow.position.y = y
        
        
        temporaryArrow.direction = direction
        temporaryArrow.speed = CGFloat(arc4random_uniform(6) + 3)
        
        if random == 4 {
            temporaryArrow.isOnFire = true
        }
        
        arrows.addChild(temporaryArrow)
        projectileArray.append(temporaryArrow)
    }
    
    func loadRandomArrow() {
        var randomNumber:Int = Int(arc4random_uniform(7) + 1)
        var yPosition = scaleFactor * randomNumber
        
        
        var temporaryArrow = CCBReader.load("Projectile") as! Projectile
        temporaryArrow.position = ccp(CGFloat(iphoneWidth + temporaryArrow.boundingBox().width ), CGFloat(yPosition))
        temporaryArrow.rotation = -90
        println("------")
        println("------")
        println("------")
        println(temporaryArrow.physicsBody.collisionType)
        println(defender.physicsBody.collisionType)
        
        
        
        
        
        
        arrows.addChild(temporaryArrow)
        projectileArray.append(temporaryArrow)
        
        println(temporaryArrow.position.x)
        println(yPosition)
        
    }
    
    func shootBow() {
        loadArrowAtLocationWithDirection(attacker.position.x, y: attacker.position.y, direction: .Right)
        
    }
    
    
    override func update(delta: CCTime) {
        if !gameOver {
            moveArrows()
            
            timeSinceStart += 1.0
            
            
            println("time since start\(timeSinceStart % 10)")
            println("time divided\(timeDivided)")
            
            if timeSinceStart % 10 == 0 {
                timeDivided += 1
                timeTillNextShot.string = "\(10 - timeDivided)"
            }
            
            if timeDivided % (10) == 0 {
                shootBow()
                timeDivided = 1
            }
            
        }
        
    }
    
    func loseALife() {
        if lives.count > 0 {
            var heartToRemove = lives.count
            if heartToRemove == 3 {
                heartThree.visible = false
            } else if heartToRemove == 2 {
                heartTwo.visible = false
            } else {
                heartOne.visible = false
                triggerGameOver()
            }
            lives.removeLast()
            
            flash()
            
            backgroundColor.visible = true
            
            /*backgroundColor.runAction(CCActionFadeIn(duration: 0.2)))
            backgroundColor.runAction(CCActionFadeIn(duration: 0.2)))
            backgroundColor.runAction(CCActionFadeIn(duration: 0.2)))
            backgroundColor.runAction(CCActionFadeIn(duration: 0.2)))
            */
            
            
        }
    }
    
    func flash() {
        var sequence = CCActionSequence(array: [CCActionFadeIn(duration: 0.2), CCActionFadeOut(duration: 0.2), CCActionFadeIn(duration: 0.2), CCActionFadeOut(duration: 0.2)])
        backgroundColor.runAction(sequence)
        
    }
    
    func moveArrows() {
        for var i = 0; i < projectileArray.count; i += 1 {
            var arrow = projectileArray[i]
            if arrow.position.y > 300 {
                arrow.position.y -= CGFloat(300)
            }
            
            var defenderBox:CGRect = defender.boundingBox()
            
            var arrowBox:CGRect = arrow.boundingBox()
            
            if CGRectIntersectsRect(defenderBox, arrowBox) {
                if arrow.isOnFire && arrow.direction == .Left {
                    arrow.removeFromParent()
                    projectileArray.removeAtIndex(i)
                } else if arrow.direction == .Left {
                    arrow.direction = .Right
                    scoreLabel.string = "\(scoreLabel.string.toInt()! + 1)"
                }
            }
            if arrow.position.x < -10 && arrow.direction == .Left {
                arrow.removeFromParent()
                projectileArray.removeAtIndex(i)
                loseALife()
            } else if arrow.position.x > iphoneWidth + 100 && arrow.direction == .Right {
                arrow.direction = .Left
                println("Direction changed")
                //arrow.removeFromParent()
            } else {
                arrow.move()
            }
        }
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, defenderType defender: CCNode!, projectile arrow: Projectile!) -> ObjCBool {
        triggerGameOver()
        arrow.rotation = 90
        arrow.direction = .Right
        
        
        
        return true
    }
    
    /*func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, defender: CCSprite!, projectile: Projectile!) -> ObjCBool {
        triggerGameOver()
        return true
    }*/
    
    func triggerGameOver() {
        println("-----")
        println("Game Over")
        println("-----")
        gameOver = true
        userInteractionEnabled = false
        defender.position = ccp(CGFloat(82), CGFloat(160))
        for arrow in projectileArray {
            arrow.removeFromParent()
        }
        projectileArray.removeAll()
        
        var temporaryGameOverScene = CCBReader.loadAsScene("GameOver")
        //CCDirector.sharedDirector().replaceScene(self, withTransition: temporaryGameOverScene)
        //CCDirector.sharedDirector().replaceScene(temporaryGameOverScene, withTransition: CCActionFadeIn(duration: 0.4))
        CCDirector.sharedDirector().presentScene(temporaryGameOverScene)
        
    }
    
    func restart() {
        //gameOverScene.opacity = 1
        gameOver = false
        heartOne.visible = true
        heartTwo.visible = true
        heartThree.visible = true
        lives = [true, true, true]
        userInteractionEnabled = true
        scoreLabel.string = "0"
        println("game over in main scene called")
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
      //  super.touchesBegan(CCTouch(), withEvent: event)
        //if touch.locationInWorld().y > (defender.boundingBox().height / 2.0) && touch.locationInWorld().y < (320.0 - (defender.boundingBox().height / 2.0)) {
            //defender.position = touch.locationInWorld()
        //}
        
        if !gameOver {
            var points:Double = 568 / (4 * M_PI)
            var theta:Double = Double(touch.locationInWorld().x) / points
            
            defender.position.x = CGFloat(108 * cos(theta) + 184.0)
            defender.position.y = CGFloat(108 * sin(theta) + 144.0)
            
            var attackerTheta = M_PI + theta
            attacker.position.x = CGFloat(108 * cos(attackerTheta) + 184.0)
            attacker.position.y = CGFloat(108 * sin(attackerTheta) + 144.0)
        }
        println("clicked!")
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if !gameOver {
            var points:Double = 568 / (4 * M_PI)
            var theta:Double = Double(touch.locationInWorld().x) / points
            
            defender.position.x = CGFloat(108 * cos(theta) + 184.0)
            defender.position.y = CGFloat(108 * sin(theta) + 144.0)
            
            var attackerTheta = M_PI + theta
            attacker.position.x = CGFloat(108 * cos(attackerTheta) + 184.0)
            attacker.position.y = CGFloat(108 * sin(attackerTheta) + 144.0)
        }
        
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        println("click ended")
    }
    
}

