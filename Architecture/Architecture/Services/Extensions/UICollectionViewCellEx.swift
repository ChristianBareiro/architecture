//
//  UICollectionViewCellEx.swift
//  Architecture
//
//  Created by Александр Колесник on 30.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit
import RxSwift

protocol ReusableCell {
    static var identifier: String { get }
}

extension ReusableCell {
    static var identifier: String {
        return String(describing: self)
    }
}

class AKCollectionViewCell: UICollectionViewCell {
    
    deinit {
        print("\(self) deinit")
    }
   
    weak var delegate: InterfaceItemDelegate? = nil
    weak var mConstructor: AKCollectionConstructor? = nil
    weak var mCollectionView: UICollectionView? = nil
    weak var defaultObject: DefaultObject? = nil
    weak var cellData: CellSuperClass? = nil
    var disposeBag: DisposeBag = DisposeBag()
    var validateItem: ValidateItem? = nil
    var mIndexPath: IndexPath? = nil
    var anyObject: Any? = nil
    var isJiggling: Bool = false
    
    func isValidField() -> (Bool, UIView?) {
        return (true, nil)
    }
    
    override func configure(_ data: CellSuperClass) {
        super.configure(data)
        delegate = data.info?.delegate
        defaultObject = data.info
        cellData = data
    }
    
    func showError(_ error: String) {}
    
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
    
    func onSelect() {}
    func onDeselect() {}
    
}

extension UICollectionViewCell {

    var collectionView: UICollectionView? {
        var sView = superview
        if sView is UICollectionView {
            return sView as? UICollectionView
        }
        while sView != nil {
            sView = sView?.superview
            if sView is UICollectionView {
                return sView as? UICollectionView
            }
        }
        return nil
    }

    func calculateHeightForConfiguredSizingCell() -> CGFloat {
        setNeedsLayout()
        layoutIfNeeded()
        return contentView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height + 1.0
    }

    @objc func configure(_ data: CellSuperClass) {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

}

