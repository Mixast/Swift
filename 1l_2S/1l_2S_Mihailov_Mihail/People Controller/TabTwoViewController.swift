import UIKit

class TabTwoTableController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var transportLine = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = "Profile"  // Имя поля
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true // Делаем прозрачным navigationBar
        
        image.image = UIImage(named:  base[transportLine].favoriteАnime[0].name +  ".jpg")
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView() //Убираем пустые строки
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
            return base[transportLine].favoriteАnime.count
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
            cell.infoText.text = base[transportLine].name
            cell.createIconAvatar(image: base[transportLine].avatar + ".jpg")
            self.view.viewWithTag(90)
        case 1:
            cell.textLabel?.text = base[transportLine].birthday
        case 2:
            cell.textLabel?.text = base[transportLine].favoriteАnime[indexPath.row].name + "\n" + "Просмотрено серий: \(base[transportLine].favoriteАnime[indexPath.row].series)"
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


