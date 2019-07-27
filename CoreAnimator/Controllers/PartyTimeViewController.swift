//
//  PartyTimeViewController.swift
//  CoreAnimator
//
//  Created by macOS on 7/24/19.
//  Copyright © 2019 macOS. All rights reserved.
//

import UIKit

class PartyTimeViewController: UIViewController {
    
    // Labels
    var partyLabel: UILabel!
    var timeLabel: UILabel!
    var celebrateLabel: UILabel!
    
    // MARK: Appearance
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        partyLabel = UILabel()
        partyLabel.layer.anchorPoint.x = 1.0
        partyLabel.frame = CGRect(x: AnimationHelper.screenBounds.midX - 150, y: 100, width: 150, height: 50)
        partyLabel.text = "Party"
        partyLabel.font = UIFont(name: "Arial-Bold", size: 20)
        partyLabel.textColor = UIColor.white
        partyLabel.textAlignment = .center
        partyLabel.layer.borderColor = UIColor.white.cgColor
        partyLabel.layer.borderWidth = 3.0
        
        timeLabel = UILabel()
        timeLabel.layer.anchorPoint.x = 0.0
        timeLabel.frame = CGRect(x: AnimationHelper.screenBounds.midX, y: 100, width: 150, height: 50)
        timeLabel.text = "Time"
        timeLabel.font = UIFont(name: "Arial-Bold", size: 20)
        timeLabel.textColor = UIColor.white
        timeLabel.textAlignment = .center
        timeLabel.layer.borderColor = UIColor.white.cgColor
        timeLabel.layer.borderWidth = 3.0
        
        celebrateLabel = UILabel()
        celebrateLabel.frame = CGRect(x: AnimationHelper.screenBounds.midX - 75, y: AnimationHelper.screenBounds.midY, width: 150, height: 150)
        celebrateLabel.text = "CELEBRATE!"
        celebrateLabel.font = UIFont(name: "Arial", size: 20)
        celebrateLabel.textColor = UIColor.white
        celebrateLabel.textAlignment = .center
        celebrateLabel.layer.borderColor = UIColor.white.cgColor
        celebrateLabel.layer.borderWidth = 5.0
        
        view.addSubview(partyLabel)
        view.addSubview(timeLabel)
        view.addSubview(celebrateLabel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        positionLabel()
        animateLabel3D()
        createFireworksEmitter()
        celebrateLabel.layer.transform = create3DMultiTransform()
    }
    
    // MARK: 3D Animations
    func create3DPerspectiveTransform(cameraDistance: CGFloat) -> CATransform3D {
        var viewPerspective = CATransform3DIdentity
        viewPerspective.m34 = -1.0 / cameraDistance
        return viewPerspective
    }
    
    func positionLabel() {
        let rotAngle = CGFloat.pi / 4.0
        var rotatedTransform = create3DPerspectiveTransform(cameraDistance: 800)
        rotatedTransform = CATransform3DRotate(rotatedTransform, rotAngle, 0.0, 1.0, 0.0)
        partyLabel.layer.transform = rotatedTransform
    }
    
    func create3DMultiTransform() -> CATransform3D {
        var multiTransform = create3DPerspectiveTransform(cameraDistance: 1000)
        multiTransform = CATransform3DTranslate(multiTransform, 0.0, 150, 200)
        multiTransform = CATransform3DRotate(multiTransform, .pi / 2.5, 1.0, 0.0, 0.0)
        multiTransform = CATransform3DScale(multiTransform, 1.7, 1.3, 1.0)
        return multiTransform
    }
    
    func animateLabel3D() {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.partyLabel.layer.shouldRasterize = false
        }
        var perspectiveTransform = create3DPerspectiveTransform(cameraDistance: 800)
        perspectiveTransform = CATransform3DRotate(perspectiveTransform, .pi / 4.0, 0.0, -1.0, 0.0)
        let rotate3DAnimation = CABasicAnimation(keyPath: AnimationHelper.transform)
        rotate3DAnimation.duration = 2.0
        rotate3DAnimation.fromValue = timeLabel.layer.transform
        rotate3DAnimation.toValue = perspectiveTransform
        rotate3DAnimation.beginTime = AnimationHelper.addDelay(for: 1.0)
        rotate3DAnimation.fillMode = .backwards
        partyLabel.layer.shouldRasterize = true
        partyLabel.layer.rasterizationScale = UIScreen.main.scale
        timeLabel.layer.transform = perspectiveTransform
        timeLabel.layer.add(rotate3DAnimation, forKey: "rotate_3D")
        CATransaction.commit()
    }
    
    // MARK: Particle Emitter
    func createFireworksEmitter() {
        let fireworksEmitter = CAEmitterLayer()
        fireworksEmitter.frame = view.bounds
        fireworksEmitter.emitterPosition = CGPoint(x: AnimationHelper.screenBounds.midX, y: AnimationHelper.screenBounds.midY)
        fireworksEmitter.emitterSize = CGSize(width: 150, height: 150)
        fireworksEmitter.emitterShape = CAEmitterLayerEmitterShape.point
        fireworksEmitter.emitterCells = [
            createFireworks(fireworkColor: UIColor.red),
            createFireworks(fireworkColor: UIColor.orange),
            createFireworks(fireworkColor: UIColor.yellow)
        ]
        view.layer.addSublayer(fireworksEmitter)
    }
    
    func createFireworks(fireworkColor: UIColor) -> CAEmitterCell {
        let fireworkCell = CAEmitterCell()
        fireworkCell.contents = UIImage(named: "firework.png")?.cgImage
        fireworkCell.birthRate = 1.5
        fireworkCell.lifetime = 1.5
        fireworkCell.yAcceleration = 100
        fireworkCell.xAcceleration = 15
        fireworkCell.velocity = 50
        fireworkCell.velocityRange = 100
        fireworkCell.emissionLongitude = -.pi / 2.0
        fireworkCell.emissionLatitude = .pi / 2.0
        fireworkCell.emissionRange = .pi / 2.0
        fireworkCell.scale = 0.7
        fireworkCell.scaleRange = 0.2
        fireworkCell.scaleSpeed = 0.1
        fireworkCell.alphaRange = 0.8
        fireworkCell.alphaSpeed = -0.1
        fireworkCell.color = fireworkColor.cgColor
        return fireworkCell
    }
}
