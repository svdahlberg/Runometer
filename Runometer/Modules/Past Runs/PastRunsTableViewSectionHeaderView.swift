//
//  PastRunsTableViewSectionHeaderView.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-05-13.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import UIKit

class PastRunsTableViewSectionHeaderView: UIView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    init(title: String) {
        super.init(frame: .zero)
        loadFromNib()
        titleLabel.text = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIView {
    
    func loadFromNib() {
        guard let loadedView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView else {
            return
        }
        
        loadedView.frame = bounds
        loadedView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(loadedView)
    }
    
}
