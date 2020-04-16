//
//  Appearance.swift
//  Runometer
//
//  Created by Svante Dahlberg on 1/18/20.
//  Copyright © 2020 Svante Dahlberg. All rights reserved.
//

import UIKit

struct Appearance {

    static func barStyle(for traitCollection: UITraitCollection) -> UIBarStyle {
        if #available(iOS 12.0, *) {
            return traitCollection.userInterfaceStyle == .light ? .default : .black
        } else {
            return .default
        }
    }

    static func blurEffect(for traitCollection: UITraitCollection) -> UIBlurEffect.Style {
        if #available(iOS 12.0, *) {
            return traitCollection.userInterfaceStyle == .light ? .light : .dark
        } else {
            return .dark
        }
    }

}
