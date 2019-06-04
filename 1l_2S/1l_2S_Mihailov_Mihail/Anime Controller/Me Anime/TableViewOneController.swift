import UIKit
import WebKit
import KeychainSwift
import Alamofire
import SwiftyJSON
import Kanna
import RealmSwift

class TableViewOneController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var changesToken: NotificationToken?

    
    private var transportLine = 0
    private var hop = 10
    let interactive = CustomInteractiveTransition()
    let mainProfile = MainProfile.instance
    var animeList = [АnimeList]()
    private var saveSector = 0
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let realm =  try? Realm() else {
            print("Error Realm")
            return
        }
        let object = realm.objects(RealmBase.self)
        guard let base = Optional(object[transportRealmIndex]) else {
            return
        }

        // Ловим изменение в реалм
        changesToken = base.favoriteАnime.observe { changes in
            switch changes {
            case .update( _, deletions: let deletions, insertions: let insertions, modifications: let modifications):
               
                self.tableView.performBatchUpdates({
                    if insertions != [] {
                        self.tableView.insertSections(insertions.map({ IndexSet(integer: $0) })[0], with: .none)
                    } else if deletions != [] {
                        self.tableView.deleteSections(deletions.map({ IndexSet(integer: $0) })[0], with: .none)
                    } else  if modifications != [] {
                    self.tableView.reloadSections(modifications.map({ IndexSet(integer: $0) })[0], with: .none)
                    }
                }, completion: { _ in
                    print("updated")
                })
                
            case .error(let error): print(error)
            default: return
            }
        }

        
//     MARK: - Параллельно прогружаем картинки аниме
        DispatchQueue.global().async {
            for i in 1...self.mainProfile.favoriteАnime.count {
                
                let namePhoto = namedConstructor(text: self.mainProfile.favoriteАnime[i-1].avatar)
                if loadImage(namePhoto: namePhoto) == Data() {
                    let imageURL = NSURL(string: "https://shikimori.one" + self.mainProfile.favoriteАnime[i-1].avatar)
                    
                    let queue = DispatchQueue.global(qos: .utility)
                    queue.async{
                        if let data = try? Data(contentsOf: imageURL! as URL){
                            DispatchQueue.main.async { [weak self] in
                                guard let self = self else { return }
                                
                                self.mainProfile.favoriteАnime[i-1].avatarImageData = data
                                fileSistemSave(namePhoto: namePhoto, data: data)

                                guard let realm =  try? Realm() else {
                                    print("Error Realm")
                                    return
                                }
                                
                                let object = realm.objects(RealmBase.self)
                                guard let base = Optional(object[transportRealmIndex]) else {
                                    return
                                }
                                if base.favoriteАnime.count < i-1 {
                                    return
                                }
                                if base.favoriteАnime[i-1].avatarImageData == Data() {
                                    
                                    try! realm.write {
                                        base.favoriteАnime[i-1].avatarImageData = data
                                    }
                                }
                            }
                        }
                    }
                } else {
                    DispatchQueue.global().async {
                        self.mainProfile.favoriteАnime[i-1].avatarImageData = loadImage(namePhoto: namePhoto)
                        DispatchQueue.main.async {
                            self.tableView.reloadSections([i-1], with: .none)
                        }
                    }
                }
            }
        }
        
        navigationItem.title = "Favorite anime"  // Имя поля
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add anime", style: .plain, target: self, action: #selector(handleShowIndexPath))
 
        let doneItem = UIBarButtonItem(title: "Log out", style: .done, target: self, action: #selector(exitLogin))
        doneItem.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        navigationItem.leftBarButtonItem = doneItem
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true // Делаем прозрачным navigationBar
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView() //Убираем пустые строки
        
        // Кастомный Header

        let headerNib = UINib.init(nibName: "TableViewAnimeHeader", bundle: Bundle.main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "TableViewAnimeHeader")
        
        
        // Загрузка списка аниме ( пока на кастыле )
        self.loadAnimeList {
            DispatchQueue.global().async {
                 for m in 1...self.mainProfile.favoriteАnime.count {

                    var count = 0
                    var countBase = self.animeList.count
                    for i in 1...countBase {
                        if self.mainProfile.favoriteАnime[m-1].name == self.animeList[count].name {
                            self.animeList.remove(at: i-1)
                            countBase-=1
                        } else {
                            count+=1
                        }
                    }

                }
                //     MARK: - Параллельно прогружаем картинки аниме
                for i in 1...self.animeList.count {
                    let imageURL = NSURL(string: "https://shikimori.one" + self.animeList[i-1].avatar)

                    let queue = DispatchQueue.global(qos: .utility)
                    queue.async{
                        if let data = try? Data(contentsOf: imageURL! as URL){
                            DispatchQueue.main.async { [weak self] in
                                guard let self = self else { return }
                                self.animeList[i-1].avatarImageData = data
                                self.animeList[i-1].flackTwo = true

                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    @objc func exitLogin() {
        let keychain = KeychainSwift()
        keychain.delete(Keys.accessToken)
        keychain.delete(Keys.refreshToken)
        
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
                                 for: records.filter{ $0.displayName.contains("shikimori") },
            completionHandler: { })
        }
        
        DispatchQueue.global().async {
            for i in 1...self.mainProfile.favoriteАnime.count {
                if self.mainProfile.favoriteАnime[i-1].avatarImageData != Data() {
                    let namePhoto = namedConstructor(text: self.mainProfile.favoriteАnime[i-1].avatar)
                    deleteImage(namePhoto: namePhoto)
                }
                if self.mainProfile.favoriteАnime[i-1].descriptionInfo != "" {
                    let nameTextFile = "description_" + self.mainProfile.favoriteАnime[i-1].name + ".txt"
                    deleteImage(namePhoto: nameTextFile)
                }
            }
            self.mainProfile.favoriteАnime.removeAll()
            self.mainProfile.friends.removeAll()
        }
        
        UserDefaults.standard.set(true, forKey: Keys.chek) // Костыль для перехода в самое начало
        dismiss(animated: true)
    }
    
    //     MARK: - Получение списка анимэ для добавления
    private func loadAnimeList(completioHandler : (() ->Void)?) {
        request("https://shikimori.one/api/animes?censored=false&genre=1,2,11&limit=20",  method: .get).validate(contentType: ["application/json"]).responseJSON() { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.animeList.removeAll()
                var count: Int = 0
                for (_, subJson):(String, JSON) in json[] {
                    
                    self.animeList.append(АnimeList())
                    self.animeList[count].id = subJson["id"].intValue
                    self.animeList[count].name = subJson["name"].stringValue + " ( \(subJson["russian"].stringValue))"
                    self.animeList[count].avatar = subJson["image"]["original"].stringValue
                    self.animeList[count].maxSeries = subJson["episodes"].intValue
                    self.animeList[count].status = subJson["status"].stringValue
       
                    count += 1
                }
                
            case .failure(let error):
                let arres = error.localizedDescription
                self.showAlert(massage: arres, title: "Error friends")
                return
            }
            completioHandler?()
        }
    }
    
//     MARK: - Добавляем аниме в лист
    @objc func handleShowIndexPath() {
        let last = animeList.count
        if animeList.count == 0 { // Сообщение при пустом списке
            let optionMenu = UIAlertController(title: "Ура", message: "У вас в списке все аниме", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            optionMenu.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            optionMenu.addAction(cancelAction)
            self.present(optionMenu, animated: true, completion: nil)
        } else if animeList[last-1].avatarImageData == Data() {
            let optionMenu = UIAlertController(title: "Loading", message: "Загружается список аниме", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            optionMenu.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            optionMenu.addAction(cancelAction)
            self.present(optionMenu, animated: true, completion: nil)
        } else {
                let optionMenu = UIAlertController(title: "Anime deck", message: "Что вы хотите добавить?", preferredStyle: .actionSheet)

                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

            var pop = 0
            for _ in 1...animeList.count { // Создаем кнопки с картинками и названием аниме
                if self.animeList[pop].flackOne == true && self.animeList[pop].flackTwo == true {
                    self.animeList.remove(at: pop)
                } else {
                    pop+=1
                }
            }

            for i in 1...animeList.count { // Создаем кнопки с картинками и названием аниме

                    guard let image = UIImage(data: self.animeList[i-1].avatarImageData) else {
                        return
                    }
                    let imageTitle = image.scaled(to: 80)

                    let greeting = self.animeList[i-1].name
                    let endOfSentence = greeting.index(of: "(")!
                    let firstSentence = greeting[..<endOfSentence]

                    let addAnime = UIAlertAction(title: String(firstSentence), style: .default, handler: { (action: UIAlertAction!) -> Void in
                        self.mainProfile.favoriteАnime.append(Аnime())
                        let indx = self.mainProfile.favoriteАnime.endIndex - 1
                        self.mainProfile.favoriteАnime[indx].id = self.animeList[i-1].id
                        self.mainProfile.favoriteАnime[indx].name = self.animeList[i-1].name
                        self.mainProfile.favoriteАnime[indx].avatar = self.animeList[i-1].avatar
                        self.mainProfile.favoriteАnime[indx].status = self.animeList[i-1].status
                        self.mainProfile.favoriteАnime[indx].maxSeries = self.animeList[i-1].maxSeries

                        if self.animeList[i-1].avatarImageData == Data() {
                            let imageURL = NSURL(string: "https://shikimori.one" + self.animeList[i-1].avatar)
                            let queue = DispatchQueue.global(qos: .utility)
                            queue.async{
                                if let data = try? Data(contentsOf: imageURL! as URL) {
                                    DispatchQueue.main.async { [weak self] in
                                        guard let self = self else { return }
                                        self.animeList[i-1].avatarImageData = data
                                        self.mainProfile.favoriteАnime[indx].avatarImageData = self.animeList[i-1].avatarImageData
                                        self.animeList[i-1].flackOne = true
                                    }
                                }
                            }
                        } else {
                            self.mainProfile.favoriteАnime[indx].avatarImageData = self.animeList[i-1].avatarImageData
                            self.animeList[i-1].flackOne = true
                        }
                        

                            guard let realm =  try? Realm() else {
                                print("Error Realm")
                                return
                            }

                            let object = realm.objects(RealmBase.self)
                            guard let base = Optional(object[transportRealmIndex]) else {
                                return
                            }

                            let anime = FavoriteАnime()
                            anime.id = self.animeList[i-1].id
                            anime.name = self.animeList[i-1].name
                            anime.avatar = self.animeList[i-1].avatar
                            anime.avatarImageData = self.animeList[i-1].avatarImageData
                            anime.status = self.animeList[i-1].status
                            anime.maxSeries = self.animeList[i-1].maxSeries
                        
                            try! realm.write {
                                base.favoriteАnime.append(anime)
                            }
                        
                        
                        // здесь должен быть post запрос для добавления в список
                        
                        self.animeList.remove(at: i-1)
                    })
                    addAnime.setValue(imageTitle?.withRenderingMode(.alwaysOriginal), forKey: "image")
                    optionMenu.addAction(addAnime)
                    optionMenu.view.tintColor = .black

            }
                optionMenu.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
                optionMenu.addAction(cancelAction)

            // Добавляем небольшую костомизацию размер текста и перенос

            UILabel.appearance(whenContainedInInstancesOf: [UIAlertController.self]).lineBreakMode = .byWordWrapping
            UILabel.appearance(whenContainedInInstancesOf: [UIAlertController.self]).preferredMaxLayoutWidth = 160
            UILabel.appearance(whenContainedInInstancesOf: [UIAlertController.self]).numberOfLines = 0
            UILabel.appearance(whenContainedInInstancesOf: [UIAlertController.self]).font = UIFont.systemFont(ofSize: 12)
            self.present(optionMenu, animated: true, completion: nil)
        }
    }


// MARK: - Создание секций и их тайтлов
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableViewAnimeHeader") as? TableViewAnimeHeader
        header?.viewAnime.backgroundColor = #colorLiteral(red: 0.1247105226, green: 0.1294333935, blue: 0.1380615532, alpha: 1)
        header?.animeButton.setTitle(self.mainProfile.favoriteАnime[section].name, for: .normal)
        header?.animeButton.backgroundColor = .clear
        header?.animeButton.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        header?.animeButton.setTitleColor(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), for: .normal)
        header?.animeButton.titleLabel?.lineBreakMode = .byWordWrapping
        header?.animeButton.titleLabel?.numberOfLines = 0
        header?.animeButton.tag = section
        header?.animeImage.layer.masksToBounds = true
        header?.wowNewAnime.layer.masksToBounds = true
        header?.animeSeries.text = "S: " + String(self.mainProfile.favoriteАnime[section].series)
        header?.animeSeries.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        if self.mainProfile.favoriteАnime[section].maxSeries == self.mainProfile.favoriteАnime[section].series {
            header?.wowNewAnime.image = nil
        } else {
            header?.wowNewAnime.image = #imageLiteral(resourceName: "icons8-vnim-50")
        }
        
        if self.mainProfile.favoriteАnime[section].avatarImageData != Data() {
            header?.animeImage.image = UIImage(data: self.mainProfile.favoriteАnime[section].avatarImageData)
        }

        return header
    }

    @objc func handleExpandClose(button: UIButton) { // Действие при нажатии на секцию
        
        if self.mainProfile.favoriteАnime[button.tag].flack == true {
            self.mainProfile.favoriteАnime[button.tag].flack = false
            
            tableView.reloadData()
        } else {
            // Закрытие предыдушей секции
            if saveSector != button.tag {
                self.mainProfile.favoriteАnime[saveSector].flack = false
            }
            saveSector = button.tag
            self.mainProfile.favoriteАnime[button.tag].flack = true
            tableView.reloadData()
        }
    }
    
    // MARK: - numberOfSections
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.mainProfile.favoriteАnime.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var heightView = (CGFloat(Double(self.mainProfile.favoriteАnime[section].name.count)*7.32)/(tableView.frame.size.width))+2
        heightView.round(.awayFromZero)
        heightView*=20
        return heightView
    }

    // MARK: - numberOfRowsInSection
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.mainProfile.favoriteАnime[section].flack  == true {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(300)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CamtomAnimeTableViewCell") as? CamtomAnimeTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        cell.animeSeries.text = "S: " + String(self.mainProfile.favoriteАnime[indexPath.section].series)
        cell.animeStepp.row = indexPath.section
        cell.animeStepp.value = Double(self.mainProfile.favoriteАnime[indexPath.section].series)
        cell.videoPlayerButton.tag = indexPath.section
        
        
        if cell.videoPlayerButton.statusPlay == (indexPath.section, true) {     // Подключаем видео плеер если нажата кнопка
            cell.videoPlayerImage.image = UIImage()
            cell.videoPlayerButton.setImage(UIImage(), for: .normal)
            cell.videoPlayerButton.isUserInteractionEnabled = false
            cell.loadingVideo.flack = false
            
            if mainProfile.favoriteАnime[indexPath.section].colectionUrl.count == 0 {
                displayURL(name: mainProfile.favoriteАnime[indexPath.section].name) {
                    DispatchQueue.main.async {
                        guard var url = URL(string: "https://www.anilibria.tv/img/404.png") else {
                            return
                        }
                        if self.mainProfile.favoriteАnime[indexPath.section].colectionUrl.count == 0 {
                            self.mainProfile.favoriteАnime[indexPath.section].colectionUrl.removeAll()
                            for _ in 1...self.mainProfile.favoriteАnime[indexPath.section].maxSeries {
                                self.mainProfile.favoriteАnime[indexPath.section].colectionUrl.append(url)
                            }
                        }
                        
                        if self.mainProfile.favoriteАnime[indexPath.section].colectionUrl.count < self.mainProfile.favoriteАnime[indexPath.section].maxSeries {
                            for _ in 1...self.mainProfile.favoriteАnime[indexPath.section].maxSeries - self.mainProfile.favoriteАnime[indexPath.section].colectionUrl.count {
                                self.mainProfile.favoriteАnime[indexPath.section].colectionUrl.append(url)
                            }
                        }
                        
                        
                        if self.mainProfile.favoriteАnime[indexPath.section].series != 0 {
                        let series = self.mainProfile.favoriteАnime[indexPath.section].series-1
                            url = self.mainProfile.favoriteАnime[indexPath.section].colectionUrl[series]
                        }
                        
                        let requstObj = URLRequest(url: url)
                        cell.loadingVideo.flack = true
                        cell.videoPlayer.isHidden = false
                        cell.videoPlayer.configuration.allowsInlineMediaPlayback = true
                        cell.videoPlayer.load(requstObj)
                    }
                }
            } else {
                let series = mainProfile.favoriteАnime[indexPath.section].series-1
                let url = mainProfile.favoriteАnime[indexPath.section].colectionUrl[series]
                let requstObj = URLRequest(url: url)
                cell.loadingVideo.flack = true
                cell.videoPlayer.isHidden = false
                cell.videoPlayer.configuration.allowsInlineMediaPlayback = true
                cell.videoPlayer.load(requstObj)
            }
        } else {  // Отображаем заставке и кнопке
            cell.videoPlayer.isHidden = true
            cell.videoPlayer.isOpaque = false
            cell.videoPlayer.backgroundColor = UIColor.clear
            cell.videoPlayerButton.setImage(#imageLiteral(resourceName: "icons8-play-100"), for: .normal)
            cell.videoPlayerButton.isUserInteractionEnabled = true
            cell.videoPlayerImage?.image = UIImage(data: self.mainProfile.favoriteАnime[indexPath.section].avatarImageData)
            
        }
        return cell
    }
    
    // MARK: - viewForFooterInSection
    // Добавляем описание аниме внизу
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.mainProfile.favoriteАnime[section].flack  == true  {
  
            let heightView = (CGFloat(Double(self.mainProfile.favoriteАnime[section].descriptionInfo.count)*7.32)/(tableView.frame.size.width))
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: (heightView+1)*22))
            
            if self.mainProfile.favoriteАnime[section].descriptionFlack == false || self.mainProfile.favoriteАnime[section].descriptionInfo == "" {
                let nameTextFile = "description_" + self.mainProfile.favoriteАnime[section].name + ".txt"
                
                let text = loadText(nameFile: nameTextFile)
                if text == "" {
                    self.loadAnimeDescription(section: section) {
                        DispatchQueue.main.async {
                            self.mainProfile.favoriteАnime[section].descriptionFlack = true
                            
                            fileSistemSaveText(nameFile: nameTextFile, text: self.mainProfile.favoriteАnime[section].descriptionInfo)
                            
                            guard let realm =  try? Realm() else {
                                print("Error Realm")
                                return
                            }
                            
                            let object = realm.objects(RealmBase.self)
                            guard let base = Optional(object[transportRealmIndex]) else {
                                return
                            }
                            if base.favoriteАnime[section].descriptionInfo == "" {
                                
                                try! realm.write {
                                    base.favoriteАnime[section].descriptionInfo = self.mainProfile.favoriteАnime[section].descriptionInfo
                                    base.favoriteАnime[section].descriptionFlack = true
                                }
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                    self.mainProfile.favoriteАnime[section].descriptionFlack = true
                    self.mainProfile.favoriteАnime[section].descriptionInfo = text
                    tableView.reloadSections([section], with: .none)
                    }
                }
            } else {
                
                let label = UILabel(frame: CGRect(x: 10, y: 10, width: tableView.frame.size.width-10, height: 20))
                label.font = UIFont.systemFont(ofSize: 18)
                label.text = "Описание"
                label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                let label2 = UILabel(frame: CGRect(x: 10, y: 30, width: tableView.frame.size.width-10, height: heightView*20))
                label2.font = UIFont.systemFont(ofSize: 14)
                label2.text = self.mainProfile.favoriteАnime[section].descriptionInfo
                label2.lineBreakMode = .byWordWrapping
                label2.numberOfLines = 0
                label2.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                
                view.addSubview(label)
                view.addSubview(label2)
                view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }
            return view
         } else {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 4))
            view.backgroundColor = .clear
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.mainProfile.favoriteАnime[section].flack  == true {
            var heightView = (CGFloat(Double(self.mainProfile.favoriteАnime[section].descriptionInfo.count)*7.32)/(tableView.frame.size.width))+2
            heightView.round(.awayFromZero)
            heightView*=22
            if heightView > (tableView.frame.size.height/3.2) {
                heightView = tableView.frame.size.height/3.2
            }
            return heightView
        } else {
            return 2
        }
    }

  // MARK: - Переход при нажатии на строку

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if mainProfile.favoriteАnime[indexPath.section].colectionImage.count == 0 {
            loadImageProfile(section: indexPath.section) { // Составляем базу картинок
                DispatchQueue.main.async {
                    let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "TabOneCollectionViewController") as! TabOneCollectionViewController
                    detailVC.transportLine = indexPath.section
                    detailVC.profile = "mainProfile"
                    self.interactive.viewController = detailVC
                    self.navigationController?.delegate = self
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
            }
        } else {
            let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "TabOneCollectionViewController") as! TabOneCollectionViewController
            detailVC.transportLine = indexPath.section
            detailVC.profile = "mainProfile"
            self.interactive.viewController = detailVC
            self.navigationController?.delegate = self
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    // MARK: - Доп действия по сдвигу (УДАЛЕНИЕ)
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let profileAction = UITableViewRowAction(style: .default, title: "Delete") {
            _, indexPath in
            self.animeList.append(АnimeList())
            let indx = self.animeList.endIndex - 1
            
            self.animeList[indx].id = self.mainProfile.favoriteАnime[indexPath.section].id
            self.animeList[indx].name = self.mainProfile.favoriteАnime[indexPath.section].name
            self.animeList[indx].avatar = self.mainProfile.favoriteАnime[indexPath.section].avatar
            self.animeList[indx].avatarImageData = self.mainProfile.favoriteАnime[indexPath.section].avatarImageData
            self.animeList[indx].status = self.mainProfile.favoriteАnime[indexPath.section].status
            self.animeList[indx].maxSeries = self.mainProfile.favoriteАnime[indexPath.section].maxSeries
            
            let namePhoto = namedConstructor(text: self.mainProfile.favoriteАnime[indexPath.section].avatar)
            deleteImage(namePhoto: namePhoto)
            
            self.mainProfile.favoriteАnime.remove(at: indexPath.section)
//             Пытаюсь в удаление из realm
            DispatchQueue.global().async {
            
                guard let realm =  try? Realm() else {
                    print("Error Realm")
                    return
                }
                
                let object = realm.objects(RealmBase.self)
                guard let base = Optional(object[transportRealmIndex]) else {
                    return
                }
                
                if base.favoriteАnime.count >= indexPath.section {
                    try! realm.write {
                        realm.delete(base.favoriteАnime[indexPath.section])
                    }
                }
            }
        
            //     MARK: -  Здесь будет post запрос о удалении из списка аниме

        }
        
        profileAction.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        return [profileAction]
    }
    
//     MARK: - Получение описание аниме
    private func loadAnimeDescription(section: Int,  completioHandler : (() ->Void)?) {
        
        request("https://shikimori.one/api/animes/\(self.mainProfile.favoriteАnime[section].id)",  method: .get).validate(contentType: ["application/json"]).responseJSON() { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                if json["description"].stringValue != "" {
                    
                    self.mainProfile.favoriteАnime[section].descriptionInfo = json["description"].stringValue
                } else {
                    self.mainProfile.favoriteАnime[section].descriptionInfo = "..."
                }
                
            case .failure(let error):
                let arres = error.localizedDescription
                self.showAlert(massage: arres, title: "Error load Anime Description")
            }
            completioHandler?()
        }
    }
    
//     MARK: - Получение скриншоты из аниме
    private func loadImageProfile(section: Int, completioHandler : (() ->Void)?) {
        request("https://shikimori.one/api/animes/\(mainProfile.favoriteАnime[section].id)/screenshots",  method: .get).validate(contentType: ["application/json"]).responseJSON() { response in

            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.mainProfile.favoriteАnime[section].colectionImage.removeAll()
                for (_, subJson):(String, JSON) in json[] {
                    self.mainProfile.favoriteАnime[section].colectionImage.append(subJson["preview"].stringValue)
                    self.mainProfile.favoriteАnime[section].colectionImageData.append(Data())

                    DispatchQueue.global().async {
                    
                        guard let realm =  try? Realm() else {
                            print("Error Realm")
                            return
                        }
                        
                        let object = realm.objects(RealmBase.self)
                        guard let base = Optional(object[transportRealmIndex]) else {
                            return
                        }
                        
                        try! realm.write {
                            base.favoriteАnime[section].colectionImage.append(subJson["preview"].stringValue)
                            base.favoriteАnime[section].colectionImageData.append(Data())
                            
                        }
                    }
                }
            case .failure(let error):
                let arres = error.localizedDescription
                self.showAlert(massage: arres, title: "Error loading")
            }
            completioHandler?()
        }
    }

    private func showAlert (massage: String, title: String) {    // Вывод ошибки если пользователь ввел неправильно данные
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
// MARK: - Actions stepper
    @IBAction func animeStepper(_ sender: HSUnderLineStepper) {
        if sender.value > Double(self.mainProfile.favoriteАnime[sender.row!].series) {
        sender.value = Double(self.mainProfile.favoriteАnime[sender.row!].series) + 1
            if self.mainProfile.favoriteАnime[sender.row!].series < self.mainProfile.favoriteАnime[sender.row!].maxSeries {
                self.mainProfile.favoriteАnime[sender.row!].series = Int(sender.value)
            }
        } else {
            sender.value = Double(self.mainProfile.favoriteАnime[sender.row!].series) - 1
            self.mainProfile.favoriteАnime[sender.row!].series = Int(sender.value)
        }
        tableView.reloadData()
    }
    
    @IBAction func playAnime(_ sender: playButton) {
        sender.isSelected = true
        sender.statusPlay = (sender.tag, sender.isSelected)
        tableView.reloadData()
    }
    
}

// MARK: - Кастомная анимация перехода navigationController?.delegate

extension TableViewOneController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return animatedTransitionTwo()
        } else if operation == .pop {
            return animatedTransitionTwoDismissed()
        } else {
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return interactive.hasStarted ? interactive : nil
    }

}

