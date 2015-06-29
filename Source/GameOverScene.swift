//
//  GameOverScene.swift
//  NiceGuy
//
//  Created by James Sobieski on 6/28/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class GameOverScene: CCScene {
    func restart() {
        println("restart in gameOver called")
        var temporaryMainScene = CCBReader.loadAsScene("MainScene") as CCScene
        CCDirector.sharedDirector().presentScene(temporaryMainScene)
    }
}