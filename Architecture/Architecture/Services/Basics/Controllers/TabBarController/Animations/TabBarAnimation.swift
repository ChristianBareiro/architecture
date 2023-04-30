import UIKit

enum TabBarAnimationType {

    case simple(UITabBar)
    case circular(UITabBar)

    var classObject: AKAnimation {
        switch self {
        case .simple(let bar): return SimpleAnimation(bar: bar)
        case .circular(let bar): return CircularAnimation(bar: bar)
        }
    }
    
}

class AKAnimation: NSObject {
    
    var tabBar: UITabBar!
    
    public init(bar: UITabBar) {
        super.init()
        tabBar = bar
        customInit()
    }
    
    public func animate(to: Int) {}
    public func customInit() {}
    
}

class TabBarAnimation: NSObject {

    private var animation: AKAnimation!

    public init(with bar: UITabBar, animation: TabBarAnimationType) {
        super.init()
        self.animation = animation.classObject
        self.animation.tabBar = bar
    }

    open func animateTo(index: Int) {
        animation.animate(to: index)
    }

}
