import Foundation
import UIKit
import SafariServices


class MainViewController: UIViewController {
    // MARK: - IBOutlet и IBAction
    let mainProfile = MainProfile.instance
    var animator: UIViewPropertyAnimator?
    
    @IBOutlet weak var messgeField: UITextView!
    @IBOutlet weak var carImage: UIImageView!
    
    @IBAction func watchigButton(_ sender: UIButton) { // Переход на страницу поиска в интернете
        let screenName =  String(self.mainProfile.favoriteАnime[0].name).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url = "https://shikimori.org/animes?search=" + screenName!
        let urlString = NSURL(string:url)
        
        let svc = SFSafariViewController(url: urlString! as URL)
            present(svc, animated: true, completion: nil)
    
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let swipe = UIPanGestureRecognizer(target: self, action: #selector(pan))
        self.view.addGestureRecognizer(swipe) //Ловим свайп
        
        messgeField.text = "Приветствую " + self.mainProfile.name + ", давненько мы не виделись." + "\n" + "Ваше любимое анимэ " + self.mainProfile.favoriteАnime[0].name + " ждет))" + "\n" + "Для продолжения доведите машинку до правога края. Удачи) ->>"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if chek { // Костыль для перехода в самое начало
            dismiss(animated: true)
            chek = false
        }
    }
    

    
//     MARK: - Анимация передвижения машинки
    @objc func pan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            animator = UIViewPropertyAnimator(duration: 6, curve: .linear, animations: {
                self.carImage.frame.origin.x += self.view.frame.maxX - (self.carImage.frame.origin.x + self.carImage.frame.size.width + 50)
            })
            animator?.pauseAnimation()
        case .changed:
            let translation = recognizer.translation(in: self.view)
            animator?.fractionComplete = translation.x / 400
        case .ended:
            animator?.stopAnimation(true)
            if self.carImage.frame.origin.x >= self.view.frame.maxX - (self.carImage.frame.size.width + 150) {
                
                
                    let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    
                    let customViewControllersArray : NSArray = [newViewController]
                    self.navigationController?.viewControllers = customViewControllersArray as! [UIViewController]
                    
                    self.performSegue(withIdentifier: "goToStartTwo", sender: self)
                
            }
    
        default: return
        }
    }
    
}
