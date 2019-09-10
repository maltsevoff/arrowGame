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
	
	override func didMove(to view: SKView) {
		arrow.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
		let sizeMultiplier: CGFloat = 0.3
		arrow.size = CGSize(width: arrow.size.width * sizeMultiplier, height: arrow.size.height * sizeMultiplier)
		addChild(arrow)
		
		run(SKAction.repeatForever(SKAction.sequence([
			SKAction.run(addTarget),
			SKAction.wait(forDuration: 1.0)
			])))
	}
	
	func addTarget() {
		let target = SKSpriteNode(imageNamed: "target")
		
		let sizeMultiplier: CGFloat = 0.5
		target.size = CGSize(width: target.size.width * sizeMultiplier, height: target.size.height * sizeMultiplier)
		let actualY = size.height * CGFloat.random(in: 0.2 ... 0.9)
		target.position = CGPoint(x: target.size.width / -2, y: actualY)
		addChild(target)
		
		let actualDuration = CGFloat.random(in: 2 ... 4)
		
		let actionMove = SKAction.move(to: CGPoint(x: size.width + target.size.width / 2, y: actualY),
									   duration: TimeInterval(actualDuration))
		let actionMoveDone = SKAction.removeFromParent()
		target.run(SKAction.sequence([actionMove, actionMoveDone]))
	}
	
	func makeArrow(position: CGPoint) -> SKSpriteNode {
		let arrow = SKSpriteNode(imageNamed: "arrow")
		arrow.position = position
		let sizeMultiplier: CGFloat = 0.3
		arrow.size = CGSize(width: arrow.size.width * sizeMultiplier, height: arrow.size.height * sizeMultiplier)
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

extension GameScene {
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else {
			return
		}
		let pointOfTouch = touch.location(in: self)
		startTouchPosition = pointOfTouch
		touchedNodeHolder = nodes(at: pointOfTouch).first
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else {
			return
		}
		let pointOfTouch = touch.location(in: self)
		if touchedNodeHolder == arrow && pointOfTouch.y < size.width * 0.2 {
			touchedNodeHolder?.position = CGPoint(x: pointOfTouch.x, y: arrow.position.y)
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else {
			return
		}
		touchedNodeHolder = nil
		if startTouchPosition == touch.location(in: self) {
			shootArrow(touch: touch)
		}
	}
}
