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
    private var viewModel: ExampleViewModel = ExampleViewModel()

    init(object: SimpleValueProtocol) {
        super.init()
        hideBottomButton = false
        screenTitle = object.title
        value = object
        info = TableExampleInfo(array: [object, object, object], canLoadMore: true)
        customizeBottomButton = { button in
            button.backgroundColor = object.anyObject as? UIColor ?? .akGreen
            button.setTitleColor(.akWhite, for: .normal)
        }
    }
    
    override func allDataLoaded() {
        super.allDataLoaded()
        constructor?.handler = { [weak self] path, object in
            guard let value = object?.object as? SimpleValueProtocol else { return }
            if path.row == 2 { self?.viewModel.loadInfo() }
            else { router.openExample(object: value) }
        }
    }
    
    override func bottomButtonTapped() {
        super.bottomButtonTapped()
        router.openExample(object: value)
//        or you can work with navigation controller
//        navigationController?.showModel(model: ExampleModel(object: value))
    }
    
    // as is requests are fake subscribe block never works
    // you will see error in terminal
    // its just examples how can it be, with different variants, to show
    // what are the possibilities of Router model and view model
    
    override func listeners() {
        super.listeners()
        viewModel
            .listener
            .subscribe(onNext: { [weak self] response in
                self?.constructor?.info = TableExampleInfo(array: [FakeData.fifth, FakeData.fourth, FakeData.third])
            })
            .disposed(by: disposeBag)
    }
    
    override func action(object: Any?) {
        if let key = object as? String, key == kPreloader {
            viewModel.loadMore()
                .subscribe(onNext: { [weak self] response in
                    self?.constructor?.info = TableExampleInfo(array: [FakeData.first, FakeData.second, FakeData.third])
                })
                .disposed(by: disposeBag)
        }
    }
    
}
