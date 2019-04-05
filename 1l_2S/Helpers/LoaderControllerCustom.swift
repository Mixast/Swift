import UIKit

class LoaderController: UIView {

    var flack = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        if flack == false {
            
            let imageView : UIImageView
            imageView  = UIImageView(frame: CGRect(x: self.bounds.midX - 20, y:  self.bounds.midY - 20, width: 30, height: 30));
            imageView.image = #imageLiteral(resourceName: "icons8-time-machine-25")
            self.addSubview(imageView)
            
            let position = CAKeyframeAnimation(keyPath: "position")
            position.values = [ NSValue.init(cgPoint: .zero) , NSValue.init(cgPoint: CGPoint(x: 40, y: 0)) ,  NSValue.init(cgPoint: CGPoint(x: 40, y: 40)) ,  NSValue.init(cgPoint: CGPoint(x: 0, y: 40)), NSValue.init(cgPoint: CGPoint(x: 0, y: 0)), NSValue.init(cgPoint: .zero) ]
            position.timingFunctions = [ CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut),  CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)  ]
            position.isAdditive = true
            position.duration = 2.5
            
            let rotation = CAKeyframeAnimation(keyPath: "transform.rotation")
            rotation.values = [ 0, 0.4 , 0.8, 1, 0.8, 0.4, 0 ]
            rotation.duration = 2.5
            rotation.timingFunctions = [ CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut),  CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)  ]
            
            let fadeAndScale = CAAnimationGroup()
            fadeAndScale.animations = [ position, rotation]
            fadeAndScale.duration = 2.5
            fadeAndScale.repeatCount = .infinity
            
            imageView.layer.add(fadeAndScale, forKey: nil)
        } else {
            self.subviews.forEach({ $0.removeFromSuperview() })
        }
        
    }
    
}
