//
//  DashboardViewController.swift
//  CoreAnimator
//
//  Created by macOS on 7/24/19.
//  Copyright © 2019 macOS. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    // Shape layers
    let gradientLayer = CAGradientLayer()
    var circle = CAShapeLayer()
    var square = CAShapeLayer()
    var triangle = CAShapeLayer()
    
    // Gradient colors
    let colors = [
        UIColor.blue.cgColor,
        UIColor.darkGray.cgColor,
        UIColor.black.cgColor
    ]
    
    // MARK: Appearance
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Gradient setup
        gradientLayer.delegate = self
        gradientLayer.colors = colors
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Shape setup
        square = AnimationHelper.squareShapeLayer()
        circle = AnimationHelper.circleShapeLayer()
        view.layer.addSublayer(square)
        view.layer.addSublayer(circle)
        
//        gradientAnimation()
        animateLineDash()
        animateCircleByPath()
        animateCircleShapeChange()
        createReplicatorLayer()
        createTextLayer()
        createCustomTransaction()
        
        segueToNextViewController(segueID: Constants.Segues.partyTimeVC, withDelay: 9.0)
    }
    
    func gradientAnimation() {
        let colorShift = CABasicAnimation(keyPath: AnimationHelper.gradientColor)
        colorShift.fromValue = colors
        colorShift.toValue = colors.reversed()
        colorShift.duration = 2.0
        colorShift.beginTime = AnimationHelper.addDelay(for: 1.0)
        colorShift.fillMode = CAMediaTimingFillMode.backwards
        gradientLayer.colors = colors.reversed()
        gradientLayer.add(colorShift, forKey: "gradient_animation")
    }
    
    func animateLineDash() {
        let dash = CABasicAnimation(keyPath: AnimationHelper.dashPhase)
        dash.fromValue = 0
        dash.toValue = square.lineDashPattern?.reduce(0, {$0 + $1.intValue })
        dash.duration = 1.0
        dash.repeatCount = Float.infinity
        square.add(dash, forKey: "line_dash")
    }
    
    func animateCircleByPath() {
        let circleMovement = CAKeyframeAnimation(keyPath: AnimationHelper.position)
        circleMovement.repeatCount = Float.infinity
        circleMovement.duration = 3.0
        circleMovement.path = square.path
        circleMovement.calculationMode = .paced
        circle.add(circleMovement, forKey: "keyframe_path")
    }
    
    func animateCircleShapeChange() {
        let squish = CABasicAnimation(keyPath: AnimationHelper.shapePath)
        squish.duration = 1.5
        squish.repeatCount = Float.infinity
        squish.autoreverses = true
        squish.toValue = UIBezierPath(roundedRect: CGRect(x: -50, y: -50, width: 100, height: 100), cornerRadius: 10).cgPath
        circle.add(squish, forKey: "circle_squish")
    }
    
    func createReplicatorLayer() {
        let replicator = CAReplicatorLayer()
        replicator.frame = CGRect(x: 0, y: AnimationHelper.screenBounds.height - 100, width: AnimationHelper.screenBounds.width, height: 100)
        replicator.masksToBounds = true
        view.layer.addSublayer(replicator)
        triangle = AnimationHelper.triangleShapeLayer()
        replicator.addSublayer(triangle)
        replicator.instanceCount = 4
        replicator.instanceTransform = CATransform3DMakeTranslation(95, 0, 0)
        replicator.instanceDelay = TimeInterval(2.0)
    }
    
    func createTextLayer() {
        let titleLayer = CATextLayer()
        titleLayer.frame = CGRect(x: 0, y: 100, width: AnimationHelper.screenBounds.width, height: 100)
        titleLayer.string = "Dashboard"
        titleLayer.alignmentMode = CATextLayerAlignmentMode.center
        view.layer.addSublayer(titleLayer)
        
        let textColorAnimation = CABasicAnimation(keyPath: AnimationHelper.textColor)
        textColorAnimation.duration = 1.5
        textColorAnimation.fromValue = UIColor.red.cgColor
        textColorAnimation.toValue = UIColor.white.cgColor
        textColorAnimation.beginTime = AnimationHelper.addDelay(for: 0.5)
        textColorAnimation.fillMode = CAMediaTimingFillMode.backwards
        
        titleLayer.foregroundColor = UIColor.white.cgColor
        titleLayer.add(textColorAnimation, forKey: "textColor_change")
    }
    
    func createCustomTransaction() {
        CATransaction.begin()
        
        CATransaction.setAnimationDuration(3.0)
        CATransaction.setCompletionBlock {
        }
        
        let pulse = AnimationHelper.basicFadeAnimation()
        pulse.autoreverses = true
        pulse.repeatCount = 3
        triangle.add(pulse, forKey: "fade_pulse")
        
        CATransaction.commit()
    }
}

extension DashboardViewController: CALayerDelegate {
    func action(for layer: CALayer, forKey event: String) -> CAAction? {
        switch event {
        case kCAOnOrderIn:
            return GradientColorAction()
        case AnimationHelper.gradientLocations:
            return GradientLocationAction()
        default:
            break
        }
        return nil
    }
}
