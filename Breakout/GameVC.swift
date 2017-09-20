//
//  FirstViewController.swift
//  Breakout
//
//  Created by Michael Gasparovic on 3/31/17.
//  Copyright © 2017 Michael Gasparovic. All rights reserved.
//

import UIKit


class GameVC: UIViewController, UICollisionBehaviorDelegate {

    
    // MARK: Views

    @IBAction func newGameButton(_ sender: UIButton) {
        self.buildGame()
    }
    @IBOutlet weak var newGameButtonOutlet: UIButton!
    
    
    @IBOutlet var gameView: UIView! {
        didSet {
            let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(GameVC.handlePan(gesture:)))
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameVC.handlePan(gesture:)))
            self.gameView.addGestureRecognizer(panRecognizer)
            self.gameView.addGestureRecognizer(tapRecognizer)
        }
    }
    
    private var balls: [Ball]!
    private var bricks: [String: UIView]!
    private var brickHealth: [String: Int]!
    private var maxHealth: Int!
    private var paddle: UIView!
    
    private var animator: UIDynamicAnimator!
    
    private let settings = Settings()
    
    
    // MARK: View Loading Functions
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.destroyGame()
    }
    
    func buildGame() {
        self.createBalls(num: self.settings.numBalls)
        self.createPaddle()
        self.createBricks(columns: 5)
        
        self.addBehaviors()
        
        self.newGameButtonOutlet.isHidden = true
    }
    
    private func createBalls(num: Int) {
        let size = CGSize(width: 10, height: 10)
        self.balls = [(Ball)]()
        for _ in 1...num {
            let view = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
            view.center = CGPoint(x: self.gameView.bounds.midX, y: self.gameView.bounds.midY)
            view.layer.cornerRadius = 10
            view.backgroundColor = UIColor.blue
            view.clipsToBounds = true
            let model = Ball(view, delegate: self)
            self.gameView.addSubview(model.ball)
            self.balls.append(model)
        }
    }
    
    private func createPaddle() {
        let paddle = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 10)))
        paddle.center = CGPoint(x: view.bounds.midX, y: view.bounds.maxY - CGFloat(60))
        paddle.backgroundColor = UIColor.black
        view.addSubview(paddle)
        self.paddle = paddle
        for ball in self.balls {
            ball.addCollider(view: self.paddle, id: "Paddle")
        }
    }
    
    private func createBricks(columns: Int) {
        let margin = CGFloat(10)
        let height = CGFloat(20)
        let width = (self.view.bounds.maxX / CGFloat(columns) - margin * 2)
        self.bricks = [String: UIView]()
        self.brickHealth = [String: Int]()
        var rows = self.settings.numBrickRows
        if rows <= 1 {
            self.settings.numBrickRows = 3
            rows = 3
        }
        self.maxHealth = rows
        for c in 1...columns {
            for r in 1...rows {
                let x = ((width * CGFloat(c)) + ((margin*1.5) * CGFloat(c)) - width)
                let y = ((height * CGFloat(r)) + ((margin*1.5) * CGFloat(r)) - height + CGFloat(5))
                let brick = UIView(frame: CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: height)))
                let health = maxHealth - r
                brick.updateBrickColor(Double(health)/Double(maxHealth))
                
                for ball in self.balls {
                    ball.addCollider(view: brick, id: "Brick r\(r) c\(c)")
                }
                self.bricks["Brick r\(r) c\(c)"] = brick
                self.brickHealth["Brick r\(r) c\(c)"] = health
                view.addSubview(brick)
            }
        }
        
    }
    
    private func addBehaviors() {
        self.animator = UIDynamicAnimator(referenceView: self.gameView)
        for ball in balls {
            self.animator.addBehavior(ball)
        }
    }
    
    private func destroyGame() {
        if self.animator != nil {
            self.animator.removeAllBehaviors()
        }
        for view in gameView.subviews {
            if ((view as? UIButton) != nil) {
                continue
            }
            view.removeFromSuperview()
        }
        self.newGameButtonOutlet.isHidden = false
    }
    
    
    // MARK: Collision Hanling
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        if let id = identifier as? String {
            switch id {
            case "Paddle":
                break
            default:
                if let brick = self.bricks[id] {
                    if var health = self.brickHealth[id] {
                        health = health - 1
                        if health <= 0 {
                            brick.removeFromSuperview()
                            for ball in self.balls {
                                ball.removeCollider(id: id)
                            }
                        
                            self.bricks.removeValue(forKey: id)
                        }
                        else {
                            brick.updateBrickColor(Double(health)/Double(self.maxHealth))
                            self.brickHealth[id] = health
                        }
                    }
                }
                break
            }
        }
        else {
            var idx = 0
            for ball in balls {
                if ball.ball.center.y > view.bounds.maxY - CGFloat(45) {
                    ball.ball.removeFromSuperview()
                    if idx <= self.balls.count {
                        self.balls.remove(at: idx)
                    }
                    self.animator.removeBehavior(ball)
                }
                idx += 1
            }
            if balls.count == 0  {
                self.destroyGame()
            }
        }
    }
    
    
    // MARK: Gensture Recognizer
    
    func handlePan(gesture: UIGestureRecognizer) {
        if self.balls == nil { return }
        
        if let gesture = gesture as? UIPanGestureRecognizer {
            switch gesture.state {
            case .began:
                fallthrough
            case .changed:
                fallthrough
            case .ended:
                let point = CGPoint(x: gesture.location(in: gameView).x, y: view.bounds.maxY - CGFloat(60))
                paddle.center = point
                for ball in balls {
                    ball.addCollider(view: self.paddle, id: "Paddle")
                }
            default:
                break
            }
        }
        else if let _ = gesture as? UITapGestureRecognizer {
            print("sub")
            for ball in self.balls {
                ball.randomizeAngle()
            }
        }
        
    }

}


extension UIView {
    func updateBrickColor(_ value: Double) {
        self.backgroundColor = UIColor(red: 1, green: CGFloat(value), blue: 0, alpha: 1)
    }
}

