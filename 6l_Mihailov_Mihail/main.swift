import Foundation

// Создаю свой тип коллекции «очередь» для колекции игр (human (ходилки), car (гонки), airplane (леталки))

enum GameOption: String {   //enum для параметров игры
    case moveTrue = "Игрок умеет ходить"
    case moveFalse =  "Игрок не умеет ходить"
    case lieDownTrue = "Игрок умеет ложиться"
    case lieDownFalse =  "Игрок не умеет ложиться"
    case ignitionTrue = "Двигатель включается"
    case ignitionFalse =  "Двигатель не включается"
    case flightTrue = "Самолет умеет взлетать"
    case flightFalse =  "Самолет не умеет взлетать"
    case gainAltitudeTrue = "Самелет умеет набирать высоту"
    case gainAltitudeFalse =  "Самелет не умеет набирать высоту"
    case driveTrue = "Автомобиль меет вопорачивать"
    case driveFalse =  "Автомобиль не умеет вопорачивать"
    case speedTrue = "Автомобиль умеет разгоняться"
    case speedFalse =  "Автомобиль не умеет разгоняться"

}

protocol Walking {      // Действия для ходилки human
    var move:  Bool { get set}
    var lieDown:  Bool { get set}
}

extension Walking {
    func move () -> String {
        if self.move == true { return GameOption.moveTrue.rawValue }
        return GameOption.moveFalse.rawValue
    }
    func lieDown () -> String {
        if self.lieDown == true { return GameOption.lieDownTrue.rawValue }
        return GameOption.lieDownFalse.rawValue
    }
}

protocol Flying {       // Действия для леталки airplane
    var ignition:  Bool { get set}
    var flight:  Bool { get set}
    var gainAltitude:  Bool { get set}
}

extension Flying {
    func ignition () -> String {
        if self.ignition == true { return GameOption.ignitionTrue.rawValue }
        return GameOption.ignitionFalse.rawValue
    }
    func flight () -> String {
        if self.flight == true { return GameOption.flightTrue.rawValue }
        return GameOption.lieDownFalse.rawValue
    }
    func gainAltitude () -> String {
        if self.gainAltitude == true { return GameOption.gainAltitudeTrue.rawValue }
        return GameOption.gainAltitudeFalse.rawValue
    }
}

protocol Driving {      // Действия для гонки car
    var ignition:  Bool { get set}
    var drive:  Bool { get set}
    var speed:  Bool { get set}
}

extension Driving {
    func ignition () -> String {
        if self.ignition == true { return GameOption.ignitionTrue.rawValue }
        return GameOption.ignitionFalse.rawValue
    }
    func drive () -> String {
        if self.drive == true { return GameOption.driveTrue.rawValue }
        return GameOption.driveFalse.rawValue
    }
    func speed () -> String {
        if self.speed == true { return GameOption.speedTrue.rawValue }
        return GameOption.speedFalse.rawValue
    }
}

class Human: Walking {      //  Class ходилки human
    let name: String
    var lieDown: Bool
    var move: Bool
    func funcMove(status: Bool) {
        if status == true { move = true; print("Изменено: \(GameOption.moveTrue.rawValue)"); return}
        move = false
        print("Изменено: \(GameOption.moveFalse.rawValue)")
    }
    func funcLieDown(status: Bool) {
        if status == true { lieDown = true; print("Изменено: \(GameOption.lieDownTrue.rawValue)"); return}
        lieDown = false
        print("Изменено: \(GameOption.lieDownFalse.rawValue)")
    }
    init(name: String, lieDown: Bool, move: Bool) {
        self.name = name
        self.lieDown = lieDown
        self.move = move
    }
}

extension Human: CustomStringConvertible {
    var description : String {
        return "Name: \(name), LieDown: \(lieDown()), Move: \(move())"
    }
}

class Car: Driving {        //  Class гонки car
    let name: String
    var speed: Bool
    var drive: Bool
    var ignition: Bool
    func funcIgnition(status: Bool) {
        if status == true { ignition = true; print("Изменено: \(GameOption.ignitionTrue.rawValue)"); return}
        ignition = false
        print("Изменено: \(GameOption.ignitionFalse.rawValue)")
    }
    func funcMove(status: Bool) {
        if status == true { drive = true; print("Изменено: \(GameOption.driveTrue.rawValue)"); return}
        drive = false
        print(GameOption.driveFalse.rawValue)
    }
    func funcSpeed(status: Bool) {
        if status == true { speed = true; print("Изменено: \(GameOption.speedTrue.rawValue)"); return}
        speed = false
        print("Изменено: \(GameOption.speedFalse.rawValue)")
    }
    init(name: String, speed: Bool, drive: Bool, ignition: Bool) {
        self.name = name
        self.speed = speed
        self.drive = drive
        self.ignition = ignition
    }
}

extension Car: CustomStringConvertible {
    var description : String {
        return "Name: \(name), Speed: \(speed()), Drive: \(drive()), Ignition:  \(ignition()))"
    }
}


class Airplane: Flying {        //  Class леталки airplane
    let name: String
    var gainAltitude: Bool
    var flight: Bool
    var ignition: Bool
    func funcIgnition(status: Bool){
        if status == true { ignition = true; print("Изменено: \(GameOption.ignitionTrue.rawValue)"); return}
        ignition = false
        print("Изменено: \(GameOption.ignitionFalse.rawValue)")
    }
    func funcFlight(status: Bool){
        if status == true { flight = true; print("Изменено: \(GameOption.flightTrue.rawValue)"); return}
        flight = false
        print("Изменено: \(GameOption.flightFalse.rawValue)")
    }
    func funcGainAltitude(status: Bool){
        if status == true { gainAltitude = true; print("Изменено: \(GameOption.gainAltitudeTrue.rawValue)"); return}
        gainAltitude = false
        print("Изменено: \(GameOption.gainAltitudeFalse.rawValue)")
    }
    init(name: String, gainAltitude: Bool, flight: Bool, ignition: Bool) {
        self.name = name
        self.gainAltitude = gainAltitude
        self.flight = flight
        self.ignition = ignition
    }
}

extension Airplane: CustomStringConvertible {
    var description : String {
        return "Name: \(name), GainAltitude: \(gainAltitude()), Flight: \(flight()), Ignition:  \(ignition()))"
    }
}

//1. Реализовать свой тип коллекции «очередь» (queue) c использованием дженериков.

//2. Добавить ему несколько методов высшего порядка, полезных для этой коллекции (пример: filter для массивов)

//3. * Добавить свой subscript, который будет возвращать nil в случае обращения к несуществующему индексу.

struct Queue <T> {                   //  Очередь игр
    private var players: [T] = []
    public var isEmpty: Bool {
        return players.count == 0
    }
    mutating func push(_ element: T) {
        players.append(element)
    }
    mutating func pop() -> T? {
        return players.removeLast()
    }
    public var head: T? {
        guard !isEmpty else {
            print("Элементов не обнаруженно. Массив пуст.")
            return nil
        }
        print("Последняя игра в колекции: \(players.last!)")
        return players.last
    }
    
    public var front: T? {
        guard !isEmpty else {
            print("Элементов не обнаруженно. Массив пуст.")
            return nil
        }
        print("Первая игра в колекции: \(players.first!)")
        return players.first
    }
}

extension Queue {
    func myFilter(predicate:(T) -> Bool) -> [T] {  //фильтр для нашей колекции
        var result = [T]()
        for i in players {
            if predicate(i) {
                result.append(i)
            }
        }
        return result
    }
}


var shooter = Queue<Human>()

shooter.push(Human(name: "Call of Duty", lieDown: false, move: true))
shooter.push(Human(name: "Doom", lieDown: false, move: true))

print(shooter)

shooter.head?.funcLieDown(status: true)

shooter.push(Human(name: "Duck Hunt", lieDown: false, move: false))

let filterGameOne = shooter.myFilter(predicate: {$0.move() == GameOption.moveTrue.rawValue })
print("Игры по фильтру: \(filterGameOne) \n")

var Race = Queue<Car>()

Race.push(Car(name: "Need for Speed", speed: true, drive: true, ignition: true))
Race.push(Car(name: "Road Rash", speed: false, drive: true, ignition: false))
print(Race)
let filterGameTwo = Race.myFilter(predicate: {$0.speed() == "Автомобиль не умеет разгоняться"})
print("Игры по фильтру: \(filterGameTwo)")





