//
//  AKServerInteractor.swift
//  Architecture
//
//  Created by Александр Колесник on 22.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire

class AKServerInteractor {
    
    private var communicator = sharedInjector.serverCommunicator

    func sendRequest(request: ObjectAPIRequest) -> Observable<AKResponse> {
        return communicator.objectRequest(object: request)
    }
    
    func uploadRequest(data: MultipartFormData, request: ObjectAPIRequest) -> Observable<AKResponse> {
        return communicator.objUploadRequest(data: data, object: request)
    }
    
}
