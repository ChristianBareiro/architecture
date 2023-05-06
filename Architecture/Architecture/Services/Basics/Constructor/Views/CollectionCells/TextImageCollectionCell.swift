//
//  TextImageCollectionCell.swift
//  Architecture
//
//  Created by Александр Колесник on 06.05.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

class TextImageCollectionCell: AKCollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func configure(_ data: CellSuperClass) {
        super.configure(data)
        if let object = data.info?.object as? SimpleValueProtocol { fillInfo(object: object) }
    }
    
    private func fillInfo(object: SimpleValueProtocol) {
        iconImageView.image = object.image
        nameLabel.text = object.title
        infoLabel.text = object.details
    }
    
}
