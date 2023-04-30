//
//  UICollectionViewEx.swift
//  Architecture
//
//  Created by Александр Колесник on 30.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    var emptyCollectionConstructor: AKCollectionConstructor { AKCollectionConstructor(collectionView: self, info: ConstructorSuperClass()) }
    
    func animateCellSelection(at indexPath: IndexPath, _ block: (() -> ())?) {
        let array = indexPathsForVisibleItems
        for i in 0..<array.count {
            let delay = Double(i) * 0.1
            let path = array[i]
            guard let cell = cellForItem(at: path) else { continue }
            var desiredFrame = cell.frame
            if path.item == indexPath.item && path.section == indexPath.section {
                desiredFrame.origin.x = UIScreen.main.bounds.size.width
            } else {
                desiredFrame.origin.y = UIScreen.main.bounds.size.height
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.animateCell(cell, to: desiredFrame)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(array.count) * 0.1) {
            block?()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.reloadData()
            })
        }
    }
    
    private func animateCell(_ cell: UICollectionViewCell, to frame: CGRect) {
        UIView.animate(withDuration: 0.3) {
            cell.frame = frame
        }
    }

}

extension UICollectionView {
    func isValid(indexPath: IndexPath) -> Bool {
        return indexPath.section >= 0
            && indexPath.section < self.numberOfSections
            && indexPath.row >= 0
            && indexPath.row < self.numberOfItems(inSection: indexPath.section)
    }
}
