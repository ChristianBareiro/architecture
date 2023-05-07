//
//  AKDBSuperObject.swift
//  Architecture
//
//  Created by Александр Колесник on 07.05.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit
import RealmSwift

class AKDBSuperObject: Object, Codable {

    private var id: String? = nil
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}
