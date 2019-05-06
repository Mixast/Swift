import UIKit
import WebKit
import Alamofire
import SwiftyJSON

import KeychainSwift
import RNCryptor


class LoginViewController: UIViewController, WKNavigationDelegate {
    let keychain = KeychainSwift()
    let mainProfile = MainProfile.instance
    
    var authorizationCode = String()
    var access_token = String()
    var refresh_token = String()
    var userID = String()
    
// MARK: - Connect IBOutlet
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var substrate: UILabel!

//// MARK: - Connect IBAction
//    @IBAction func buttonAction(_ sender: Any) {
//        // Запускаем процесс составления базы (это кастыль решил так реализовать). И когда база составлена ищу в ней связку login/password
//
//        fillingBase {
//            DispatchQueue.main.async {
//
//                var flack = false
//                for i in 1...base.count {
//
//                    guard  let login = self.loginTextField.text, login.count > 0 else {
//                        self.showAlert(massage: "Поле Login пустое", title: "Error")
//                        return
//                    }
//
//                    guard let password = self.passwordTextField.text, password.count > 0   else {
//                        self.showAlert(massage: "Поле Password пустое", title: "Error")
//                        return
//                    }
//
//                    if base[i-1].login == self.loginTextField.text {
//                        if base[i-1].password == self.passwordTextField.text {
//
//                            self.mainProfile.name = base[i-1].name
//                            self.mainProfile.birthday = base[i-1].birthday
//                            self.mainProfile.avatar = base[i-1].avatar
//                            self.mainProfile.favoriteАnime = base[i-1].favoriteАnime
//                            self.mainProfile.friends = base[i-1].friends
//
//                            let keychainLogin = encryptMessage(message: login, encryptionKey: "hooP")
//                            let keychainPasword = encryptMessage(message: password, encryptionKey: "hooP")
//                            self.keychain.set(keychainLogin, forKey: Keys.login)
//                            self.keychain.set(keychainPasword, forKey: Keys.password)
//                            self.view.endEditing(true)
//
//
//                            self.performSegue(withIdentifier: "goToInfo", sender: self)
//                            flack = true
//                        }
//                    }
//                }
//
//                if flack == false {
//                    self.showAlert(massage: "Пользователь в базе не зарегистрирован", title: "Error")
//                }
//            }
//        }
//    }
//
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
        designFor(label: substrate)  // Кастомизация подложки substrate
        
        webView.navigationDelegate = self
//     MARK: - Авторизация пользователя, получение кода авторизации (authorizationCode)
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "shikimori.org"
        urlComponents.path = "/oauth/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "82a953045b3a5fe2f0b3360e6d8be5697625f54733950494a4946344ea44175a"),
            URLQueryItem(name: "redirect_uri", value: "https://shikimori.org/"),
            URLQueryItem(name: "response_type", value: "code")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        webView.load(request)
        
    }
    
//    override func loadView() {
//        super.loadView()
//        
//        if self.keychain.get(Keys.login) != nil && self.keychain.get(Keys.password) != nil {
//            
//            fillingBase {
//                DispatchQueue.main.async {
//                    for i in 1...base.count {
//                        
//                        let login = decryptMessage(encryptedMessage: self.keychain.get(Keys.login)!, encryptionKey: "hooP")
//                        let password = decryptMessage(encryptedMessage: self.keychain.get(Keys.password)!, encryptionKey: "hooP")
//                        
//                        if login == base[i-1].login {
//                            if password == base[i-1].password {
//                                self.mainProfile.name = base[i-1].name
//                                self.mainProfile.birthday = base[i-1].birthday
//                                self.mainProfile.avatar = base[i-1].avatar
//                                self.mainProfile.favoriteАnime = base[i-1].favoriteАnime
//                                self.mainProfile.friends = base[i-1].friends
//                                
//                                
//                                self.performSegue(withIdentifier: "goToStart", sender: self)
//                                
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
    
//     MARK: - Получение токена (authorizationCode)
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        
        let url = navigationResponse.response.url!
        
        let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems
        let fragment = queryItems?.filter({$0.name == "code"}).first
        
        if fragment == nil {
            decisionHandler(.allow)
        } else {
            
            authorizationCode = fragment!.value!
            
            decisionHandler(.cancel)
            webView.isHidden = true

            let url = "https://shikimori.org/oauth/token"
            let parameters : [String: Any] = [ "User-Agent" : "Anime_Viewe" ,
                                               "grant_type" : "authorization_code" ,
                                               "client_id" : "82a953045b3a5fe2f0b3360e6d8be5697625f54733950494a4946344ea44175a" ,
                                               "client_secret" : "1afd4a059fcda8c9997843e22e6c6da89158ac0df0c15648ad4f5d584472c81f" ,
                                               "code" : authorizationCode ,
                                               "redirect_uri" : "https://shikimori.org/"]
            
            request(url,  method: .post, parameters: parameters).validate(contentType: ["application/json"]).responseJSON() { response in
                
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    //     MARK: - Сохранение  токена (access_token)
                    self.access_token = json["access_token"].stringValue
                    self.refresh_token = json["refresh_token"].stringValue
                    
                    self.loadProfile {
                        DispatchQueue.main.async {
                            self.loadAnime {
                                DispatchQueue.main.async {
                                    
                                    self.loadFriends {
                                        DispatchQueue.main.async {
                                            //                                                    let keychainLogin = encryptMessage(message: login, encryptionKey: "hooP")
                                            //                                                    let keychainPasword = encryptMessage(message: password, encryptionKey: "hooP")
                                            //                                                    self.keychain.set(keychainLogin, forKey: Keys.login)
                                            //                                                    self.keychain.set(keychainPasword, forKey: Keys.password)
                                            self.performSegue(withIdentifier: "goToInfo", sender: self)
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                case .failure(let error):
                    let arres = error.localizedDescription
                    self.showAlert(massage: arres, title: "Error access_token")
                }
            }
            
        }
    }
    
//     MARK: - Получение данных о пользователе (id ...)
    private func loadProfile(completioHandler : (() ->Void)?) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "shikimori.org"
        urlComponents.path = "/api/users/whoami"
        
        var r = URLRequest(url: urlComponents.url!)
        r.httpMethod = "GET"
        r.setValue("User-Agent", forHTTPHeaderField: "Anime_Viewe")
        r.setValue("application/json", forHTTPHeaderField: "Accept")
        r.setValue("Bearer \(self.access_token)", forHTTPHeaderField: "Authorization")
        
        request(r).responseJSON() { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                self.mainProfile.id = json["id"].intValue
                self.mainProfile.name = json["nickname"].stringValue
                self.mainProfile.birthday = json["birth_on"].stringValue
                self.mainProfile.avatar = json["image"]["x148"].stringValue
                
            case .failure(let error):
                let arres = error.localizedDescription
                self.showAlert(massage: arres, title: "Error Profile")
            }
            completioHandler?()
        }
    }
    
//     MARK: - Получение данных о пользователе (списка аниме)
    private func loadAnime(completioHandler : (() ->Void)?) {
        request("https://shikimori.org/api/users/\(self.mainProfile.id)/anime_rates?&limit=99999",  method: .get).validate(contentType: ["application/json"]).responseJSON() { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var count: Int = 0
                for (_, subJson):(String, JSON) in json[] {
                    
                    self.mainProfile.favoriteАnime.append(Аnime())
                    self.mainProfile.favoriteАnime[count].id = subJson["anime"]["id"].intValue
                    self.mainProfile.favoriteАnime[count].name = subJson["anime"]["name"].stringValue + " ( \(subJson["anime"]["russian"].stringValue))"
                    self.mainProfile.favoriteАnime[count].avatar = subJson["anime"]["image"]["original"].stringValue
                    
                    self.mainProfile.favoriteАnime[count].series = subJson["episodes"].intValue
                    self.mainProfile.favoriteАnime[count].maxSeries = subJson["anime"]["episodes"].intValue
                    self.mainProfile.favoriteАnime[count].status = subJson["anime"]["status"].stringValue
                    
                    count += 1
                }
            case .failure(let error):
                let arres = error.localizedDescription
                self.showAlert(massage: arres, title: "Error favoriteАnime")
            }
            completioHandler?()
        }
    }

    //     MARK: - Получение данных о пользователе (списка друзей)
    private func loadFriends(completioHandler : (() ->Void)?) {
        request("https://shikimori.org/api/users/\(self.mainProfile.id)/friends",  method: .get).validate(contentType: ["application/json"]).responseJSON() { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                var count: Int = 0
                for (_, subJson):(String, JSON) in json[] {
                    
                    self.mainProfile.friends.append(Friend())
                    self.mainProfile.friends[count].id = subJson["id"].intValue
                    self.mainProfile.friends[count].name = subJson["nickname"].stringValue
                    self.mainProfile.friends[count].avatarName = subJson["image"]["x148"].stringValue
                    
                    count += 1
                }
                
            case .failure(let error):
                let arres = error.localizedDescription
                self.showAlert(massage: arres, title: "Error friends")
            }
            completioHandler?()
        }
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
