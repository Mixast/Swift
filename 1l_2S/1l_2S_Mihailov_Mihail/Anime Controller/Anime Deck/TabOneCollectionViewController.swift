import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class TabOneCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    
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
        
        if profile == "mainProfile" {
            mainProfile.favoriteАnime[transportLine].close = true
            navigationItem.title = mainProfile.favoriteАnime[transportLine].name  // Имя поля
            self.backgoundImage.image = UIImage(data: mainProfile.favoriteАnime[transportLine].avatarImageData)
            
            DispatchQueue.global().async {
                guard let realm =  try? Realm() else {
                    print("Error Realm")
                    return
                }
                
                let object = realm.objects(RealmBase.self)
                guard let base = Optional(object[transportRealmIndex]) else {
                    return
                }
                
                if base.favoriteАnime[self.transportLine].colectionImageData.count != 0 {
                    for i in 1...base.favoriteАnime[self.transportLine].colectionImageData.count {
                        self.mainProfile.favoriteАnime[self.transportLine].colectionImageData[i-1] = base.favoriteАnime[self.transportLine].colectionImageData[i-1]
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }

            }
            
        } else {
            friendProfile.favoriteАnime[transportLine].close = true
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
        if self.view.frame.size.width < self.view.frame.size.height {
            sizeWidthCell = self.view.frame.size.width / 1.45
            sizeHeightCell = self.view.frame.size.height / 4
        } else {
            if self.view.frame.size.width < 1024 {
                sizeWidthCell = self.view.frame.size.width / 3
                sizeHeightCell = self.view.frame.size.height / 3.2
            } else {
                sizeWidthCell = self.view.frame.size.width / 3
                sizeHeightCell = self.view.frame.size.height / 4
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewDidLayoutSubviews() {
        
        if self.flack == true {
            if self.view.frame.size.width < self.view.frame.size.height {
                self.sizeWidthCell = self.view.frame.size.width / 1.45
                self.sizeHeightCell = self.view.frame.size.height / 4
            } else {
                if self.view.frame.size.width < 1024 {
                    self.sizeWidthCell = self.view.frame.size.width / 3
                    self.sizeHeightCell = self.view.frame.size.height / 3.2
                } else {
                    self.sizeWidthCell = self.view.frame.size.width / 3
                    self.sizeHeightCell = self.view.frame.size.height / 4
                }
            }
        } else {
            self.sizeWidthCell = self.view.frame.size.width
            self.sizeHeightCell = self.view.frame.size.height
        }
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
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
            return mainProfile.favoriteАnime[transportLine].colectionImage.count
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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cell.imageAnime.addGestureRecognizer(tapGestureRecognizer)
        cell.imageAnime.tag = ((indexPath.section*100)+indexPath.row+1)
        
        if profile == "mainProfile" {
            
            if mainProfile.favoriteАnime[transportLine].colectionImageData[indexPath.row] == Data() {
                    DispatchQueue.global().async {
                        self.requestImage(forIndex: indexPath)
                    }
                    cell.imageAnime.image = #imageLiteral(resourceName: "icons8-vnim-50")

            } else {
                cell.imageAnime.image = UIImage(data: mainProfile.favoriteАnime[transportLine].colectionImageData[indexPath.row])
                DispatchQueue.global().async {
                    guard let realm =  try? Realm() else {
                        print("Error Realm")
                        return
                    }
                    
                    let object = realm.objects(RealmBase.self)
                    guard let base = Optional(object[transportRealmIndex]) else {
                        return
                    }
                    if base.favoriteАnime[self.transportLine].colectionImageData.count < indexPath.row {
                        return 
                    }
                    
                    if base.favoriteАnime[self.transportLine].colectionImageData[indexPath.row] == Data() {
                        
                        try! realm.write {
                            base.favoriteАnime[self.transportLine].colectionImageData[indexPath.row] = self.mainProfile.favoriteАnime[self.transportLine].colectionImageData[indexPath.row]
                        }
                    }
                }
            }
        } else {
            if friendProfile.favoriteАnime[transportLine].colectionImageData[indexPath.row] == Data() {
                DispatchQueue.global().async {
                    self.requestImage(forIndex: indexPath)
                }
                cell.imageAnime.image = #imageLiteral(resourceName: "icons8-vnim-50")
            } else {
                cell.imageAnime.image = UIImage(data: friendProfile.favoriteАnime[transportLine].colectionImageData[indexPath.row])
            }
        }
    
        return cell
    }
    
    // Прогружаю картинки при пролистывании
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            if profile == "mainProfile" {

                if mainProfile.favoriteАnime[transportLine].colectionImageData[indexPath.row] == Data() {
                    self.requestImage(forIndex: indexPath)
                }
            } else {
                if friendProfile.favoriteАnime[transportLine].colectionImageData[indexPath.row] == Data() {
                    DispatchQueue.global().async {
                        self.requestImage(forIndex: indexPath)
                    }
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
        if profile == "mainProfile" {
            if self.mainProfile.favoriteАnime[self.transportLine].colectionImageData[forIndex.row] != Data() {
                return
            }
        } else {
            if self.friendProfile.favoriteАnime[self.transportLine].colectionImageData[forIndex.row] != Data() {
                return
            }
        }
        
  
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
    //  URLSessionDataTask
    func getTask(forIndex: IndexPath) -> URLSessionDataTask  {
        
        if profile == "mainProfile" {
            if self.mainProfile.favoriteАnime[self.transportLine].colectionImageData[forIndex.row] != Data() {
                return URLSessionDataTask()
            }
            
            let imgURL = URL(string: "https://shikimori.one" + mainProfile.favoriteАnime[transportLine].colectionImage[forIndex.row])!
            
            return URLSession.shared.dataTask(with: imgURL) { data, response, error in
                DispatchQueue.global().async {
                    guard let data = data, error == nil else { return }
                    
                    self.mainProfile.favoriteАnime[self.transportLine].colectionImageData[forIndex.row] = data
                    
                    
                    DispatchQueue.main.async() {
                        self.collectionView.reloadItems(at: [forIndex])
                    }
                    
                }
            }
        } else {
            if self.friendProfile.favoriteАnime[self.transportLine].colectionImageData[forIndex.row] != Data() {
                return URLSessionDataTask()
            }
            let imgURL = URL(string: "https://shikimori.one" + friendProfile.favoriteАnime[transportLine].colectionImage[forIndex.row])!
            
            return URLSession.shared.dataTask(with: imgURL) { data, response, error in
                DispatchQueue.global().async {
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async() {
                        self.friendProfile.favoriteАnime[self.transportLine].colectionImageData[forIndex.row] = data
                        self.collectionView.reloadItems(at: [forIndex])
                    }
                }
            }
        }
    }
    
    
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



