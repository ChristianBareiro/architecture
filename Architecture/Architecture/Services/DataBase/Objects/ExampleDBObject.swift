//
//  ExampleDBObject.swift
//  Architecture
//
//  Created by Александр Колесник on 07.05.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

class ExampleDBObject: AKDBSuperObject {
    
    private var stringValue: String? = nil
    private var doubleValue: Double? = nil
    private var boolValue: Bool? = nil
    
    // here can be your parser implemented
    
}

// MARK: - getters

extension ExampleDBObject: ExampleDBProtocol {
    
    var parameter1: String? { stringValue }
    var parameter2: Double? { doubleValue }
    var parameter3: Bool? { boolValue }
    
}
