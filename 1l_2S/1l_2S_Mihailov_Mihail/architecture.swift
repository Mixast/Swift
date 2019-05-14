import Foundation
import RNCryptor

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
    var avatar: UIImage
    init() {
        self.id = 0
        self.name = ""
        self.avatarName = ""
        self.avatar = UIImage()
    }
}

struct News { // Структура News
    var id: Int
    var name: String
    var news: String
    var likeMetr: Int
    var likeStatus: Bool
    var flack: Bool
    var image: String
    init() {
        self.id = 0
        self.name = ""
        self.news = ""
        self.likeMetr = 0
        self.flack = false
        self.likeStatus = true
        self.image = ""
    }
}

struct Аnime { // Структура Аnime
    var close: Bool
    var flack: Bool
    var descriptionFlack: Bool
    var id: Int
    var name: String
    var avatar: String
    var avatarImage: UIImage
    var status: String
    var series: Int
    var maxSeries: Int
    var colectionImage: [String]
    var colectionImG: [UIImage]
    var description: String
    init() {
        self.close = false
        self.id = 0
        self.name = ""
        self.series = 1
        self.maxSeries = 1
        self.flack = false
        self.description = ""
        self.descriptionFlack = false
        self.avatar = ""
        self.avatarImage = UIImage()
        self.status = ""
        self.colectionImage = []
        self.colectionImG = []
    }
}

struct АnimeList { // Структура АnimeList
    var flackOne: Bool
    var flackTwo: Bool
    var id: Int
    var name: String
    var avatar: String
    var avatarImage: UIImage
    var status: String
    var maxSeries: Int
    init() {
        self.flackOne = false
        self.flackTwo = false
        self.id = 0
        self.name = ""
        self.maxSeries = 1
        self.avatar = ""
        self.avatarImage = UIImage()
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
    var colectionImG: [UIImage]
    init() {
        self.close = false
        self.id = 0
        self.name = ""
        self.series = 1
        self.avatar = ""
        self.colectionImage = []
        self.colectionImG = []
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

var likeBase = [News]() // База новосте

func fillingLikeBase(completioHandler : (() ->Void)?) {
    var news = 0
    likeBase.removeAll()
    likeBase.append(News())
    likeBase[news].id = news
    likeBase[news].image = "news1"
    likeBase[news].name = "Анонсировано аниме Phantasy Star Online 2: Episode Oracle"
    likeBase[news].news = "В воскресенье на мероприятии Phantasy Star Kanshasai 2019 Sega анонсировала новое аниме, основанное на серии игр Phantasy Star Online 2. Под названием «Phantasy Star Online 2: Episode Oracle» в аниме будет рассказано о первых трех эпизодах игры и своя оригинальная история. Аниме выйдет в этом году."
    news+=1
    likeBase.append(News())
    likeBase[news].id = news
    likeBase[news].image = "news2"
    likeBase[news].name = "Первые подробности о грядущей аниме-адаптации «Mairimashita! Iruma-kun»."
    likeBase[news].news = "В каждой семье случаются проблемы, в том числе финансовые, и решать их приходится по-разному. Вот только иногда принимаемые решения оказываются, мягко говоря, экстремальными. Как раз так и обстояли дела в семье школьника Ирумы Сузуки, когда выяснилось, что родители решили продать его дьяволу. И не так уж сильно они нуждались в деньгах, просто безалаберным родителям Сузуки захотелось лёгкой жизни. И вот Ирума глазом моргнуть не успел, а он уже в мире демонов, и демон, выкупивший его у родителей, умоляет его стать ему внуком! В общем, это история о том, что и в аду может быть довольно весело!"
    news+=1
    likeBase.append(News())
    likeBase[news].id = news
    likeBase[news].image = "news3"
    likeBase[news].name = "Постер и трейлер фильма Kimi to, Nami ni Noretara"
    likeBase[news].news = "Поступив в университет, Хинако переезжает в прибрежный городок. Она очень любит сёрфинг и на волнах чувствует себя уверенно, однако неопределённость будущего всё ещё беспокоит её. Когда разбушевавшийся пожар сеет хаос в городке, Хинако знакомится с молодым пожарным Минато. Пока они занимаются сёрфингом и проводят много времени вместе, девушка начинает чувствовать, что её тянет к кому-то вроде Минато, кто посвятил свою жизнь помощи другим. В свою очередь Хинако тоже занимает особое место в сердце юноши."
    news+=1
    likeBase.append(News())
    likeBase[news].id = news
    likeBase[news].image = "news4"
    likeBase[news].name = "На Netflix появилась страница сериала по мотивам One Piece"
    likeBase[news].news = "О подготовке игрового сериала по One Piece объявили летом 2017 года, когда оригинальной манге исполнилось 20 лет. Согласно синопсису на Netflix, сюжет грядущей адаптации совпадает с первоисточником и расскажет о приключениях пирата Манки Д. Луффи и его команды в поисках таинственного сокровища."
    news+=1
    likeBase.append(News())
    likeBase[news].id = news
    likeBase[news].image = "news5"
    likeBase[news].name = "Манга Totsukuni no Shoujo («Девочка из Чужеземья») получит OAD"
    likeBase[news].news = "«Эта история полна печали. С этого момента, давайте окунёмся в неторопливую и прекрасную историю, что произошла давным давно». Шива, маленькая девочка, любящая прогуляться по округе, живёт в пустой деревне со своим стражем, монстровидным джентльменом. Он запрещает ей выходить за пределы деревни, иначе она может быть проклята. Но Шива очень любопытна и жаждет внешнего мира. В чем же заключается проклятие?"
    news+=1
    completioHandler?()
}

class MainProfile {         // Структура профиля пользователя Singleton
    var id = 0
    var name = ""
    var birthday = ""
    var avatar = ""
    var favoriteАnime = [Аnime]()
    var friends = [Friend]()
    private init() {}
    static let instance = MainProfile()
}

class FriendProfile {         // Структура профиля друга Singleton
    var name = ""
    var id = 0
    var birthday = ""
    var avatarName = ""
    var avatar = UIImage()
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

func fileSestemSave(namePhoto: String, img: UIImage) {  // Сохранение картинки
    let fileUrl = getDocumentsDir().appendingPathComponent(namePhoto)
    
    guard let data = img.pngData() else { return }
    
    do {
        try data.write(to: fileUrl)
    } catch {
        print(error)
        return
    }
    print("Image saved")
}

func loadImage(namePhoto: String) -> UIImage {  // Чтение картинки
    let fileUrl = getDocumentsDir().appendingPathComponent(namePhoto)
    
    do {
        let imageData = try Data(contentsOf: fileUrl)
        return UIImage(data: imageData)!
    } catch {
        return UIImage()
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

