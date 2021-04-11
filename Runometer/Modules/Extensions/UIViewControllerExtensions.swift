//
//  UIViewControllerExtensions.swift
//  Runometer
//
//  Created by Svante Dahlberg on 4/4/21.
//  Copyright © 2021 Svante Dahlberg. All rights reserved.
//

import UIKit

extension UIViewController {

    func updateStyle() {
        let barStyle = Appearance.barStyle(for: traitCollection)

        var viewControllers = [UIViewController]()
        childViewControllers(of: self, result: &viewControllers)

        for viewController in viewControllers {
            if let tabBarController = viewController as? UITabBarController {
                tabBarController.tabBar.barStyle = barStyle
            }

            if let navigationController = viewController as? UINavigationController {
                navigationController.navigationBar.barStyle = barStyle
            }
        }
    }

    private func childViewControllers(of viewController: UIViewController, result: inout [UIViewController]) {
        result.append(viewController)

        for viewController in viewController.children {
            result.append(viewController)
            childViewControllers(of: viewController, result: &result)
        }
    }

}
