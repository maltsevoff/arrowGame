//
//  Model.swift
//  test
//
//  Created by Alex Maltsev on 9/10/19.
//  Copyright © 2019 Aleksandr Maltsev. All rights reserved.
//

import Foundation
import SpriteKit

struct PhysicsSettings {
	static let none : UInt32 = 0
	static let all : UInt32 = UInt32.max
	static let target : UInt32 = 0b1
	static let arrow : UInt32 = 0b10
}

struct Layer {
	static let background : CGFloat  = 0
	static let gameNodes : CGFloat = 1
}
