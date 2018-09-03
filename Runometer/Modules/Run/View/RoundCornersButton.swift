//
//  RoundCornersButton.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-02-11.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import UIKit


@IBDesignable class RoundCornersButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = frame.height/2
    }
    
}
