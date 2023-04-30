//
//  AKRouterModel.swift
//  Architecture
//
//  Created by Александр Колесник on 30.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import RxSwift

enum AnimatePosition: CaseIterable {
    
    case left, right, top, bottom, none
    
    var topPositionStart: CGFloat {
        switch self {
        case .left, .right, .none: return .zero
        case .top: return -UIScreen.main.bounds.height
        case .bottom: return UIScreen.main.bounds.height
        }
    }
    
    var bottomPositionStart: CGFloat {
        switch self {
        case .left, .right, .none: return .zero
        case .top: return UIScreen.main.bounds.height
        case .bottom: return -UIScreen.main.bounds.height
        }
    }
    
    var leadingPositionStart: CGFloat {
        switch self {
        case .top, .bottom, .none: return .zero
        case .left: return -UIScreen.main.bounds.width
        case .right: return UIScreen.main.bounds.width
        }
    }
    
    var bottomPositionEnd: CGFloat { return .zero }
    var topPositionEnd: CGFloat { return .zero }
    var leadingPositionEnd: CGFloat { return .zero }
    
}

class AKRouterModel: NSObject, InterfaceItemDelegate {
    
    public override init() {
        super.init()
        info.delegate = self
        setupViews()
        setupSettings()
        listeners()
    }
    
    public init(title: String? = nil) {
        super.init()
        info.delegate = self
        screenTitle = title
        setupViews()
        setupSettings()
        listeners()
    }
    
    deinit {
        print("deinit \(self)")
    }
    
    var ignoreBottomPadding: Bool = false
    var useTwoButtons: Bool = false
    var info: Info = Info()
    var anyObject: Any?
    weak var constructor: AKTableConstructor? = nil
    weak var constructor2: AKCollectionConstructor? = nil
    var hideBottomButton: Bool = true
    var hideBottomBar: Bool = true
    var listenToKeyboard: Bool = false
    var animateHideBottom: Bool = false
    var canShowGradientTopView: Bool = true
    var canShowRoundBottomView: Bool = false
    var screenTitle: String? = nil
    var titleNumberOfLines: Int = 1
    var bottomButtonTitle: String? = nil
    var safeAreaInsets: UIEdgeInsets = UIEdgeInsets.zero
    var disposeBag: DisposeBag = DisposeBag()
    var canSwipeGesture: Bool = true
    var canButtonIsHighlighted: Bool = true
    var isScrollEnabled: Bool = true
    
    var tableSettings: ((UITableView) -> ())? = { tableView in tableView.separatorStyle = .none }
    var constructorSettings: ((AKTableConstructor?) -> ())? = nil
    var constructorSettings2: ((AKCollectionConstructor?) -> ())? = nil
    var customizeActionButton: ((UIButton) -> ())? = nil
    var customizeActionTwoButton: ((UIButton) -> ())? = nil
    var customizeBottomButton: ((UIButton) -> ())? = nil
    var customizeBottom2Button: ((UIButton) -> ())? = nil
    var customizeLeftBottomButton: ((UIButton) -> ())? = nil
    var customizeBackButton: ((UIButton) -> ())? = nil
    var customHeaderHeight: ((NSLayoutConstraint, UIView) -> ())? = nil
    var customizeTitle: ((UILabel) -> ())? = nil
    var customizeLayer: ((CALayer) -> ())? = nil
    var customizeBottomView: ((UIView) -> ())?
    var customizeGradientView: ((UIView) -> ())?
    
    // Only for container usage
    // Use below functions in model to perform Rx actions
    var screenTitleRx: PublishSubject<String?> = PublishSubject()
    var bottomButtonTitleRx: PublishSubject<String?> = PublishSubject()
    var bottomButtonHighlightRx: PublishSubject<UIColor?> = PublishSubject()
    var hideBottomButtonRx: PublishSubject<Bool> = PublishSubject()
    var hideBottomViewRx: PublishSubject<Bool> = PublishSubject()
    var hideLeftBottomButtonRx: PublishSubject<Bool> = PublishSubject()
    var headerHeightRx: PublishSubject<(height: CGFloat, isAnimated: Bool, duration: CGFloat?)> = PublishSubject()
    var customHeaderRx: PublishSubject<(view: UIView, isAnimated: Bool)> = PublishSubject()
    var fillHeaderRx: PublishSubject<(view: UIView, isAnimated: Bool)> = PublishSubject()
    var gradientViewRx: PublishSubject<[CGColor]> = PublishSubject()
    var bottomStackUpdateView: PublishSubject<(view: UIView, at: Int, isRemove: Bool)> = PublishSubject()
    var gradientViewHeightRx: PublishSubject<(height: CGFloat, isAnimated: Bool)> = PublishSubject()
    var bottomStackViewSwapperRx: PublishSubject<Bool> = PublishSubject()
    var animatePosition: PublishSubject<AnimatePosition> = PublishSubject()
    var showNew: PublishSubject<Bool?> = PublishSubject()
    
    // calls memory leak, that's why navigation controller is get-only property
    // typaliases below are not being called from container to prevent leaks
    var navigationController: UINavigationController? {
        return UIApplication.shared.topViewController()?.navigationController
    }
    
    var tabBarController: UITabBarController? {
        return UIApplication.shared.topViewController()?.tabBarController
    }
    
    var navigationSettings: ((UINavigationController?) -> ())? = nil
    var onDataUpdate: ((ConstructorSuperClass) -> ())? = nil
    
    func viewWillAppear() {}
    func viewDidAppear() {}
    func viewWillDissapear() {}
    func viewDidLayoutSubviews() {}
    func actionButtonTapped() {}
    func actionButtonTwoTapped() {}
    func backButtonTapped() { navigationController?.popCurrentModel() }
    func bottomButtonTapped() {}
    func bottom2ButtonTapped() {}
    func bottomLeftButtonTapped() {}
    func setupSettings() {}
    func listeners() {}
    func initConstructor() {}
    func initHeader() {}

    func setupViews() {
        customizeBackButton = { button in
            button.isHidden = (self.navigationController?.viewControllers.count ?? 0) < 3
        }
    }
    func allDataLoaded() {
        initConstructor()
        initHeader()
    }
    
    // MARK: - Rx funcs
    
    func setScreenTitle(_ title: String?) {
        screenTitle = title
        screenTitleRx.onNext(title)
    }
    
    func setBottomButtonTitle(_ title: String?) {
        bottomButtonTitle = title
        bottomButtonTitleRx.onNext(title)
    }
    
    func setBottomButtonHighlightColor(to color: UIColor?) {
        bottomButtonHighlightRx.onNext(color)
    }
    
    func hideBottomButton(boolValue: Bool) {
        hideBottomButton = boolValue
        hideBottomButtonRx.onNext(boolValue)
    }
    
    func hideLeftBottomButton(boolValue: Bool) {
        hideLeftBottomButtonRx.onNext(boolValue)
    }
    
    func hideBottomView(boolValue: Bool) {
        hideBottomViewRx.onNext(boolValue)
    }
    
    func changeHeaderHeight(height: CGFloat, animated: Bool = false, duration: CGFloat? = nil) {
        headerHeightRx.onNext((height, animated, duration))
    }
    
    func addCustomHeader(_ header: UIView, animated: Bool = true) {
        customHeaderRx.onNext((header, animated))
    }
    
    func addFillHeader(_ header: UIView, animated: Bool = true) {
        fillHeaderRx.onNext((header, animated))
    }
    
    func showGradientView(colors: [CGColor]) {
        gradientViewRx.onNext(colors)
    }
    
    func changeGradientHeight(height: CGFloat, animated: Bool = true) {
        gradientViewHeightRx.onNext((height, animated))
    }
    
    func swapButtons(viceversa: Bool = true) {
        bottomStackViewSwapperRx.onNext(viceversa)
    }
    
    func reloadContent(info: Info, animated: AnimatePosition) {
        self.info = info
        animatePosition.onNext(animated)
    }
    
    func addNavigationBar(with title: String, addBackButton: Bool = true, rightBarbuttonItems: [UIBarButtonItem]? = nil) {
        guard let nvc = navigationController else { return }
        nvc.setNavigationBarHidden(false, animated: false)
        nvc.navigationBar.topItem?.title = title
        if addBackButton {
            let button = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_main.pdf"), style: .plain, target: self, action: #selector(goBack))
            nvc.navigationBar.topItem?.leftBarButtonItem = button
        }
        nvc.navigationBar.topItem?.setRightBarButtonItems(rightBarbuttonItems, animated: true)
    }
    
    func addNavigationBar(with titleView: UIView?, addBackButton: Bool = true, rightBarbuttonItems: [UIBarButtonItem]? = nil) {
        guard let nvc = navigationController else { return }
        nvc.setNavigationBarHidden(false, animated: false)
        nvc.navigationBar.topItem?.titleView = titleView
        nvc.navigationBar.topItem?.setRightBarButtonItems(rightBarbuttonItems, animated: true)
        if addBackButton {
            let button = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_main.pdf"), style: .plain, target: self, action: #selector(goBack))
            nvc.navigationBar.topItem?.leftBarButtonItem = button
            
            if rightBarbuttonItems == nil {
                let fillView = UIView()
                fillView.widthAnchor.constraint(equalToConstant: 20).isActive = true
                let fillButton = UIBarButtonItem(customView: fillView)
                nvc.navigationBar.topItem?.rightBarButtonItem = fillButton
            }
        }
    }
    
    @objc private func goBack() {
        navigationController?.popCurrentModel()
    }
    
    func action(object: Any?) {}
    
    func didSelect(object: Any?) {}
    
    func addLoader() { router.addPreloader() }
    func removeLoader() { router.removePreloader() }
    
    func hideKeyboardOnTap() {
        navigationController?.viewControllers.last?.hideKeyboardWhenTappedAround()
    }
    
}
