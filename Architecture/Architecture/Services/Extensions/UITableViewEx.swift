//
//  UITableViewEx.swift
//  Architecture
//
//  Created by Александр Колесник on 30.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit

extension UITableView {
    
    var epptyTableConstructor: AKTableConstructor { AKTableConstructor(tableView: self, info: ConstructorSuperClass()) }
    
    func allowsHeaderViewsToFloat() -> Bool { return false }
    
    func animateCellSelection(at indexPath: IndexPath, _ block: (() -> ())?) {
        guard let array = indexPathsForVisibleRows else { return }
        for i in 0..<array.count {
            let delay = Double(i) * 0.1
            let path = array[i]
            guard let cell = cellForRow(at: path) else { continue }
            var desiredFrame = cell.frame
            desiredFrame.origin.x = path.row == indexPath.row && path.section == indexPath.section ? desiredFrame.size.width : -desiredFrame.size.width
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {[weak self] in
                self?.animateCell(cell, to: desiredFrame)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(array.count) * 0.1) { [weak self] in
            block?()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self?.reloadData()
            })
        }
    }
    
    func animateCellSelection(_ block: (() -> ())?) {
        guard let array = indexPathsForVisibleRows else { return }
        for i in 0..<array.count {
            let delay = Double(i) * 0.1
            let isOdd = i % 2 == 0
            let path = array[i]
            guard let cell = cellForRow(at: path) else { continue }
            var desiredFrame = cell.frame
            desiredFrame.origin.x = isOdd ? desiredFrame.size.width : -desiredFrame.size.width
            cell.frame = desiredFrame
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {[weak self] in
                desiredFrame.origin.x = .zero
                cell.contentView.alpha = 1
                self?.animateCell(cell, to: desiredFrame)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(array.count) * 0.1) { [weak self] in
            block?()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self?.reloadData()
            })
        }
    }
    
    private func animateCell(_ cell: UITableViewCell, to frame: CGRect) {
        UIView.animate(withDuration: 0.3) {[weak cell] in
            cell?.frame = frame
        }
    }
    
}
