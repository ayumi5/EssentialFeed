//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by 宇高あゆみ on 2022/04/06.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}

