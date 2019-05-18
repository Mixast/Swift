import UIKit
import Alamofire
import SwiftyJSON

class TabTwoTableController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    let mainProfile = MainProfile.instance
    let friendProfile = FriendProfile.instance
    let interactive = CustomInteractiveTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if friendProfile.favoriteАnime.count == 0 {
        image.image = UIImage(named:  "Hp.jpg")
        } else {
            let imageURL = NSURL(string: "https://shikimori.org" + friendProfile.favoriteАnime[0].avatar)
            if let data = try? Data(contentsOf: imageURL! as URL) {
            image.image = UIImage(data: data)!
            }

        }
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView() //Убираем пустые строки
        
        self.setNavigationBar()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)  //Ловим свайп
        
        self.loadFriendProfile(id: friendProfile.id) {
            DispatchQueue.main.async {
                self.tableView.reloadSections([1], with: .none)
                self.loadFriendAnime(id: self.friendProfile.id) {
                    DispatchQueue.main.async {
                        self.reload(tableView: self.tableView)
                        self.tableView.reloadSections([0], with: .none)
                    }
                }
            }
        }
        
    }
//     MARK: - Reload data
    func reload(tableView: UITableView) {
    
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
    
    }
    
//     MARK: - Прогружаем скриншоты возраст друга
    private func loadFriendProfile(id: Int, completioHandler : (() ->Void)?) {
        request("https://shikimori.org/api/users/\(id)",  method: .get).validate(contentType: ["application/json"]).responseJSON() { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
            
                self.friendProfile.birthday = json["full_years"].stringValue + " years old"

            case .failure(let error):
                let arres = error.localizedDescription
                self.showAlert(massage: arres, title: "Error loading Profile Friend")
            }
            completioHandler?()
        }
    }

//     MARK: - Прогружаем список аниме друга
    private func loadFriendAnime(id: Int, completioHandler : (() ->Void)?) {
        request("https://shikimori.org/api/users/\(id)/anime_rates?&limit=60",  method: .get).validate(contentType: ["application/json"]).responseJSON() { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.friendProfile.favoriteАnime.removeAll()
                var i = 0
                for (_, subJson):(String, JSON) in json[] {
                    
                    self.friendProfile.favoriteАnime.append(АnimeFriend())
                    self.friendProfile.favoriteАnime[i].id = subJson["anime"]["id"].intValue
                    self.friendProfile.favoriteАnime[i].name = subJson["anime"]["name"].stringValue + " ( \(subJson["anime"]["russian"].stringValue)) "
                    self.friendProfile.favoriteАnime[i].series = subJson["anime"]["episodes"].intValue
                    
                    if i == 0 {
                        self.friendProfile.favoriteАnime[i].avatar = subJson["anime"]["image"]["original"].stringValue
                    }
                    
                    i+=1
                }
            case .failure(let error):
                let arres = error.localizedDescription
                self.showAlert(massage: arres, title: "Error loading Profile Friend Anime list")
            }
            completioHandler?()
        }
    }
    
    func showAlert (massage: String, title: String) {    // Вывод ошибки если пользователь ввел неправильно данные
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func setNavigationBar() {
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 50))
        navBar.backgroundColor = .clear
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        let navItem = UINavigationItem(title: "Profile")
        navItem.largeTitleDisplayMode = .automatic
        
        let doneItem = UIBarButtonItem(title: "Friend list", style: .done, target: nil, action: #selector(handleShowIndexPath))
        doneItem.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        navItem.leftBarButtonItem = doneItem
        
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)]
        navBar.setItems([navItem], animated: false)
        navBar.tag = 999
        self.view.addSubview(navBar)
        
    }
    
    @objc func handleShowIndexPath() {      //Подключение любой кнопки
        dismiss(animated: true)
    }
    
    
    //     MARK: - Переход по свайпу вправо
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer)  // Возврат к предыдушему меню по свайпу
    {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer
        {
            switch swipeGesture.direction
            {
            case UISwipeGestureRecognizer.Direction.right:
                dismiss(animated: true)
            default:
                break
            }
        }
    }
    
        // MARK: - Создаем имена секций
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {     // Создание section решеток
        let button = UIButton(type: .system)
        switch section {
        case 0:
            break
        case 1:
            button.setTitle("Birthday" , for: .normal)
        case 2:
            button.setTitle("FavoriteАnime" , for: .normal)
        default:
            break
        }

        button.backgroundColor = #colorLiteral(red: 0.1247105226, green: 0.1294333935, blue: 0.1380615532, alpha: 1)
        button.setTitleColor(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), for: .normal)
        return button
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 18
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            if friendProfile.favoriteАnime.count != 0 {
                return friendProfile.favoriteАnime.count
            } else {
                return 1
            }
        default:
            return 0
        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
           return 120
        } else if indexPath.section == 2 {
            if friendProfile.favoriteАnime.count != 0 {
                var heightView = (CGFloat(Double(friendProfile.favoriteАnime[indexPath.row].name.count)*7.32)/(tableView.frame.size.width))+2
                heightView.round(.awayFromZero)
                heightView*=22
                return heightView
            } else {
                return 16
            }
        } else {
            return 22
        }
    }

    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {    //reload data при повороте
        self.view.viewWithTag(999)!.frame.size.width = self.view.frame.size.width
        guard let viewWithTag = self.view.viewWithTag(100)  else {
            return
        }
        guard let viewWithTag2 = self.view.viewWithTag(90)  else {
            return
        }
        viewWithTag2.removeFromSuperview()
        viewWithTag.removeFromSuperview()
        tableView.reloadData()
    }

    // MARK: - Создаем имена строк

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IntoTabTwoTableViewCell") as? IntoTabTwoTableViewCell  else { return UITableViewCell() }
        switch indexPath.section {
        case 0:
            cell.infoText.text = friendProfile.name
            cell.createIconAvatar(image: friendProfile.avatar)
            cell.textLabel?.text = ""
            self.view.viewWithTag(90)
        case 1:
            cell.textLabel?.text = friendProfile.birthday
        case 2:
            if friendProfile.favoriteАnime.count != 0 {
                cell.textLabel?.textAlignment = .left
                cell.infoText.text = ""
                cell.textLabel?.text = friendProfile.favoriteАnime[indexPath.row].name + "\n" + "Просмотрено серий: \(friendProfile.favoriteАnime[indexPath.row].series)"
                cell.textLabel?.lineBreakMode = .byWordWrapping
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.contentMode = .center
                guard let viewWithTag = self.view.viewWithTag(100)  else {
                    break
                }
                guard let viewWithTag2 = self.view.viewWithTag(90)  else {
                    break
                }
                viewWithTag2.removeFromSuperview()
                viewWithTag.removeFromSuperview()
            } else {
                cell.infoText.text = "Loading"
                cell.textLabel?.textAlignment = .center
            }
        default:
            break
        }
        cell.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return cell
    }

    // MARK: - Переход при нажатии на строку
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
          
            loadImageProfile(section: indexPath.row) { // Составляем базу картинок
                DispatchQueue.main.async {
                    
                    let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "TabOneCollectionViewController") as! TabOneCollectionViewController
                    detailVC.transportLine = indexPath.row
                    detailVC.profile = "friendProfile"
                    detailVC.transitioningDelegate = self
                    self.present(detailVC, animated: true)
                    
                }
            }
        }
    }
    
    //     MARK: - Получение скриншоты из аниме
    private func loadImageProfile(section: Int, completioHandler : (() ->Void)?) {
        request("https://shikimori.org/api/animes/\(friendProfile.favoriteАnime[section].id)/screenshots",  method: .get).validate(contentType: ["application/json"]).responseJSON() { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                self.friendProfile.favoriteАnime[section].colectionImage.removeAll()
                for (_, subJson):(String, JSON) in json[] {
                self.friendProfile.favoriteАnime[section].colectionImage.append(subJson["original"].stringValue)
                self.friendProfile.favoriteАnime[section].colectionImG.append(UIImage())
                }
            case .failure(let error):
                let arres = error.localizedDescription
                self.showAlert(massage: arres, title: "Error loading")
            }
            completioHandler?()
        }
    }
    
}

// MARK: - Кастомная анимация перехода detailVC.transitioningDelegate

extension TabTwoTableController:  UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animatedTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animatedTransitionDismissed()
    }
        
}

