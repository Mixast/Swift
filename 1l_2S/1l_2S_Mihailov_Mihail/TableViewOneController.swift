//
//  TableViewOneController.swift
//  1l_2S_Mihailov_Mihail
//
//  Created by Лекс Лютер on 04/03/2019.
//  Copyright © 2019 Лекс Лютер. All rights reserved.
//

import UIKit

class TableViewOneController: UITableViewController {
    var flack = true
    
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
        tableView.backgroundView = UIImageView(image: UIImage(named: "Hp.jpg"))
        
        self.tableView.tableFooterView = UIView() //Убираем пустые строки
    }

    // MARK: - Добавляем аниме в лист
    @objc func handleShowIndexPath() {
        if animeBase.count == 0 { // Сообщение при пустом списке
            let optionMenu = UIAlertController(title: "Ура", message: "У вас в списке все аниме", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            optionMenu.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            optionMenu.addAction(cancelAction)
            self.present(optionMenu, animated: true, completion: nil)
        } else {
                
                let optionMenu = UIAlertController(title: "Anime deck", message: "Что вы хотите добавить?", preferredStyle: .actionSheet)
            
            
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                for i in 1...animeBase.count { // Создаем кнопки с картинками и названием аниме
                    let image = UIImage(named: animeBase[i-1].name + ".jpg")
                    let imageTitle = image?.scaled(to: 80)
                    
                    let addAnime = UIAlertAction(title: animeBase[i-1].name, style: .default, handler: { (action: UIAlertAction!) -> Void in
                        base[transportLine].favoriteАnime.append(Аnime())
                        let indx = base[transportLine].favoriteАnime.endIndex - 1
                        base[transportLine].favoriteАnime[indx].id = indx
                        base[transportLine].favoriteАnime[indx].name = animeBase[i-1].name
                        animeBase.remove(at: i-1)
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
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let button = UIButton(type: .system)
            button.setTitle("Anime List", for: .normal)
            button.backgroundColor = #colorLiteral(red: 0.1247105226, green: 0.1294333935, blue: 0.1380615532, alpha: 1)
            button.addTarget(self, action: #selector(handleExpandClose), for: .touchDownRepeat)
            button.setTitleColor(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), for: .normal)
            return button
    }
    
    @objc func handleExpandClose(button: UIButton) { // Действие при двойном нажатии на секцию
        if flack == true {
            flack = false
            tableView.reloadData()
        } else {
            flack = true
            tableView.reloadData()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 18
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flack == true {
            return base[transportLine].favoriteАnime.count
        } else {
            return 0
        }
    }
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if animeBase.count != 0 {
        var count = 0
        var countBase = animeBase.count
            for i in 1...countBase {
                if base[transportLine].favoriteАnime[indexPath.row].name == animeBase[count].name {
                    animeBase.remove(at: i-1)
                    countBase-=1
                } else {
                    count+=1
                }
            }
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else { return UITableViewCell() }
        cell.textLabel?.text = base[transportLine].favoriteАnime[indexPath.row].name
        cell.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        cell.imageView?.image = UIImage(named: base[transportLine].favoriteАnime[indexPath.row].name + ".jpg")
        cell.imageView?.layer.masksToBounds = true
        return cell
    }
    
    // MARK: - Переход при нажатии на строку
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "TabOneCollectionViewController") as! TabOneCollectionViewController
        detailVC.transportLineColl = indexPath.row
            self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - Доп действия по сдвигу
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            let profileAction = UITableViewRowAction(style: .default, title: "Delete") {
                _, indexPath in
                animeBase.append(Аnime())
                let indx = animeBase.endIndex - 1
                animeBase[indx].id = indx
                animeBase[indx].name = base[transportLine].favoriteАnime[indexPath.row].name
                base[transportLine].favoriteАnime.remove(at: indexPath.row)

                tableView.reloadData()
        }
            
            profileAction.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            return [profileAction]
        }
    
}

 // MARK: - Добавляем ф-цию для изменения размера картинки

private extension UIImage {
    func scaled(to maxSize: CGFloat) -> UIImage? {
        let aspectRatio: CGFloat = min(maxSize / size.width, maxSize / size.height)
        let newSize = CGSize(width: size.width * aspectRatio, height: size.height * aspectRatio)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { context in
            draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        }
    }
}
