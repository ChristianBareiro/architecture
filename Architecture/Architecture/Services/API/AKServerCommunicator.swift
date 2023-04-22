//
//  AKServerCommunicator.swift
//  Architecture
//
//  Created by Александр Колесник on 22.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift

class AKServerCommunicator {

    private var requester = AKRequester()
    
    func cancelAllRequests() {
        requester.cancelAll()
    }
    
    func objUploadRequest(data: MultipartFormData, object: ObjectAPIRequest) -> Observable<AKResponse> {
        let request = object.current
        return uploadRequest(data: data, request: request.request, method: request.method, parameters: request.parameters, headers: request.headers)
    }
    
    private func uploadRequest(data: MultipartFormData, request: String, method: Alamofire.HTTPMethod, parameters: [String: Any]? = nil, headers: [String: String]? = nil) -> Observable<AKResponse> {
        return requester.uploadRequest(data: data, request: request, method: method, parameters: parameters, headers: headers)
    }

    func objectRequest(object: ObjectAPIRequest) -> Observable<AKResponse> {
        let request = object.current
        return sendRequest(request: request.request, method: request.method, parameters: request.parameters, headers: request.headers)
    }
    
    private func sendRequest(request: String, method: Alamofire.HTTPMethod, parameters: [String: Any]? = nil, headers: [String: String]? = nil) -> Observable<AKResponse> {
        return requester.sendRequest(request: request, method: method, parameters: parameters, headers: headers)
    }

    
}
