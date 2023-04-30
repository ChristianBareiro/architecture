//
//  AKLocalizedString.swift
//  Architecture
//
//  Created by Александр Колесник on 30.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit
import RxSwift

public typealias LocalizedClosure = (String?) -> ()

public func AKLocalizedString(_ key: String, comment: String, _ unchangableLocale: String? = nil) -> String { AKLocalizedString(key, comment: comment, defUA: nil, defRU: nil, unchangableLocale) }

public func AKLocalizedString(_ key: String, comment: String, defUA: String? = nil, defRU: String? = nil, _ unchangableLocale: String? = nil) -> String {
    let placeholder = NSLocalizedString(key, comment: "")
    let unchangableArray: [String] = []
    return unchangableArray.contains(key) ? placeholder : localizer.localized(key: key, placeholder: placeholder, unchangableLocale)
}

// Example for three locales
// Can be easily simplified with enum
// but its your problem

let kFBTextsRequest = "lastTimeTextsRequest"
let kSavedFBTextsRu = "savedFSTextsRu"
let kSavedFBTextsUk = "savedFSTextsUk"
let kSavedFBTextsEn = "savedFSTextsEn"

let kSavedABTextsRu = "savedAKTextsRu"
let kSavedABTextsUk = "savedAKTextsUk"
let kSavedABTextsEn = "savedAKTextsEn"
let kSavedRuTextsTimeStamp = "kSavedRuTextsTimeStamp"
let kSavedUATextsTimeStamp = "kSavedUATextsTimeStamp"
let kSavedENTextsTimeStamp = "kSavedENTextsTimeStamp"
let appOS: String = "ios"

let localizer = sharedInjector.localizer

class AKLocalizableString: NSObject {
    
    private let uaLocale = "uk"
    private let ruLocale = "ru"
    private let enLocale = "en"
    private var ruDict: [String: String] = [:]
    private var uaDict: [String: String] = [:]
    private var enDict: [String: String] = [:]
    
//    MARK: - for Firestore usage
//    private let database = Firestore.firestore()
//    private var ref: DocumentReference? = nil
    
    private var canUpload: Bool = false
    private var viewModel: AKLocalizedTextsViewModel = AKLocalizedTextsViewModel()
    private var disposeBag: DisposeBag = DisposeBag()
    
    private var locale: String { sessionCache.currentLocalization }
    private var timeStampForLocaleDouble: Int {
        switch locale {
        case uaLocale: return UserDefaults.standard.integer(forKey: kSavedUATextsTimeStamp)
        case ruLocale: return UserDefaults.standard.integer(forKey: kSavedRuTextsTimeStamp)
        case enLocale: return UserDefaults.standard.integer(forKey: kSavedENTextsTimeStamp)
        default: return .zero
        }
    }
    private var timeStampForLocale: String { timeStampForLocaleDouble == .zero ? "null" : "\(timeStampForLocaleDouble)" }
    
    override init() {
        super.init()
        // load or update local texts on start
        loadSavedTexts()
//        MARK: - update once in three days logic
//        let time = TimeInterval(UserDefaults.standard.double(forKey: kFBTextsRequest))
//        let passed = Date().timeIntervalSince(Date(timeIntervalSince1970: time))
//        passed / 86400 > 3 ? downloadTexts() : loadSavedTexts()
    }
    
    func loadSavedTexts() {
        ruDict = UserDefaults.standard.dictionary(forKey: kSavedABTextsRu) as? [String: String] ?? UserDefaults.standard.dictionary(forKey: kSavedFBTextsRu) as? [String: String] ?? [:]
        uaDict = UserDefaults.standard.dictionary(forKey: kSavedABTextsUk) as? [String: String] ?? UserDefaults.standard.dictionary(forKey: kSavedFBTextsUk) as? [String: String] ?? [:]
        enDict = UserDefaults.standard.dictionary(forKey: kSavedABTextsEn) as? [String: String] ?? UserDefaults.standard.dictionary(forKey: kSavedFBTextsEn) as? [String: String] ?? [:]
    }
    
    func downloadTexts(sid: String? = nil) {
        viewModel.loadTexts(sid: sid, time: timeStampForLocale)
            .subscribe(onNext: {[weak self] response in
                self?.canUpload = true
                guard
                    let self = self,
                    let texts = response?.mData?.allTexts,
                    !texts.isEmpty
                else { return }
                switch self.locale {
                case self.ruLocale:
                    self.ruDict.merge(texts) { $1 }
                    UserDefaults.standard.set(self.ruDict, forKey: kSavedABTextsRu)
                    UserDefaults.standard.set(Int(Date().timeIntervalSince1970), forKey: kSavedRuTextsTimeStamp)
                case self.uaLocale:
                    self.uaDict.merge(texts) { $1 }
                    UserDefaults.standard.set(self.uaDict, forKey: kSavedABTextsUk)
                    UserDefaults.standard.set(Int(Date().timeIntervalSince1970), forKey: kSavedUATextsTimeStamp)
                case self.enLocale:
                    self.enDict.merge(texts) { $1 }
                    UserDefaults.standard.set(self.enDict, forKey: kSavedABTextsEn)
                    UserDefaults.standard.set(Int(Date().timeIntervalSince1970), forKey: kSavedENTextsTimeStamp)
                default: break
                }
            })
            .disposed(by: disposeBag)
    }
    
    func localized(key: String, placeholder: String, _ unchangableLocale: String? = nil) -> String {
        let localLocale = unchangableLocale ?? locale
        let result = localLocale == ruLocale ? ruDict[key] : localLocale == uaLocale ? uaDict[key] : enDict[key]
        if result == nil && (!key.isEmpty && !placeholder.isEmpty) {
            if localLocale == ruLocale { ruDict[key] = placeholder }
            else if localLocale == uaLocale { uaDict[key] = placeholder }
            else if localLocale == enLocale { enDict[key] = placeholder }
            return placeholder
        }
        return (result == key ? placeholder : result ?? placeholder).replacingOccurrences(of: "\\n", with: "\n")
    }

    public func addTo(locale: String, string: String, key: String) {
        viewModel.uploadText(key, value: string, locale: locale)
    }
    
}

// MARK: - Firebase usage
 
 // ios - collection
 // -- en - document
 // -- -- -- key
 // -- -- -- value
 /*
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

extension ABLocalizableString {
    
    private func loadSavedTextsFS() {
        ruDict = UserDefaults.standard.dictionary(forKey: kSavedFBTextsRu) as? [String: String] ?? [:]
        uaDict = UserDefaults.standard.dictionary(forKey: kSavedFBTextsUk) as? [String: String] ?? [:]
        enDict = UserDefaults.standard.dictionary(forKey: kSavedFBTextsEn) as? [String: String] ?? [:]
    }
    
    private func downloadTextsFS() {
        database.collection(appOS).document(ruLocale).getDocument {[weak self] snapshot, error in
            self?.ruDict = snapshot?.data() as? [String: String] ?? [:]
            UserDefaults.standard.set(self?.ruDict, forKey: kSavedFBTextsRu)
        }
        database.collection(appOS).document(uaLocale).getDocument {[weak self] snapshot, error in
            self?.uaDict = snapshot?.data() as? [String: String] ?? [:]
            UserDefaults.standard.set(self?.uaDict, forKey: kSavedFBTextsUk)
        }
        database.collection(appOS).document(enLocale).getDocument {[weak self] snapshot, error in
            self?.enDict = snapshot?.data() as? [String: String] ?? [:]
            UserDefaults.standard.set(self?.enDict, forKey: kSavedFBTextsEn)
        }
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: kFBTextsRequest)
    }
    
    public func putString(uaString: String, ruString: String, enString: String, key: String) {
        addToFS(locale: uaLocale, string: uaString, key: key)
        addToFS(locale: ruLocale, string: ruString, key: key)
        addToFS(locale: enLocale, string: enString, key: key)
    }
    
    public func addToFS(locale: String, string: String, key: String) {
        database.collection(appOS).document(locale).setData([key: string], mergeFields: [key])
    }
    
    private func replaceAllTexts(locale: String) {
        if
            let path = Bundle.main.path(forResource: "Localizable", ofType: "strings"),
            let dictionary = NSDictionary.init(contentsOfFile: path) as? [String: String] {
            for (key, value) in dictionary {
                AKLocalizableString.shared.addTo(locale: locale, string: value, key: key)
            }
        }
    }
    
}
*/
