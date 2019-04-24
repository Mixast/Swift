import UIKit

class LoginViewController: UIViewController {
// MARK: - Connect IBOutlet
    @IBOutlet weak var substrate: UILabel!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var button: UIButton!
// MARK: - Connect IBAction
    @IBAction func buttonAction(_ sender: Any) {
        // Запускаем процесс составления базы (это кастыль решил так реализовать). И когда база составлена ищу в ней связку login/password
        fillingBase {
            DispatchQueue.main.async {
                var flack = false
                for i in 1...base.count {
                    
                    guard  let login = self.loginTextField.text, login.count > 0 else {
                        self.showAlert(massage: "Поле Login пустое", title: "Error")
                        return
                    }
                    
                    guard let password = self.passwordTextField.text, password.count > 0   else {
                        self.showAlert(massage: "Поле Password пустое", title: "Error")
                        return
                    }
                    
                    if base[i-1].login == self.loginTextField.text {
                        if base[i-1].password == self.passwordTextField.text {
                            transportLine = base[i-1].id
                            self.performSegue(withIdentifier: "goToInfo", sender: self)
                            flack = true
                        }
                    }
                }
                
                if flack == false {
                    self.showAlert(massage: "Пользователь в базе не зарегистрирован", title: "Error")
                }
            }
        }
    }
    
// MARK: - Функции кастомизации UILabel и UIButton
    private func designFor(label: UILabel) {
        label.backgroundColor = UIColor(patternImage: UIImage(named: "ww33.jpg")!)
        label.layer.shadowOffset = CGSize(width: 10, height: 10)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.6
    }
    
    private func designFor(button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        button.layer.cornerRadius = 10
        button.backgroundColor = .clear
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.6
    }
    
// MARK: - Main body
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Login Field"  // Имя поля
        designFor(label: substrate)  // Кастомизация подложки substrate
        designFor(button: button)    // Костомизация кнопри Connect
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true // Делаем прозрачным navigationBar
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) // Убираем клавиатуру после ввода
    }
    
    func showAlert (massage: String, title: String) {    // Вывод ошибки если пользователь ввел неправильно данные
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
