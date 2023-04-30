//
//  AKVibration.swift
//  Architecture
//
//  Created by Александр Колесник on 30.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import AVFoundation
import UIKit

enum AKVibration {
    
    case error
    case success
    case warning
    case light
    case medium
    case heavy
    case selection
    case oldSchool
    case none
    
    func vibrate() {
        switch self {
        case .error: UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .success: UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning: UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .light: UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium: UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .heavy: UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        case .selection: UISelectionFeedbackGenerator().selectionChanged()
        case .oldSchool: AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        case .none: ()
        }
    }
}

