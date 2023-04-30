import UIKit
import RxSwift

class AKCollectionConstructor: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    var customTopOffset: CGFloat? = nil
    var handler: TableHandler? = nil
    var scrollHandler: ScrollHandler? = nil
    var headerScrollHandler: ScrollHandler? = nil
    var indexHandler: IndexHandler? = nil
    var centerHorizontally: Bool = false
    var isInfinite: Bool = false
    var topAlignInSection: Int = .min
    var lastContentOffset: CGPoint = .zero
    var lastCenteredIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    private var firstCyclePassed: Bool = false
    private var scrollDirection: ScrollDirection = .crazy
    private var frames: [Int: CGRect] = [:]
    private var ids: [AKIdentifier] = [.empty, .separator, .titled]
    private var isJiggling: Bool = false
    var infoRx: PublishSubject<ConstructorSuperClass> = PublishSubject()
    var newCellListener: PublishSubject<UICollectionViewCell>?
    var insideOffset: CGPoint = CGPoint.zero
    var info: ConstructorSuperClass = ConstructorSuperClass() {
        didSet {
            infoRx.onNext(info)
            reloadCells()
        }
    }
    var collectionView: UICollectionView? = nil
    
    private var infiniteMultiplier: Int { isInfinite ? kFakeInfiniteValue : 1 }
    private var isLoading: Bool = false
    private var ignorePaging: Bool = false

    public init(collectionView: UICollectionView, info: ConstructorSuperClass, refreshable: Bool = false) {
        super.init()
        self.collectionView = collectionView
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.info = info
        self.collectionView?.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return info.sectionInfo.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return info.sectionInfo[section].data.count * infiniteMultiplier
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let row = isInfinite ? indexPath.row % info.sectionInfo[indexPath.section].data.count : indexPath.row
        let size = info.sectionInfo[indexPath.section].data[row].size
        return CGSize(width: size.width == 0 ? collectionView.frame.width : size.width,
                      height: size.height == 0 ? collectionView.frame.height : size.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return info.sectionInfo[section].header?.size ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return info.sectionInfo[section].footer?.size ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return info.sectionInfo[section].sideSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return info.sectionInfo[section].sideSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var identifier: AKIdentifier = info.sectionInfo[indexPath.section].header?.identifier ?? .empty
        identifier = ids.contains(identifier) ? identifier : .empty
        collectionView.register(UINib(nibName: identifier.rawValue.firstUppercased, bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier.rawValue)
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier.rawValue, for: indexPath) as! CollectionHeader
        if let attributedText = info.sectionInfo[indexPath.section].header?.attributedText {
            view.label?.attributedText = attributedText
        } else {
            view.label?.text = info.sectionInfo[indexPath.section].header?.text
            view.label?.textColor = info.sectionInfo[indexPath.section].header?.textColor
            view.label?.font = info.sectionInfo[indexPath.section].header?.font
        }
        if let constaint = info.sectionInfo[indexPath.section].header?.topConstraint {
            view.labelTopConstraint?.constant = constaint
        }
        view.configure(header: info.sectionInfo[indexPath.section].header)
        return view
    }
    
    private func correctRow(for indexPath: IndexPath) -> Int {
        let count = info.sectionInfo[indexPath.section].data.count
        return isInfinite ? indexPath.row % count : indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = info.sectionInfo[indexPath.section].data[correctRow(for: indexPath)]
        let identifier = data.identifier.rawValue
        let nib = UINib(nibName: identifier.firstUppercased, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        data.info?.delegate = data.info?.delegate ?? info.delegate
        let wxcell = cell as? AKCollectionViewCell
        wxcell?.mIndexPath = indexPath
        wxcell?.mCollectionView = collectionView
        wxcell?.anyObject = data.info?.object
        wxcell?.mConstructor = self
        wxcell?.isJiggling = isJiggling
        data.cCell = wxcell
        if isJiggling { cell.contentView.jiggleAnimation() } else { cell.contentView.layer.removeAllAnimations() }
        cell.configure(data)
        if indexPath.section == topAlignInSection { changeCellPosition(cell: cell, at: indexPath) }
        newCellListener?.onNext(cell)
        return cell
    }

    // to perform simple row slide animation before action use tableView extension
    // animateCellSelection(at indexPath: IndexPath, _ block: @escaping () -> ())
    // slides desired cell to the right, other cells down
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isJiggling { stopJiggling(); return }
        let data = info.sectionInfo[indexPath.section].data[correctRow(for: indexPath)]
        data.action()
        data.isSelected = true
        (collectionView.cellForItem(at: indexPath) as? AKCollectionViewCell)?.onSelect()
        handler?(indexPath, data.info)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let data = info.sectionInfo[indexPath.section].data[correctRow(for: indexPath)]
        data.isSelected = false
        (collectionView.cellForItem(at: indexPath) as? AKCollectionViewCell)?.onDeselect()
    }

    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @objc private func reloadCells() {
        collectionView?.reloadData()
    }
    
    func reloadFrames() {
        frames.removeAll()
        reloadCells()
    }

    // MARK: - UIScrollView methods

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollHandler?(scrollView)
        headerScrollHandler?(scrollView)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        func scroll(to indexPath: IndexPath) {
            lastCenteredIndexPath = indexPath
            targetContentOffset.pointee = scrollView.contentOffset
            collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        guard
            let collectionView = collectionView,
            centerHorizontally,
            scrollView.contentOffset.x > 0
        else { return }
        scrollDirection = lastContentOffset.x <= targetContentOffset.pointee.x ? .left : .right
        let path = lastCenteredIndexPath
        var item = scrollDirection == .left ? path.item + 1 : path.item - 1
        if item < 0 { item = 0 }
        if item > collectionView.numberOfItems(inSection: path.section) - 1 { item = collectionView.numberOfItems(inSection: path.section) - 1 }
        let newPath = IndexPath(item: item, section: path.section)
        scroll(to: newPath)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView.contentOffset.x > 0 else { return }
        lastContentOffset = scrollView.contentOffset
        indexHandler?(lastCenteredIndexPath.item)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(checkInfiniteCase), object: nil)
        perform(#selector(checkInfiniteCase), with: nil, afterDelay: 0.5)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset
    }
    
    @objc private func checkInfiniteCase() {
        if lastCenteredIndexPath.section > info.sectionInfo.count - 1 { return }
        let count = info.sectionInfo[lastCenteredIndexPath.section].data.count
        if isInfinite && !firstCyclePassed && lastCenteredIndexPath.row == count {
            firstCyclePassed = true
            let middle = infiniteMultiplier / 2 / count
            let row = middle * count
            lastCenteredIndexPath = IndexPath(item: row, section: lastCenteredIndexPath.section)
            collectionView?.scrollToItem(at: lastCenteredIndexPath, at: .centeredHorizontally, animated: false)
            if let scrollView = collectionView { lastContentOffset = scrollView.contentOffset }
        }
    }
    
}

//MARK: - redraw cell position
extension AKCollectionConstructor {
    
    func changeCellPosition(cell: UICollectionViewCell, at indexPath: IndexPath) {
        
        func changeFrame(to anotherCell: UICollectionViewCell) {
            var frame = cell.frame
            frame.origin.x = anotherCell.frame.origin.x
            frame.origin.y = anotherCell.frame.origin.y + anotherCell.frame.height + info.sectionInfo[topAlignInSection].sideSpace
            cell.frame = frame
        }
        
        guard let collectionView = collectionView else { return }
        if let frame = frames[indexPath.item] { cell.frame = frame; return }
        if indexPath.row == 0 && indexPath.section == topAlignInSection {
            var frame = cell.frame
            frame.origin.y = indexPath.section == .zero ? customTopOffset ?? kDefaultSideSpace : frame.origin.y
            cell.frame = frame
        } else if indexPath.row == 1, let prCell = collectionView.cellForItem(at: IndexPath(item: 0, section: topAlignInSection)) {
            var frame = cell.frame
            frame.origin.y = prCell.frame.origin.y
            cell.frame = frame
        } else {
            if indexPath.row == collectionView.numberOfItems(inSection: topAlignInSection) - 1
                && indexPath.row % 2 == 0 {
                guard
                    let minusOne = collectionView.cellForItem(at: IndexPath(item: indexPath.row - 1, section: topAlignInSection)),
                    let minusTwo = collectionView.cellForItem(at: IndexPath(item: indexPath.row - 2, section: topAlignInSection))
                else { return }
                let isLower = minusOne.frame.origin.y + minusOne.frame.height >= minusTwo.frame.origin.y + minusTwo.frame.height
                if isLower { changeFrame(to: minusTwo); return }
                changeFrame(to: minusOne)
            } else {
                guard let prCell = collectionView.cellForItem(at: IndexPath(item: indexPath.row - 2, section: topAlignInSection))
                else { return }
                changeFrame(to: prCell)
            }
        }
        frames[indexPath.item] = cell.frame
    }
    
}

// MARK: - Animation

extension AKCollectionConstructor {
    
    func startJiggling() {
        if isJiggling { return }
        isJiggling = true
        collectionView?.reloadData()
    }
    
    @objc func stopJiggling() {
        if !isJiggling { return }
        isJiggling = false
        collectionView?.reloadData()
    }
    
    func insertItem(at indexPath: IndexPath, cell: CellSuperClass, animated: Bool = true) {
        var data = info.sectionInfo[indexPath.section]
        data.data.insert(cell, at: indexPath.row)
        info.sectionInfo[indexPath.section] = data
        if animated { collectionView?.insertItems(at: [indexPath]) }
        else { collectionView?.reloadData() }
    }
    
}
