//
//  RunometerNavigationController.swift
//  Runometer
//
//  Created by Svante Dahlberg on 4/4/21.
//  Copyright © 2021 Svante Dahlberg. All rights reserved.
//

import UIKit

class RunometerNavigationController: UINavigationController {

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag, completion: completion)
        viewControllerToPresent.updateStyle()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateStyle()
    }

}
