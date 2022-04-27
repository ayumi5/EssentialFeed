//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by 宇高あゆみ on 2022/03/25.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
