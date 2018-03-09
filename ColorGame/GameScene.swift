//
//  GameScene.swift
//  ColorGame
//
//  Created by sanket kumar on 08/03/18.
//  Copyright © 2018 sanket kumar. All rights reserved.
//

import SpriteKit
import GameplayKit

enum Enemies : Int {
    case small
    case medium
    case large
}

class GameScene: SKScene {
    
    var tracksArray : [SKSpriteNode]? = [SKSpriteNode]()
    var player : SKSpriteNode?
    var currentTrack = 0
    var movingToTrack = false
    let moveSound = SKAction.playSoundFileNamed("move.wav", waitForCompletion: false)
    let trackVelocities = [180,200,250]
    var directionArray = [Bool]()
    var velocityArray = [Int]()
    
    
    override func didMove(to view: SKView) {
        setupTracks()
        createPlayer()
        
        if let numberOfTracks = tracksArray?.count {
            for _ in 0...numberOfTracks {
                let randomNumberForVelocity = GKRandomSource.sharedRandom().nextInt(upperBound: 3)
                velocityArray.append(trackVelocities[randomNumberForVelocity])
                directionArray.append(GKRandomSource.sharedRandom().nextBool())
            }
        }
        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
                self.spawnEnemies()
            },SKAction.wait(forDuration: 2)])))
        
    }
    
    
    func createPlayer() {
        
        player = SKSpriteNode(imageNamed: "player")
        guard let playerPosition = tracksArray?.first?.position.x else {
            return
        }
        player?.position = CGPoint(x: playerPosition, y: self.size.height / 2)
        self.addChild(player!)
        
        let pulse = SKEmitterNode(fileNamed: "pulse")!
        player?.addChild(pulse)
        pulse.position = CGPoint(x: 0, y: 0)
    }
    
    
    func createEnemy(type : Enemies , forTrack track : Int) -> SKShapeNode? {
        
        // Create a SKShapeNode()
        let enemyStrite = SKShapeNode()
        enemyStrite.name = "ENEMY"
    
        switch(type) {
            case .small:
                enemyStrite.path = CGPath(roundedRect: CGRect(x : -10 , y : 0 , width : 20 , height : 70), cornerWidth: 8, cornerHeight: 8, transform: nil)
                enemyStrite.fillColor = UIColor(red: 0.4431, green: 0.5529, blue: 0.7451, alpha: 1)
            
            case .medium:
                enemyStrite.path = CGPath(roundedRect: CGRect(x : -10 , y : 0 , width : 20 , height : 100), cornerWidth: 8, cornerHeight: 8, transform: nil)
                enemyStrite.fillColor = UIColor(red: 0.7804, green: 0.4039, blue: 0.4039, alpha: 1)
            case .large:
                enemyStrite.path = CGPath(roundedRect: CGRect(x : -10 , y : 0 , width : 20 , height : 130), cornerWidth: 8, cornerHeight: 8, transform: nil)
                enemyStrite.fillColor = UIColor(red: 0.7804, green: 0.6392, blue: 0.4039, alpha: 1)
        }
        
        // check track is available or not
        guard let enemyPosition = tracksArray?[track].position else {
            return nil
        }
        
        // get the direction
        let up = directionArray[track]
        
        // set the enemy position
        enemyStrite.position.x = enemyPosition.x
        enemyStrite.position.y = up ? -130 : self.size.height + 130
        
        // Add physics body property to detect collision or other stuff
        enemyStrite.physicsBody = SKPhysicsBody(edgeLoopFrom: enemyStrite.path!)
        enemyStrite.physicsBody?.velocity = up ? CGVector(dx: 0, dy: velocityArray[track]) : CGVector(dx: 0, dy: -velocityArray[track])
        
        return enemyStrite
    }
    
    
    func spawnEnemies() {
        for i in 1...7 {
            let randomEnemyType = Enemies(rawValue: GKRandomSource.sharedRandom().nextInt(upperBound: 3))!
            if let newEnemy = createEnemy(type: randomEnemyType, forTrack: i) {
                self.addChild(newEnemy)
            }
        }
        
        self.enumerateChildNodes(withName: "ENEMY"){(node: SKNode , nil) in
            if node.position.y < -150 || node.position.y > self.size.height + 150 {
                node.removeFromParent()
            }
        }
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
