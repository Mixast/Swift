import Foundation
import UIKit
import SafariServices

class MainViewController: UIViewController {
    // MARK: - IBOutlet и IBAction
    
    @IBOutlet weak var messgeField: UITextView!
    
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
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGestureTwo))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft) //Ловим свайп
        
        messgeField.text = "Приветствую " + base[transportLine].name + ", давненько мы не виделись." + "\n" + "Ваше любимое анимэ " + base[transportLine].favoriteАnime[0].name + " ждет))" + "\n" + "По свайпу вправа вы вернетесь на поле логина. <<-" + "\n" + "По свайпу влево вы перейдете дальше. Удачи) ->>"
        
    }
    // MARK: - Переход по свайпу вправо
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
    // MARK: - Переход по свайпу влево
    
    @objc func respondToSwipeGestureTwo(gesture: UIGestureRecognizer)  // Возврат к предыдушему меню по свайпу
    {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer
        {
            switch swipeGesture.direction
            {
            case UISwipeGestureRecognizer.Direction.left:
                self.performSegue(withIdentifier: "goToStart", sender: self)
            default:
                break
            }
        }
    }



}
