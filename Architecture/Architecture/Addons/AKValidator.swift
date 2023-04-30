//
//  AKValidator.swift
//  Architecture
//
//  Created by Александр Колесник on 30.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

public protocol EnumErrorProtocol {

    var title: String? { get }

}

enum AKValidationEnum: Equatable {
    
    case none, error(String)
    
}

class AKValidationError: EnumErrorProtocol {
    
    public init() {}
    
    public init(with enumValue: AKValidationEnum) {
        value = enumValue
    }
    
    var value: AKValidationEnum = .none
    
    var title: String? {
        switch value {
        case .none: return nil
        case .error(let string): return string
        }
    }
    
}
// MARK: - below example of usage based on a bfride pattern
/*
enum PhoneError: EnumErrorProtocol {

    case none
    case short
    case long
    case exist

    var title: String? {
        switch self {
        case .none: return nil
        case .short: return AKLocalizedString("value_too_short", comment: "")
        case .long: return AKLocalizedString("value_too_long", comment: "")
        case .exist: return AKLocalizedString("not_registered", comment: "")
        }
    }

}

enum PasswordError: EnumErrorProtocol {

    case none
    case short
    case mismatch
    case error

    var title: String? {
        switch self {
        case .none: return nil
        case .short: return AKLocalizedString("password_too_short", comment: "")
        case .mismatch: return AKLocalizedString("passwords_not_equal", comment: "")
        case .error: return AKLocalizedString("wrong_password", comment: "")
        }
    }

}

enum IDError: EnumErrorProtocol {

    case none
    case touch
    case face

    var title: String? {
        switch self {
        case .none: return nil
        case .touch: return AKLocalizedString("touch_id_enter", comment: "")
        case .face: return AKLocalizedString("face_id_enter", comment: "")
        }
    }

    var explanation: String? {
        switch self {
        case .none: return nil
        case .touch: return AKLocalizedString("touch_id_description", comment: "")
        case .face: return AKLocalizedString("face_id_description", comment: "")
        }
    }

}
*/
public protocol ValidateOption {

    var pattern: String { get }
    var predicate: NSPredicate { get }
    var body: String { set get }
    var item: ValidateItem { set get }

}

public enum ValidateItem: String {

    case name = "[A-Za-z-\\p{Cyrillic}]{3,}"
    case phone = "[0-9]{9,11}"
    case cellPhone = "\\+?[0-9]{11,17}"
    case prettyPhone = "\\+[0-9]{2}\\([0-9]{3}\\)[0-9]{3}\\-[0-9]{2}\\-[0-9]{2}"
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    case link = ""
    case youtube = "^((?:https?:)?\\/\\/)?((?:www|m)\\.)?((?:youtube\\.com|youtu.be))(\\/(?:[\\w\\-]+\\?v=|embed\\/|v\\/)?)([\\w\\-]+)(\\S+)?$"
    case numbers = "[0-9]"
    case password = "[A-Z0-9a-z-\\p{Cyrillic}]{6,}"
    case floats = "(\\d+(\\,\\d+)?)"
    case depositName = "^[^ ][0-9A-Za-z-\\p{Cyrillic} -!,:'’‘]{2,50}"
    case templateName = "^[^ ][0-9A-Za-z-\\p{Cyrillic} -!,:'’‘]{1,30}"
    case address = "^[^ ][0-9A-Za-z-\\p{Cyrillic} -,.:'’‘]{2,}"
    case latinName = "^[^ ][a-zA-Z '’‘]{1,49}"
    case inn = "[0-9]{10}"
    case amount = "^(?!(0))[0-9]{1,9}+([.0-9]{2,3})?"
    case amountZeros = "[0-9]{1,9}+([.0-9]{2,3})?"
    case houseNumber = "[0-9]{1,}([A-Za-z-\\p{Cyrillic}]{1})?"

    var errorString: String {
        switch self {
        case .phone, .cellPhone, .prettyPhone: return NSLocalizedString("auth_phone_error", comment: "")
        case .password: return NSLocalizedString("auth_password_error", comment: "")
        default: return NSLocalizedString("wrong_format", comment: "")
        }
    }
    
    var key: String {
        switch self {
        case .inn: return "itn"
        default: return rawValue
        }
    }
}

public struct ValidValue: ValidateOption {

    public var body: String
    public var item: ValidateItem

    public var pattern: String {
        return item.rawValue
    }

    public var predicate: NSPredicate {
        switch item {
        case .link: return NSPredicate()
        default: return NSPredicate(format: "SELF MATCHES %@", pattern)
        }
    }

    var isValid: AKValidationError {
        switch item {
        case .link: return isValidLink
        case .inn:
            var set = Set<Character>()
            let squeezed = body.filter { set.insert($0).inserted }
            let result = predicate.evaluate(with: body)
            return result && squeezed.count != 1 ?  AKValidationError() : AKValidationError(with: .error(item.errorString))
        default: return predicate.evaluate(with: body) ? AKValidationError() : AKValidationError(with: .error(item.errorString))
        }
    }

    private var isValidLink: AKValidationError {
        guard let url = URL(string: self.body)
            else {
                return AKValidationError(with: .error(NSLocalizedString("url_is_nil", comment: "")))
        }
        return UIApplication.shared.canOpenURL(url) ? AKValidationError() : AKValidationError(with: .error(NSLocalizedString("cant_open_url", comment: "")))
    }

    public init(body: String, type: ValidateItem) {
        self.body = body
        self.item = type
    }

}

open class AKValidator: NSObject {

    class func isValid(_ some: String?, type: ValidateItem) -> AKValidationError {
        guard let some = some
            else {
                return AKValidationError(with: .error(NSLocalizedString("value_is_nil", comment: "")))
        }
        return ValidValue(body: some, type: type).isValid
    }

}


