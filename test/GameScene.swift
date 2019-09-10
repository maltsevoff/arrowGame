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
	
	override func didMove(to view: SKView) {
//		backgroundColor = SKColor.white
		arrow.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
		let sizeMultiplier: CGFloat = 0.3
		arrow.size = CGSize(width: arrow.size.width * sizeMultiplier, height: arrow.size.height * sizeMultiplier)
		addChild(arrow)
		print(size.width, size.height)
		
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
}
