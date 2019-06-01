import Foundation
import RNCryptor
import WebKit
import Kanna
import RealmSwift
import Alamofire
import SwiftyJSON

struct Keys { // Ключевые слова для keychain
    static let chek = "chek"
    static let accessToken = "access_token"
    static let refreshToken = "refresh_token"
}

func encryptMessage(message: String, encryptionKey: String) -> String { // encrypt текст
    let messageData = message.data(using: .utf8)!
    let cipherData = RNCryptor.encrypt(data: messageData, withPassword: encryptionKey)
    return cipherData.base64EncodedString()
}

func decryptMessage(encryptedMessage: String, encryptionKey: String) -> String { // decrypt текст
    let encryptedData = Data.init(base64Encoded: encryptedMessage)!
    let decryptedData = try? RNCryptor.decrypt(data: encryptedData, withPassword: encryptionKey)
    let decryptedString = String(data: decryptedData!, encoding: .utf8)!
    return decryptedString
}

struct Friend { // Структура Friend
    var id: Int
    var name: String
    var avatarName: String
    var avatarData: Data
    init() {
        self.id = 0
        self.name = ""
        self.avatarName = ""
        self.avatarData = Data()
    }
}

struct Аnime { // Структура Аnime
    var close: Bool
    var flack: Bool
    var descriptionFlack: Bool
    var id: Int
    var name: String
    var avatar: String
    var avatarImageData: Data
    var status: String
    var series: Int
    var maxSeries: Int
    var colectionImage: [String]
    var colectionImageData: [Data]
    var colectionUrl: [URL]
    var descriptionInfo: String
    init() {
        self.close = false
        self.id = 0
        self.name = ""
        self.series = 1
        self.maxSeries = 1
        self.flack = false
        self.descriptionInfo = ""
        self.descriptionFlack = false
        self.avatar = ""
        self.avatarImageData = Data()
        self.status = ""
        self.colectionImage = []
        self.colectionImageData = []
        self.colectionUrl = []
    }
}

struct АnimeList { // Структура АnimeList
    var flackOne: Bool
    var flackTwo: Bool
    var id: Int
    var name: String
    var avatar: String
    var avatarImageData: Data
    var status: String
    var maxSeries: Int
    
    init() {
        self.flackOne = false
        self.flackTwo = false
        self.id = 0
        self.name = ""
        self.maxSeries = 1
        self.avatar = ""
        self.avatarImageData = Data()
        self.status = ""
    }
}

struct АnimeFriend { // Структура Аnime friend
    var close: Bool
    var id: Int
    var name: String
    var series: Int
    var avatar: String
    var colectionImage: [String]
    var colectionImageData: [Data]
    init() {
        self.close = false
        self.id = 0
        self.name = ""
        self.series = 1
        self.avatar = ""
        self.colectionImage = []
        self.colectionImageData = []
    }
}

struct Profile {         // Структура для общей базы
    var id: Int
    var name: String
    var login: String
    var birthday: String
    var password: String
    var avatar: String
    var favoriteАnime: [Аnime]
    var friends: [Friend]
    init() {
        self.id = 0
        self.name = ""
        self.login = ""
        self.password = ""
        self.birthday = ""
        self.avatar = ""
        self.favoriteАnime = []
        self.friends = []
    }
}

struct Razmermer {   // Структура для размеров ячейки при анимациях
    var id: Int
    var size: Float
    var flack: Bool
    init(id: Int, size: Float) {
        self.id = id
        self.flack = true
        self.size = size
        
    }
}

func fillingLikeBase(completioHandler : (() ->Void)?) {
    let news = NewsAll.instance
    
    let url = "https://www.anilibria.tv/public/api/index.php"
    let parameters : [String: String] = [ "query" : "schedule" ,
                                          "filter" : "id,torrents,playlist,favorite,moon,blockedInfo" ,
                                          "rm" : "true"]
    
    request(url,  method: .post, parameters: parameters).validate(contentType: ["text/html"]).responseJSON() { response in
        
        switch response.result {
        case .success(let value):
            let json = JSON(value)

                news.news.removeAll()
                for (i, subJson):(String, JSON) in json["data"] {
                    
                    guard let indx = Int(i) else {
                        return
                    }
                    news.news.append(News())
                    news.news[indx].day = subJson["day"].intValue
                    
                    for (m, subTwoJson):(String, JSON) in subJson["items"] {
                        guard let indxTwo = Int(m) else {
                            return
                        }
                        news.news[indx].arrayNews.append(InfoNews())
                        news.news[indx].arrayNews[indxTwo].description = subTwoJson["description"].stringValue
                        news.news[indx].arrayNews[indxTwo].id = subTwoJson["id"].intValue
                        news.news[indx].arrayNews[indxTwo].name = subTwoJson["names"][0].stringValue
                        news.news[indx].arrayNews[indxTwo].poster = subTwoJson["poster"].stringValue
                        news.news[indx].arrayNews[indxTwo].series = subTwoJson["series"].stringValue
                        
                    }
                    
                }

        case .failure(let error):
            let arres = error.localizedDescription
            print(arres)
            
        }
        completioHandler?()
    }
}

struct News { // Структура News
    var day: Int
    var arrayNews: [InfoNews]
    init() {

        self.day = 1
        self.arrayNews = []
    }
}

struct InfoNews {
    var id: Int
    var name: String
    var series: String
    var description: String
    var flack: Bool
    var poster: String
    var posterData: Data
    init() {
        self.id = 0
        self.name = ""
        self.series = ""
        self.description = ""
        self.flack = true
        self.poster = ""
        self.posterData = Data()
    }
}

class NewsAll: Any { // Класс News
    var news = [News()]

    private init() {}
    static let instance = NewsAll()
}

class MainProfile: Any {         // Структура профиля пользователя Singleton
    var id = 0
    var name = ""
    var birthday = ""
    var avatar = ""
    var favoriteАnime = [Аnime]()
    var friends = [Friend]()
    private init() {}
    static let instance = MainProfile()
}

class FriendProfile: Any {         // Структура профиля друга Singleton
    var name = ""
    var id = 0
    var birthday = ""
    var avatarName = ""
    var avatarData = Data()
    var favoriteАnime = [АnimeFriend]()
    var friends = [Friend]()
    private init() {}
    static let instance = FriendProfile()
}

func namedConstructor(text: String) -> String { // Получение коректного имени
    let text = text
    let result = text.split(separator: "/")
    let word = String(result.last!).split(separator: "?")
    let name = String(word.last!) + String(word.first!)
    return name
}


func getDocumentsDir() -> URL {  // Получение дирректории
    return FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask)[0]
}

func fileSistemSave(namePhoto: String, data: Data) {  // Сохранение картинки
    let fileUrl = getDocumentsDir().appendingPathComponent(namePhoto)
    
    do {
        try data.write(to: fileUrl)
    } catch {
        print(error)
        return
    }
}

func fileSistemSaveText(nameFile: String, text: String) {  // Сохранение текста
    let fileUrl = getDocumentsDir().appendingPathComponent(nameFile)
        //writing
    do {
        try text.write(to: fileUrl, atomically: false, encoding: .utf8)
    }
    catch {
        print(error)
        return
    }
}

func loadText(nameFile: String) -> String {  // Чтение текста
    let fileUrl = getDocumentsDir().appendingPathComponent(nameFile)
    //reading
    do {
        let text = try String(contentsOf: fileUrl, encoding: .utf8)
        return text
    }
    catch {
        print(error)
        return ""
    }
}

func loadImage(namePhoto: String) -> Data {  // Чтение картинки
    let fileUrl = getDocumentsDir().appendingPathComponent(namePhoto)
    
    do {
        let imageData = try Data(contentsOf: fileUrl)

        return imageData
    } catch {
        return Data()
    }
}

func deleteImage(namePhoto: String) {  // Удаление картинки
    let fileUrl = getDocumentsDir().appendingPathComponent(namePhoto)
    let fileManager = FileManager.default
    do {
        try fileManager.removeItem(at: fileUrl)
    } catch {
        print(error)
        return
    }
    print("Image delete")
}


//     MARK: - Очищаем память
func clearMemory() {
    let mainProfile = MainProfile.instance
    let friendProfile = FriendProfile.instance

    DispatchQueue.global().async {
        DispatchQueue.main.async {
            for i in stride(from: 1, through: mainProfile.favoriteАnime.count, by: 1) {
                if mainProfile.favoriteАnime[i-1].close {
                    mainProfile.favoriteАnime[i-1].close = false
                    for k in stride(from: 1, through: mainProfile.favoriteАnime[i-1].colectionImageData.count, by: 1) {
                        mainProfile.favoriteАnime[i-1].colectionImageData[k-1] = Data()
                    }
                }
            }

            for i in stride(from: 1, through: friendProfile.favoriteАnime.count, by: 1) {
                if friendProfile.favoriteАnime[i-1].close {
                    friendProfile.favoriteАnime[i-1].close = false
                    for k in stride(from: 1, through: friendProfile.favoriteАnime[i-1].colectionImageData.count, by: 1) {
                        friendProfile.favoriteАnime[i-1].colectionImageData[k-1] = Data()
                    }
                }
            }
        }
    }
    
}

// Парсим сайт
//func displayURL(url: String) -> String {
//    let myURLString = url
//    guard let myURL = URL(string: myURLString) else {
//        print("Error: \(myURLString) doesn't seem to be a valid URL")
//        return ""
//    }
//
//    do {
//        let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
//        if let doc = try? HTML(html: myHTMLString, encoding: .utf8) {
//            // Search for nodes by CSS
//
//            for link in doc.css("body") {
//                if link["class"] == "p-anime_videos p-anime_videos-index p-db_entries p-db_entries-index p-animes p-animes-index x1200" {
//                    let l = link
//                    for link in l.css("div") {
//                        if link["class"] == "video-link" {
//                            let k = link
//                            for link in k.css("a") {
//                                guard let link = link["href"] else {
//                                    return ""
//                                }
//                                return link
//                            }
//                        }
//                    }
//                }
//
//            }
//
//        }
//    } catch let error {
//        print("Error: \(error)")
//    }
//    return ""
//}

//  Получаем день недели
func getDayOfWeek(_ today:String) -> String? {
    let formatter  = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    guard let todayDate = formatter.date(from: today) else { return nil }
    let myCalendar = Calendar(identifier: .gregorian)
    let weekDay = myCalendar.component(.weekday, from: todayDate)
    
    switch weekDay {
    case 1: return "ВС"
    case 2: return "ПН"
    case 3: return "ВТ"
    case 4: return "СР"
    case 5: return "ЧТ"
    case 6: return "ПТ"
    case 7: return "СБ"
    default: return ""
    }
}
func getDay() -> Int {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    let result = formatter.string(from: date)
    
    guard let todayDate = formatter.date(from: result) else { return 0}
    let myCalendar = Calendar(identifier: .gregorian)
    let weekDay = myCalendar.component(.weekday, from: todayDate) - 2
    return weekDay
}


// Получение ссылки на видео файл

func displayURL(name: String, completioHandler : (() ->Void)?) {
    let url = "https://www.anilibria.tv/public/api/index.php"
    let parameters : [String: String] = [ "query" : "search" ,
                                          "search" : name,
                                          "filter" : "id,code,names,poster"]
   
    request(url,  method: .post, parameters: parameters).validate(contentType: ["text/html"]).responseJSON() { response in
        
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            var idElement = String()
            idElement = json["data"][0]["id"].stringValue
            
            fillingJson(id: idElement, name: name){
                DispatchQueue.main.async {
                    completioHandler?()
                }
            }
            
        case .failure(let error):
            let arres = error.localizedDescription
            print(arres)
            completioHandler?()
        }
    }

   
}

func fillingJson(id: String, name: String, completioHandler : (() ->Void)?) {
    let mainProfile = MainProfile.instance
    var array = [Int: String]()
    let url = "https://www.anilibria.tv/public/api/index.php"
    let parameters : [String: String] = [ "query" : "release" ,
                                          "id" : id,
                                          "filter" : "data,description,torrents,type,code,voices,genres,status,year,announce,day,favorite,blockedInfo,error,poster,last,names,series",
                                          "rm" : "true"]
    request(url,  method: .post, parameters: parameters).validate(contentType: ["text/html"]).responseJSON() { response in
        
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            
            for (_, subJson):(String, JSON) in json["data"]["playlist"] {
                array.updateValue(subJson["srcHd"].stringValue, forKey: subJson["id"].intValue)
            }
            
            for m in 1...mainProfile.favoriteАnime.count {
                if mainProfile.favoriteАnime[m-1].name == name {
                    mainProfile.favoriteАnime[m-1].colectionUrl.removeAll()
                    if array.count != 0 {
                        for i in 1...array.count {
                            guard let urlString = array[i] else {
                                return
                            }
                            guard let urlStr = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
                                return
                            }
                            guard let url = URL(string: urlStr) else {
                                return
                            }
                            mainProfile.favoriteАnime[m-1].colectionUrl.append(url)
                        }
                    }
                }
            }
            completioHandler?()
        case .failure(let error):
            let arres = error.localizedDescription
            print(arres)
            completioHandler?()
        }
    }
}
