//
//  UIImageView+Animations.swift
//  EssentialFeediOS
//
//  Created by 宇高あゆみ on 2022/04/06.
//

import UIKit

extension UIImageView {
    func setImageAnimated(_ newImage: UIImage?) {
        image = newImage
        guard newImage != nil else { return }
        
        alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
}
