import UIKit

class TabTwoTableController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    let friendProfile = FriendProfile.instance

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if friendProfile.favoriteАnime.count == 0 {
        image.image = UIImage(named:  "Hp.jpg")
        } else {
        image.image = UIImage(named:  friendProfile.favoriteАnime[0].name +  ".jpg")
        }
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView() //Убираем пустые строки
        
        self.setNavigationBar()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)  //Ловим свайп
        
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
            return friendProfile.favoriteАnime.count
        default:
            return 0
        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
           return 120
        } else if indexPath.section == 2 {
            return 44
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
            cell.createIconAvatar(image: friendProfile.avatar + ".jpg")
            self.view.viewWithTag(90)
        case 1:
            cell.textLabel?.text = friendProfile.birthday
        case 2:
            cell.textLabel?.text = friendProfile.favoriteАnime[indexPath.row].name + "\n" + "Просмотрено серий: \(friendProfile.favoriteАnime[indexPath.row].series)"
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.contentMode = .center
        default:
            break
        }
        cell.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return cell
    }

}


