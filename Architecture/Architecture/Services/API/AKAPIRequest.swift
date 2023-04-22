//
//  AKAPIRequest.swift
//  Architecture
//
//  Created by Александр Колесник on 22.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

protocol ObjectRequest {

    var request: String { set get }
    var response: Codable.Type? { set get }
    var parameters: [String: Any] { set get }
    var method: Alamofire.HTTPMethod { set get }
    var headers: [String: String]? { set get }

}

class SuperRequest: ObjectRequest {
    
    var request: String = ""
    var parameters: [String: Any] = [:]
    var method: HTTPMethod = .post
    var headers: [String: String]? = AKAPIConfigs.headers
    var response: Codable.Type? = nil
    
}

class AKAttachObject {
    
    private var id: String?
    private var title: String?
    private var data: Data?
    private var fileName: String?
    private var fileKeyPath: String?
    
    init(iid: String, iTitle: String, iData: Data?, fName: String, url: URL? = nil) {
        id = iid
        title = iTitle
        data = iData
        fileName = fName
        fileKeyPath = url == nil ? "image" : "file"
        if url != nil { downloadData(by: url!)}
    }
    
    var mId: String { id ?? "" }
    var mTitle: String { title ?? "" }
    var mData: Data? { data }
    var mFileName: String { fileName ?? "" }
    var mFileKey: String { fileKeyPath ?? "" }
    
    private func downloadData(by: URL) {
        DispatchQueue.global(qos: .background).async { self.data = try? Data(contentsOf: by) }
    }
    
}


private class AKRequest: SuperRequest {
    
    init(with params: [String: Any], req: String, httpMethod: HTTPMethod = .post) {
        super.init()
        parameters = params
        if parameters[kAPIRequestRef] == nil { parameters[kAPIRequestRef] = String.random(20) }
        method = httpMethod
    }
    
}

enum ObjectAPIRequest {

    case getObject(ObjectRequest)

    var current: ObjectRequest {
        switch self {
        case .getObject(let req): return req
        }
    }

}

enum EndPointValue {
    
    case example([String: Any])
    case getExample([String: Any])

    var requestClass: ObjectRequest {
        switch self {
        case .example(let parameters),
                .getExample(let parameters):
            return AKRequest(with: parameters, req: request, httpMethod: httpMethod)
        }
    }
    
    private var request: String {
        return mainPath + restPath
    }
    
    private var mainPath: String {
        switch self {
        case .example: return AKAPIPath.example.rawValue
        case .getExample: return AKAPIPath.example.rawValue
        default: assertionFailure("Unknown path to send request"); return ""
        }
    }
    
    private var restPath: String {
        switch self {
        case .example: return RESTPath.example.rawValue
        case .getExample(let params): return RESTPath.example.rawValue + URLParameters(params)
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getExample: return .get
        default: return .post
        }
    }
    
    private func URLParameters(_ source: [String: Any]) -> String! {
        return "?" + source.map {"\($0.key)=\($0.value)" }.joined(separator: "&")
    }
    
}

class AKAPIRequest: NSObject {

    private var value: EndPointValue!
    
    init(with loginValue: EndPointValue) {
        value = loginValue
    }
    
    var aRequest: ObjectRequest { value.requestClass }
    
    open var request: ObjectAPIRequest { .getObject(aRequest) }
    
}
