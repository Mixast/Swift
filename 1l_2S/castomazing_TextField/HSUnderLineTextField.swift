import UIKit

class HSUnderLineTextField: UITextField , UITextFieldDelegate {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        backgroundColor = .clear
        borderStyle = .roundedRect
//        let border = CALayer()
//        let width = CGFloat(2.0)
//        border.borderColor = UIColor.white.cgColor
//        
//        border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: frame.size.height)
//        
//        border.borderWidth = CGFloat(1.0)
//        layer.addSublayer(border)
//        layer.masksToBounds = true
    }
}
