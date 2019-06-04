import UIKit
import Kanna
import Alamofire
import SwiftyJSON
import WebKit

class testViewController: UIViewController, WKNavigationDelegate {

    
    @IBOutlet weak var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let task = "Восхождение героя щита ".encodeUrl
//
//        displayURL(url: "https://online.animedia.tv/search?keywords=\(task)")
////
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "www.anilibria.tv"
        urlComponents.path = "/public/login.php"

        var r = URLRequest(url: urlComponents.url!)
        r.httpMethod = "POST"
        r.setValue("mail", forHTTPHeaderField: "")
        r.setValue("passwd", forHTTPHeaderField: "")
        r.setValue("fa2code", forHTTPHeaderField: "")
//
        
//        var urlComponents = URLComponents()
//        urlComponents.scheme = "https"
//        urlComponents.host = "www.anilibria.tv"
//        urlComponents.path = "/public/api/index.php"
//        urlComponents.queryItems = [
//            URLQueryItem(name: "mail", value: "mixast@mail.ru"),
//            URLQueryItem(name: "passwd", value: "mixast12"),
//            URLQueryItem(name: "fa2code", value: "")
//        ]
        
//        let request = URLRequest(url: urlComponents.url!)
        
//
        request(r).responseJSON() { response in
//
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
//
//
            case .failure(let error):
                let arres = error.localizedDescription
                self.showAlert(massage: arres, title: "Error friends")
                return
            }
        }
//

        
//        webView.isHidden = false
//        webView.navigationDelegate = self
//        webView.load(request)
        
        
        
    }
    
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//
//
//        let url = navigationResponse.response.url!
//
//        let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems
//        print(queryItems)
////        let fragment = queryItems?.filter({$0.name == "code"}).first
//
//    }
    
    private func showAlert (massage: String, title: String) {    // Вывод ошибки если пользователь ввел неправильно данные
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
//    func displayUR(url: String) {
//        let myURLString = url
//
//        guard let myURL = URL(string: myURLString) else {
//            print("Error: \(myURLString) doesn't seem to be a valid URL")
//            return
//        }
//
//        do {
//            let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
//            if let doc = try? HTML(html: myHTMLString, encoding: .utf8) {
//                // Search for nodes by CSS
//
//                for link in doc.css("div") {
//                    if link["class"] == "shortstoryContent" {
//                        let l = link
//                        for link in l.css("span") {
//                            if link["id"] == "playerbox" {
//                                let k = link
//                                for link in k.css("div") {
//                                    if link["id"] == "anime" {
//                                        let p = link
//                                        for link in p.css("div") {
//                                            if link["id"] == "player2" {
//                                                let a = link
//                                                for link in a.css("iframe") {
//                                                    print("wedwed")
//                                                    print(link["src"])
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//
//            }
//
//
//        } catch let error {
//            print("Error: \(error)")
//        }
//        return
//
//    }
    
    
    
    
    
    func displayURL(url: String) {
        let myURLString = sheredURL(url: url)
        
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return
        }
        
        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
            if let doc = try? HTML(html: myHTMLString, encoding: .utf8) {
                // Search for nodes by CSS
                
                
                for link in doc.css("body") {
                    if link["class"] == "p-anime_videos p-anime_videos-index p-db_entries p-db_entries-index p-animes p-animes-index x1200" {
                        let l = link
                        for link in l.css("div") {
                            if link["class"] == "video-link" {
                                let k = link
                                for link in k.css("a") {
                                    guard let link = link["href"] else {
                                        return
                                    }
                                    print("")
                                }
                            }
                        }
                    }
                    
                }
                
                
                
            }
        } catch let error {
            print("Error: \(error)")
        }
        return
        
    }
    
    func sheredURL(url: String) -> String {
        let myURLString = url
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return ""
        }
        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
            if let doc = try? HTML(html: myHTMLString, encoding: .utf8) {
                // Search for nodes by CSS
                for link in doc.css("div") {
                    if link["class"] == "h5 font-weight-normal mb-2 card-title text-truncate" {
                        let k = link
                        for link in k.css("a") {
                            guard let link = link["href"] else {
                                return ""
                            }
                            return link
                        }
                    }
                }
                
            }
        } catch let error {
            print("Error: \(error)")
        }
        return ""
    }
    
}





