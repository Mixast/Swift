import UIKit

class NewsViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dayControl: SelectDayControl!
    var rowSizer = [Razmermer]()
    var flack = true
    var sizeWidth = CGFloat(0)
    var sizeHeight = CGFloat(0)
    
    override func viewDidLoad() {
        
        sizeWidth = self.view.frame.size.width/4
        sizeHeight = self.view.frame.size.height/5

        fillingLikeBase { // Составляем список новостей
            DispatchQueue.main.async {
                for i in 0...likeBase.count {
                    self.rowSizer.append(Razmermer(id: i, size: 250))
                }
                self.tableView.reloadData()
            }
        }
        super.viewDidLoad()
        
        // Делаем обновление view при нажании на UIControl
        for i in 1...dayControl.buttons.count {
            dayControl.buttons[i-1].addTarget(self, action: #selector(toop), for: .touchUpInside)
        }
        
        navigationItem.title = "News"  // Имя поля
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true // Делаем прозрачным navigationBar

        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView() //Убираем пустые строки

        
        // Кастомный Header

        let headerNib = UINib.init(nibName: "TableViewHistoryHeader", bundle: Bundle.main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "TableViewHistoryHeader")
  
    }
    
    @objc func toop() {
        tableView.reloadData()
    }
    
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {    //reload data при повороте
        tableView.reloadData()
    }

    // MARK: - Создание секций и их тайтлов
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableViewHistoryHeader") as? TableViewHistoryHeader
        header?.tag = section + 22
        header?.historyView.backgroundColor = #colorLiteral(red: 0.1247105226, green: 0.1294333935, blue: 0.1380615532, alpha: 1)
        header?.historyButton.setTitle(likeBase[section].name, for: .normal)
        header?.historyButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        header?.historyButton.titleLabel?.lineBreakMode = .byWordWrapping
        header?.historyButton.titleLabel?.numberOfLines = 0
        header?.historyButton.tag = section
        header?.historyButton.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        header?.historyButton.setTitleColor(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), for: .normal)

        header?.likeLabel.font = UIFont.systemFont(ofSize: 14)
        header?.likeLabel.text = String(likeBase[section].likeMetr)
        header?.likeLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)

        header?.likeButton.addTarget(self, action: #selector(handleExpandLike), for: .touchUpInside)
        header?.likeButton.tag = section

        if likeBase[section].likeStatus == true {
            header?.likeButton.bool = true
        } else {
            header?.likeButton.bool = false
        }
            
        return header
    }
    
    @objc func handleExpandClose(button: UIButton) { // Действие при двойном нажатии на секцию
        if  likeBase[button.tag].flack == true {
            likeBase[button.tag].flack = false
            tableView.reloadData()
        } else {
            likeBase[button.tag].flack = true
            tableView.reloadData()
        }
    }

    @objc func handleExpandLike(button: LikeButton) {
        if likeBase[button.tag].likeStatus == true {
            likeBase[button.tag].likeMetr+=1
            likeBase[button.tag].likeStatus = false
        } else {
            likeBase[button.tag].likeMetr-=1
            likeBase[button.tag].likeStatus = true
        }
        tableView.reloadData()
    }
    
    // MARK: - numberOfSections
    
    func numberOfSections(in tableView: UITableView) -> Int {
       // Устанавливаем отображение информации в задисимотси от дня в UIControl
        if dayControl.selectedDay?.title == Day.monday.title {
            return 1
        } else if dayControl.selectedDay?.title == Day.tuesday.title {
            return 2
        } else if dayControl.selectedDay?.title == Day.wednesday.title {
            return 3
        } else if dayControl.selectedDay?.title == Day.thursday.title {
            return 4
        } else if dayControl.selectedDay?.title == Day.friday.title {
            return 5
        } else if dayControl.selectedDay?.title == Day.saturday.title {
            return 1
        } else if dayControl.selectedDay?.title == Day.sunday.title {
            return 1
        } else {
           return likeBase.count
        }


    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // MARK: - numberOfRowsInSection
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if likeBase[section].flack == true {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(self.rowSizer[indexPath.section].size)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let image = UIImage(named: likeBase[indexPath.section].image + ".jpg")
        let imageTitle = image?.scaled(to: CGFloat(self.rowSizer[indexPath.section].size - 25))
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InsideTableViewCell") as? InsideTableViewCell else { return UITableViewCell() }
        
 
        cell.textLabel?.text = likeBase[indexPath.section].news
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.tag = (indexPath.section*100)+1
        
        cell.imageView?.image = imageTitle                                           // Добавляем аватарку
        cell.imageView?.layer.cornerRadius = 30                                     // Делаем её круглой
        cell.imageView?.layer.masksToBounds = true
        cell.imageView?.frame.size.width = self.sizeWidth
        cell.imageView?.frame.size.height = self.sizeHeight
        cell.imageView?.frame.origin.x = 15
        cell.imageView?.frame.origin.y = 12

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cell.imageView?.isUserInteractionEnabled = true
        cell.imageView?.addGestureRecognizer(tapGestureRecognizer)
        cell.imageView?.tag = (indexPath.section*100)+2
    
        cell.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        
        return cell
    }
 
    // Анимация по нажатию на картинку
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
     
        let touch = tapGestureRecognizer.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touch) {

            let originSizeWidth = self.view.viewWithTag((indexPath.section*100)+2)!.frame.size.width
            let originSizeHeight = self.view.viewWithTag((indexPath.section*100)+2)!.frame.size.height
            
            let IMGoriginX = self.view.viewWithTag((indexPath.section*100)+1)!.frame.origin.x
            let IMGoriginY = self.view.viewWithTag((indexPath.section*100)+1)!.frame.origin.y
            let IMGsizeWidth = self.view.viewWithTag((indexPath.section*100)+1)!.frame.size.width
            let IMGsizeHeight = self.view.viewWithTag((indexPath.section*100)+1)!.frame.size.height
 
            if self.rowSizer[indexPath.section].flack {
                
                
                self.rowSizer[indexPath.section].flack = false
                UIView.animate(withDuration: 2,
                           delay: 0.2,
                           usingSpringWithDamping: 0.4,
                           initialSpringVelocity: 4,
                           options: [.curveEaseOut , .beginFromCurrentState],
                           animations: {
                            self.rowSizer[indexPath.section].size =  350
                            self.sizeWidth += 80
                            self.sizeHeight += 100
                            self.tableView.beginUpdates()
                            self.tableView.endUpdates()
                            self.view.viewWithTag((indexPath.section*100)+2)!.frame = CGRect(x: 15, y: 12, width: originSizeWidth+80, height: originSizeHeight+100)
                            self.view.viewWithTag((indexPath.section*100)+1)!.frame = CGRect(x: IMGoriginX + 80, y: IMGoriginY, width: IMGsizeWidth - 80, height: IMGsizeHeight + 100)

                })
            } else {
                
                self.rowSizer[indexPath.section].flack = true
                UIView.animate(withDuration: 2,
                               delay: 0.2,
                               usingSpringWithDamping: 0.4,
                               initialSpringVelocity: 4,
                               options: [],
                               animations: {
                                self.sizeWidth = self.view.frame.size.width/4
                                self.sizeHeight = self.view.frame.size.height/5
                                self.view.viewWithTag((indexPath.section*100)+2)!.frame = CGRect(x: 15, y: 12, width: originSizeWidth-80, height: originSizeHeight-100)
                                self.view.viewWithTag((indexPath.section*100)+1)!.frame = CGRect(x: IMGoriginX - 80, y: IMGoriginY, width: IMGsizeWidth + 80, height: IMGsizeHeight - 100)
                                self.rowSizer[indexPath.section].size =  250
                                self.tableView.beginUpdates()
                                self.tableView.endUpdates()
                                
                                
                })
            }
        }
    }
    
}

