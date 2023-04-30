//
//  AKContainerViewController.swift
//  Architecture
//
//  Created by Александр Колесник on 30.04.2023.
//  Copyright © 2023 A&A. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AKContainerViewController: AKNotificatedViewController {
    
    private var bottomButtonBackgroundColor: UIColor? = nil
    private var canBottomButtonIsHighlighted: Bool = true
    private var bottomButtonHighlightBackgroundColor: UIColor? = nil
    private var constructor: AKTableConstructor? = nil
    private var constructor2: AKCollectionConstructor? = nil
    
    open var topViewMaxHeight: CGFloat {
        let padding = fillHeaderView.subviews.isEmpty ? headerView.frame.origin.y : .zero
        return topViewHeightConstraint.constant - padding
    }
    open var topViewMinHeight: CGFloat {
        let padding = fillHeaderView.subviews.isEmpty ? headerView.frame.origin.y : .zero
        return kTopViewHeight - padding
    }
    open var bottomInset: CGFloat = .zero
    
    @IBOutlet weak var gradientView: UIView! {
        didSet {
            gradientView.backgroundColor = .akWhite
            gradientView.cornerRadius = kCornerRadius25
            gradientView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
    @IBOutlet weak var backButtonTopSpace: NSLayoutConstraint! {
        didSet {
            backButtonTopSpace.constant = hasPhysicalButton ? kDefaultSideSpace : kTabBarHeight / 2
        }
    }
    @IBOutlet weak var tableTopSpace: NSLayoutConstraint!
    @IBOutlet weak var tableLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var tableTralingSpace: NSLayoutConstraint!
    @IBOutlet weak var tableEquilSpace: NSLayoutConstraint!
    @IBOutlet weak var tableBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var gradientViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            topViewHeightConstraint.constant = kTopViewHeight
        }
    }
    @IBOutlet weak var topView: UIView! {
        didSet {
            topView.cornerRadius = kCornerRadius20
            topView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    @IBOutlet weak var topShadowView: UIView!{
        didSet {
            topShadowView.layer.cornerRadius = kCornerRadius20
            topShadowView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            topShadowView.clipsToBounds = true
        }
    }
    @IBOutlet weak var collectionLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var collectionTrailingSpace: NSLayoutConstraint!
    @IBOutlet weak var fillHeaderView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var bottomView: UIView!{
        didSet {
            bottomView.cornerRadius = kCornerRadius20
            bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    @IBOutlet weak var viewBottomBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            constructor = tableView.epptyTableConstructor
        }
    }
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.clipsToBounds = false
            constructor2 = collectionView.emptyCollectionConstructor
        }
    }
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.font = .medium18
            nameLabel.textColor = .akBlack
        }
    }
    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.imageView?.tintColor = .akBlack
        }
    }
    @IBOutlet weak var actionButton: UIButton! {
        didSet {
            actionButton.isHidden = true
            actionButton.imageView?.tintColor = .akBlack
        }
    }
    
    @IBOutlet weak var actionTwoButton: UIButton! {
        didSet {
            actionTwoButton.isHidden = true
            actionTwoButton.imageView?.tintColor = .akBlack
        }
    }
    
    @IBOutlet weak var bottomButtonView: UIView! {
        didSet {
            bottomButtonView.backgroundColor = .clear
        }
    }
    @IBOutlet weak var newImageView: UIImageView!
    
    @IBOutlet weak var bottomButton: UIButton! {
        didSet {
            bottomButton.cornerRadius = bottomButton.frame.height / 2
            bottomButton.setTitle(AKLocalizedString("next", comment: ""), for: .normal)
            bottomButton.setTitleColor(.akBlack, for: .normal)
            bottomButton.backgroundColor = .green
            bottomButton.titleLabel?.font = .medium16
        }
    }
    @IBOutlet weak var bottomLeftButton: UIButton! {
        didSet {
            bottomLeftButton.isHidden = true
        }
    }
    
    @IBOutlet weak var bottom2Button: UIButton! {
        didSet {
            bottom2Button.cornerRadius = bottom2Button.frame.height / 2
            bottom2Button.setTitle(AKLocalizedString("next", comment: ""), for: .normal)
            bottom2Button.setTitleColor(.akBlack, for: .normal)
            bottom2Button.backgroundColor = .green
            bottom2Button.titleLabel?.font = .medium16
        }
    }
    
    deinit {
        model = nil
        shouldBindKeyboard(boolValue: false)
        collectionView.delegate = nil
        tableView.delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startSettings()
        initConstructor()
        guard let modelUnwrapped = model else { model?.allDataLoaded(); return }
        tableView.isScrollEnabled = modelUnwrapped.isScrollEnabled
        collectionView.isScrollEnabled = modelUnwrapped.isScrollEnabled
        modelUnwrapped.allDataLoaded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        model?.safeAreaInsets = view.safeAreaInsets
        model?.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model?.viewWillAppear()
        shouldBindKeyboard(boolValue: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        model?.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        model?.viewWillDissapear()
        shouldBindKeyboard(boolValue: false)
    }
    
    // MARK: - Actions
    
    @IBAction func onButtonTapped(_ sender: Any) {
        model?.actionButtonTapped()
    }
    
    @IBAction func onButtonTwoTapped(_ sender: Any) {
        model?.actionButtonTwoTapped()
    }
    
    @IBAction func topButtonTapped(_ sender: UIButton) {
        model?.backButtonTapped()
    }
    
    @IBAction func bottomButtonTapped(_ sender: UIButton) {
        model?.bottomButtonTapped()
    }
    
    @IBAction func bottom2ButtonTapped(_ sender: UIButton) {
        model?.bottom2ButtonTapped()
    }
    
    @IBAction func buttonLeftTapped(_ sender: Any) {
        model?.bottomLeftButtonTapped()
    }
    // MARK: - Helper methods
    
    private func initConstructor() {
        model?.constructor = constructor
        model?.constructorSettings?(constructor)
        
        model?.constructor2 = constructor2
        model?.constructorSettings2?(constructor2)
        listenToChanges()
        reloadContent()
    }
    
    private func shouldBindKeyboard(boolValue: Bool = true) {
        boolValue ? tableView?.bindToKeyboard() : tableView?.unBindKeyboard()
        boolValue ? collectionView?.bindToKeyboard() : collectionView?.unBindKeyboard()
    }
    
    private func reloadContent() {
        guard
            let model = model,
            let identifier = model.info.sectionInfo.first?.data.first?.identifier.rawValue
        else { return }
        guard
            let _ = classFromString(identifier.firstUppercased) as? UICollectionViewCell.Type
        else {
            constructor?.info = model.info
            constructor2?.info = ConstructorSuperClass()
            return
        }
        constructor2?.info = model.info
        constructor?.info = ConstructorSuperClass()
    }
    
    private func startSettings() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        nameLabel.text = model?.screenTitle
        nameLabel.numberOfLines = model?.titleNumberOfLines ?? 1
        canSwipeGesture = model?.canSwipeGesture ?? true
        canBottomButtonIsHighlighted = model?.canButtonIsHighlighted ?? true
        noAnimateButtonState(hide: model?.hideBottomButton ?? true)
        model?.customizeActionButton?(actionButton)
        model?.customizeActionTwoButton?(actionTwoButton)
        model?.customizeBottomButton?(bottomButton)
        model?.customizeBottom2Button?(bottom2Button)
        model?.customizeLeftBottomButton?(bottomLeftButton)
        model?.customizeBottomView?(bottomView)
        model?.customizeBackButton?(backButton)
        model?.customizeTitle?(nameLabel)
        model?.customHeaderHeight?(topViewHeightConstraint, topView)
        model?.tableSettings?(tableView)
        model?.customizeLayer?(view.layer)
        model?.customizeBottomView?(bottomView)
        model?.customizeGradientView?(gradientView)
    }
    
    private func countBottomInset(hide: Bool) {
        if model?.animateHideBottom ?? false {
            animateButtonState(hide: hide)
        } else {
            noAnimateButtonState(hide: hide)
        }
    }
    
    private func changeBottomInset(to: CGFloat) {
        let toValue = bottomView.isHidden ? to : to + bottomView.frame.height
        let minInset: CGFloat = bottomView.isHidden ? .zero : bottomView.frame.height
        let tableFreeSpace = tableView.contentSize.height - tableView.frame.height
        let collectionFreeSpace = collectionView.contentSize.height - collectionView.frame.height
        let scrollSpace = (topViewHeightConstraint.constant - kTopViewHeight) / 2
        let ignoreBottomPadding = model?.ignoreBottomPadding ?? false
        if !ignoreBottomPadding {
            tableView.contentInset.bottom = tableFreeSpace > topViewHeightConstraint.constant ? minInset : tableFreeSpace < 0 ? toValue - tableFreeSpace : toValue + scrollSpace
            collectionView.contentInset.bottom = collectionFreeSpace > topViewHeightConstraint.constant ? minInset : collectionFreeSpace < 0 ? toValue - collectionFreeSpace : toValue + scrollSpace
        }
        bottomInset = tableView.contentSize == .zero ? collectionView.contentInset.bottom : tableView.contentInset.bottom
    }
    
    private func noAnimateButtonState(hide: Bool) {
        bottomView.isHidden = hide
        bottomView.alpha = hide ? 0 : 1
        changeBottomInset(to: topViewMaxHeight + topViewMinHeight)
    }
    
    private func animateButtonState(hide: Bool) {
        if !hide { bottomView.isHidden = hide }
        UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCrossDissolve) { [weak self] in
            self?.bottomView.alpha = hide ? 0 : 1
        } completion: { [weak self] finish in
            guard let self = self else { return }
            if finish {
                if hide { self.bottomView.isHidden = hide }
                self.changeBottomInset(to: self.topViewMaxHeight + self.topViewMinHeight)
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if topView.isHidden != topShadowView.isHidden {
            topShadowView.isHidden = topView.isHidden
        }
    }
    
    private func listenToChanges() {
        model?.screenTitleRx
            .subscribe(onNext: {[weak self] title in
                self?.nameLabel.text = title
            }, onError: { error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        model?.bottomButtonTitleRx
            .subscribe(onNext: { [weak self] title in
                self?.bottomButton.setTitle(title, for: .normal)
            }, onError: { error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        model?.hideBottomButtonRx
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] boolValue in
                self?.bottomButton.isHidden = boolValue
                self?.countBottomInset(hide: boolValue)
                self?.bottomButtonView.isHidden = boolValue
            }, onError: { error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        model?.hideLeftBottomButtonRx
            .subscribe(onNext: { [weak self] boolValue in
                self?.bottomLeftButton.isHidden = boolValue
            })
            .disposed(by: disposeBag)
        model?.headerHeightRx
            .subscribe(onNext: {[weak self] tuple in
                guard let self = self else { return }
                let padding = self.fillHeaderView.subviews.count == 0 ? self.headerView.frame.origin.y : 0
                self.topViewHeightConstraint.constant = tuple.height + padding
                self.topView.isHidden = tuple.height == 0
                let duration = tuple.duration == nil ? kTransformDuration : tuple.duration!
                UIView.animate(withDuration: tuple.isAnimated ? duration : .zero) {
                    self.view.layoutIfNeeded()
                }
            }, onError: { error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        model?.customHeaderRx
            .subscribe(onNext: {[weak self] tuple in
                guard let self = self else { return }
                let view = tuple.view
                let duration = tuple.isAnimated ? 0.5 : 0
                view.translatesAutoresizingMaskIntoConstraints = false
                self.headerView.addSubview(view)
                if let animatedHeader = view as? AKAnimatedHeaderView { animatedHeader.listenToScroll(from: self.model) }
                if let animatedHeader = view as? SelfSizingView { animatedHeader.listenResize(from: self.model) }
                AKConstraintBuilder().setInsideConstraints(view: view, toView: self.headerView)
                view.frame = CGRect(origin: .zero, size: CGSize(width: self.headerView.frame.width, height: view.frame.height))
                self.topViewHeightConstraint.constant = self.headerView.frame.origin.y + view.frame.height
                let isHidden = self.bottomView.isHidden || self.bottomView.alpha == 0
                self.countBottomInset(hide: isHidden)
                UIView.animate(withDuration: duration) {
                    self.view.layoutIfNeeded()
                }
            }, onError: { error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        model?.fillHeaderRx
            .subscribe(onNext: {[weak self] tuple in
                guard let self = self else { return }
                self.fillHeaderView.subviews.forEach { $0.removeFromSuperview() }
                let view = tuple.view
                let duration = tuple.isAnimated ? 0.5 : 0
                self.view.layoutIfNeeded()
                view.translatesAutoresizingMaskIntoConstraints = false
                self.fillHeaderView.addSubview(view)
                if let animatedHeader = view as? AKAnimatedHeaderView { animatedHeader.listenToScroll(from: self.model) }
                if let animatedHeader = view as? SelfSizingView { animatedHeader.listenResize(from: self.model) }
                AKConstraintBuilder().setInsideConstraints(view: view, toView: self.fillHeaderView)
                view.frame = CGRect(origin: .zero, size: CGSize(width: self.fillHeaderView.frame.width, height: view.frame.height))
                self.topViewHeightConstraint.constant = view.frame.height
                UIView.animate(withDuration: duration) {
                    self.view.layoutIfNeeded()
                } completion: { _ in
                    self.changeBottomInset(to: self.topViewHeightConstraint.constant + kDefaultSideSpace * 2)
                }
            }, onError: { error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        model?.constructor?.infoRx
            .subscribe(onNext: { [weak self] info in
                guard let self = self else { return }
                self.tableView.isHidden = info.sectionInfo.count == 0
                info.delegate = self.model
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let isHidden = self.bottomView.isHidden || self.bottomView.alpha == 0
                    if self.model?.listenToKeyboard == false { self.countBottomInset(hide: isHidden) }
                }
            }, onError: { error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        model?.constructor2?.infoRx
            .subscribe(onNext: { [weak self] info in
                guard let self = self else { return }
                self.collectionView.isHidden = info.sectionInfo.count == 0
                info.delegate = self.model
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let isHidden = self.bottomView.isHidden || self.bottomView.alpha == 0
                    if self.model?.listenToKeyboard == false { self.countBottomInset(hide: isHidden) }
                }
            }, onError: { error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        model?.gradientViewRx
            .subscribe(onNext: { [weak self] colors in
                self?.gradientView?.isHidden = colors.count == 0
                self?.gradientView?.addGradient(colors: colors, direction: .vertical)
            }, onError: { error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        model?.bottomStackUpdateView
            .subscribe(onNext: {[weak self] tuple in
                guard let self = self else {return}
                if !tuple.isRemove {
                    self.bottomStackView.insertArrangedSubview(tuple.view, at: tuple.at)
                    self.bottomStackView.layoutIfNeeded()
                } else if self.bottomStackView.arrangedSubviews.contains(tuple.view) {
                    self.bottomStackView.removeArrangedSubview(tuple.view)
                    tuple.view.removeFromSuperview()
                }
            }, onError: { error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        model?.hideBottomViewRx
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] value in
                guard let bottomView = self?.bottomView else { return }
                bottomView.isHidden = value
                UIView.animate(withDuration: kTransformDuration) {
                    bottomView.alpha = value ? 0 : 1
                }
            }, onError: { error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        bottomButton.rx.observe(Bool.self, #keyPath(UIButton.isEnabled))
            .asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] boolValue in
                let boolValue = boolValue ?? false
                self?.bottomButton.isEnabled = boolValue
                self?.bottomButton.alpha = boolValue ? 1 : kTransformDuration
            })
            .disposed(by: disposeBag)
        bottomButton.rx.observe(Bool.self, #keyPath(UIButton.isHighlighted))
            .asObservable()
            .distinctUntilChanged()
            .subscribe (onNext: { [weak self] boolValue in
                guard self?.canBottomButtonIsHighlighted == true else { return }
                if self?.bottomButtonBackgroundColor == nil { self?.bottomButtonBackgroundColor = self?.bottomButton.backgroundColor }
                if self?.bottomButtonHighlightBackgroundColor == nil { self?.bottomButtonHighlightBackgroundColor = self?.bottomButton.backgroundColor?.withAlphaComponent(0.3) }
                let boolValue = boolValue ?? false
                self?.bottomButton.backgroundColor = boolValue ? (self?.bottomButtonHighlightBackgroundColor ?? .green) : (self?.bottomButtonBackgroundColor ?? .green)
                self?.bottomButton.titleLabel?.alpha = 1
            })
            .disposed(by: disposeBag)
        collectionView.rx.observe(UIEdgeInsets.self, #keyPath(UICollectionView.contentInset))
            .asObservable()
            .distinctUntilChanged()
            .subscribe (onNext: { [weak self] inset in
                guard
                    let self,
                    self.constructor2?.info.sectionInfo.count != .zero
                else { return }
                // in the keyboard is opened inset and scrollIndicatorInset must be equal
                // in other cases bottom view must be pinned to bottom
                var mInset = self.collectionView.contentInset.bottom == self.collectionView.verticalScrollIndicatorInsets.bottom ? inset : .zero
                self.configureBottomInset(inset: mInset, height: self.collectionView.frame.height)
            })
            .disposed(by: disposeBag)
        tableView.rx.observe(UIEdgeInsets.self, #keyPath(UITableView.contentInset))
            .asObservable()
            .distinctUntilChanged()
            .subscribe (onNext: { [weak self] inset in
                guard
                    let self,
                    self.constructor?.info.sectionInfo.count != .zero
                else { return }
                // in the keyboard is opened inset and scrollIndicatorInset must be equal
                // in other cases bottom view must be pinned to bottom
                var mInset = self.tableView.contentInset.bottom == self.tableView.verticalScrollIndicatorInsets.bottom ? inset : .zero
                self.configureBottomInset(inset: mInset, height: self.tableView.frame.height)
            })
            .disposed(by: disposeBag)
        model?.gradientViewHeightRx
            .subscribe(onNext: { [weak self] tuple in
                guard let self = self else { return }
                self.gradientViewHeightConstraint.constant = tuple.height
                UIView.animate(withDuration: tuple.isAnimated ? kTransformDuration : .zero) {
                    self.view.layoutIfNeeded()
                }
            }, onError: { error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        model?.bottomStackViewSwapperRx
            .subscribe(onNext: { [weak self] boolValue in
                guard let self = self else { return }
                let topCenter = self.bottomButton.center
                let bottomCenter = self.bottom2Button.center
                UIView.animate(withDuration: boolValue ? kTransformDuration : .zero, animations: {
                    self.bottom2Button.center = topCenter
                    self.bottomButton.center = bottomCenter
                })
            })
            .disposed(by: disposeBag)
        model?.animatePosition
            .subscribe(onNext: { [weak self] position in
                guard let self = self else { return }
                self.reloadContent()
                self.tableBottomSpace.constant = position.bottomPositionStart
                self.tableTopSpace.constant = position.topPositionStart
                self.tableLeadingSpace.constant = position.leadingPositionStart
                self.view.layoutIfNeeded()
                self.tableBottomSpace.constant = position.bottomPositionEnd
                self.tableTopSpace.constant = position.topPositionEnd
                self.tableLeadingSpace.constant = position.leadingPositionEnd
                UIView.animate(withDuration: kTransformDuration) { self.view.layoutIfNeeded() }
            })
            .disposed(by: disposeBag)
        model?.bottomButtonHighlightRx
            .subscribe(onNext: { [weak self] color in
                self?.bottomButtonHighlightBackgroundColor = color
            })
            .disposed(by: disposeBag)
        model?.showNew
            .subscribe(onNext: { [weak self] boolValue in
                guard let isShow = boolValue else { return }
                self?.newImageView.isHidden = !isShow
            })
            .disposed(by: disposeBag)
    }
    
    private func configureBottomInset(inset: UIEdgeInsets?, height: CGFloat) {
        var value = model?.listenToKeyboard == true ? inset?.bottom == bottomInset ? .zero : (inset?.bottom ?? .zero) : .zero
        if bottomView.isHidden == false && value == bottomView.frame.height { value = .zero }
        viewBottomBottomConstraint.constant = value > height ? .zero : value
        // WORKAROUND: - to keep space between button and keyboard 36px on hidden, 24px - on show
        if viewBottomBottomConstraint.constant != .zero { viewBottomBottomConstraint.constant -= 24 }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
}
