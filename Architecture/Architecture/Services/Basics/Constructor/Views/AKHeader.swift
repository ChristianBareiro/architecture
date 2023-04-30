//
//  AKHeader.swift
//  Architecture
//
//  Created by Александр Колесник on 30.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit
import RxSwift

protocol HeaderFooterProtocol: UITableViewHeaderFooterView {
    func configure(object: HeaderFooter?)
}

class CollectionHeader: UICollectionReusableView {
    
    // MARK: - @IBOutlets
    
    @IBOutlet weak var lcTopConstraint: NSLayoutConstraint?
    @IBOutlet weak var separatorView: UIView? {
        didSet {
            separatorView?.backgroundColor = .gray
        }
    }
    
    @IBOutlet weak var label: UILabel? {
        didSet {
            label?.textColor = .gray
            label?.font = .regular12
        }
    }
    @IBOutlet weak var labelTopConstraint: NSLayoutConstraint?
    
    // MARK: - Private Properties
    
    private weak var delegate: InterfaceItemDelegate? = nil
    // MARK: - Public Methods
    
    public func configure(header: HeaderFooter?) {
        if let attributedText = header?.attributedText {
            label?.attributedText = attributedText
        } else {
            label?.text = header?.text
            label?.textAlignment = header?.textAlignment ?? .left
            label?.textColor = header?.textColor
            label?.font = header?.font
            
            if let insets = header?.insets {
                lcTopConstraint?.constant = insets.top
            }
        }
    }
    
}

class Header: UITableViewHeaderFooterView {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel?
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var checkButton: UIButton?
    @IBOutlet weak var stackView: UIStackView?
    @IBOutlet weak var filterButton: UIButton?
    @IBOutlet weak var analyticButton: UIButton?
    @IBOutlet weak var leadingHeaderConstraint: NSLayoutConstraint?
    
    var section: Int = 0
    var anyObject: Any? = nil
    
    // MARK: - Actions
    
    @IBAction func openFilter(_ sender: Any) {
        print("filter")
    }
    
    // MARK: - Helper methods
    
    func shouldHideStackView(hide: Bool) {
        stackView?.isHidden = hide
    }
    
}

