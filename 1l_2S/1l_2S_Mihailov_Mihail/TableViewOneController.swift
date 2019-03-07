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
        
        navigationItem.title = "Home"  // Имя поля
 
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true // Делаем прозрачным navigationBar
        tableView.backgroundView = UIImageView(image: UIImage(named: "Hp.jpg"))
        
        self.tableView.tableFooterView = UIView() //Убираем пустые строки
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
        return CGFloat(18)
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else { return UITableViewCell() }
        cell.textLabel?.text = base[transportLine].favoriteАnime[indexPath.row].name
        cell.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return cell
    }
    
    // MARK: - Переход при нажатии на строку
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "TabOneCollectionViewController") as! TabOneCollectionViewController
            detailVC.transportLine = base[transportLine].favoriteАnime[indexPath.row].name
            self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
