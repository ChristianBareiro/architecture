//
//  ExampleDBProtocol.swift
//  Architecture
//
//  Created by Александр Колесник on 07.05.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

protocol ExampleDBProtocol {
    
    var parameter1: String? { get }
    var parameter2: Double? { get }
    var parameter3: Bool? { get }
    
}

extension ExampleDBProtocol {
    
    var parameter1: String? { nil }
    var parameter2: Double? { nil }
    var parameter3: Bool? { nil }
    
}
