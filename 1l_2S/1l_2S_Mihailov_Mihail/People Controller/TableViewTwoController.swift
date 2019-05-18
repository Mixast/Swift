import UIKit

class TableViewTwoController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    private var searching = false
    private var filteredList = [Friend]()
    let friendProfile = FriendProfile.instance
    let mainProfile = MainProfile.instance

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundView: UIImageView!
    
    var sectionNumber = 1
    var rowNumber = [(Int, Int)]()

    override func viewDidLoad() {
        sortedPeople()
        super.viewDidLoad()
        
        backgroundView.image = UIImage(named: "Hp.jpg")
        
        navigationItem.title = "Friend list"  // Имя поля
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true // Делаем прозрачным navigationBar
        
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView() //Убираем пустые строки
        
        self.tableView.tableFooterView = UIView() //Убираем пустые строки
        
//             MARK: - Параллельно прогружаем картинки аниме
        
        let queue = DispatchQueue.global(qos: .utility)
        queue.async{
            DispatchQueue.main.async {
                for i in 1...self.mainProfile.friends.count {
                    let namePhoto = namedConstructor(text: self.mainProfile.friends[i-1].avatarName)
                    if loadImage(namePhoto: namePhoto).pngData() == nil {
                        let imageURL = NSURL(string: self.mainProfile.friends[i-1].avatarName)
                        if let data = try? Data(contentsOf: imageURL! as URL) {
                            self.mainProfile.friends[i-1].avatar = UIImage(data: data)!
                            fileSestemSave(namePhoto: namePhoto, img: UIImage(data: data)!)
                        }
                    } else {
                        self.mainProfile.friends[i-1].avatar = loadImage(namePhoto: namePhoto)
                    }
                }
                self.tableView.reloadData()
            }
        }

    }
    
    
    //MARK: - Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {  //searchBar
        guard searchText != "" else {
            searching = false
            tableView.reloadData()
            return
        }

        filteredList.removeAll()
        
        for i in 1...mainProfile.friends.count {

            if mainProfile.friends[i-1].name.lowercased().prefix(searchText.count) == searchText.lowercased() {
                filteredList.append(mainProfile.friends[i-1])
            }
        }
        tableView.reloadData()
        if filteredList.count != 0 {
            searching = true }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    //MARK: - Sorted People
    
    func sortedPeople() {
        
        var indx = 0
        while indx < mainProfile.friends.count-1{
            if mainProfile.friends[indx].name > mainProfile.friends[indx+1].name {
                mainProfile.friends.append(mainProfile.friends[indx])
                mainProfile.friends.remove(at: indx)
            } else {
                indx+=1
            }
        }
        
        var coint = 1
        for i in 1...mainProfile.friends.count-1 {
            if mainProfile.friends[i-1].name.first != mainProfile.friends[i].name.first {
                sectionNumber+=1
                rowNumber.append((sectionNumber-2, coint))
                coint = 1
            } else {
                coint+=1
            }
            if i == mainProfile.friends.count-1 && mainProfile.friends[i].name.first != mainProfile.friends[i-1].name.first {
                rowNumber.append((sectionNumber-1, coint))
            }
        }
    }
    
    // MARK: - Создание секций и их тайтлов
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {     // Создание section решеток
        let button = UIButton(type: .system)
        if searching {

            button.setTitle("Search resault", for: .normal)
            button.contentHorizontalAlignment = .center
            button.backgroundColor = #colorLiteral(red: 0.1247105226, green: 0.1294333935, blue: 0.1380615532, alpha: 1)
            button.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
        } else {
        
            var idx = 0
            if section > 0 {
                for i in 1...section{
                    idx += rowNumber[i-1].1
                }
            }
        
            button.setTitle(String(mainProfile.friends[idx].name.first!), for: .normal)
            button.contentHorizontalAlignment = .left
            button.contentEdgeInsets = UIEdgeInsets(top: 0,left: 85,bottom: 0,right: 0)
            button.backgroundColor = #colorLiteral(red: 0.1247105226, green: 0.1294333935, blue: 0.1380615532, alpha: 1)
            button.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
        }
        return button
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searching {
            return 1
        } else {
        return sectionNumber
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 18
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return filteredList.count
        } else {
            return rowNumber[section].1
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var idx = 0
        if indexPath.section > 0 {
            for i in 1...indexPath.section{
                idx += rowNumber[i-1].1
            }
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else { return UITableViewCell() }
        cell.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        if searching {
            cell.textLabel?.text = filteredList[indexPath.row].name
            cell.imageView?.image = filteredList[indexPath.row].avatar  // Добавляем аватарку
        } else {
            cell.textLabel?.text = mainProfile.friends[idx+indexPath.row].name
            cell.imageView?.image =  mainProfile.friends[idx+indexPath.row].avatar      // Добавляем аватарку
            cell.imageView?.layer.cornerRadius = 25.0                                    // Делаем её круглой
            cell.imageView?.layer.masksToBounds = true
        }
        return cell
        
    }
    
// MARK: - Переход при нажатии на строку
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var idx = 0
        if indexPath.section > 0 {
            for i in 1...indexPath.section{
                idx += rowNumber[i-1].1
            }
        }

        if searching {

            for i in 1...mainProfile.friends.count {
                if mainProfile.friends[i-1].name == filteredList[indexPath.row].name {
                    friendProfile.avatarName = filteredList[indexPath.row].avatarName
                    friendProfile.id = filteredList[indexPath.row].id
                    friendProfile.avatar = filteredList[indexPath.row].avatar
                    friendProfile.name = filteredList[indexPath.row].name
                    
                    let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "TabTwoTableController") as! TabTwoTableController
                    detailVC.transitioningDelegate = self
                    self.present(detailVC, animated: true)

                }
            }
            
        } else {
                    friendProfile.avatarName = mainProfile.friends[idx+indexPath.row].avatarName
                    friendProfile.id = mainProfile.friends[idx+indexPath.row].id
                    friendProfile.avatar = mainProfile.friends[idx+indexPath.row].avatar
                    friendProfile.name = mainProfile.friends[idx+indexPath.row].name
            
                            let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "TabTwoTableController") as! TabTwoTableController
                            detailVC.transitioningDelegate = self
                            self.present(detailVC, animated: true)
        }
    }
    
}

// MARK: - Кастомная анимация перехода detailVC.transitioningDelegate

extension TableViewTwoController:  UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animatedTransition()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animatedTransitionDismissed()
    }
    
    
}



