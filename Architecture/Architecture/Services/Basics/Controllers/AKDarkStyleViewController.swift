//
//  DarkStyleViewController.swift
//  Architecture
//
//  Created by Александр Колесник on 30.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

class AKDarkStyleViewController: AKNotificatedViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.akBlack]
        setNeedsStatusBarAppearanceUpdate()
    }
    
}

