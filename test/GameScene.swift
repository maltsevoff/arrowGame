//
//  GameScene.swift
//  test
//
//  Created by Alex Maltsev on 9/10/19.
//  Copyright © 2019 Aleksandr Maltsev. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
	
	let arrow = SKSpriteNode(imageNamed: "arrow")
	var touchedNodeHolder: SKNode?
	var startTouchPosition: CGPoint?
	var score: Int = 0
	var scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
	
	override func didMove(to view: SKView) {
//		let background = SKSpriteNode(imageNamed: "background")
//		background.position = CGPoint(x: size.width / 2, y: size.height / 2)
//		addChild(background)
		arrow.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
		let sizeMultiplier: CGFloat = 0.3
		arrow.size = CGSize(width: arrow.size.width * sizeMultiplier, height: arrow.size.height * sizeMultiplier)
		addChild(arrow)
		physicsWorld.gravity = .zero
		physicsWorld.contactDelegate = self
		addScoreLabel()
		
		run(SKAction.repeatForever(SKAction.sequence([
			SKAction.run(addTarget),
			SKAction.wait(forDuration: 1.0)
			])))
	}
	
	func addScoreLabel() {
		scoreLabel.text = "Score: \(score)"
		scoreLabel.fontSize = 20
		scoreLabel.fontColor = SKColor.yellow
		scoreLabel.position = CGPoint(x: size.width * 0.1 , y: size.height * 0.9)
		addChild(scoreLabel)
	}
	
	func addTarget() {
		let target = SKSpriteNode(imageNamed: "target")
		let sizeMultiplier: CGFloat = 0.5
		target.size = CGSize(width: target.size.width * sizeMultiplier, height: target.size.height * sizeMultiplier)
		target.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "target"), size: target.size)
		target.physicsBody?.isDynamic = true
		target.physicsBody?.categoryBitMask = PhysicsSettings.target
		target.physicsBody?.contactTestBitMask = PhysicsSettings.arrow
		target.physicsBody?.collisionBitMask = PhysicsSettings.none
		
		let actualY = size.height * CGFloat.random(in: 0.2 ... 0.9)
		target.position = CGPoint(x: target.size.width / -2, y: actualY)
		addChild(target)
		
		let actualDuration = CGFloat.random(in: 2 ... 4)
		
		let actionMove = SKAction.move(to: CGPoint(x: size.width + target.size.width / 2, y: actualY),
									   duration: TimeInterval(actualDuration))
		let actionMoveDone = SKAction.removeFromParent()
		let loseAction = SKAction.run() { [weak self] in
			guard let `self` = self else { return }
			let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
			let gameOverScene = GameOverScene(size: self.size, won: false)
			self.view?.presentScene(gameOverScene, transition: reveal)
		}
		target.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
	}
	
	func makeArrow(position: CGPoint) -> SKSpriteNode {
		let arrow = SKSpriteNode(imageNamed: "arrow")
		arrow.position = position
		let sizeMultiplier: CGFloat = 0.3
		arrow.size = CGSize(width: arrow.size.width * sizeMultiplier, height: arrow.size.height * sizeMultiplier)
		arrow.physicsBody = SKPhysicsBody(rectangleOf: arrow.size)
		arrow.physicsBody?.isDynamic = true
		arrow.physicsBody?.categoryBitMask = PhysicsSettings.arrow
		arrow.physicsBody?.contactTestBitMask = PhysicsSettings.target
		arrow.physicsBody?.collisionBitMask = PhysicsSettings.none
		arrow.physicsBody?.usesPreciseCollisionDetection = true
		return arrow
	}
	
	func shootArrow(touch: UITouch) {
		let frontTouchedNode = atPoint(touch.location(in: self))
		if frontTouchedNode != arrow {
			return
		}

		let movingArrow = makeArrow(position: arrow.position)
		addChild(movingArrow)
		let actionMove = SKAction.move(to: CGPoint(x: movingArrow.position.x, y: size.height + movingArrow.size.height / 2), duration: 1.0)
		let actionMoveDone = SKAction.removeFromParent()
		movingArrow.run(SKAction.sequence([actionMove, actionMoveDone]))
	}
}

extension GameScene : SKPhysicsContactDelegate {
	
	func arrowDidCollideWithTarget(arrow: SKSpriteNode, target: SKSpriteNode) {
		arrow.removeFromParent()
		target.removeFromParent()
	}
	
	func didBegin(_ contact: SKPhysicsContact) {
		var firstBody: SKPhysicsBody
		var secondBody: SKPhysicsBody
		if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
			firstBody = contact.bodyA
			secondBody = contact.bodyB
		} else {
			firstBody = contact.bodyB
			secondBody = contact.bodyA
		}
		if (firstBody.categoryBitMask & PhysicsSettings.target != 0) && (secondBody.categoryBitMask & PhysicsSettings.arrow != 0) {
			if let target = firstBody.node as? SKSpriteNode, let arrow = secondBody.node as? SKSpriteNode {
				checkContactPoint(contactPoint: contact.contactPoint, target: target)
				arrowDidCollideWithTarget(arrow: arrow, target: target)
				updateScoreLabel()
			}
		}
	}
	
	func showHitLabel(contactPoint: CGPoint, isPerfect: Bool) {
		let label = SKLabelNode(fontNamed: "Chalkduster")
		let message = isPerfect ? "+2" : "+1"
		label.text = message
		label.fontSize = 20
		label.fontColor = SKColor.yellow
		label.position = CGPoint(x: contactPoint.x + 20, y: contactPoint.y + 20)
		addChild(label)
		let actionWait = SKAction.wait(forDuration: 0.4)
		let actionMoveDone = SKAction.removeFromParent()
		if isPerfect {
			let labelPerfect = SKLabelNode(fontNamed: "Chalkduster")
			labelPerfect.text = "Perfect!"
			labelPerfect.fontSize = 20
			labelPerfect.fontColor = SKColor.yellow
			labelPerfect.position = CGPoint(x: label.position.x + 30, y: label.position.y - 20)
			addChild(labelPerfect)
			labelPerfect.run(SKAction.sequence([actionWait, actionMoveDone]))
		}
		label.run(SKAction.sequence([actionWait, actionMoveDone]))
	}
	
	func checkContactPoint(contactPoint: CGPoint, target: SKSpriteNode) {
		let leftBorder = target.position.x - target.size.width * 0.25
		let rightBorder = target.position.x + target.size.width * 0.25
		if contactPoint.x > leftBorder && contactPoint.x < rightBorder {
			score += 2
			showHitLabel(contactPoint: contactPoint, isPerfect: true)
		} else {
			score += 1
			showHitLabel(contactPoint: contactPoint, isPerfect: false)
		}
	}
	
	func updateScoreLabel() {
		scoreLabel.text = "Score: \(score)"
	}
}

extension GameScene {
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//		guard let touch = touches.first else {
//			return
//		}
		for touch in touches {
			let pointOfTouch = touch.location(in: self)
			startTouchPosition = pointOfTouch
			touchedNodeHolder = nodes(at: pointOfTouch).first
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//		guard let touch = touches.first else {
//			return
//		}
		for touch in touches {
			let pointOfTouch = touch.location(in: self)
			if touchedNodeHolder == arrow && pointOfTouch.y < size.width * 0.2 {
				touchedNodeHolder?.position = CGPoint(x: pointOfTouch.x, y: arrow.position.y)
			}
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//		guard let touch = touches.first else {
//			return
//		}
		for touch in touches {
			touchedNodeHolder = nil
			if startTouchPosition == touch.location(in: self) {
				shootArrow(touch: touch)
			}
		}
	}
}
