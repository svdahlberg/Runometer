//
//  UIViewExtensions.swift
//  Runometer
//
//  Created by Svante Dahlberg on 4/17/20.
//  Copyright © 2020 Svante Dahlberg. All rights reserved.
//

import UIKit

extension UIView {

    func pinToSuperview(leading: CGFloat = 0, top: CGFloat = 0, trailing: CGFloat = 0, bottom: CGFloat = 0) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading).isActive = true
        topAnchor.constraint(equalTo: superview.topAnchor, constant: top).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: trailing).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottom).isActive = true
    }

}
