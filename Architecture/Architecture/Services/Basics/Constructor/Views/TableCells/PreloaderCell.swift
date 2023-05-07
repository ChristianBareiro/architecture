//
//  PreloaderCell.swift
//  Architecture
//
//  Created by Александр Колесник on 07.05.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

class PreloaderCell: AKTableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func configure(_ data: CellSuperClass) {
        super.configure(data)
        delegate?.action(object: kPreloader)
    }
    
}
