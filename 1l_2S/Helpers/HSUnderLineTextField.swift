import UIKit

class HSUnderLineTextField: UITextField , UITextFieldDelegate {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        backgroundColor = .clear
        borderStyle = .roundedRect
    }
}
