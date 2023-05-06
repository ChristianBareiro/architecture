//
//  AKSecondViewController.swift
//  Architecture
//
//  Created by Александр Колесник on 06.05.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

class CollectionExampleInfo: Info {
    
    init(array: [FakeData]) {
        super.init()
        sectionInfo = [mySection(array: array)]
    }
    
    private func mySection(array: [FakeData]) -> HFSuperClass {
        var section = HFSuperClass()
        section.data = array.map { CellSuperClass(id: .textWithImageC, object: $0, cellSize: CGSize(width: 100, height: 100)) }
        return section
    }
    
}

class AKSecondViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var constructor: AKCollectionConstructor? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initConstructor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sessionCache.mTabbarController?.hideBottomBar(false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sessionCache.mTabbarController?.hideBottomBar(true)
    }
    
    private func initConstructor() {
        // as empty info ConstructorSuperClass() can be used
        // if your table is refreshable (means pull to refresh implemented)
        // refreshData must be implemented
        constructor = AKCollectionConstructor(collectionView: collectionView, info: CollectionExampleInfo(array: FakeData.allCases))
        constructor?.handler = { path, object in
            guard let value = object?.object as? SimpleValueProtocol else { return }
            router.openExample(object: value)
        }
    }

}
