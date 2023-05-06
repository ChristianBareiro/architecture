//
//  ExampleModel.swift
//  Architecture
//
//  Created by Александр Колесник on 06.05.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

class ExampleModel: AKRouterModel {
    
    private var value: SimpleValueProtocol!

    init(object: SimpleValueProtocol) {
        super.init()
        hideBottomButton = false
        screenTitle = object.title
        value = object
    }
    
    override func bottomButtonTapped() {
        super.bottomButtonTapped()
        router.openExample(object: value)
//        or you can work with navigation controller
//        navigationController?.showModel(model: ExampleModel(object: value))
    }
    
}