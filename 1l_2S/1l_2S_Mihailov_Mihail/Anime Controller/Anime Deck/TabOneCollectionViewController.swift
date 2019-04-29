import UIKit

class TabOneCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var backgoundImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var sizeWidthCell = CGFloat()
    var sizeHeightCell = CGFloat()
    var flack = true
    
    var transportLine = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = transportLine  // Имя поля
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        backgoundImage.image = UIImage(named: transportLine + ".jpg")
        collectionView.backgroundColor = .clear
        
        sizeWidthCell = self.view.frame.size.width / 3
        sizeHeightCell = self.view.frame.size.height / 4
        
    }
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: sizeWidthCell, height: sizeHeightCell)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dataSource = self
        collectionView.delegate = self
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.imageAnime.image = UIImage(named: transportLine + " \(indexPath.row+1).jpg")
        cell.imageAnime.translatesAutoresizingMaskIntoConstraints = false
        
       
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cell.imageAnime.isUserInteractionEnabled = true
        cell.imageAnime.addGestureRecognizer(tapGestureRecognizer)
        cell.imageAnime.tag = ((indexPath.section*100)+indexPath.row+1)
        return cell
    }
    
    // MARK: -  Анимация увеличения машинки
    
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
    
}
