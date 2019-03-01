import Foundation

struct Profile {         // структура для базы
    var id: Int
    var name: String
    var login: String
    var password: String
    var favoriteАnime: String
    init() {
        self.id = 0
        self.name = ""
        self.login = ""
        self.password = ""
        self.favoriteАnime = ""
    }
}


var base = [Profile]()

func fillingBase(completioHandler : (() ->Void)?) {  // заполнение базы
    var count = 0
    var point = 0
    base.removeAll()
    base.append(Profile())
    base[point].id = count; count+=1
    base[point].login = "Mark"
    base[point].password = "123"
    base[point].name = "Марк Аврелий"
    base[point].favoriteАnime = "Beck"
    point+=1
    base.append(Profile())
    base[point].id = count; count+=1
    base[point].login = "Aloe"
    base[point].password = "321"
    base[point].name = "Алина Вей"
    base[point].favoriteАnime = "Мастера Меча Онлайн"
    point+=1
    base.append(Profile())
    base[point].id = count; count+=1
    base[point].login = "Hloya"
    base[point].password = "456"
    base[point].name = "Хлоя Мауер"
    base[point].favoriteАnime = "Твоё имя"
    point+=1
    base.append(Profile())
    base[point].id = count; count+=1
    base[point].login = "Max"
    base[point].password = "654"
    base[point].name = "Макс Фрай"
    base[point].favoriteАnime = "Стальной алхимик"
    point+=1
    base.append(Profile())
    base[point].id = count; count+=1
    base[point].login = "Len"
    base[point].password = "789"
    base[point].name = "Василий Мисковец"
    base[point].favoriteАnime = "Шумиха!"
    point+=1
    base.append(Profile())
    base[point].id = count; count+=1
    base[point].login = "Pop"
    base[point].password = "987"
    base[point].name = "Михаил Аустерлиц"
    base[point].favoriteАnime = "Восхождение героя щита"
    point+=1
    
    completioHandler?()
}
