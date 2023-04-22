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
    
    let uiService = AKUIService()
    let themeManager = AKThemeManager()
    let fontManager = AKFontManager()
    let sessionCache = AKSessionCache()
    let serverCommunicator = AKServerCommunicator()
    
    var reachabilityRx: PublishSubject<Bool> = PublishSubject()
    
}
