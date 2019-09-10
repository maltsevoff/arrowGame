//
//  GameViewController.swift
//  test
//
//  Created by Alex Maltsev on 9/10/19.
//  Copyright © 2019 Aleksandr Maltsev. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .resizeFill
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
//		view.addSubview(imageView)
//		self.view.sendSubviewToBack(imageView)
//		view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }

	func assignbackground() -> UIView {
		let background = UIImage(named: "background")
		
		var imageView : UIImageView!
		imageView = UIImageView(frame: view.bounds)
		imageView.contentMode =  UIView.ContentMode.scaleAspectFill
		imageView.clipsToBounds = true
		imageView.image = background
		imageView.center = view.center
		return imageView
	}
	
//    override var shouldAutorotate: Bool {
//        return true
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return .allButUpsideDown
//        } else {
//            return .all
//        }
//    }
//
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
}
