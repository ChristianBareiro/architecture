//
//  AKInjector.swift
//  Architecture
//
//  Created by Александр Колесник on 22.04.2023.
//  Copyright © 2023 A&A. All rights reserved.

import UIKit
import RxSwift

let sharedInjector = appDelegate.injector

class AKInjector {

    init() {
        AKDBService()
    }
    
    lazy var uiService = { AKUIService() }()
    lazy var  themeManager = { AKThemeManager() }()
    lazy var  fontManager = { AKFontManager() }()
    lazy var  sessionCache = { AKSessionCache() }()
    lazy var  serverCommunicator = { AKServerCommunicator() }()
    lazy var  localizer = { AKLocalizableString() }()
    lazy var  router = { AKRouter() }()
    
    var reachabilityRx: PublishSubject<Bool> = PublishSubject()
    
}
