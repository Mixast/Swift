import Foundation

struct Аnime {
    var id: Int
    var name: String
    init() {
        self.id = 0
        self.name = ""
    }
}

struct Profile {         // Структура для базы
    var id: Int
    var name: String
    var login: String
    var birthday: String
    var password: String
    var avatar: String
    var favoriteАnime: [Аnime]
    init() {
        self.id = 0
        self.name = ""
        self.login = ""
        self.password = ""
        self.birthday = ""
        self.avatar = ""
        self.favoriteАnime = []
    }
}


var base = [Profile]()
var transportLine = Int()

func fillingBase(completioHandler : (() ->Void)?) {  // Заполнение базы
    var count = 0
    var point = 0
    var animePoint = 0
    base.removeAll()
    base.append(Profile())
    base[point].id = count; count+=1
    base[point].login = "Mark"
    base[point].password = "123"
    base[point].name = "Марк Аврелий"
    base[point].birthday = "14.02.1990"
    base[point].avatar = "mark"
    base[point].favoriteАnime.append(Аnime())
    base[point].favoriteАnime[animePoint].id = animePoint
    base[point].favoriteАnime[animePoint].name = "Beck"
    point+=1
    animePoint = 0
    base.append(Profile())
    base[point].id = count; count+=1
    base[point].login = "Aloe"
    base[point].password = "321"
    base[point].name = "Алина Вей"
    base[point].birthday = "20.02.1996"
    base[point].avatar = "aloe"
    base[point].favoriteАnime.append(Аnime())
    base[point].favoriteАnime[animePoint].id = animePoint
    base[point].favoriteАnime[animePoint].name = "Мастера Меча Онлайн"
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
    base[point].favoriteАnime[animePoint].id = animePoint
    base[point].favoriteАnime[animePoint].name = "Твоё имя"
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
    base[point].favoriteАnime[animePoint].id = animePoint
    base[point].favoriteАnime[animePoint].name = "Стальной алхимик"
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
    base[point].favoriteАnime[animePoint].id = animePoint
    base[point].favoriteАnime[animePoint].name = "Шумиха"
    point+=1
    animePoint = 0
    base.append(Profile())
    base[point].id = count; count+=1
    base[point].login = "Pop"
    base[point].password = "987"
    base[point].name = "Михаил Аустерлиц"
    base[point].birthday = "23.04.1992"
    base[point].avatar = "pop"
    base[point].favoriteАnime.append(Аnime())
    base[point].favoriteАnime[animePoint].id = animePoint
    base[point].favoriteАnime[animePoint].name = "Восхождение героя щита"
    animePoint+=1
    base[point].favoriteАnime.append(Аnime())
    base[point].favoriteАnime[animePoint].id = animePoint
    base[point].favoriteАnime[animePoint].name = "Мастера Меча Онлайн"
    point+=1
    animePoint = 0
    
    completioHandler?()
}

var animeBase = [Аnime]()
func fillinganimeBase(completioHandler : (() ->Void)?) {
    var animePoint = 0
    animeBase.append(Аnime())
    animeBase[animePoint].id = animePoint
    animeBase[animePoint].name = "Beck"
    animePoint+=1
    animeBase.append(Аnime())
    animeBase[animePoint].id = animePoint
    animeBase[animePoint].name = "Мастера Меча Онлайн"
    animePoint+=1
    animeBase.append(Аnime())
    animeBase[animePoint].id = animePoint
    animeBase[animePoint].name = "Твоё имя"
    animePoint+=1
    animeBase.append(Аnime())
    animeBase[animePoint].id = animePoint
    animeBase[animePoint].name = "Стальной алхимик"
    animePoint+=1
    animeBase.append(Аnime())
    animeBase[animePoint].id = animePoint
    animeBase[animePoint].name = "Шумиха"
    animePoint+=1
    animeBase.append(Аnime())
    animeBase[animePoint].id = animePoint
    animeBase[animePoint].name = "Восхождение героя щита"
    animePoint+=1
    
    completioHandler?()
}
