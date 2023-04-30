import UIKit
import RxSwift

class AKRowAction: UITableViewRowAction {
    
    var image: UIImage?
    var color: UIColor?
    var handler: TableHandler?
}

class AKTableConstructor: NSObject, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    var handler: TableHandler? = nil
    var deleteHandler: TableHandler? = nil
    var scrollHandler: ScrollHandler? = nil
    var headerScrollHandler: ScrollHandler? = nil
    var insideOffset: CGPoint = CGPoint.zero
    var infoRx: PublishSubject<ConstructorSuperClass> = PublishSubject()
    var info: ConstructorSuperClass = ConstructorSuperClass() {
        didSet {
            infoRx.onNext(info)
            reloadCells()
        }
    }
    var tableView: UITableView = UITableView()
    private var pickerHeight: CGFloat = 162
    private var isLoading: Bool = false
    private var dateCase: [IndexPath] = []
    private var cachedCells: [(path: IndexPath, cell: UITableViewCell)] = []
    private let refresh = UIRefreshControl()
    private weak var viewController: UIViewController? = nil
    public var showSelection: Bool = false {
        didSet {
            tableView.keyboardDismissMode = .onDrag
        }
    }

    private var vc: UIViewController? {
        if viewController != nil { return viewController }
        viewController = UIApplication.shared.topViewController()
        return viewController
    }

    public init(tableView: UITableView, info: ConstructorSuperClass, refreshable: Bool = false) {
        super.init()
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        if #available(iOS 15.0, *) { self.tableView.sectionHeaderTopPadding = .zero }
        self.info = info
        self.tableView.reloadData()
        if refreshable == true { addRefreshControl() }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return info.sectionInfo.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section < info.sectionInfo.count ? info.sectionInfo[section].data.count : 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = info.sectionInfo[indexPath.section].data[indexPath.row].cellHeight
            else {
            return UITableView.automaticDimension
        }
        return dateCase.contains(indexPath) ? height + pickerHeight : height
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return info.sectionInfo[section].footer?.height ?? .leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return info.sectionInfo[section].header?.height ?? .leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let identifier = info.sectionInfo[section].header?.identifier
        else { return UIView(frame: .zero) }
        tableView.register(UINib(nibName: identifier.rawValue.firstUppercased, bundle: nil), forHeaderFooterViewReuseIdentifier: identifier.rawValue)
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier.rawValue) as? Header
        let view = header?.subviews.first(where: { ($0 as? UILabel) == nil && $0.frame.width == .zero && $0.frame.height == .zero })
        view?.removeFromSuperview()
        header?.backgroundColor = UIColor.clear
        header?.headerLabel?.text = info.sectionInfo[section].header?.text
        header?.leadingHeaderConstraint?.constant = info.sectionInfo[section].header?.constraint ?? kDefaultSideSpace * 2
        header?.counterLabel?.text = info.sectionInfo[section].header?.textDetails
        header?.headerLabel?.textColor = info.sectionInfo[section].header?.textColor ?? .gray
        header?.headerLabel?.font = info.sectionInfo[section].header?.font ?? .regular14
        header?.headerLabel?.textAlignment = info.sectionInfo[section].header?.textAlignment ?? .left
        header?.colorView.backgroundColor = info.sectionInfo[section].header?.backgroundColor ?? .clear
        header?.shouldHideStackView(hide: info.sectionInfo[section].header?.shouldHideButtons ?? true)
        header?.anyObject = info.sectionInfo[section].header?.anyObject
        return header
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard
            let identifier = info.sectionInfo[section].footer?.identifier
        else { return UIView(frame: .zero) }
        tableView.register(UINib(nibName: identifier.rawValue.firstUppercased, bundle: nil), forHeaderFooterViewReuseIdentifier: identifier.rawValue)
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier.rawValue) as? Header
        footer?.backgroundColor = UIColor.clear
        footer?.headerLabel.text = info.sectionInfo[section].footer?.text
        footer?.headerLabel.textColor = info.sectionInfo[section].footer?.textColor ?? .gray
        footer?.headerLabel.textAlignment = info.sectionInfo[section].footer?.textAlignment ?? .left
        footer?.colorView.backgroundColor = info.sectionInfo[section].footer?.backgroundColor ?? .clear
        footer?.shouldHideStackView(hide: info.sectionInfo[section].footer?.shouldHideButtons ?? true)
        if let font = info.sectionInfo[section].footer?.font {
            footer?.headerLabel.font = font
        }
        if let attString = info.sectionInfo[section].footer?.attributedText {
            footer?.headerLabel.attributedText = attString
        }
        footer?.anyObject = info.sectionInfo[section].footer?.anyObject
        if
            let view = info.sectionInfo[section].footer?.anyObject as? UIView,
            let footer = footer {
            footer.addSubview(view)
            footer.bringSubviewToFront(view)
            AKConstraintBuilder().setInsideConstraints(view: view, toView: footer)
        }
        
        if let aFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier.rawValue) as? HeaderFooterProtocol {
            aFooter.configure(object: info.sectionInfo[section].footer)
            return aFooter
        }
        
        return footer
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cached = cachedCells.first(where: { $0.path.section == indexPath.section && $0.path.row == indexPath.row})?.cell { return cached }
        let data = info.sectionInfo[indexPath.section].data[indexPath.row]
        let identifier = data.identifier.rawValue
        let nib = UINib(nibName: identifier.firstUppercased, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.accessoryType = data.cellType
        cell.selectionStyle = .default
        cell.selectedBackgroundView = showSelection ? SelectionView(frame: cell.frame) : nil
        if !showSelection { cell.selectionStyle = .none }
        cell.tag = indexPath.row
        data.info?.delegate = data.info?.delegate ?? info.delegate
        
        let wxcell = cell as? AKTableViewCell
        wxcell?.mTableView = tableView
        wxcell?.mConstructor = self
        wxcell?.mIndexPath = indexPath
        wxcell?.anyObject = data.info?.object
        data.cell = wxcell
        
        cell.configure(data)
        return cell
    }
    
    // to perform simple row slide animation before action use tableView extension
    // animateCellSelection(at indexPath: IndexPath, _ block: @escaping () -> ())
    // slides desired cell to the right, other cells to the left

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = info.sectionInfo[indexPath.section].data[indexPath.row]
        data.action()
        handler?(indexPath, data.info)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {}

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return info.sectionInfo[indexPath.section].data[indexPath.row].isEditable
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let data = info.sectionInfo[indexPath.section].data[indexPath.row]
        data.deleteHandler = self.deleteHandler
        return data.rowActions
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        delete(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let data = info.sectionInfo[indexPath.section].data[indexPath.row]
        var configuration: UISwipeActionsConfiguration
        
        let deleteAction = UIContextualAction(style: .destructive, title: AKLocalizedString("remove_action_title", comment: "")) { [weak self] _, _, completionHandler in
            self?.delete(at: indexPath)
            completionHandler(true)
        }
        deleteAction.image = UIImage(named: "ic_delete_cell")
        deleteAction.backgroundColor = .red
        configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return configuration
    }
    
    private func delete(at indexPath: IndexPath) {
        let data = info.sectionInfo[indexPath.section].data[indexPath.row]
        data.action(nil)
        deleteHandler?(indexPath, data.info)
    }

    private func reloadCells() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { self.refresh.endRefreshing() }
        tableView.reloadData()
    }
    
    // MARK: - Helper methods

    private func addRefreshControl() {
        let tvc = UITableViewController()
        tvc.tableView = tableView
        refresh.tintColor = .akBlack
        tableView.addSubview(refresh)
        refresh.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }

    @objc private func refreshData(_ sender: UIRefreshControl) {
        if vc?.responds(to: #selector(refreshData(_:))) == false { return }
        vc?.refreshData { [weak self] _ in
            self?.tableView.sendSubviewToBack(sender)
            sender.endRefreshing()
        }
    }
    
    func addToCache(cell: UITableViewCell, for indexPath: IndexPath) {
        cachedCells.append((indexPath, cell))
    }
    
    func removeFromCache(cell: UITableViewCell) {
        cachedCells.removeAll(where: { $0.cell == cell })
    }
    
    func removeObjectsFromConstructor(indexPaths: [IndexPath], animation: UITableView.RowAnimation = .none) {
        indexPaths.reversed().forEach {
            var array = info.sectionInfo[$0.section].data
            array.remove(at: $0.row)
            info.sectionInfo[$0.section].data = array
        }
        tableView.deleteRows(at: indexPaths, with: animation)
    }

    func insertObjectsToConstructor(cells: [CellSuperClass], section: Int, animation: UITableView.RowAnimation = .none) {
        var array = info.sectionInfo[section].data
        let index = array.count
        array.append(contentsOf: cells)
        info.sectionInfo[section].data = array
        var indexPaths: [IndexPath] = []
        for i in index..<array.count {
            indexPaths.append(IndexPath(row: i, section: section))
        }
        tableView.insertRows(at: indexPaths, with: animation)
    }
    
    func insertSection(section: HFSuperClass, at index: Int, animation: UITableView.RowAnimation = .none) {
        var array = info.sectionInfo
        array.insert(section, at: index)
        info.sectionInfo = array
        tableView.insertSections([index], with: animation)
    }
    
    func appendSection(section: HFSuperClass, animation: UITableView.RowAnimation = .none) {
        var array = info.sectionInfo
        array.append(section)
        info.sectionInfo = array
        tableView.insertSections([array.count - 1], with: animation)
    }
    
    func removeSection(at index: Int, animation: UITableView.RowAnimation = .none) {
        var array = info.sectionInfo
        if (0...array.count - 1).contains(index) {
            array.remove(at: index)
            info.sectionInfo = array
            tableView.deleteSections([index], with: animation)
        }
    }
    
    func reloadSection(_ section: Int, cells: [CellSuperClass], animation: UITableView.RowAnimation = .none) {
        info.sectionInfo[section].data = cells
        tableView.reloadSections([section], with: animation)
    }
    
    func hideHeader(in section: Int, animation: UITableView.RowAnimation = .automatic) {
        let header = info.sectionInfo[section].header
        if header?.height == .zero { return }
        header?.height = .zero
        tableView.reloadSections([section], with: animation)
    }
    
    func hideFooter(in section: Int, animation: UITableView.RowAnimation = .automatic) {
        let footer = info.sectionInfo[section].footer
        if footer?.height == .zero { return }
        footer?.height = .zero
        tableView.reloadSections([section], with: animation)
    }
    
    func showHeader(in section: Int, animation: UITableView.RowAnimation = .automatic) {
        let header = info.sectionInfo[section].header
        if header?.height != .zero { return }
        header?.height = header?.text?.height(withConstrainedWidth: tableView.frame.width - kDefaultSideSpace * 2, font: header?.font ?? .medium16) ?? .zero
        tableView.reloadSections([section], with: animation)
    }
    
    func showFooter(in section: Int, animation: UITableView.RowAnimation = .automatic) {
        let footer = info.sectionInfo[section].footer
        if footer?.height != .zero { return }
        footer?.height = footer?.text?.height(withConstrainedWidth: tableView.frame.width - kDefaultSideSpace * 2, font: footer?.font ?? .medium16) ?? .zero
        tableView.reloadSections([section], with: animation)
    }
    
    func animationTableView(duration: Double = kTransformDuration) {
        UIView.transition(with: tableView,
                          duration: duration,
                          options: .transitionCrossDissolve,
                          animations: {[weak self] in self?.tableView.reloadData() })
    }
    
    func animateReload(info: ConstructorSuperClass,
                       animation: UIView.AnimationOptions = .transitionCrossDissolve,
                       duration: Double = kTransformDuration) {
        UIView.transition(with: tableView,
                          duration: duration,
                          options: animation,
                          animations: { [weak self] in
            self?.info = info
        })
    }
    
    // MARK: - UIScrollView methods

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollHandler?(scrollView)
        headerScrollHandler?(scrollView)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {}

}
