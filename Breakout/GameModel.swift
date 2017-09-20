//
//  GameModel.swift
//  Breakout
//
//  Created by Michael Gasparovic on 4/3/17.
//  Copyright © 2017 Michael Gasparovic. All rights reserved.
//

import Foundation
import UIKit

class Ball: UIDynamicBehavior {
    
    var ball: UIView!
    
    private var collider: UICollisionBehavior!
    private var push: UIPushBehavior!
    private var behavior: UIDynamicItemBehavior!
    
    private let settings = Settings()
    
    init(_ ball: UIView, delegate: UICollisionBehaviorDelegate) {
        super.init()
        
        self.ball = ball
        self.dynamicAnimator?.referenceView?.addSubview(self.ball)
        self.push = UIPushBehavior(items: [self.ball], mode: .instantaneous)
        let angle = CGFloat( (Float(arc4random()) / Float(UINT32_MAX) ) * (Float.pi / -2))
        self.push!.setAngle(angle, magnitude: CGFloat(settings.speed))
        self.push!.active = true
        self.addChildBehavior(self.push)
        
        self.collider = UICollisionBehavior(items: [self.ball])
        self.collider!.translatesReferenceBoundsIntoBoundary = true
        self.collider!.collisionDelegate = delegate
        self.addChildBehavior(self.collider)
        
        self.behavior = UIDynamicItemBehavior()
        self.behavior.addItem(self.ball)
        self.behavior.allowsRotation = false
        self.behavior.elasticity = 1.0
        self.behavior.resistance = 0.0
        self.behavior.friction = 0.0
        self.addChildBehavior(self.behavior)
    }
    
    func addCollider(view: UIView, id identifier: String) {
        let id = identifier as NSCopying
        let path = UIBezierPath(rect: view.frame)
        
        self.collider.removeBoundary(withIdentifier: id)
        self.collider.addBoundary(withIdentifier: id, for: path)
    }
    
    func removeCollider(id identifier: String) {
        let id = identifier as NSCopying
        self.collider.removeBoundary(withIdentifier: id)
    }
    
    func randomizeAngle() {
        let angle = CGFloat( (Float(arc4random()) / Float(UINT32_MAX) ) * (Float.pi / -2))
        self.push!.angle = angle
        self.push.active = true
    }
}

class Settings {
    
    private let user = UserDefaults.standard
    
    var speed: Double {
        get { return user.double(forKey: "Speed") }
        set { user.set(newValue, forKey: "Speed") }
    }
    var numBalls: Int {
        get { return user.integer(forKey: "Num_Balls") }
        set { user.set(newValue, forKey: "Num_Balls") }
    }
    var numBrickRows: Int {
        get { return user.integer(forKey: "Num_Brick_Rows") }
        set { user.set(newValue, forKey: "Num_Brick_Rows") }
    }
}
