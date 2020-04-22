//
//  StringExtensions.swift
//  Runometer
//
//  Created by Svante Dahlberg on 4/20/20.
//  Copyright © 2020 Svante Dahlberg. All rights reserved.
//

import Foundation

extension String {

    func firstLetterCapitalized() -> String {
        prefix(1).capitalized + dropFirst()
    }

}
