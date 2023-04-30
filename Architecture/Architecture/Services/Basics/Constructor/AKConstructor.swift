import UIKit

enum AKIdentifier: String {
    
    // table cells
    
    case textWithImage = "textImageCell"
    case preloader = "preloaderCell"
    
    // collection cells
    
    case cLoader = "loaderCollectionViewCell"
    
    // Table view headers
    
    case header = "header"
    case alignmentHeader = "alignmentHeader"
    case buttonHeader = "buttonHeader"
    
    // Collection view headers
    
    case separator = "separatorHeader"
    case empty = "emptyHeader"
    case titled = "collectionTitledHeader"
    
}

class SelectionView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.green.withAlphaComponent(0.3)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

}

class WXConstructor: NSObject {

    var handler: TableHandler? = nil

    var tableConstructor: AKTableConstructor? = nil
    var collectionConstructor: AKCollectionConstructor? = nil

    public init(with scrollView: UIScrollView, object: ConstructorSuperClass, refreshable: Bool = false) {
        guard
            let tableView = scrollView as? UITableView
            else {
                guard
                    let collectionView = scrollView as? UICollectionView
                    else {
                        fatalError("Trying to pass constructor object to ui object cannot be performed in: \(scrollView), constructor can vizualize objects only in UITableview or UICollectionView")
                }
                self.collectionConstructor = AKCollectionConstructor(collectionView: collectionView, info: object, refreshable: refreshable)
                return
        }
        self.tableConstructor = AKTableConstructor(tableView: tableView, info: object, refreshable: refreshable)
    }

    private init(with tableView: UITableView, object: ConstructorSuperClass, refreshable: Bool = false) {
        self.tableConstructor = AKTableConstructor(tableView: tableView, info: object, refreshable: refreshable)
        self.tableConstructor?.handler = handler
    }

    private init(with collectionView: UICollectionView, object: ConstructorSuperClass, refreshable: Bool = false) {
        self.collectionConstructor = AKCollectionConstructor(collectionView: collectionView, info: object, refreshable: refreshable)
        self.collectionConstructor?.handler = handler
    }

}

