//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by 宇高あゆみ on 2022/04/13.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
