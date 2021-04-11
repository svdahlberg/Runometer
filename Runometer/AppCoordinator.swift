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
    private let runObserver: RunObserving

    init(navigationController: UINavigationController, runObserver: RunObserving = RunProvider()) {
        self.navigationController = navigationController
        self.runObserver = runObserver
    }

    func start() {
        guard let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateInitialViewController() as? UITabBarController else {
            return
        }

        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(tabBarController, animated: false)

        (navigationController as? RunometerNavigationController)?.updateStyle()

        // The point of observing the runs here is to reload the widget timeline when something changes. I would like to put the widget timeline reload code here, but for some reason this completion block does not get called when the app is in the background, so the widget timeline is reloaded in HealthKitRunProvider's observe method.
        runObserver.observe { _ in }
    }

}
