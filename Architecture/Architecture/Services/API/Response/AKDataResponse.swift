//
//  AKDataResponse.swift
//  Architecture
//
//  Created by Александр Колесник on 22.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

enum ErrorShowStyle: String {
    
    case screen = "screen", tost = "tost"
    
}

enum PopUpType: String {
    
    case error = "error", success = "success", info = "info"
    
}

final class AKResponse: NSObject {

    var request: URLRequest? = nil
    var responseObject: Codable? = nil
    var dictionary: [String: Any]? = nil
    var string: String? = nil
    var data: Data? = nil
    var statusCode: Int? = nil
    var error: ABResponseError? = nil
    
    init(code: Int?) { statusCode = code }

}

class AKDataResponse<ContentType: Codable>: Codable {

    private var status: String? = nil
    private var data: ContentType? = nil
    private var statusCode: Int? = nil
    private var error: ABResponseError? = nil
    private var info: ABResponseError? = nil
    private var success: ABResponseError? = nil

    var mData: ContentType? { return data ?? fakeData }
    var mStatus: String { return status ?? "" }
    var mError: String { return error?.mMessage ?? "" }
    var mFullError: ABResponseError? { return error }
    var fakeData: ContentType? = nil
    var mStatusCode: Int? {
        set { statusCode = newValue }
        get { statusCode }
    }
    
    init(data: ContentType) { self.data = data }
    
}

class ABResponseError: Codable {

    private var status: String? = nil
    private var title: String? = nil
    private var message: String? = nil
    private var sub_message: String? = nil
    private var should_be_shown: Bool? = nil
    private var message_type: String? = nil
    private var should_pop_screen: Bool? = nil
    private var style: String? = nil

    var mTitle: String? { title }
    var mMessage: String? { (sub_message?.isEmpty ?? true) == true ? nil : message }
    var mSubMessage: String? { (sub_message?.isEmpty ?? true) == true ? message : sub_message }
    var type: PopUpType { set { message_type = newValue.rawValue } get { PopUpType(rawValue: message_type ?? "") ?? .error } }
    var mStyle: ErrorShowStyle { ErrorShowStyle(rawValue: style?.lowercased() ?? "") ?? .tost }
    
    func showError() {
        if should_be_shown == false { return }
        if message == nil && sub_message == nil { return }
        if mStyle == .screen { return showMessageScreen() }
        // show alert or whatever
    }
    
    func showMessageScreen() {
        if should_be_shown == false { return }
        if message == nil && sub_message == nil { return }
        // open error screen
    }
    
}
