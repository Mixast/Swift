import UIKit
import WebKit

class TableViewOneController: UIViewController, UITableViewDelegate,  UITableViewDataSource {
    
    var hop = 10
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillinganimeBase { // Составляем список Антиме
            DispatchQueue.main.async {
            }
        }
        
        navigationItem.title = "Home"  // Имя поля
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add anime", style: .plain, target: self, action: #selector(handleShowIndexPath))
 
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true // Делаем прозрачным navigationBar
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView() //Убираем пустые строки
        
        // Кастомный Header

        let headerNib = UINib.init(nibName: "TableViewAnimeHeader", bundle: Bundle.main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "TableViewAnimeHeader")
        
    }
    
//     MARK: - Добавляем аниме в лист
    @objc func handleShowIndexPath() {
        if animelist.count == 0 { // Сообщение при пустом списке
            let optionMenu = UIAlertController(title: "Ура", message: "У вас в списке все аниме", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            optionMenu.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            optionMenu.addAction(cancelAction)
            self.present(optionMenu, animated: true, completion: nil)
        } else {

                let optionMenu = UIAlertController(title: "Anime deck", message: "Что вы хотите добавить?", preferredStyle: .actionSheet)


                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                for i in 1...animelist.count { // Создаем кнопки с картинками и названием аниме
                    let image = UIImage(named: animelist[i-1].name + ".jpg")
                    let imageTitle = image?.scaled(to: 80)

                    let addAnime = UIAlertAction(title: animelist[i-1].name, style: .default, handler: { (action: UIAlertAction!) -> Void in
                        base[transportLine].favoriteАnime.append(Аnime())
                        let indx = base[transportLine].favoriteАnime.endIndex - 1
                        base[transportLine].favoriteАnime[indx].id = indx
                        base[transportLine].favoriteАnime[indx].name = animelist[i-1].name
                        base[transportLine].favoriteАnime[indx].description = animelist[i-1].description
                        animelist.remove(at: i-1)
                        self.tableView.reloadData()
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

        if animelist.count != 0 {
            var count = 0
            var countBase = animelist.count
            for i in 1...countBase {
                if base[transportLine].favoriteАnime[section].name == animelist[count].name {
                    animelist.remove(at: i-1)
                    countBase-=1
                } else {
                    count+=1
                }
            }
        }
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableViewAnimeHeader") as? TableViewAnimeHeader
        header?.viewAnime.backgroundColor = #colorLiteral(red: 0.1247105226, green: 0.1294333935, blue: 0.1380615532, alpha: 1)
        header?.animeButton.setTitle(base[transportLine].favoriteАnime[section].name, for: .normal)
        header?.animeButton.backgroundColor = .clear
        header?.animeButton.addTarget(self, action: #selector(handleExpandClose), for: .touchDownRepeat)
        header?.animeButton.setTitleColor(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), for: .normal)
        header?.animeButton.titleLabel?.lineBreakMode = .byWordWrapping
        header?.animeButton.titleLabel?.numberOfLines = 0
        header?.animeButton.tag = section
        header?.animeImage.image = UIImage(named: base[transportLine].favoriteАnime[section].name + ".jpg")
        header?.animeImage.layer.masksToBounds = true
        header?.wowNewAnime.layer.masksToBounds = true
        header?.animeSeries.text = "S: " + String(base[transportLine].favoriteАnime[section].series)
        header?.animeSeries.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        for i in 1...animeBase.count {
            if animeBase[i-1].name == base[transportLine].favoriteАnime[section].name {
                if animeBase[i-1].series == base[transportLine].favoriteАnime[section].series {
                    header?.wowNewAnime.image = nil
                } else {
                    header?.wowNewAnime.image = #imageLiteral(resourceName: "icons8-vnim-50")
                }
            }
        }

        return header
    }

    @objc func handleExpandClose(button: UIButton) { // Действие при двойном нажатии на секцию
        if base[transportLine].favoriteАnime[button.tag].flack == true {
            base[transportLine].favoriteАnime[button.tag].flack = false
            tableView.reloadData()
        } else {
            base[transportLine].favoriteАnime[button.tag].flack = true
            tableView.reloadData()
        }
    }
    
    // MARK: - numberOfSections
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return base[transportLine].favoriteАnime.count
    }


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    // MARK: - numberOfRowsInSection
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if base[transportLine].favoriteАnime[section].flack  == true {
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
        cell.animeSeries.text = "S: " + String(base[transportLine].favoriteАnime[indexPath.section].series)
        cell.animeStepp.row = indexPath.section
        cell.animeStepp.value = Double(base[transportLine].favoriteАnime[indexPath.section].series)
        cell.videoPlayerButton.tag = indexPath.section
        
        if cell.videoPlayerButton.statusPlay == (indexPath.section, true) {     // Подключаем видео плеер если нажапа кнопка
            cell.isOn = cell.videoPlayerButton.isSelected
            cell.videoPlayerImage.image = UIImage()
            cell.videoPlayerButton.setImage(UIImage(), for: .normal)
            cell.videoPlayerButton.isUserInteractionEnabled = false
            for i in 1...animeBase.count {
                if animeBase[i-1].name == base[transportLine].favoriteАnime[indexPath.section].name {
                    if let url = NSURL(string: "https://video.sibnet.ru/shell.php?videoid=" + animeBase[i-1].seriesURL[base[transportLine].favoriteАnime[indexPath.section].series-1]) {
                        let requstObj = URLRequest(url: url as URL)
                        cell.videoPlayer.isHidden = false
                        cell.videoPlayer.load(requstObj)
                    }
                }
            }
        } else {  // Отображаем заставке и кнопке
            cell.videoPlayer.isHidden = true
            cell.videoPlayer.isOpaque = false
            cell.videoPlayer.backgroundColor = UIColor.clear
            cell.videoPlayerButton.setImage(#imageLiteral(resourceName: "icons8-play-100"), for: .normal)
            cell.videoPlayerButton.isUserInteractionEnabled = true
            cell.videoPlayerImage?.image = UIImage(named: base[transportLine].favoriteАnime[indexPath.section].name + ".jpg")
        }
        return cell
    }
    
    // MARK: - viewForFooterInSection
    // Добавляем описание аниме внизу
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let heightView = (CGFloat(Double(base[transportLine].favoriteАnime[section].description.count)*7.32)/(tableView.frame.size.width))
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: (heightView+1)*22))
        if base[transportLine].favoriteАnime[section].flack  == true {
            let label = UILabel(frame: CGRect(x: 10, y: 10, width: tableView.frame.size.width-10, height: 20))
            label.font = UIFont.systemFont(ofSize: 18)
            label.text = "Описание"
            label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            let label2 = UILabel(frame: CGRect(x: 10, y: 30, width: tableView.frame.size.width-10, height: heightView*20))
            label2.font = UIFont.systemFont(ofSize: 14)
            label2.text = String(base[transportLine].favoriteАnime[section].description)
            label2.lineBreakMode = .byWordWrapping
            label2.numberOfLines = 0
            label2.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

            view.addSubview(label)
            view.addSubview(label2)
            view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
         } else {
            view.backgroundColor = .clear
        }
        return view
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if base[transportLine].favoriteАnime[section].flack  == true {
            var heightView = (CGFloat(Double(base[transportLine].favoriteАnime[section].description.count)*7.32)/(tableView.frame.size.width))+2
            heightView.round(.awayFromZero)
            heightView*=22
            return heightView
        } else {
            return 2
        }
    }


  // MARK: - Переход при нажатии на строку

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "TabOneCollectionViewController") as! TabOneCollectionViewController
        detailVC.transportLineColl = indexPath.row
            self.navigationController?.pushViewController(detailVC, animated: true)
    }

    // MARK: - Доп действия по сдвигу

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            let profileAction = UITableViewRowAction(style: .default, title: "Delete") {
                _, indexPath in
                animelist.append(Аnime())
                let indx = animelist.endIndex - 1
                animelist[indx].id = indx
                animelist[indx].name = base[transportLine].favoriteАnime[indexPath.section].name
                animelist[indx].description = base[transportLine].favoriteАnime[indexPath.section].description
                base[transportLine].favoriteАnime.remove(at: indexPath.section)

                tableView.reloadData()
        }

            profileAction.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            return [profileAction]
        }

    
    // MARK: - Actions
    @IBAction func animeStepper(_ sender: HSUnderLineStepper) {
        if sender.value > Double(base[transportLine].favoriteАnime[sender.row!].series) {
        sender.value = Double(base[transportLine].favoriteАnime[sender.row!].series) + 1
            var pop = 0
            for _ in 1...animeBase.count {
                if animeBase[pop].name == base[transportLine].favoriteАnime[sender.row!].name {
                    if base[transportLine].favoriteАnime[sender.row!].series < animeBase[pop].series {
                        base[transportLine].favoriteАnime[sender.row!].series = Int(sender.value)
                    }
                }
                pop+=1
            }
        } else {
            sender.value = Double(base[transportLine].favoriteАnime[sender.row!].series) - 1
            base[transportLine].favoriteАnime[sender.row!].series = Int(sender.value)
        }
        tableView.reloadData()
    }
    
    
    @IBAction func playAnime(_ sender: playButton) {
        sender.isSelected = true
        sender.statusPlay = (sender.tag, sender.isSelected)
        tableView.reloadData()
    }
    
    
}

