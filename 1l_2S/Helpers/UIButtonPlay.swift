import UIKit

class playButton: UIButton {
    var statusPlay = (0 ,false) {
        didSet {
            setNeedsDisplay()
        }
    }
}
