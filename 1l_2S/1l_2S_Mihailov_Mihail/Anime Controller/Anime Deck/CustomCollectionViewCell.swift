

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageAnime: UIImageView!
    
    let mainProfile = MainProfile.instance
    let friendProfile = FriendProfile.instance
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageAnime.translatesAutoresizingMaskIntoConstraints = false
        imageAnime.isUserInteractionEnabled = true
        
    }

}
