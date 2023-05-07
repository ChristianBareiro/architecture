//
//  ExampleViewModel.swift
//  Architecture
//
//  Created by Александр Колесник on 06.05.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit
import RxSwift

struct ExampleResponse: Codable {
    
}

class ExampleViewModel: AKBaseViewModel {
    
    var listener: PublishSubject<ExampleResponse> = PublishSubject()

    func loadInfo() {
        let parameters: [String: Any] = [:]
        requestDictionary(request: .init(with: .example(parameters)))
            .subscribe(onNext: { [weak self] response in
                guard
                    let data = response["data"] as? [String: Any],
                    let object = try? ExampleResponse(from: data)
                else { return }
                self?.listener.onNext(object)
            })
            .disposed(by: disposedBag)
    }
    
    func loadMore() -> Observable<ExampleResponse?> {
        let parameters: [String: Any] = [:]
        return requestCodable(request: .init(with: .example(parameters)), typeOf: AKDataResponse<ExampleResponse>.self)
            .flatMap { response -> Observable<ExampleResponse?> in
                return Observable.just(response?.mData)
            }
    }
    
}
