import Foundation
import UIKit
import SafariServices

class MainViewController: UIViewController {
    // MARK: - IBOutlet и IBAction
    var animator: UIViewPropertyAnimator?
    
    
    
    @IBOutlet weak var messgeField: UITextView!
    @IBOutlet weak var carImage: UIImageView!
    
    @IBAction func watchigButton(_ sender: UIButton) { // Переход на страницу поиска в интернете
        
        let screenName =  String(base[transportLine].favoriteАnime[0].name).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url = "https://shikimori.org/animes?search=" + screenName!
        let urlString = NSURL(string:url)
        
        let svc = SFSafariViewController(url: urlString! as URL)
            present(svc, animated: true, completion: nil)
    
    }
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Main Board"
        let emptyView = UIView(frame: .zero)    // Делаем navigationItem прозрачным
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: emptyView)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)  //Ловим свайп
        
        let swipe = UIPanGestureRecognizer(target: self, action: #selector(pan))
        self.view.addGestureRecognizer(swipe) //Ловим свайп
        
        messgeField.text = "Приветствую " + base[transportLine].name + ", давненько мы не виделись." + "\n" + "Ваше любимое анимэ " + base[transportLine].favoriteАnime[0].name + " ждет))" + "\n" + "По свайпу вправа вы вернетесь на поле логина. <<-" + "\n" + "Для продолжения доведите машинку до правога края. Удачи) ->>"
        
    }
//     MARK: - Переход по свайпу вправо
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer)  // Возврат к предыдушему меню по свайпу
    {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer
        {
            switch swipeGesture.direction
            {
            case UISwipeGestureRecognizer.Direction.right:
                self.navigationController?.popViewController(animated: true)
            default:
                break
            }
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
                self.performSegue(withIdentifier: "goToStart", sender: self)
            }
    
        default: return
        }
    }
   
}
