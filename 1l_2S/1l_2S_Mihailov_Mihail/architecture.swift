import Foundation
import RNCryptor

var chek = false // Костыль для перехода в самое начало

struct Keys { // Ключевые слова для keychain
    static let login = "login"
    static let password = "password"
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
    var name: String
    var avatarName: String
    var avatar: UIImage
    init() {
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
    var flack: Bool
    var id: Int
    var name: String
    var avatar: UIImage
    var series: Int
    var seriesURL: [String]
    var description: String
    init() {
        self.id = 0
        self.name = ""
        self.series = 1
        self.seriesURL = []
        self.flack = false
        self.description = ""
        self.avatar = UIImage()
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

var base = [Profile]() // Общаяя база

func fillingBase(completioHandler : (() ->Void)?) {  // Заполнение общей базы
    var count = 0
    var point = 0
    var animePoint = 0
    var friend = 0
    base.removeAll()
    base.append(Profile())
    base[point].id = count; count+=1
    base[point].login = "Mark"
    base[point].password = "123"
    base[point].name = "Марк Аврелий"
    base[point].birthday = "14.02.1990"
    base[point].avatar = "mark"
    base[point].friends.append(Friend())
    base[point].friends[friend].name = "Алина Вей"
    base[point].friends[friend].avatarName = "aloe"
    friend+=1
    base[point].favoriteАnime.append(Аnime())
    base[point].favoriteАnime[animePoint].id = 0
    base[point].favoriteАnime[animePoint].name = "Beck"
    base[point].favoriteАnime[animePoint].description = "Юкио Танака, а для друзей Коюки, с детства любил петь. Впрочем, талант его не нашёл применения, и сам он ведёт обыкновенную школьную жизнь."
    base[point].favoriteАnime[animePoint].series = 3
    point+=1
    friend = 0
    animePoint = 0
    base.append(Profile())
    base[point].id = count; count+=1
    base[point].login = "Aloe"
    base[point].password = "321"
    base[point].name = "Алина Вей"
    base[point].birthday = "20.02.1996"
    base[point].avatar = "aloe"
    base[point].favoriteАnime.append(Аnime())
    base[point].favoriteАnime[animePoint].id = 1
    base[point].favoriteАnime[animePoint].name = "Мастера Меча Онлайн"
    base[point].favoriteАnime[animePoint].description = "И вот вышла многопользовательская игра нового поколения — игра, где смерть реальна и бегство невозможно. Единственный выход — дойти до конца. А называется игра «Sword Art Online»."
    base[point].favoriteАnime[animePoint].series = 1
    point+=1
    animePoint = 0
    base.append(Profile())
    base[point].id = count; count+=1
    base[point].login = "Hloya"
    base[point].password = "456"
    base[point].name = "Хлоя Мауер"
    base[point].birthday = "04.01.1992"
    base[point].avatar = "hloya"
    base[point].favoriteАnime.append(Аnime())
    base[point].favoriteАnime[animePoint].id = 2
    base[point].favoriteАnime[animePoint].name = "Твоё имя"
    base[point].favoriteАnime[animePoint].description = "Мицуха Миямидзу — обычная девушка, уставшая от жизни в провинции. Её отец, мэр города, ведёт избирательную кампанию, а в семейном синтоистском храме ей приходится прилюдно исполнять древние ритуалы."
    point+=1
    animePoint = 0
    base.append(Profile())
    base[point].id = count; count+=1
    base[point].login = "Max"
    base[point].password = "654"
    base[point].name = "Макс Фрай"
    base[point].birthday = "14.12.1986"
    base[point].avatar = "max"
    base[point].favoriteАnime.append(Аnime())
    base[point].favoriteАnime[animePoint].id = 3
    base[point].favoriteАnime[animePoint].name = "Стальной алхимик"
    base[point].favoriteАnime[animePoint].description = "В этом мире существуют алхимики — люди, владеющие искусством алхимии, способностью манипулировать материей и преобразовывать вещество. "
    point+=1
    animePoint = 0
    base.append(Profile())
    base[point].id = count; count+=1
    base[point].login = "Len"
    base[point].password = "789"
    base[point].name = "Василий Мисковец"
    base[point].birthday = "14.04.1992"
    base[point].avatar = "len"
    base[point].favoriteАnime.append(Аnime())
    base[point].favoriteАnime[animePoint].id = 4
    base[point].favoriteАnime[animePoint].name = "Шумиха"
    base[point].favoriteАnime[animePoint].description = "В конце 1930-х годов, в разгар Великой депрессии, из Чикаго отправляется трансконтинентальный поезд «Крадущийся тигр», который впоследствии захватывают сразу две враждующие банды. Понятное дело, разгорается схватка, в которой то там, то тут мелькают незадачливые пассажиры, и летящий на всех парах состав начинает оставлять за собой кровавый след, тянущийся вдоль всей страны."
    point+=1
    animePoint = 0
    base.append(Profile())
    base[point].id = count; count+=1
    base[point].login = "Pop"
    base[point].password = "987"
    base[point].name = "Михаил Аустерлиц"
    base[point].birthday = "23.04.1992"
    base[point].avatar = "pop"
    base[point].friends.append(Friend())
    base[point].friends[friend].name = "Алина Вей"
    base[point].friends[friend].avatarName = "aloe"
    friend+=1
    base[point].friends.append(Friend())
    base[point].friends[friend].name = "Хлоя Мауер"
    base[point].friends[friend].avatarName = "hloya"
    friend+=1
    base[point].friends.append(Friend())
    base[point].friends[friend].name = "Марк Аврелий"
    base[point].friends[friend].avatarName = "mark"
    friend+=1
    base[point].friends.append(Friend())
    base[point].friends[friend].name = "Макс Фрай"
    base[point].friends[friend].avatarName = "max"
    friend+=1
    base[point].favoriteАnime.append(Аnime())
    base[point].favoriteАnime[animePoint].id = 5
    base[point].favoriteАnime[animePoint].name = "Восхождение героя щита"
    base[point].favoriteАnime[animePoint].description = "Наофуми Иватани вместе с тремя другими людьми был призван в параллельный мир, чтобы стать его Героем. При переносе в другой мир каждый из них получил специальную экипировку, которая соответствует типу Героя. Наш же протагонист получил в руки легендарный щит и решил отправиться в путешествие по этому сказочному миру."
    base[point].favoriteАnime[animePoint].series = 3
    animePoint+=1
    base[point].favoriteАnime.append(Аnime())
    base[point].favoriteАnime[animePoint].id = 1
    base[point].favoriteАnime[animePoint].name = "Мастера Меча Онлайн"
    base[point].favoriteАnime[animePoint].description = "И вот вышла многопользовательская игра нового поколения — игра, где смерть реальна и бегство невозможно. Единственный выход — дойти до конца. А называется игра «Sword Art Online»."
    base[point].favoriteАnime[animePoint].series = 4
    point+=1
    animePoint = 0
    
    for i in 1...base.count {
        if base[i-1].friends.count != 0 {
            for m in 1...base[i-1].friends.count {
                base[i-1].friends[m-1].avatar = UIImage(named: base[i-1].friends[m-1].avatarName + ".jpg")!
            }
            for m in 1...base[i-1].favoriteАnime.count {
                base[i-1].favoriteАnime[m-1].avatar = UIImage(named: base[i-1].favoriteАnime[m-1].name + ".jpg")!
            }
        }
        base[i-1].id = i-1
    }
    
    completioHandler?()
}

var animeBase = [Аnime]() // Посный список Аниме
var animelist = [Аnime]() // Предлагаемый список Аниме

func fillinganimeBase(completioHandler : (() ->Void)?) { // Составление списка аниме
    var animePoint = 0
    animeBase.removeAll()
    animeBase.append(Аnime())
    animeBase[animePoint].id = animePoint
    animeBase[animePoint].name = "Beck"
    animeBase[animePoint].series = 4
    animeBase[animePoint].seriesURL = ["3406950", "3406956", "3418397", "3418398"]
    animeBase[animePoint].description = "Юкио Танака, а для друзей Коюки, с детства любил петь. Впрочем, талант его не нашёл применения, и сам он ведёт обыкновенную школьную жизнь."
    animePoint+=1
    animeBase.append(Аnime())
    animeBase[animePoint].id = animePoint
    animeBase[animePoint].name = "Мастера Меча Онлайн"
    animeBase[animePoint].series = 4
    animeBase[animePoint].seriesURL = ["3025745", "3032316", "3039521", "3044296"]
    animeBase[animePoint].description = "И вот вышла многопользовательская игра нового поколения — игра, где смерть реальна и бегство невозможно. Единственный выход — дойти до конца. А называется игра «Sword Art Online»."
    animePoint+=1
    animeBase.append(Аnime())
    animeBase[animePoint].id = animePoint
    animeBase[animePoint].name = "Твоё имя"
    animeBase[animePoint].series = 1
    animeBase[animePoint].seriesURL = ["3377720"]
    animeBase[animePoint].description = "Мицуха Миямидзу — обычная девушка, уставшая от жизни в провинции. Её отец, мэр города, ведёт избирательную кампанию, а в семейном синтоистском храме ей приходится прилюдно исполнять древние ритуалы."
    animePoint+=1
    animeBase.append(Аnime())
    animeBase[animePoint].id = animePoint
    animeBase[animePoint].name = "Стальной алхимик"
    animeBase[animePoint].series = 51
    animeBase[animePoint].seriesURL = ["2884233", "2884241", "2884246"]
    animeBase[animePoint].description = "В этом мире существуют алхимики — люди, владеющие искусством алхимии, способностью манипулировать материей и преобразовывать вещество. "
    animePoint+=1
    animeBase.append(Аnime())
    animeBase[animePoint].id = animePoint
    animeBase[animePoint].name = "Шумиха"
    animeBase[animePoint].series = 4
    animeBase[animePoint].seriesURL = ["3296861", "3296863", "3296864", "3296866"]
    animeBase[animePoint].description = "В конце 1930-х годов, в разгар Великой депрессии, из Чикаго отправляется трансконтинентальный поезд «Крадущийся тигр», который впоследствии захватывают сразу две враждующие банды. Понятное дело, разгорается схватка, в которой то там, то тут мелькают незадачливые пассажиры, и летящий на всех парах состав начинает оставлять за собой кровавый след, тянущийся вдоль всей страны."
    animePoint+=1
    animeBase.append(Аnime())
    animeBase[animePoint].id = animePoint
    animeBase[animePoint].name = "Восхождение героя щита"
    animeBase[animePoint].series = 4
    animeBase[animePoint].seriesURL = ["3521828", "3530835", "3535432", "3540212"]
    animeBase[animePoint].description = "Наофуми Иватани вместе с тремя другими людьми был призван в параллельный мир, чтобы стать его Героем. При переносе в другой мир каждый из них получил специальную экипировку, которая соответствует типу Героя. Наш же протагонист получил в руки легендарный щит и решил отправиться в путешествие по этому сказочному миру."
    animePoint+=1
    
    for m in 1...animeBase.count {
        animeBase[m-1].avatar = UIImage(named: animeBase[m-1].name + ".jpg")!
    }
    
    animelist=animeBase
    completioHandler?()
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
    var birthday = ""
    var avatar = ""
    var favoriteАnime = [Аnime]()
    var friends = [Friend]()
    private init() {}
    static let instance = FriendProfile()
}


