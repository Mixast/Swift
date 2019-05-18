import UIKit

class IntoTabTwoTableViewCell: UITableViewCell {
    let imageSize: (height: CGFloat, width: CGFloat) = (90.0, 90.0)
    let cornerRadius: CGFloat = 45.0
    @IBInspectable var shadow: Bool = true
    @IBInspectable var shadowCollor: UIColor = .black
    @IBInspectable var shadowOpacity: Float = 0.7
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 5.0, height: 5.0)
    @IBInspectable var shadowRadius: CGFloat = 5.0
    
    @IBOutlet weak var infoText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
    }

    
    func createIconAvatar(image name: UIImage) {  // Создание иконок
        
        let imageContainer = UIView(frame: CGRect(x: 10, y: 15, width: imageSize.width, height: imageSize.height))
        
        if shadow {
            imageContainer.clipsToBounds = false
            imageContainer.layer.shadowColor = shadowCollor.cgColor
            imageContainer.layer.shadowOpacity = shadowOpacity
            imageContainer.layer.shadowOffset = shadowOffset
            imageContainer.layer.shadowRadius = shadowRadius
            imageContainer.tag = 90
            imageContainer.layer.shadowPath = UIBezierPath(roundedRect: imageContainer.bounds, cornerRadius: cornerRadius).cgPath
        }
        
        let imageView = UIImageView(frame: imageContainer.bounds)
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1.0
        imageView.image = name
        imageView.tag = 100
        self.addSubview(imageContainer)
        imageContainer.addSubview(imageView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageContainer.isUserInteractionEnabled = true
        imageContainer.addGestureRecognizer(tapGestureRecognizer)
    
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) //Анимация по нажатию
    {
        UIView.animate(withDuration: 6,
                       delay: 0.2,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 4,
                       options: [],
                       animations: {
                        self.viewWithTag(100)!.transform = self.viewWithTag(100)!.transform.rotated(by: CGFloat(Double.pi))
                        self.viewWithTag(100)!.transform = .identity
        })
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
    }

}
