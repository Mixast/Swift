import UIKit
import WebKit
import Alamofire
import SwiftyJSON
import KeychainSwift
import RNCryptor
import CoreFoundation

class LoginViewController: UIViewController, WKNavigationDelegate {
    let keychain = KeychainSwift()
    let mainProfile = MainProfile.instance
    
// MARK: - Connect IBOutlet
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var substrate: UILabel!
    
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
        
        if self.keychain.get(Keys.accessToken) == nil && self.keychain.get(Keys.refreshToken) == nil {
        webView.isHidden = false
        webView.navigationDelegate = self
//     MARK: - Авторизация пользователя, получение кода авторизации (authorizationCode)
            
            //Заготовка для подключения через прокси
//        let session = URLSession().withProxy(proxyURL: "myProxyHost.com", proxyPort: 12345)

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "shikimori.one"
        urlComponents.path = "/oauth/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "82a953045b3a5fe2f0b3360e6d8be5697625f54733950494a4946344ea44175a"),
            URLQueryItem(name: "redirect_uri", value: "https://shikimori.one/"),
            URLQueryItem(name: "response_type", value: "code")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        //Заготовка для подключения через прокси
//        session.dataTask(with: request)

            
        webView.load(request)
        } else {
            webView.isHidden = true
        }
    }
      

    override func loadView() {
        super.loadView()

        if self.keychain.get(Keys.accessToken) != nil && self.keychain.get(Keys.refreshToken) != nil {

            self.loadProfile {
                DispatchQueue.main.async {
                    self.loadAnime {
                        DispatchQueue.main.async {
                            self.loadFriends {
                                DispatchQueue.main.async {
                                    UserDefaults.standard.set(false, forKey: Keys.chek)
                                    self.performSegue(withIdentifier: "goToStart", sender: self)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        
        if UserDefaults.standard.bool(forKey: Keys.chek) { // Костыль для перехода в самое начало
            
            var libraryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, false).first!
            libraryPath += "/Cookies"
            
            do {
                try FileManager.default.removeItem(atPath: libraryPath)
            } catch {
                print("Error clear cash")
            }
            URLCache.shared.removeAllCachedResponses()
            webView.isHidden = false
            UserDefaults.standard.set(false, forKey: Keys.chek) // Костыль для перехода в самое начало
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "shikimori.one"
            urlComponents.path = "/oauth/authorize"
            urlComponents.queryItems = [
                URLQueryItem(name: "client_id", value: "82a953045b3a5fe2f0b3360e6d8be5697625f54733950494a4946344ea44175a"),
                URLQueryItem(name: "redirect_uri", value: "https://shikimori.one/"),
                URLQueryItem(name: "response_type", value: "code")
            ]
            let request = URLRequest(url: urlComponents.url!)

            webView.load(request)
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) // Убираем клавиатуру после ввода
    }
    
    
//     MARK: - Получение токена (authorizationCode)
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        
        let url = navigationResponse.response.url!
        
        let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems
        let fragment = queryItems?.filter({$0.name == "code"}).first
        
        if fragment == nil {
            decisionHandler(.allow)
        } else {
            let authorizationCode = fragment!.value!
            
            decisionHandler(.cancel)
            webView.isHidden = true

            let url = "https://shikimori.one/oauth/token"
            let parameters : [String: Any] = [ "User-Agent" : "Anime_Viewe" ,
                                               "grant_type" : "authorization_code" ,
                                               "client_id" : "82a953045b3a5fe2f0b3360e6d8be5697625f54733950494a4946344ea44175a" ,
                                               "client_secret" : "1afd4a059fcda8c9997843e22e6c6da89158ac0df0c15648ad4f5d584472c81f" ,
                                               "code" : authorizationCode ,
                                               "redirect_uri" : "https://shikimori.one/"]
            
            request(url,  method: .post, parameters: parameters).validate(contentType: ["application/json"]).responseJSON() { response in
                
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    //     MARK: - Сохранение  токена (access_token)
                    
                    let accessToken = json["access_token"].stringValue
                    let refreshToken = json["refresh_token"].stringValue
                    
                    let keychainselfAccessToken = encryptMessage(message: accessToken, encryptionKey: "hooP")
                    let keychainselfRefreshToken = encryptMessage(message: refreshToken, encryptionKey: "hooP")
                    self.keychain.set(keychainselfAccessToken, forKey: Keys.accessToken)
                    self.keychain.set(keychainselfRefreshToken, forKey: Keys.refreshToken)
                    
                    self.loadProfile {
                        DispatchQueue.main.async {
                            self.loadAnime {
                                DispatchQueue.main.async {
                                    
                                    self.loadFriends {
                                        DispatchQueue.main.async {
                                            UserDefaults.standard.set(false, forKey: Keys.chek)
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
        urlComponents.host = "shikimori.one"
        urlComponents.path = "/api/users/whoami"
        
        let accessToken = decryptMessage(encryptedMessage: self.keychain.get(Keys.accessToken)!, encryptionKey: "hooP")
        
        var r = URLRequest(url: urlComponents.url!)
        r.httpMethod = "GET"
        r.setValue("User-Agent", forHTTPHeaderField: "Anime_Viewe")
        r.setValue("application/json", forHTTPHeaderField: "Accept")
        r.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        request(r).responseJSON() { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                self.mainProfile.id = json["id"].intValue
                self.mainProfile.name = json["nickname"].stringValue
                self.mainProfile.birthday = json["birth_on"].stringValue
                self.mainProfile.avatar = json["image"]["x148"].stringValue
                
            case .failure(let error):
                let json = JSON(error)
                let task = json["error"].stringValue
                
                if task == "invalid_token" {
                    self.refreshToken()
                } else {
                    let arres = error.localizedDescription
                    self.showAlert(massage: arres, title: "Error access_token")
                }
                return
            }
            completioHandler?()
        }
    }
    
    //  Обновление токена
    private func refreshToken() {
        
        let refreshToken = decryptMessage(encryptedMessage: self.keychain.get(Keys.refreshToken)!, encryptionKey: "hooP")
        let url = "https://shikimori.one/oauth/token"
        let parameters : [String: Any] = [ "User-Agent" : "Anime_Viewe" ,
                                           "grant_type" : "refresh_token" ,
                                           "client_id" : "82a953045b3a5fe2f0b3360e6d8be5697625f54733950494a4946344ea44175a" ,
                                           "client_secret" : "1afd4a059fcda8c9997843e22e6c6da89158ac0df0c15648ad4f5d584472c81f" ,
                                           "refresh_token" : refreshToken ]
        
        request(url,  method: .post, parameters: parameters).validate(contentType: ["application/json"]).responseJSON() { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let accessToken = json["access_token"].stringValue
                let refreshToken = json["refresh_token"].stringValue
                
                let keychainselfAccessToken = encryptMessage(message: accessToken, encryptionKey: "hooP")
                let keychainselfRefreshToken = encryptMessage(message: refreshToken, encryptionKey: "hooP")
                
                self.keychain.delete(Keys.accessToken)
                self.keychain.delete(Keys.refreshToken)
                
                self.keychain.set(keychainselfAccessToken, forKey: Keys.accessToken)
                self.keychain.set(keychainselfRefreshToken, forKey: Keys.refreshToken)
                
            case .failure(let error):
                let arres = error.localizedDescription
                self.showAlert(massage: arres, title: "Error refresh access_token")
            }
        }
    }
    
//     MARK: - Получение данных о пользователе (списка аниме)
    private func loadAnime(completioHandler : (() ->Void)?) {
        request("https://shikimori.one/api/users/\(self.mainProfile.id)/anime_rates?&limit=99999",  method: .get).validate(contentType: ["application/json"]).responseJSON() { response in
            
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
        request("https://shikimori.one/api/users/\(self.mainProfile.id)/friends",  method: .get).validate(contentType: ["application/json"]).responseJSON() { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var count: Int = 0
                for (_, subJson):(String, JSON) in json[] {
                    if subJson["nickname"].stringValue != "!delete" {
                    self.mainProfile.friends.append(Friend())
                    self.mainProfile.friends[count].id = subJson["id"].intValue
                    self.mainProfile.friends[count].name = subJson["nickname"].stringValue
                    self.mainProfile.friends[count].avatarName = subJson["image"]["x148"].stringValue
                    
                    count += 1
                    }
                }
               
                
            case .failure(let error):
                let arres = error.localizedDescription
                self.showAlert(massage: arres, title: "Error friends")
            }
            completioHandler?()
        }
    }
    
   private func showAlert (massage: String, title: String) {    // Вывод ошибки если пользователь ввел неправильно данные
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    
    
    
    
    }
}

extension URLSession {
    //Заготовка для подключения через прокси
    func withProxy(proxyURL: String, proxyPort: Int) -> URLSession {
        
        let configuration = self.configuration
        
        configuration.connectionProxyDictionary = [
            kCFNetworkProxiesHTTPEnable as AnyHashable : true,
            kCFNetworkProxiesHTTPPort as AnyHashable : proxyPort,
            kCFNetworkProxiesHTTPProxy as AnyHashable : proxyURL
        ]
        
        return URLSession(configuration: configuration, delegate: self.delegate, delegateQueue: self.delegateQueue)
    }
}
