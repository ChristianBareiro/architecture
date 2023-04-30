import UIKit
import Foundation

// will be invoked on table didSelectRow
// should be implemented to handle tap

typealias TableHandler = (IndexPath, DefaultObject?) -> ()
typealias HFHandler = (Any?) -> ()
typealias ObjectHandler = (Any?) -> ()
typealias ScrollHandler = (UIScrollView) -> ()
typealias IndexHandler = (Int) -> ()

public protocol SectionModelType {
    associatedtype Item

    var items: [Item] { get }

    init(original: Self, items: [Item])
}


class ConstructorSuperClass: NSObject {

    var sectionInfo: [HFSuperClass] = []
    weak var delegate: InterfaceItemDelegate? = nil
    
}

class Info: ConstructorSuperClass {
    
    public init(with object: Any) {
        super.init()

    }

    public override init() {}
    
    public init(delegate: InterfaceItemDelegate?) {
        super.init()
        self.delegate = delegate
    }
    
    deinit {
        print("\(self) deinit")
    }

}

// default keys to use in cell implementation, will be parse by default

enum CellSettings {

    case titleTextColor
    case titleTextAlignment
    case titleFont
    case titleSize
    case detailsTextAlignment
    case detailsFont
    case detailsSize
    case textColor
    case textAlignment
    case textFont
    case textSize
    case enabled
    case selected
    case insets
    case hideBackground
    case backgroundColor
    case borderColor
    case boolValue
    case constraint
    case cornerRadius
    case topConstraint
    case bottomConstraint
    case heightConstraint
    case widthConstraint
    case leadingConstraint
    case trailingConstraint

}

// default object to fill standard cell fields

class InfoImage: NSObject {
    
    var image: UIImage? = nil
    var placeholder: UIImage? = nil
    var imageUrl: String? = nil
    
}

class DefaultObject: NSObject {

    var identifier: AKIdentifier = .textWithImage
    var title: String? = nil
    var details: String? = nil
    var text: String? = nil
    var image: InfoImage? = nil
    weak var delegate: InterfaceItemDelegate? = nil
    var object: Any? = nil
    var object2: Any? = nil
    var newDelegate: Any? = nil
    
    public override init() {}

    init(identifier: AKIdentifier, title: String? = nil, text: String? = nil, object: Any? = nil, object2: Any? = nil, newDelegate: Any? = nil) {
        self.identifier = identifier
        super.init()
        self.title = title
        self.text = text
        self.object = object
        self.object2 = object2
        self.newDelegate = newDelegate
    }
    
}

// class to override to use in case

class CellSuperClass: NSObject {

    var info: DefaultObject? = nil
    var isEditable: Bool = false
    var isSelected: Bool = false
    var isEnabled: Bool = true
    var canSwipe: Bool = true
    var identifier: AKIdentifier = .textWithImage
    var cellType: UITableViewCell.AccessoryType = .none
    var cellHeight: CGFloat? = UITableView.automaticDimension
    var cellSettings: [CellSettings: Any] = [:]
    var rowActions: [UITableViewRowAction]? = nil
    var dictionary: [AnyHashable: Any]? = nil
    var size: CGSize = CGSize(width: 50, height: 50)
    var deleteHandler: TableHandler? = nil
    var anyObject: Any? = nil
    weak var cell: AKTableViewCell? = nil
    weak var cCell: AKCollectionViewCell? = nil
    
    func action(_ sender: Any? = nil, block: TableHandler? = nil) {}

    public override init() {
        super.init()
    }
    
    public init(id: AKIdentifier,
                object: Any? = nil,
                object2: Any? = nil,
                delegate: Any? = nil,
                title: String? = nil,
                text: String? = nil,
                cellSize: CGSize = CGSize.zero,
                height: CGFloat = UITableView.automaticDimension,
                type: UITableViewCell.AccessoryType = .none,
                editable: Bool = false,
                interfaceDelegate: InterfaceItemDelegate? = nil) {
        super.init()
        identifier = id
        info = DefaultObject(identifier:  id)
        info?.object = object
        info?.object2 = object2
        info?.newDelegate = delegate
        info?.title = title
        info?.text = text
        info?.delegate = interfaceDelegate
        size = cellSize
        cellHeight = height
        cellType = type
        isEditable = editable
    }

}

// general class for header and footer, fields can be overriden with needs

class HeaderFooter: NSObject {

    var identifier: AKIdentifier = .header
    var height: CGFloat = 30
    var size: CGSize = .zero
    var insets: UIEdgeInsets? = nil
    var textAlignment: NSTextAlignment = .left
    var textColor: UIColor = .akBlack
    var backgroundColor: UIColor = .clear
    var font: UIFont = .medium16
    var text: String? = nil
    var textDetails: String? = nil
    var attributedText: NSAttributedString? = nil
    var attributedDetailsText: NSAttributedString? = nil
    var shouldHideButtons: Bool = true
    var anyObject: Any? = nil
    var topConstraint: CGFloat? = nil
    var constraint: CGFloat = kDefaultSideSpace * 2
    
    init(height: CGFloat = 30, text: String? = nil, size: CGSize = .zero, font: UIFont = .medium16, id: AKIdentifier = .header) {
        self.height = height
        self.text = text
        self.size = size
        self.identifier = id
        self.font = font
    }

}

// class which represents array of sections with cells, contains default settings for header, footer and cell

struct HFSuperClass {

    var cellHeight: CGFloat = UITableView.automaticDimension
    var sideSpace: CGFloat = .zero
    var data: [CellSuperClass] = []
    var header: HeaderFooter? = nil
    var footer: HeaderFooter? = nil

}

// Model section extension to use current constructor protocols with Rx

extension HFSuperClass: SectionModelType {

    var items: [CellSuperClass] {
        return data
    }

    typealias Item = CellSuperClass

    init(original: HFSuperClass, items: [CellSuperClass]) {
        self = original
        self.data = items
    }

}
