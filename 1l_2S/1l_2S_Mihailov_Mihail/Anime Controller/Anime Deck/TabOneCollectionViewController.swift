

import UIKit

private let reuseIdentifier = "Cell"

class TabOneCollectionViewController: UICollectionViewController {
    var transportLineColl = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = base[transportLine].favoriteАnime[transportLineColl].name  // Имя поля
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        // Устанавливает background
        let imageView : UIImageView = {
            let iv = UIImageView()
            iv.image = UIImage(named: base[transportLine].favoriteАnime[transportLineColl].name + ".jpg")
            iv.contentMode = .scaleAspectFill
            return iv
        }()
        self.collectionView?.backgroundView = imageView
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
       
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds) // Делаем картинки
        backgroundImageView.image = UIImage(named: base[transportLine].favoriteАnime[transportLineColl].name + " \(indexPath.row+1).jpg")
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        cell.backgroundView = backgroundImageView
        return cell
    }

}
