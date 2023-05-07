//
//  AKFirstViewController.swift
//  Architecture
//
//  Created by Александр Колесник on 06.05.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

protocol SimpleValueProtocol {
    
    var title: String? { get }
    var details: String? { get }
    var image: UIImage? { get }
    var anyObject: Any? { get }
    
    func action(object: Any)
    
}

extension SimpleValueProtocol {
    
    var title: String? { nil }
    var details: String? { nil }
    var image: UIImage? { nil }
    var anyObject: Any? { nil }
    
    func action(object: Any) {}
    
}

enum FakeData: CaseIterable, SimpleValueProtocol {
    
    case first, second, third, fourth, fifth
    
    var title: String? {
        switch self {
        case .first: return "first"
        case .second: return "second"
        case .third: return "third"
        case .fourth: return "fourth"
        case .fifth: return "fifth"
        }
    }
    
    var anyObject: Any? {
        switch self {
        case .first: return UIColor.red
        case .second: return UIColor.blue
        case .third: return UIColor.black
        case .fourth: return UIColor.brown
        case .fifth: return UIColor.purple
        }
    }
    
}

class TableExampleInfo: Info {
    
    init(array: [SimpleValueProtocol], canLoadMore: Bool = false) {
        super.init()
        sectionInfo = [mySection(array: array)]
        if canLoadMore { sectionInfo.append(loaderSection) }
    }
    
    private func mySection(array: [SimpleValueProtocol]) -> HFSuperClass {
        var section = HFSuperClass()
        section.data = array.map { CellSuperClass(id: .textWithImage, object: $0) }
        return section
    }
    
    private var loaderSection: HFSuperClass {
        var section = HFSuperClass()
        section.data = [CellSuperClass(id: .preloader)]
        return section
    }
    
}

class AKFirstViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var constructor: AKTableConstructor? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initConstructor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sessionCache.mTabbarController?.hideBottomBar(false)
    }
    
    private func initConstructor() {
        // as empty info ConstructorSuperClass() can be used
        // if your table is refreshable (means pull to refresh implemented)
        // refreshData must be implemented
        constructor = AKTableConstructor(tableView: tableView, info: TableExampleInfo(array: FakeData.allCases), refreshable: true)
        constructor?.handler = { [weak self] path, object in
            guard let value = object?.object as? SimpleValueProtocol else { return }
            self?.navigationController?.showModel(model: ExampleModel(object: value))
        }
    }

    override func refreshData(_ block: @escaping SuccessHandler) {
//        super.refreshData(block) don't call
        constructor?.info = TableExampleInfo(array: [FakeData.second, FakeData.third, FakeData.fourth])
        // do everything you need and then call block, to inform constructor
        // you finished your updates and want to perform some changes inside
        // block(true)
    }
    
}
