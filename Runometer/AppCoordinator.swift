//
//  AppCoordinator.swift
//  Runometer
//
//  Created by Svante Dahlberg on 1/18/20.
//  Copyright © 2020 Svante Dahlberg. All rights reserved.
//

import UIKit

class AppCoordinator {

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        guard let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateInitialViewController() as? UITabBarController else {
            return
        }

        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(tabBarController, animated: false)

        (navigationController as? RunometerNavigationController)?.updateStyle()
    }

}

class RunometerNavigationController: UINavigationController {

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag, completion: completion)
        viewControllerToPresent.updateStyle()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateStyle()
    }

}

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
