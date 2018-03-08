//
//  GameScene.swift
//  ColorGame
//
//  Created by sanket kumar on 08/03/18.
//  Copyright © 2018 sanket kumar. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var tracksArray : [SKSpriteNode]? = [SKSpriteNode]()
    var player : SKSpriteNode?
    var currentTrack = 0
    var movingToTrack = false
    let moveSound = SKAction.playSoundFileNamed("move.wav", waitForCompletion: false)
    
    
    override func didMove(to view: SKView) {
        setupTracks()
        createPlayer()
    }
    
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        guard let playerPosition = tracksArray?.first?.position.x else {
            return
        }
        player?.position = CGPoint(x: playerPosition, y: self.size.height / 2)
        self.addChild(player!)
    }
    
    func setupTracks() {
        for i in 0...8 {
            if let tracks = self.childNode(withName: "\(i)") as? SKSpriteNode {
                tracksArray?.append(tracks)
            }
        }
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func moveVertically(up : Bool) {
        if up {
            let moveAction = SKAction.moveBy(x: 0, y: 10, duration: 0.01)
            let repeatAction = SKAction.repeatForever(moveAction)
            player?.run(repeatAction)
        }else {
            let moveAction = SKAction.moveBy(x: 0, y: -10, duration: 0.01)
            let repeatAction = SKAction.repeatForever(moveAction)
            player?.run(repeatAction)
        }
    }
    
    
    func moveToNextTrack() {
        player?.removeAllActions()
        movingToTrack = true
        
        guard let nextTrack = tracksArray?[currentTrack + 1].position else {
            return
        }
        
        if let player = self.player {
            let moveAction = SKAction.move(to: CGPoint(x : nextTrack.x, y : player.position.y), duration: 0.2)
            player.run(moveAction, completion: {
                self.movingToTrack = false
            })
            currentTrack += 1
            self.run(moveSound)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch  = touches.first {
            let location = touch.previousLocation(in: self)
            let node = self.nodes(at: location).first
            
            if node?.name == "right" {
                moveToNextTrack()
            }else if node?.name == "up" {
                moveVertically(up: true)
            }else if node?.name == "down" {
                moveVertically(up: false)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !movingToTrack {
            player?.removeAllActions()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        player?.removeAllActions()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
