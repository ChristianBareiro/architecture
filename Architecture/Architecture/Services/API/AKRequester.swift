//
//  AKRequester.swift
//  Architecture
//
//  Created by Александр Колесник on 22.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit
import Alamofire
import SystemConfiguration
import RxAlamofire
import RxSwift

class AKRequester {

    // USAGE: - https://github.com/RxSwiftCommunity/RxAlamofire

    private var disposeBag: DisposeBag = DisposeBag()
    var manager = Alamofire.SessionManager.default
    let validator = AKResponseValidator()

    private let rManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = AKAPIConfigs.timeoutInterval
        manager = Alamofire.SessionManager(configuration: configuration)
        listenToReachability()
    }

    private func listenToReachability() {
        let listener: Alamofire.NetworkReachabilityManager.Listener = { status in
            switch status {
            case .notReachable, .unknown:
                sharedInjector.reachabilityRx.onNext(false)
                debugPrint("Internet connection is not available")
            case .reachable(let type):
                sharedInjector.reachabilityRx.onNext(true)
                debugPrint("Internet connection available via \(type)")
            }
        }
        rManager?.listener = listener
        rManager?.startListening()
    }
    
    func uploadRequest(data: MultipartFormData, request: String, method: Alamofire.HTTPMethod = .post, parameters: [String: Any]? = nil, headers: [String: String]? = nil) -> Observable<AKResponse> {
        cancelRequestIfExisted(request)
        guard let mData = try? data.encode() else { return Observable.just(AKResponse(code: .zero)) }
        let headers: HTTPHeaders = ["Content-Type": "multipart/form-data",
                       "Accept": "application/json"]
        return manager
            .upload(mData, to: request, headers: headers)
            .rx.responseJSON()
            .do(onError: { error in
                //show error if needed
            })
            .flatMap { response -> Observable<AKResponse> in
                debugPrint("RESPONSE \(String(format: "%@", response.debugDescription))")
                return self.validator.checkResponse(response: response)
            }
    }

    func sendRequest(request: String, method: Alamofire.HTTPMethod, parameters: [String: Any]? = nil, headers: [String: String]? = nil) -> Observable<AKResponse> {
        // use retrier if needed
        debugPrint("SENDING AT \(Date())")
        debugPrint("REQUEST \(request)")
        debugPrint("METHOD \(method)")
        debugPrint("PARAMETERS \(parameters ?? [:])")
        debugPrint("HEADERS \(headers ?? [:])")
        cancelRequestIfExisted(request)
        let encoding: ParameterEncoding = method == .get ? URLEncoding.default : JSONEncoding.default
        return manager
            .rx
            .request(method, request, parameters: parameters, encoding: encoding, headers: headers)
            .retry(AKAPIConfigs.maxAttempts)
            .responseJSON()
            .flatMap { response -> Observable<AKResponse> in
                debugPrint("RESPONSE \(String(format: "%@", response.debugDescription))")
                return self.validator.checkResponse(response: response)
        }
    }

    func cancelAll() {
        manager.session.getTasksWithCompletionHandler { dataTasks, _, _ in
            dataTasks.forEach { $0.cancel() }
        }
    }

    private func cancelRequestIfExisted(_ request: String?) {
        manager.session.getTasksWithCompletionHandler { dataTasks, _, _ in
            dataTasks.forEach {
                if $0.originalRequest?.url?.absoluteString == request {
                    $0.cancel()
                    debugPrint("request \(request ?? "") cancelled")
                }
            }
        }
    }
    
}
