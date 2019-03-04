//
//  TabTwoTableViewController.swift
//  1l_2S_Mihailov_Mihail
//
//  Created by Лекс Лютер on 04/03/2019.
//  Copyright © 2019 Лекс Лютер. All rights reserved.
//

import UIKit

class TabTwoTableViewController: UITableViewController {
    var transportLine = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Profile"  // Имя поля
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true // Делаем прозрачным navigationBar
        
        tableView.backgroundView = UIImageView(image: UIImage(named:  base[transportLine].favoriteАnime[0].name +  ".jpg"))
        
        self.tableView.tableFooterView = UIView() //Убираем пустые строки
    }

        // MARK: - Создаем имена секций
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {     // Создание section решеток
        let button = UIButton(type: .system)
        switch section {
        case 0:
            button.setTitle("Name" , for: .normal)
        case 1:
            button.setTitle("Birthday" , for: .normal)
        case 2:
            button.setTitle("FavoriteАnime" , for: .normal)
        default:
            break
        }
        
        button.backgroundColor = #colorLiteral(red: 0.1247105226, green: 0.1294333935, blue: 0.1380615532, alpha: 1)
        button.setTitleColor(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), for: .normal)
        return button
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 18
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return base[transportLine].favoriteАnime.count
        default:
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(18)
    }
   
    // MARK: - Создаем имена строк
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else { return UITableViewCell() }
        switch indexPath.section {
        case 0:
           cell.textLabel?.text = base[transportLine].name
        case 1:
            cell.textLabel?.text = base[transportLine].birthday
        case 2:
            cell.textLabel?.text = base[transportLine].favoriteАnime[indexPath.row].name
        default:
            break
        }
        cell.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return cell
    }

}
