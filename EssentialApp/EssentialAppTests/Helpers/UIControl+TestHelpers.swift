//
//  UIControl+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by 宇高あゆみ on 2022/03/25.
//

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
