//
//  UITableViewCellEx.swift
//  Architecture
//
//  Created by Александр Колесник on 30.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit
import RxSwift

protocol InterfaceItemSelectedDelegate: InterfaceItemDelegate {
    func selected(object: Any?)
}

protocol InterfaceItemDeleteDelegate: InterfaceItemDelegate {
    func delete(object: Any?)
}

protocol InterfaceItemDelegate: NSObject {
    
    func action(object: Any?)
}

class AKTableViewCell: UITableViewCell {
    
    deinit {
        print("\(self) deinit")
    }
    
    weak var mTableView: UITableView? = nil
    weak var mConstructor: AKTableConstructor? = nil
    weak var delegate: InterfaceItemDelegate? = nil
    weak var defaultObject: DefaultObject? = nil
    weak var cellData: CellSuperClass? = nil

    var disposeBag: DisposeBag = DisposeBag()
    var validateItem: ValidateItem? = nil
    var mIndexPath: IndexPath? = nil
    var anyObject: Any? = nil
    
    func isValidField() -> (Bool, UIView?) {
        return (true, nil)
    }
    
    override func configure(_ data: CellSuperClass) {
        super.configure(data)
        defaultObject = data.info
        delegate = data.info?.delegate
        cellData = data
    }
    
    func showError(_ error: String) {}
    @objc func dismissField() { hideKeyboard() }
    
    func animateSelection(sender: UIView, block: @escaping () -> ()) {
        UIView.animate(withDuration: 0.3, animations: {
            sender.backgroundColor = UIColor.akGreen.withAlphaComponent(0.3)
        }) { _ in
            block()
            UIView.animate(withDuration: 0.3, animations: {
                sender.backgroundColor = .clear
            }) { _ in
                
            }
        }
    }
    
    func reloadUI(object: Any? = nil) {}
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if let indicatorButton = subviews.compactMap({ $0 as? UIButton }).last {
            let image = indicatorButton.backgroundImage(for: .normal)?.withRenderingMode(.alwaysTemplate)
            indicatorButton.setBackgroundImage(image, for: .normal)
            indicatorButton.tintColor = .akGreen
        }
    }
    
}

extension UITableViewCell {

    var tableView: UITableView? {
        var sView = superview
        if sView is UITableView {
            return sView as? UITableView
        }
        while sView != nil {
            sView = sView?.superview
            if sView is UITableView {
                return sView as? UITableView
            }
        }
        return nil
    }

    func leftSeparatorInset(_ left: CGFloat) {
        if responds(to: #selector(getter: UIView.preservesSuperviewLayoutMargins)) {
            layoutMargins = UIEdgeInsets(top: 0, left: left, bottom: 0, right: 0)
        }
        if responds(to: #selector(getter: UITableViewCell.separatorInset)) {
            separatorInset = UIEdgeInsets(top: 0, left: left, bottom: 0, right: 0)
        }
    }

    @objc func configure(_ data: CellSuperClass) {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

}

