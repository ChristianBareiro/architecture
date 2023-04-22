//
//  AKBaseViewModel.swift
//  Architecture
//
//  Created by Александр Колесник on 22.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire

class AKBaseViewModel {
    
    var disposedBag = DisposeBag()
    var interactor: AKServerInteractor = AKServerInteractor()
    var uiErrorListener: PublishSubject<String> = PublishSubject()
    
    init() {
        listeners()
    }
    
    deinit {
        print("deinit \(self)")
    }
    
    func addLoader() {
        
    }
    
    func removeLoader() {
        
    }
    
    func listeners() { }
    
    func upload<R: Codable>(data: [AKAttachObject], request: AKAPIRequest, typeOf: R.Type) -> Observable<R?> {
        let multipart = MultipartFormData()
        for (index, object) in data.enumerated() {
            multipart.append(object.mData!, withName: "file", fileName: "file\(index).png", mimeType: "image/png")
        }
        for (key, value) in request.aRequest.parameters {
            if value is [String: Any], let data = try? JSONSerialization.data(withJSONObject: value, options: [.prettyPrinted]) {
                multipart.append(data, withName: key)
            } else { multipart.append("\(value)".data(using: .utf8)!, withName: key) }
        }
        return interactor.uploadRequest(data: multipart, request: request.request)
            .flatMap { response -> Observable<R?> in
                guard
                    let data = response.data,
                    let newObject = try? JSONDecoder().decode(typeOf.self, from: data)
                else {
                    if let exData = response.data {
                        do {
                            let _ = try JSONDecoder().decode(typeOf.self, from: exData)
                        } catch {
                            print(error)
                        }
                    }
                    return Observable.just(nil)
                }
                return Observable.just(newObject)
            }
    }
    
    func requestCodable<R: Codable>(request: AKAPIRequest, typeOf: R.Type) -> Observable<R?> {
        return interactor.sendRequest(request: request.request)
            .applyIOSchedulers()
            .flatMap { response -> Observable<R?> in
                guard
                    let data = response.data,
                    let newObject = try? JSONDecoder().decode(typeOf.self, from: data)
                else {
                    if let exData = response.data {
                        do {
                            let _ = try JSONDecoder().decode(typeOf.self, from: exData)
                        } catch {
                            print(error)
                        }
                    }
                    return Observable.just(nil)
                }
                return Observable.just(newObject)
            }
    }
    
    func requestDictionary(request: AKAPIRequest) -> Observable<[String: Any]> {
        return interactor.sendRequest(request: request.request)
            .applyIOSchedulers()
            .flatMap { response -> Observable<[String: Any]> in
                guard
                    let data = response.data,
                    let parsedData = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any]
                else {
                    return Observable.just([:])
                }
                return Observable.just(parsedData)
            }
    }
    
    func convert<T: Codable>(dictionary: [String: Any], to: T.Type) -> T? {
        guard
            let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: []),
            let foo = try? JSONDecoder().decode(to.self, from: jsonData)
        else { return nil }
        return foo
    }
    
}
