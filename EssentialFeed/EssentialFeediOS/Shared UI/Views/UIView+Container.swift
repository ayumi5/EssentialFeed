//
//  UIView+Container.swift
//  EssentialFeediOS
//
//  Created by 宇高あゆみ on 2022/08/26.
//

import UIKit

extension UIView {
    func makeContainer() -> UIView {
        let container = UIView()
        container.backgroundColor = .clear
        container.addSubview(self)
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: container.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            topAnchor.constraint(equalTo: container.topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        return container
    }
}
