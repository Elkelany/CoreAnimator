//
//  Actions.swift
//  CoreAnimator
//
//  Created by macOS on 7/24/19.
//  Copyright © 2019 macOS. All rights reserved.
//

import UIKit

class GradientColorAction: NSObject, CAAction {
    func run(forKey event: String, object anObject: Any, arguments dict: [AnyHashable : Any]?) {
        let layer = anObject as! CAGradientLayer
        let colorChangeAnimation = CABasicAnimation(keyPath: AnimationHelper.gradientColor)
        let finalColors = [
            UIColor.black.cgColor,
            UIColor.orange.cgColor,
            UIColor.red.cgColor
        ]
        colorChangeAnimation.duration = 2.0
        colorChangeAnimation.fromValue = layer.colors
        colorChangeAnimation.toValue = finalColors
        colorChangeAnimation.fillMode = .backwards
        colorChangeAnimation.beginTime = AnimationHelper.addDelay(for: 4.0)
        
        layer.colors = finalColors
        layer.add(colorChangeAnimation, forKey: "gradient_color_swap")
    }
}

class GradientLocationAction: NSObject, CAAction {
    func run(forKey event: String, object anObject: Any, arguments dict: [AnyHashable : Any]?) {
        let layer = anObject as! CAGradientLayer
        let locationChangeAnimation = CABasicAnimation(keyPath: AnimationHelper.gradientLocations)
        let finalLocations: [NSNumber] = [0.0, 0.9, 1.0]
        
        locationChangeAnimation.duration = 2.0
        locationChangeAnimation.fromValue = layer.locations
        locationChangeAnimation.toValue = finalLocations
        locationChangeAnimation.beginTime = AnimationHelper.addDelay(for: 1.0)
        locationChangeAnimation.fillMode = .backwards
        
        layer.locations = finalLocations
        layer.add(locationChangeAnimation, forKey: "gradient_locations")
    }
}
