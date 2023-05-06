//
//  ABTabBar.swift
//  ABank24
//
//  Created by Александр Колесник on 17.08.2021.
//  Copyright © 2021 ABank. All rights reserved.
//

import UIKit
import RxSwift

// MARK: - rude example of implementation custom tabbar
// in fact in real project it must be based on some enum
// and can be dynamic as an example below:

//enum MyTabBarItem: Int, CaseIterable {
//
//    case first = 1, second, third
//
//    var image: UIImage? {
//        switch self {
//        case .first: return UIImage(named: "your_first_item_image")
//        default: return nil
//        }
//    }
//
//    var title: String {
//        switch self {
//        case .first: return AKLocalizedString("item 1", comment: "")
//        default: return AKLocalizedString("item other", comment: "")
//        }
//    }
//
//    // your view for tab item based on enum value
//    var item: UIView { ItemView(value: self) }
//
////    rawValue can be used as a tag or index
//
//}
//
//class ItemView: UIView {
//
//    // this class is not completed and used only as example to show all chain of dependencies
//
//    // outlets if you want
//    private var imageView: UIImageView!
//    private var titleLable: UILabel!
//
//    init(value: MyTabBarItem) {
//        imageView.image = value.image
//        titleLable.text = value.title
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
//
//class AKTabBar: UIView {
//
//    @IBOutlet weak var stackView: UIStackView! {
//        didSet {
//            MyTabBarItem.allCases.forEach { stackView.addArrangedSubview($0.item) }
//        }
//    }
//
//}

typealias AKTabBarItemSelected = (Int) -> ()

class AKTabBar: UIView {
    
    var itemSelected: AKTabBarItemSelected? = nil
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView! {
        didSet {
//            visualEffectView.effect = UIBlurEffect(style: appThemeManager.isDarkTheme ? .dark : .extraLight)
            visualEffectView.effect = nil
            visualEffectView.backgroundColor = .akWhite
        }
    }
    
    @IBOutlet weak var dotView: UIView!

    @IBOutlet weak var bottomSpace1: NSLayoutConstraint!
    @IBOutlet weak var bottomSpace2: NSLayoutConstraint!
    @IBOutlet weak var bottomSpace3: NSLayoutConstraint!
    @IBOutlet weak var bottomSpace4: NSLayoutConstraint!
    @IBOutlet weak var bottomSpace5: NSLayoutConstraint!
    @IBOutlet weak var lineIndicatorView: UIView! {
        didSet {
            lineIndicatorView.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width / 5, height: 5))
            lineIndicatorView.cornerRadius = 2
            lineIndicatorView.backgroundColor = .akGreen
        }
    }
    private var names: [Int: String] = [100: AKLocalizedString("first", comment: ""),
                                        200: AKLocalizedString("second", comment: ""),
                                        300: AKLocalizedString("third", comment: ""),
                                        400: AKLocalizedString("fourth", comment: ""),
                                        500: AKLocalizedString("fifthg", comment: "")]
    
    private let bag = DisposeBag()
    
    static func configure(with rect: CGRect = UIScreen.main.bounds, inset: CGFloat) -> AKTabBar {
        let view = Bundle.main.loadNibNamed("AKTabBar", owner: nil, options: nil)?.first as? AKTabBar ?? AKTabBar()
        view.frame = rect
        view.bottomSpace1.constant = inset
        view.bottomSpace2.constant = inset
        view.bottomSpace3.constant = inset
        view.bottomSpace4.constant = inset
        view.bottomSpace5.constant = inset
        view.selectedAt(index: 1)
        return view
    }

    // MARK: - Actions
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        itemSelected?(sender.tag - 1)
        selectedAt(index: sender.tag)
    }
    
    // MARK: - Helper methods
    
    func selectItem(at index: Int) {
        if let view = stackView.viewWithTag(index),
           let button = view.subviews.first(where: { $0.tag == index }) as? UIButton { buttonTapped(button) }
    }
    
    private func selectedAt(index: Int) {
        let defColor: UIColor = .akBlack
        let defGrayColor: UIColor = .gray
        let appColor: UIColor = .akGreen
        stackView.subviews.forEach { view in
            let label = view.viewWithTag(view.tag * 100) as? UILabel
            let imageView = view.viewWithTag(view.tag * 10) as? UIImageView
            label?.font = .regular12
            if let text = names[label?.tag ?? 0] { label?.text = text }
            var frame = lineIndicatorView.frame
            if view.tag == index {  frame.origin.x = view.frame.origin.x }
            UIView.animate(withDuration: 0.3) {
                label?.textColor = view.tag == index ? .akGreen : defColor
                    imageView?.tintColor = view.tag == index ? appColor : defGrayColor
                self.lineIndicatorView.frame = frame
            }
            if view.tag == index { /* some animation if you want */ }
        }
    }

}
