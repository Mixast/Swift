import Foundation
import RealmSwift

var transportRealmIndex = Int()

class RealmBase: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var birthday = ""
    @objc dynamic var avatar = ""
    var favoriteАnime = List<FavoriteАnime>()
    var friends = List<Friends>()

    // primaryKey  для проверки сохраняемых данных на дублирование
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // indexedProperties  для ускорения чтения данных
    override static func indexedProperties() -> [String] {
        return ["id"]
    }

}

class FavoriteАnime: Object {
    @objc dynamic var descriptionFlack = false
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var avatar = ""
    @objc dynamic var avatarImageData = Data()
    @objc dynamic var status = ""
    @objc dynamic var series = 1
    @objc dynamic var maxSeries = 1
    @objc dynamic var descriptionInfo = ""
    var colectionImage = List<String>()
    var colectionImageData = List<Data>()
}

class Friends: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var avatarName = ""
    @objc dynamic var avatarData = Data()
}

// Сохраниение данных в реалм
func realmSave() {
    let mainProfile = MainProfile.instance
    let testEntyty = RealmBase()
    testEntyty.id = mainProfile.id
    testEntyty.name = mainProfile.name
    testEntyty.birthday = mainProfile.birthday
    testEntyty.avatar = mainProfile.avatar
    
    for i in 1...mainProfile.favoriteАnime.count {
        let anime = FavoriteАnime()
        anime.descriptionFlack = mainProfile.favoriteАnime[i-1].descriptionFlack
        anime.id = mainProfile.favoriteАnime[i-1].id
        anime.name = mainProfile.favoriteАnime[i-1].name
        anime.avatar = mainProfile.favoriteАnime[i-1].avatar
        anime.avatarImageData = mainProfile.favoriteАnime[i-1].avatarImageData
        anime.status = mainProfile.favoriteАnime[i-1].status
        anime.series = mainProfile.favoriteАnime[i-1].series
        anime.maxSeries = mainProfile.favoriteАnime[i-1].maxSeries
        anime.descriptionInfo = mainProfile.favoriteАnime[i-1].descriptionInfo
        
        if mainProfile.favoriteАnime[i-1].colectionImage.count != 0 {
            let list = List<String>()
            for k in 1...mainProfile.favoriteАnime[i-1].colectionImage.count {
                list.append(mainProfile.favoriteАnime[i-1].colectionImage[k-1])
            }
            anime.colectionImage = list
        }
        if mainProfile.favoriteАnime[i-1].colectionImage.count != 0 {
            let list = List<Data>()
            for k in 1...mainProfile.favoriteАnime[i-1].colectionImageData.count {
                list.append(mainProfile.favoriteАnime[i-1].colectionImageData[k-1])
            }
            anime.colectionImageData = list
        }
        testEntyty.favoriteАnime.append(anime)
    }
    
    for i in 1...mainProfile.friends.count {
        let friend = Friends()
        friend.id = mainProfile.friends[i-1].id
        friend.name = mainProfile.friends[i-1].name
        friend.avatarName = mainProfile.friends[i-1].avatarName
        friend.avatarData = mainProfile.friends[i-1].avatarData
        testEntyty.friends.append(friend)
    }
    
    do {
        let realm = try Realm()
        print(realm.configuration.fileURL as Any)
        realm.beginWrite()
        realm.add(testEntyty)
        try realm.commitWrite()
        
    } catch {
        print(error)
    }
}

// Загрузка данных из реалм
func realmLoad(index: Int) -> RealmBase {
    guard let realm =  try? Realm() else {
        print("Error Realm")
        return RealmBase()
    }
    let object = realm.objects(RealmBase.self)
    guard let base = Optional(object[index]) else {
        return RealmBase()
    }
    
    return base
}

// Загрузка аниме из List в Array ( Anime )
func realmLoadAnime() {
    let mainProfile = MainProfile.instance
    let anime = realmLoad(index: transportRealmIndex)
    if anime.favoriteАnime.count != 0 {
   
        for i in 1...anime.favoriteАnime.count {
            var animeSeve = Аnime()
            animeSeve.descriptionFlack = anime.favoriteАnime[i-1].descriptionFlack
            animeSeve.id = anime.favoriteАnime[i-1].id
            animeSeve.name = anime.favoriteАnime[i-1].name
            animeSeve.avatar = anime.favoriteАnime[i-1].avatar
            animeSeve.avatarImageData = anime.favoriteАnime[i-1].avatarImageData
            animeSeve.status = anime.favoriteАnime[i-1].status
            animeSeve.series = anime.favoriteАnime[i-1].series
            animeSeve.maxSeries = anime.favoriteАnime[i-1].maxSeries
            animeSeve.descriptionInfo =  anime.favoriteАnime[i-1].descriptionInfo
            
            
            if anime.favoriteАnime[i-1].colectionImage.count != 0 {
                var base = [String]()
                for k in 1...anime.favoriteАnime[i-1].colectionImage.count {
                    base.append(anime.favoriteАnime[i-1].colectionImage[k-1])
                }
                animeSeve.colectionImage = base
            }
            
            if anime.favoriteАnime[i-1].colectionImageData.count != 0 {
                var base = [Data]()
                for _ in 1...anime.favoriteАnime[i-1].colectionImageData.count {
                    base.append(Data())
                }
                animeSeve.colectionImageData = base
            }
            
            mainProfile.favoriteАnime.append(animeSeve)
        }
    }
}

// Загрузка аниме из List в Array ( Friends )

func realmLoadFriends() {
    let mainProfile = MainProfile.instance
    let friendBase = realmLoad(index: transportRealmIndex)
    
    if friendBase.friends.count != 0 {
        for i in 1...friendBase.friends.count {
            var friendSave = Friend()
            friendSave.id = friendBase.friends[i-1].id
            friendSave.name = friendBase.friends[i-1].name
            friendSave.avatarName = friendBase.friends[i-1].avatarName
            friendSave.avatarData = friendBase.friends[i-1].avatarData
            
            mainProfile.friends.append(friendSave)
        }
    }
}
