import UIKit

class SimpleAnimation: AKAnimation {

    private var duration: TimeInterval = 0.5

    override func animate(to index: Int) {
        getImageView(at: index)?.playBounceAnimation(duration: duration)
    }

    private func getImageView(at index: Int) -> UIImageView? {
        var imageView: UIImageView? = nil
        if index + 1 < tabBar.subviews.count {
            let view = tabBar.subviews[index + 1]
            imageView = view.subviews.first as? UIImageView
            imageView?.contentMode = .center
        }
        return imageView
    }

}
