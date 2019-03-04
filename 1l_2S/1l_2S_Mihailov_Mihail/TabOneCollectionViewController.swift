//
//  TabOneCollectionViewController.swift
//  1l_2S_Mihailov_Mihail
//
//  Created by Лекс Лютер on 04/03/2019.
//  Copyright © 2019 Лекс Лютер. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class TabOneCollectionViewController: UICollectionViewController {
    var transportLine = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = transportLine  // Имя поля
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        // Устанавливает background
        let imageView : UIImageView = {
            let iv = UIImageView()
            iv.image = UIImage(named: transportLine + ".jpg")
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
        backgroundImageView.image = UIImage(named: transportLine + ".jpg")
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        cell.backgroundView = backgroundImageView
        
        return cell
    }

}
