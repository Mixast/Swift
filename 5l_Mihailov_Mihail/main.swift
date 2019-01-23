import Foundation

enum Parameters: String {       // enum для заполнения
    case brand = "Введите марку автомобиля: "
    case mark = "Введите модель автомобиля: "
    case yearIssue = "Введите год производства автомобиля: "
    case luggageCapacity = "Введите объем багажника (л.): "
    case luggageStatus = "Укажите насколько % загружен багажник (только цыфрами c 1 до 100) "
    case engineRunning = "Для запуска двигателя 1, для остановки двигателя 2"
    case openWindows = "Для открытия окон 1, для закрытия 2 "
    case power = "Введите объём двигателя (лс.): "
    case numberOfDoors = "Введите количество дверей: "
    case statusDoors = "Для открытия дверей 1, для закрытия дверей 2"
    case loadСapacity = "Укажите грузоподъёмность автомобиля (кг.): "
    case cargo = "Укажите наименование груза: "
    case availabilityCargo = "Если есть груз 1, если нету 2"
}

func NewCar(parameter: Parameters) -> String {      // функция для ввода данных
    var key = String()
    func keyReview (Key: String) -> String {
        if (Double(Key)) != nil {} else {
            print("Ошибка вы ввели не число!!!")
            return "0"}
        return Key
    }
    print(parameter.rawValue)
    switch  parameter {
    case Parameters.brand : key = readLine()!
    case Parameters.mark : key = readLine()!
    case Parameters.yearIssue : key = keyReview(Key: readLine()!)
    case Parameters.luggageCapacity : key = keyReview(Key: readLine()!)
    case Parameters.luggageStatus : key = keyReview(Key: readLine()!)
    case Parameters.power : key = keyReview(Key: readLine()!)
    case Parameters.numberOfDoors : key = keyReview(Key: readLine()!)
    case Parameters.loadСapacity : key = keyReview(Key: readLine()!)
    case Parameters.cargo : key = readLine()!
    default: break
    }
    return key
}

//4. Для каждого класса написать расширение, имплементирующее протокол CustomStringConvertible.

protocol ConsolePrintable: CustomStringConvertible {
    func printDescription()
}
extension ConsolePrintable{
    func printDescription() {
        print(description)
    }
}

//1. Создать протокол «Car» и описать свойства, общие для автомобилей, а также метод действия.

protocol Carable {
    var brand: String { get }
    var mark: String { get }
    var yearIssue: Int { get }
    var luggageCapacity: Double { get }
    var luggageStatus: Double { get set }
    var engineRunning: Bool { get set }
    var openWindows: Bool { get set }
}

//2. Создать расширения для протокола «Car» и реализовать в них методы конкретных действий с автомобилем: открыть/закрыть окно, запустить/заглушить двигатель и т.д. (по одному методу на действие, реализовывать следует только те действия, реализация которых общая для всех автомобилей).

extension   Carable {
    mutating func OpenWindows(Count : String) {
        if Count == "1" { print("Окна открыты"); openWindows = true }
        else if Count == "2" { print("Окна закрыты"); openWindows = false }
    }
    mutating func EngineRunning(Count : String) {
        if Count == "1" { print("Двигатель запущен"); engineRunning = true }
        else if Count == "2" { print("Двигатель остановлен"); engineRunning = false }
    }
    mutating func LuggageStatus(Count : String) {
        if luggageStatus < 0 && luggageStatus > 100 {
            print("Багажник заполнен на \(engineRunning) %")
        }
    }
}

extension Carable {
    private func statusOpenWindows () -> String {
        if self.openWindows == true { return "Окна открыты" }
        return "Окна закрыты"
    }
    private func statusLuggageStatus () -> String {
        if luggageStatus > 0 && luggageStatus <= 100 { return "Багажник заполнен на \(luggageStatus) %" }
        return "Багажник пустой"
    }
    private func statusEngineRunning () -> String {
        if self.engineRunning == true { return "Двигатель запущен" }
        return "Двигатель не запущен"
    }
    func fullPriceMain() -> Any {
        return "Бренд: \(brand), Марка: \(mark), Год производства: \(yearIssue), Объем багажника: \(luggageCapacity), Статус багажника: \(statusLuggageStatus()), Статус окон: \(statusOpenWindows()), Статус зажигания: \(statusEngineRunning())" }
}

protocol LightCarable {
    var power: Double { get }
    var numberOfDoors: Int { get }
    var statusDoors: Bool { get set }
}

extension   LightCarable {
    mutating func StatusDoors(Count : String) {
        if Count == "1" { print("Двери закрыты"); statusDoors = true}
        else if Count == "2" { print("Двери открыты"); statusDoors = false }
    }
}

extension LightCarable {
    private func statusDoors () -> String {
        if self.statusDoors == true { return "Двери закрыты" }
        return "Двери открыты"
    }
    func fullPriceLight() -> Any {
        return ("Мощность двигателя: \(power), Количество дверей: \(numberOfDoors), Статус дверей: \(statusDoors())")
    }
}

protocol TruckCarable {
    var loadСapacity: Double { get }
    var cargo: String { get set}
    var availabilityCargo: Bool { get set}
}

extension   TruckCarable {
    mutating func AvailabilityCargo(Count : String) {
        if Count == "1" { print("Есть груз"); availabilityCargo = true}
        else if Count == "2" { print("Нет груза"); availabilityCargo = false }
    }
}

extension TruckCarable {
    private func availabilityCargo () -> String {
        if self.availabilityCargo == true { return "Грузовик с грузом" }
        return "Грузовик без груза"
    }
    func fullPriceTruck() -> Any {
        return ("Грузоподъёмность: \(loadСapacity), Наименование груза: \(cargo), Статус груза: \(availabilityCargo())")
    }
}

class Car: Carable {
    static var Point: Int = 0
    var brand: String
    var mark: String
    var yearIssue: Int
    var luggageCapacity: Double
    var luggageStatus: Double
    var engineRunning: Bool
    var openWindows: Bool
    init(brand: String, mark: String ,yearIssue: Int, luggageCapacity: Double) {
        Car.Point += 1
        print("Вы записали данные о новом автомобиле \n")
        if (Int(brand)) == nil {
            self.brand = brand
        }
        else {
            print("Ввесто бренда вы ввели число. Данные записаны по умолчанию")
            self.brand = "No Brand"
        }
        if (Int(mark)) == nil {
            self.mark = mark
        }
        else {
            print("Ввесто марки вы ввели число. Данные записаны по умолчанию")
            self.mark = "No Mark"
        }
        if yearIssue != 0 {
            self.yearIssue = yearIssue
        }
        else {
            print("Год машины указан по умолчанию 1900")
            self.yearIssue = 1900
        }
        if luggageCapacity != 0.0 {
            self.luggageCapacity = luggageCapacity
        }
        else {
            print("Объём кузава указан по умолчанию 0.0")
            self.luggageCapacity = 0.0
        }
        
        self.luggageStatus = 0.0
        self.engineRunning = false
        self.openWindows = false
    }
}

//3. Создать два класса, имплементирующих протокол «Car» - trunkCar и sportСar. Описать в них свойства, отличающиеся для спортивного автомобиля и цистерны.

class LightCar: Car, LightCarable, ConsolePrintable {
    var description: String {
        return String (describing: (Car.Point, "Легковой автомобиль ", fullPriceMain(), fullPriceLight()))
    }
    var power: Double
    var numberOfDoors: Int
    var statusDoors: Bool
    init(brand: String, mark: String ,yearIssue: Int, luggageCapacity: Double, power: Double, numberOfDoors: Int) {
        if power != 0.0 {
            self.power = power
        }
        else {
            print("Мощность указана по умолчанию 0.0")
            self.power = 0.0
        }
        if numberOfDoors != 0 {
            self.numberOfDoors = numberOfDoors
        }
        else {
            print("Количество дверей указано по умолчанию 4")
            self.numberOfDoors = 4
        }
        self.statusDoors = false
        super.init(brand: brand, mark: mark, yearIssue: yearIssue, luggageCapacity: luggageCapacity)
    }
}

class Truck: Car, TruckCarable, ConsolePrintable {
    var description: String {
        return String (describing: (Car.Point, "Грузовой автомобиль ", fullPriceMain(), fullPriceTruck()))
    }
    var loadСapacity: Double
    var cargo: String
    var availabilityCargo: Bool
    init(brand: String, mark: String ,yearIssue: Int, luggageCapacity: Double, loadСapacity: Double, cargo: String) {
        if loadСapacity != 0.0 {
            self.loadСapacity = loadСapacity
        }
        else {
            print("Объём кузава указан по умолчанию 0.0")
            self.loadСapacity = 0.0
        }
        if (Int(cargo)) == nil {
            self.cargo = cargo
        }
        else {
            print("Ввесто наименования товара вы ввели число. Данные записаны по умолчанию")
            self.cargo = "No Сargo"
        }
        self.availabilityCargo = false
        super.init(brand: brand, mark: mark, yearIssue: yearIssue, luggageCapacity: luggageCapacity)
    }
}

var array = [Any]()

func NewLightCar() -> Any { // Функция добавляет новый автомобиль
    var car = LightCar(brand: NewCar(parameter: Parameters.brand), mark: NewCar(parameter: Parameters.mark), yearIssue: Int(NewCar(parameter: Parameters.yearIssue))!, luggageCapacity: Double(NewCar(parameter: Parameters.luggageCapacity))!, power: Double(NewCar(parameter: Parameters.power))!, numberOfDoors: Int(NewCar(parameter: Parameters.numberOfDoors))!)
    var koint = true
    while koint {
        print("Для указания дополнительных параметров нажмите 1, для продолжения любую другую цыфру")
        let Cout = readLine()
        if Cout == "1" {
            while koint {
                print("Для изменеия статуса окон 1, для изменения статуса двигателя 2, для изменения статуса багажника 3, для изменения статуса дверей 4, для продолжения нажмите любую другую цыфру")
                let Cout = readLine()
                if Cout == "1" {
                    print(Parameters.openWindows.rawValue)
                    car.OpenWindows(Count: readLine()!)
                } else if Cout == "2" {
                    print(Parameters.engineRunning.rawValue)
                    car.EngineRunning(Count: readLine()!)
                } else if Cout == "3" {
                    while koint {
                    print(Parameters.luggageStatus.rawValue)
                    car.LuggageStatus(Count: readLine()!)
                    koint = false
                    }
                    koint = true
                } else if Cout == "4" {
                    print(Parameters.statusDoors.rawValue)
                    car.StatusDoors(Count: readLine()!)
                } else { koint = false }
            }
        } else { koint = false }
    }
    car.printDescription()
    return car.description
}

func NewTruckCar() -> Any { // Функция добавляет новый автомобиль
    var car = Truck(brand: NewCar(parameter: Parameters.brand), mark: NewCar(parameter: Parameters.mark), yearIssue: Int(NewCar(parameter: Parameters.yearIssue))!, luggageCapacity: Double(NewCar(parameter: Parameters.luggageCapacity))!, loadСapacity: Double(NewCar(parameter: Parameters.loadСapacity))!, cargo: NewCar(parameter: Parameters.cargo))
    var koint = true
    while koint {
        print("Для указания дополнительных параметров нажмите 1, для продолжения любую другую цыфру")
        let Cout = readLine()
        if Cout == "1" {
            while koint {
                print("Для изменеия статуса окон 1, для изменения статуса двигателя 2, для изменения статуса багажника 3, для изменения статуса груза 4, для продолжения нажмите любую другую цыфру")
                let Cout = readLine()
                if Cout == "1" {
                    print(Parameters.openWindows.rawValue)
                    car.OpenWindows(Count: readLine()!)
                } else if Cout == "2" {
                    print(Parameters.engineRunning.rawValue)
                    car.EngineRunning(Count: readLine()!)
                } else if Cout == "3" {
                    while koint {
                    print(Parameters.luggageStatus.rawValue)
                    car.LuggageStatus(Count: readLine()!)
                    koint = false
                    }
                    koint = true
                } else if Cout == "4" {
                    print(Parameters.availabilityCargo.rawValue)
                    car.AvailabilityCargo(Count: readLine()!)
                } else { koint = false }
            }
        } else { koint = false }
    }
    car.printDescription()
    return car.description
}
//// Созданем новые автомобил на парковке
func NewCarBD()
{
    var koint = true
    while koint {
        print("Для создания нового легкового автомобиля 1 , для создания нового грузового автомобиля 2, для внесения данных в базу любую другую цыфру")
        let cout = readLine()
        if cout == "1" {
            array.append(NewLightCar())
        } else if cout == "2" {
            array.append(NewTruckCar())
        } else {
            koint = false
            print("Ваша база: ")
            for i in 0..<array.count { print(array[i]) }   //6. Вывести значения свойств экземпляров в консоль.
        }
    }
}

NewCarBD()

//5. Создать несколько объектов каждого класса. Применить к ним различные действия.

print("Введите 1 для бонуса , для финала любую другую цыфру")
let cout = readLine()
if cout == "1" {
    print("Сначало создадим грузовой автомобиль")
    var instance = Truck(brand: NewCar(parameter: Parameters.brand), mark: NewCar(parameter: Parameters.mark), yearIssue: Int(NewCar(parameter: Parameters.yearIssue))!, luggageCapacity: Double(NewCar(parameter: Parameters.luggageCapacity))!, loadСapacity: Double(NewCar(parameter: Parameters.loadСapacity))!, cargo: NewCar(parameter: Parameters.cargo))
    var koint = true
    while koint {
        print("Для указания дополнительных параметров нажмите 1, для продолжения любую другую цыфру")
        let Cout = readLine()
        if Cout == "1" {
            while koint {
                print("Для изменеия статуса окон 1, для изменения статуса двигателя 2, для изменения статуса багажника 3, для изменения статуса груза 4, для продолжения нажмите любую другую цыфру")
                let Cout = readLine()
                if Cout == "1" {
                    print(Parameters.openWindows.rawValue)
                    instance.OpenWindows(Count: readLine()!)
                } else if Cout == "2" {
                    print(Parameters.engineRunning.rawValue)
                    instance.EngineRunning(Count: readLine()!)
                } else if Cout == "3" {
                    while koint {
                        print(Parameters.luggageStatus.rawValue)
                        instance.LuggageStatus(Count: readLine()!)
                        koint = false
                    }
                    koint = true
                } else if Cout == "4" {
                    print(Parameters.availabilityCargo.rawValue)
                    instance.AvailabilityCargo(Count: readLine()!)
                } else { koint = false }
            }
        } else { koint = false }
    }
    instance.printDescription()
    
    print("Потом создадим легковой автомобиль")
    var copy = LightCar(brand: NewCar(parameter: Parameters.brand), mark: NewCar(parameter: Parameters.mark), yearIssue: Int(NewCar(parameter: Parameters.yearIssue))!, luggageCapacity: Double(NewCar(parameter: Parameters.luggageCapacity))!, power: Double(NewCar(parameter: Parameters.power))!, numberOfDoors: Int(NewCar(parameter: Parameters.numberOfDoors))!)
    koint = true
    while koint {
        print("Для указания дополнительных параметров нажмите 1, для продолжения любую другую цыфру")
        let Cout = readLine()
        if Cout == "1" {
            while koint {
                print("Для изменеия статуса окон 1, для изменения статуса двигателя 2, для изменения статуса багажника 3, для изменения статуса дверей 4, для продолжения нажмите любую другую цыфру")
                let Cout = readLine()
                if Cout == "1" {
                    print(Parameters.openWindows.rawValue)
                    copy.OpenWindows(Count: readLine()!)
                } else if Cout == "2" {
                    print(Parameters.engineRunning.rawValue)
                    copy.EngineRunning(Count: readLine()!)
                } else if Cout == "3" {
                    while koint {
                        print(Parameters.luggageStatus.rawValue)
                        copy.LuggageStatus(Count: readLine()!)
                        koint = false
                    }
                    koint = true
                } else if Cout == "4" {
                    print(Parameters.statusDoors.rawValue)
                    copy.StatusDoors(Count: readLine()!)
                } else { koint = false }
            }
        } else { koint = false }
    }
    copy.printDescription()
    
    print("Созданы 2 автомобиля, давайте изменим некоторые параметры 2 автомобиля?")
    koint = true
    while koint {
        print("Для изменеия статуса окон 1, для изменения статуса двигателя 2, для изменения статуса багажника 3, для продолжения нажмите любую другую цыфру")
        let Cout = readLine()
        if Cout == "1" {
            print(Parameters.openWindows.rawValue)
            copy.OpenWindows(Count: readLine()!)
        } else if Cout == "2" {
            print(Parameters.engineRunning.rawValue)
            copy.EngineRunning(Count: readLine()!)
        } else if Cout == "3" {
            while koint {
                print(Parameters.luggageStatus.rawValue)
                copy.LuggageStatus(Count: readLine()!)
                koint = false
            }
            koint = true
        } else { koint = false }
    }
    
    if instance.openWindows != copy.openWindows { print("У копии изменились параметр openWindows") }
    if instance.engineRunning != copy.engineRunning { print("У копии изменились параметр engineRunning") }
    if instance.luggageStatus != copy.luggageStatus { print("У копии изменились параметр luggageStatus") }
    
    //6. Вывести сами объекты в консоль.
    instance.printDescription()
    copy.printDescription()
}


