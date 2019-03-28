import UIKit

class NewsViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {
    var statusLike: (Int , Bool) = (0, true)
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dayControl: SelectDayControl!
    
    
    override func viewDidLoad() {
        fillingLikeBase { // Составляем список новостей
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        super.viewDidLoad()
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
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {    //reload data при повороте
        tableView.reloadData()
    }

    // MARK: - Создание секций и их тайтлов
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableViewHistoryHeader") as? TableViewHistoryHeader

        header?.historyView.backgroundColor = #colorLiteral(red: 0.1247105226, green: 0.1294333935, blue: 0.1380615532, alpha: 1)
        header?.historyButton.setTitle(likeBase[section].name, for: .normal)
        header?.historyButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        header?.historyButton.titleLabel?.lineBreakMode = .byWordWrapping
        header?.historyButton.titleLabel?.numberOfLines = 0
        header?.historyButton.tag = section
        header?.historyButton.addTarget(self, action: #selector(handleExpandClose), for: .touchDownRepeat)
        header?.historyButton.setTitleColor(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), for: .normal)

        header?.likeLabel.font = UIFont.systemFont(ofSize: 14)
        header?.likeLabel.text = String(likeBase[section].likeMetr)
        header?.likeLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)

        header?.likeButton.addTarget(self, action: #selector(handleExpandLike), for: .touchDown)
        header?.likeButton.tag = section
        if statusLike.0 == header?.likeButton.tag {
            header?.likeButton.bool = statusLike.1
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
        if button.bool {
            statusLike = (button.tag, false)

        } else {
            statusLike = (button.tag, true)
        }
        if button.bool {
            likeBase[button.tag].likeMetr+=1
        } else {
            likeBase[button.tag].likeMetr-=1
        }
        tableView.reloadData()
    }
    
    // MARK: - numberOfSections
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return likeBase.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    // MARK: - numberOfRowsInSection
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if likeBase[section].flack == true {
            return 1
        } else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let image = UIImage(named: likeBase[indexPath.section].image + ".jpg")
        let imageTitle = image?.scaled(to: 225)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InsideTableViewCell") as? InsideTableViewCell else { return UITableViewCell() }
        cell.textLabel?.text = likeBase[indexPath.section].news
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0
        cell.imageView?.image = imageTitle                                           // Добавляем аватарку
        cell.imageView?.layer.cornerRadius = 30                                     // Делаем её круглой
        cell.imageView?.layer.masksToBounds = true
        
        cell.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return cell
    }
 

}
