//
//  RunometerVisualEffectView.swift
//  Runometer
//
//  Created by Svante Dahlberg on 4/16/20.
//  Copyright © 2020 Svante Dahlberg. All rights reserved.
//

import UIKit

/// Subclass of UIVisualEffectView that changes blur effect when trait collection changes
class RunometerVisualEffectView: UIVisualEffectView {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateBlurEffect()
    }

    var blurEffectProvider: ((_ traitCollection: UITraitCollection) -> UIBlurEffect.Style)? = {
        Appearance.blurEffect(for: $0)
    } {
        didSet {
            updateBlurEffect()
        }
    }

    private func updateBlurEffect() {
        guard let style = blurEffectProvider?(traitCollection) else { return }
        effect = UIBlurEffect(style: style)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateBlurEffect()
    }

}
