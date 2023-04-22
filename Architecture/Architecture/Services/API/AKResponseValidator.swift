//
//  AKResponseValidator.swift
//  Architecture
//
//  Created by Александр Колесник on 22.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire

class AKResponseValidator {

    func checkResponse(response: DataResponse<Any>) -> Observable<AKResponse> {
        let akResponse = AKResponse(code: response.response?.statusCode)
        if response.value == nil { return Observable.just(akResponse) }
        let code = response.response?.statusCode
        switch code {
        case 4:
            //JSON serialization error, ignoring
            return Observable.just(akResponse)
        case 401:
            // auth error
            return Observable.just(akResponse)
        case 403:
            // auth error
            return Observable.just(akResponse)
        case 404:
            // auth error
            return Observable.just(akResponse)
        case NSURLErrorTimedOut, NSURLErrorCannotFindHost, -999, -1008:
            return Observable.just(akResponse)
        case 500, 501, 502, 503, 504:
            // access error
            return Observable.just(akResponse)
        default: break
        }
        akResponse.request = response.request
        akResponse.statusCode = code
        if let data = response.data {
            akResponse.dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
        }
        akResponse.string = response.value as? String
        akResponse.data = response.data

        return Observable.just(akResponse)
    }
    
}
