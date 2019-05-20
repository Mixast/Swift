import UIKit
import Alamofire
import SwiftyJSON

class TabOneCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDataSourcePrefetching, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var backgoundImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var sizeWidthCell = CGFloat()
    var sizeHeightCell = CGFloat()
    var flack = true
    
    let mainProfile = MainProfile.instance
    let friendProfile = FriendProfile.instance
    var tasks = [URLSessionDataTask?](repeating: nil, count: 100)
    
    var count = 0
    var transportLine = Int()
    var profile: String = "" {
        didSet {
            if profile == "mainProfile" {
                count = mainProfile.favoriteАnime[transportLine].colectionImage.count
            } else {
                count = friendProfile.favoriteАnime[transportLine].colectionImage.count
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        
//        getImage(infoProfile: profile, transportLine: transportLine)
        if profile == "mainProfile" {
            navigationItem.title = mainProfile.favoriteАnime[transportLine].name  // Имя поля
            self.backgoundImage.image = mainProfile.favoriteАnime[transportLine].avatarImage
        } else {
            self.setNavigationBar()
            self.backgoundImage.image = UIImage(named: "Hp.jpg")
            let imageURL = NSURL(string: "https://shikimori.one" + friendProfile.favoriteАnime[transportLine].colectionImage[0])
            let queue = DispatchQueue.global(qos: .utility)
            queue.async{
                if let data = try? Data(contentsOf: imageURL! as URL){
                    DispatchQueue.main.async {
                        self.backgoundImage.image = UIImage(data: data)!
                        self.collectionView.reloadData()
                    }
                }
            }
            
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
            self.view.addGestureRecognizer(swipeRight)  //Ловим свайп
        }
            
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        collectionView.backgroundColor = .clear
        
        sizeWidthCell = self.view.frame.size.width / 3
        sizeHeightCell = self.view.frame.size.height / 4
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        clearMemory()
    }
    
    override func viewDidLayoutSubviews() {
        
        if self.flack == true {
            self.sizeWidthCell = self.view.frame.size.width / 3
            self.sizeHeightCell = self.view.frame.size.height / 4
        } else {
            self.sizeWidthCell = self.view.frame.size.width
            self.sizeHeightCell = self.view.frame.size.height
        }
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    
    
//    //     MARK: - Получение картинок
//    private func getImage(infoProfile: String, transportLine: Int) {
//        if infoProfile == "mainProfile" {
//            if mainProfile.favoriteАnime[transportLine].colectionImage.count != 0 {
//                print(self._IQDescription())
//                for i in 1...mainProfile.favoriteАnime[transportLine].colectionImage.count {
//
//                    if mainProfile.favoriteАnime[transportLine].close { } else {
//                        let imageURL = NSURL(string: "https://shikimori.one" + mainProfile.favoriteАnime[transportLine].colectionImage[i-1])
//                        let queue = DispatchQueue.global(qos: .utility)
//                        queue.async{
//                            if let data = try? Data(contentsOf: imageURL! as URL) {
//                                DispatchQueue.main.async { [weak self] in
//                                    guard let self = self else { return }
//
//                                    self.mainProfile.favoriteАnime[transportLine].colectionImG[i-1] = UIImage(data: data)!
//
//                                    let indexPath = IndexPath(row: i-1, section: 0)
//                                    self.collectionView.reloadItems(at: [indexPath])
//                                    }
//                                }
//                            }
//                        }
//                    }
//
//                mainProfile.favoriteАnime[transportLine].close = true
//            }
//        } else {
//            if friendProfile.favoriteАnime[transportLine].colectionImage.count != 0 {
//                for i in 1...friendProfile.favoriteАnime[transportLine].colectionImage.count {
//                    if self.mainProfile.favoriteАnime[self.transportLine].close { } else {
//                        let imageURL = NSURL(string: "https://shikimori.one" + friendProfile.favoriteАnime[transportLine].colectionImage[i-1])
//                        let queue = DispatchQueue.global(qos: .utility)
//                        queue.async{
//                            if let data = try? Data(contentsOf: imageURL! as URL){
//                                DispatchQueue.main.async {
//                                    self.friendProfile.favoriteАnime[self.transportLine].colectionImG[i-1] = UIImage(data: data)!
//                                    let indexPath = IndexPath(row: i-1, section: 0)
//                                    self.collectionView.reloadItems(at: [indexPath])
//                                }
//                            }
//                        }
//                    }
//                }
//                friendProfile.favoriteАnime[transportLine].close = true
//            }
//        }
//    }

    
    
    
    private func setNavigationBar() {
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 50))
        navBar.backgroundColor = .clear
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        let navItem = UINavigationItem(title: friendProfile.favoriteАnime[transportLine].name)
        navItem.largeTitleDisplayMode = .automatic
        
        let doneItem = UIBarButtonItem(title: "Profile", style: .done, target: nil, action: #selector(handleShowIndexPath))
        doneItem.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        navItem.leftBarButtonItem = doneItem
        
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)]
        navBar.setItems([navItem], animated: false)
        navBar.tag = 999
        self.view.addSubview(navBar)
        
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
    
    @objc func handleShowIndexPath() {      //Подключение любой кнопки
        dismiss(animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if profile == "mainProfile" {
            return mainProfile.favoriteАnime[transportLine].colectionImG.count
        } else {
           return friendProfile.favoriteАnime[transportLine].colectionImage.count
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: sizeWidthCell, height: sizeHeightCell)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell

        if mainProfile.favoriteАnime[transportLine].colectionImG[indexPath.row].pngData() != nil {
            cell.imageAnime.image = mainProfile.favoriteАnime[transportLine].colectionImG[indexPath.row]
        }
        else {
            cell.imageAnime.image = #imageLiteral(resourceName: "icons8-vnim-50")
            if (0...8).contains(indexPath.row) {
                DispatchQueue.global().async {
                    self.mainProfile.favoriteАnime[self.transportLine].close = true
                    self.requestImage(forIndex: indexPath)
                }
            }

        }
        
        
//        if profile == "mainProfile" {
//            cell.imageAnime.image = mainProfile.favoriteАnime[transportLine].colectionImG[indexPath.row]
//        } else {
//            cell.imageAnime.image = friendProfile.favoriteАnime[transportLine].colectionImG[indexPath.row]
//        }
//
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cell.imageAnime.addGestureRecognizer(tapGestureRecognizer)
        cell.imageAnime.tag = ((indexPath.section*100)+indexPath.row+1)
        return cell
    }
    
    
    // Пытаюсь прогружать картинки при пролистывании - пока не знаю как убрать тормоза при пролистывании ((
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            
            if mainProfile.favoriteАnime[transportLine].colectionImG[indexPath.row].pngData() == nil {
                 DispatchQueue.global().async {
                    self.requestImage(forIndex: indexPath)
                }
            }
        }
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            
            if let task = tasks[indexPath.row] {
                if task.state != URLSessionTask.State.canceling {
                    task.cancel()
                }
            }
        }
    }

    func requestImage(forIndex: IndexPath) {
        
        var task: URLSessionDataTask
        
        if tasks[forIndex.row] != nil
            && tasks[forIndex.row]!.state == URLSessionTask.State.running {
            // Wait for task to finish
            return
        }
        
        task = getTask(forIndex: forIndex)
        tasks[forIndex.row] = task
        task.resume()
    }
    
    func getTask(forIndex: IndexPath) -> URLSessionDataTask  {
        let imgURL = URL(string: "https://shikimori.one" + mainProfile.favoriteАnime[transportLine].colectionImage[forIndex.row])!
        
        return URLSession.shared.dataTask(with: imgURL) { data, response, error in
            DispatchQueue.global().async {
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    let image = UIImage(data: data)!
                    self.mainProfile.favoriteАnime[self.transportLine].colectionImG[forIndex.row] = image
                    self.collectionView.reloadItems(at: [forIndex])
                }
            }
        }
    }
    
    // ^^^
    
// MARK: -  Анимация увеличения картинки

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {

        let touch = tapGestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: touch) {
            let originX = self.view.viewWithTag((indexPath.section*100)+indexPath.row+1)!.frame.origin.x
            let originY = self.view.viewWithTag((indexPath.section*100)+indexPath.row+1)!.frame.origin.y
            let originSizeWidth = self.view.viewWithTag((indexPath.section*100)+indexPath.row+1)!.frame.size.width
            let originSizeHeight = self.view.viewWithTag((indexPath.section*100)+indexPath.row+1)!.frame.size.height

            UIView.animateKeyframes(withDuration: 1, delay: 0, options: [], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                    self.view.viewWithTag((indexPath.section*100)+indexPath.row+1)!.frame = CGRect(x: originX, y: originY, width: originSizeWidth+80, height: originSizeHeight+80)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                    self.view.viewWithTag((indexPath.section*100)+indexPath.row+1)!.frame = CGRect(x: originX, y: originY, width: originSizeWidth, height: originSizeHeight)
                })
            }) { (_) in
                UIView.animate(withDuration: 2,
                               delay: 0.2,
                               usingSpringWithDamping: 0.4,
                               initialSpringVelocity: 4,
                               options: [],
                               animations: {
                                if self.flack == true {
                                    self.sizeWidthCell = self.view.frame.size.width
                                    self.sizeHeightCell = self.view.frame.size.height
                                    self.flack = false
                                } else {
                                    self.sizeWidthCell = self.view.frame.size.width / 3
                                    self.sizeHeightCell = self.view.frame.size.height / 4
                                    self.flack = true
                                }
                                self.collectionView.collectionViewLayout.invalidateLayout()
                })
            }
        }
    }
    
}
