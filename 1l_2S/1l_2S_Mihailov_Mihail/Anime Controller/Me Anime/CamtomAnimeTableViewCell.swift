import UIKit
import WebKit

class CamtomAnimeTableViewCell: UITableViewCell {

    @IBOutlet weak var animeSeries: UILabel!
    @IBOutlet weak var animeStepp: HSUnderLineStepper!
    @IBOutlet weak var videoPlayer: WKWebView!
    @IBOutlet weak var videoPlayerImage: UIImageView!
    @IBOutlet weak var videoPlayerButton: playButton!
    var isOn = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

