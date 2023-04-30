//
//  AKLocalizedTextsViewModel.swift
//  Architecture
//
//  Created by Александр Колесник on 30.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit
import RxSwift

// Must pe placed in folder with other responses
// Placed here just for example, to show logic of usage

class AKTextsDBResponse: Codable {

    private var texts: [AKTextDBObject] = []
    
    var allTexts: [String: String] { texts
        .map { [$0.mKey: $0.mText] }
        .flatMap { $0 }
        .reduce([String: String]()) { dict, tuple  in
            var dictionary = dict
            dictionary.updateValue(tuple.1, forKey: tuple.0)
            return dictionary
        }
    }
    
}

class AKTextDBObject: Codable {
    
    private var key: String? = nil
    private var text: String? = nil
    
    var mKey: String { key ?? "" }
    var mText: String { text ?? "" }
    
}

// Requests below are example, to show how to
// not for usage in prod

class AKLocalizedTextsViewModel: AKBaseViewModel {

    func loadTexts(sid: String? = nil, time: String = "null") -> Observable<AKDataResponse<AKTextsDBResponse>?> {
        var dictionary: [String: Any] = ["data": ["platform": appOS, "date": time]]
        return requestCodable(request: .init(with: .example(dictionary)), typeOf: AKDataResponse<AKTextsDBResponse>.self)
    }
    
    func uploadText(_ key: String, value: String, locale: String) {
        let parameters: [String: Any] = ["key": key, "value": value, "locale": locale]
        requestDictionary(request: .init(with: .example(parameters)))
            .subscribe(onNext: { dictionary in
                print("text saved")
            })
            .disposed(by: disposedBag)
    }
    
}
