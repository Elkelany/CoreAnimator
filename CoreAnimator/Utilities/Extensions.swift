//
//  Extensions.swift
//  CoreAnimator
//
//  Created by macOS on 7/24/19.
//  Copyright © 2019 macOS. All rights reserved.
//

import UIKit

extension UIView {
    func round(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.clipsToBounds = true
    }
}

extension NSObject {
    public func delayForSeconds(delay: Double, completion: @escaping() -> ()) {
        let timer = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: timer) {
            completion()
        }
    }
}

extension UIViewController {
    func segueToNextViewController(segueID: String, withDelay: Double) {
        delayForSeconds(delay: withDelay) {
            self.performSegue(withIdentifier: segueID, sender: nil)
        }
    }
}
