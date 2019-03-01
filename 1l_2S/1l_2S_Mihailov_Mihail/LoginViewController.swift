//
//  LoginViewController.swift
//  1l_2S_Mihailov_Mihail
//
//  Created by Лекс Лютер on 28/02/2019.
//  Copyright © 2019 Лекс Лютер. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var substrate: UILabel!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    @IBAction func buttonAction(_ sender: Any) {
        var flack = false
        for i in 1...base.count {    // поиск по струтуре
            if base[i-1].login == loginTextField.text {
                if base[i-1].password == passwordTextField.text {
                        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                        detailVC.transportLine = base[i-1].id
                        self.navigationController?.pushViewController(detailVC, animated: true)
                     flack = true
                }
            }
        }
        if flack == false {
        showAlert(massage: "Вы ввели неправильные данные", title: "Error")
        }
    }
    
    private func designFor(label: UILabel) {  // Кастомизирую подложку
//        label.layer.masksToBounds = true
//        label.layer.cornerRadius = 12
        label.backgroundColor = UIColor(patternImage: UIImage(named: "ww33.jpg")!)
        label.layer.shadowOffset = CGSize(width: 10, height: 10)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.6
    }
    
    private func designFor(button: UIButton) {  // Кастамизирую кнопку
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        button.layer.cornerRadius = 10
        button.backgroundColor = .clear
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.6
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Login Field"
        designFor(label: substrate)
        designFor(button: button)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        fillingBase {
            DispatchQueue.main.async {
            }
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func showAlert (massage: String, title: String) {    // Вывод ошибки если пользователь ввел неправильно данные
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
