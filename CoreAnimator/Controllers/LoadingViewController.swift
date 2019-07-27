//
//  LoadingViewController.swift
//  CoreAnimator
//
//  Created by macOS on 7/24/19.
//  Copyright © 2019 macOS. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var clockImage: UIImageView!
    @IBOutlet weak var setupLabel: UILabel!
    
    // MARK: Appearance
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clockImage.round(cornerRadius: clockImage.frame.size.width/2, borderWidth: 4, borderColor: UIColor.black)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let titleAnimationGroup = CAAnimationGroup()
        titleAnimationGroup.duration = 1.5
        titleAnimationGroup.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        titleAnimationGroup.repeatCount = Float.infinity
        titleAnimationGroup.autoreverses = true
        titleAnimationGroup.animations = [positionPulse(), scalePulse()]
        loadingLabel.layer.add(titleAnimationGroup, forKey: "title_group")

        let clockAnimationGroup = CAAnimationGroup()
        clockAnimationGroup.duration = 3.0
        clockAnimationGroup.timingFunction = CAMediaTimingFunction(name: .easeIn)
        clockAnimationGroup.repeatCount = Float.infinity
        clockAnimationGroup.animations = [
            createKeyFrameColorAnimation(),
            bounceKeyFrameAnimation(),
            rotateKeyFrameAnimation()
        ]
        clockImage.layer.add(clockAnimationGroup, forKey: "clock_group")
        
        delayForSeconds(delay: 2.0) {
            self.animateViewTransition()
        }
        
        segueToNextViewController(segueID: Constants.Segues.dashboardVC, withDelay: 5.2)
    }
    
    func positionPulse() -> CABasicAnimation {
        let posY = CABasicAnimation(keyPath: AnimationHelper.posY)
        posY.fromValue = loadingLabel.layer.position.y - 20
        posY.toValue = loadingLabel.layer.position.y + 20
        return posY
    }
    
    func scalePulse() -> CABasicAnimation {
        let scale = CABasicAnimation(keyPath: AnimationHelper.scale)
        scale.fromValue = 1.2
        scale.toValue = 1.0
        return scale
    }
    
    // MARK: Keyframe Animations
    func createKeyFrameColorAnimation() -> CAKeyframeAnimation {
        let colorChange = CAKeyframeAnimation(keyPath: AnimationHelper.borderColor)
        colorChange.values = [
            UIColor.white.cgColor,
            UIColor.yellow.cgColor,
            UIColor.red.cgColor,
            UIColor.black.cgColor
        ]
        colorChange.keyTimes = [0.0, 0.25, 0.75, 1.0]
        colorChange.duration = 0.8
        colorChange.autoreverses = true
        return colorChange
    }
    
    func bounceKeyFrameAnimation() -> CAKeyframeAnimation {
        let bounce = CAKeyframeAnimation(keyPath: AnimationHelper.position)
        bounce.values = [
            NSValue(cgPoint: CGPoint(x: 25, y: AnimationHelper.screenBounds.height - 25)),
            NSValue(cgPoint: CGPoint(x: 175, y: AnimationHelper.screenBounds.height - 100)),
            NSValue(cgPoint: CGPoint(x: 325, y: AnimationHelper.screenBounds.height - 25)),
            NSValue(cgPoint: CGPoint(x: AnimationHelper.screenBounds.width + 200, y: AnimationHelper.screenBounds.height - 250))
        ]
        bounce.keyTimes = [0.0, 0.3, 0.6, 1.0 ]
        return bounce
    }
    
    func rotateKeyFrameAnimation() -> CAKeyframeAnimation {
        let rotation = CAKeyframeAnimation(keyPath: AnimationHelper.rotation)
        rotation.values = [0.0, Double.pi / 2.0, Double.pi * 3 / 2, Double.pi * 2]
        rotation.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
        return rotation
    }
    
    // MARK: Transitions
    func animateViewTransition() {
        let viewTransition = CATransition()
        viewTransition.duration = 1.5
        viewTransition.type = .reveal
        viewTransition.subtype = .fromLeft
//        viewTransition.startProgress = 0.2
//        viewTransition.endProgress = 0.8
        loadingLabel.layer.add(viewTransition, forKey: "reveal_left")
        setupLabel.layer.add(viewTransition, forKey: "reveal_left")
        loadingLabel.isHidden = true
        setupLabel.isHidden = false
    }
}

// MARK: Delegate Extensions
extension LoadingViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        //guard let animName = anim.value(forKey: "animation_name") as? String else { return }
    }
}
