//
//  UIView.swift
//  CabifyTest
//
//  Created by Pedro Moura on 03/02/23.
//

import UIKit

extension UIView {
    func pin(to superview: UIView, top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        if let top = top {
            constraints.append(topAnchor.constraint(equalTo: superview.topAnchor, constant: top))
        }
        if let left = left {
            constraints.append(leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: left))
        }
        if let bottom = bottom {
            constraints.append(bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -bottom))
        }
        if let right = right {
            constraints.append(trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -right))
        }
        superview.addConstraints(constraints)
    }
}
