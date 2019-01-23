import Foundation
//3. Взять из прошлого урока enum с действиями над автомобилем. Подумать, какие особенные действия имеет trunkCar, а какие – sportCar. Добавить эти действия в перечисление.
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
    print(parameter.rawValue)
    switch  parameter {
    case Parameters.brand : key = readLine()!
    case Parameters.mark : key = readLine()!
    case Parameters.yearIssue : key = readLine()!
    if (Int(key)) != nil {}
    else { key = "0"
        print("Ошибка вы ввели не число!!!")
        }
    case Parameters.luggageCapacity : key = readLine()!
    if (Double(key)) != nil {}
    else { key = "0.0"
        print("Ошибка вы ввели не число!!!")
        }
    case Parameters.luggageStatus : key = readLine()!
    if (Double(key)) != nil {}
    else { key = "0.0"
        print("Ошибка вы ввели не число!!!")
        }
    case Parameters.power : key = readLine()!
    if (Double(key)) != nil {}
    else { key = "0.0"
        print("Ошибка вы ввели не число!!!")
        }
    case Parameters.numberOfDoors : key = readLine()!
    if (Int(key)) != nil {}
    else { key = "0"
        print("Ошибка вы ввели не число!!!")
        }
    case Parameters.loadСapacity : key = readLine()!
    if (Double(key)) != nil {}
    else { key = "0.0"
        print("Ошибка вы ввели не число!!!")
    }
    case Parameters.cargo : key = readLine()!
    default: break
    }
    
    return key
}
//1. Описать класс Car c общими свойствами автомобилей и пустым методом действия по аналогии с прошлым заданием.// Класс Car содержит марку авто (brand), год выпуска (yearIssue), объем багажника/кузова (luggageCapacity), запущен ли двигатель (engineRunning), открыты ли окна (openWindows), заполненный объем багажника (luggageStatus).
class Car {
    static var count: Int = 0
    let brand: String, mark: String ,yearIssue: Int, luggageCapacity: Double
    var luggageStatus: Double
    var engineRunning: Bool
    var openWindows: Bool
    private var statusOpenWindows: String {
        if self.openWindows == true {
            return "Окна открыты"}
        else { return "Окна закрыты"}
    }
    private var statusLuggageStatus: String {
        if luggageStatus > 0 && luggageStatus <= 100 {
            return "Багажник заполнен на \(luggageStatus) %"
        } else { return "Багажник пустой"}
    }
    private var statusEngineRunning: String {
        if self.engineRunning == true {
            return "Двигатель запущен"}
        else { return "Двигатель не запущен"}
    }

    func fullPrice() -> Any {
        return "\(Car.count) Бренд: \(brand), Марка: \(mark), Год производства: \(yearIssue), Объем багажника: \(luggageCapacity), Статус багажника: \(statusLuggageStatus), Статус окон: \(statusOpenWindows), Статус зажигания: \(statusEngineRunning)"
    }
    
    init(brand: String, mark: String ,yearIssue: Int, luggageCapacity: Double) {
        Car.count += 1
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

//2. Описать пару его наследников trunkCar и sportСar. Подумать, какими отличительными свойствами обладают эти автомобили. Описать в каждом наследнике специфичные для него свойства.
//4. В каждом подклассе переопределить метод действия с автомобилем в соответствии с его классом.

class LightCar: Car {       // Клас легкового автомобиля
    var power: Double
    var numberOfDoors: Int
    var statusDoors: Bool
    private var sDoors: String {
        if self.statusDoors == true {
            return "Двери закрыты"}
        else { return "Двери открыты"}
    }
   
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
    
    override func fullPrice() -> Any {
        return (super.fullPrice(), "Мощность двигателя: \(power), Количество дверей: \(numberOfDoors), Статус дверей: \(sDoors)")
    }
}

class Truck: Car {          // Клас грузового автомобиля
    var loadСapacity: Double
    var cargo: String
    var availabilityCargo: Bool
    private var sAvailabilityCargo: String {
        if self.availabilityCargo == true {
            return "Грузовик с грузом"}
        else { return "Грузовик без груза"}
    }
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
    override func fullPrice() -> Any {
        return (super.fullPrice(), "Грузоподъёмность: \(loadСapacity), Наименование груза: \(cargo), Статус груза: \(sAvailabilityCargo)")
    }
}

// Создаем масив и заполняем его данными о автомабилях стоящих на паркорвке

var array = [Any]()

// Ф-ция для добавления нового легкового автомобиля
func NewLightCar() -> Any { // Функция добавляет новый автомобиль
    let car = LightCar(brand: NewCar(parameter: Parameters.brand), mark: NewCar(parameter: Parameters.mark), yearIssue: Int(NewCar(parameter: Parameters.yearIssue))!, luggageCapacity: Double(NewCar(parameter: Parameters.luggageCapacity))!, power: Double(NewCar(parameter: Parameters.power))!, numberOfDoors: Int(NewCar(parameter: Parameters.numberOfDoors))!)
    var koint = true
    while koint {
        print("Для указания дополнительных параметров нажмите 1, для продолжения любую другую цыфру")
        let Cout = readLine()
        if Cout == "1" {
            koint = true
            while koint {
                print("Для изменеия статуса окон 1, для изменения статуса двигателя 2, для изменения статуса багажника 3, для изменения статуса дверей 4, для продолжения нажмите любую другую цыфру")
                var Cout = readLine()
                if Cout == "1" {
                    print(Parameters.openWindows.rawValue)
                    Cout = readLine()
                    if Cout == "1" { print("Окна открыты"); car.openWindows = true}
                    else if Cout == "2" { print("Окна закрыты"); car.openWindows = false}
                } else if Cout == "2" {
                    print(Parameters.engineRunning.rawValue)
                    Cout = readLine()
                    if Cout == "1" { print("Двигатель запущен"); car.engineRunning = true}
                    else if Cout == "2" { print("Двигатель остановлен"); car.engineRunning = false}
                } else if Cout == "3" {
                    while koint {
                        print(Parameters.luggageStatus.rawValue)
                        car.luggageStatus = Double(NewCar(parameter: Parameters.luggageStatus))!
                        if car.luggageStatus > 0 && car.luggageStatus <= 100 {
                            koint = false
                        }
                    }
                    koint = true
                } else if Cout == "4" {
                    print(Parameters.statusDoors.rawValue)
                    Cout = readLine()
                    if Cout == "1" { print("Двери открыты"); car.statusDoors = false}
                    else if Cout == "2" { print("Двери закрыты"); car.statusDoors = true}
                } else { koint = false }
            }
        } else { koint = false }
    }
    print("Легковой автомобиль ", car.fullPrice())
    return ("Легковой автомобиль ", car.fullPrice())
}
// Ф-ция для добавления нового грузового автомобиля
func NewTruckCar() -> Any { // Функция добавляет новый автомобиль
    let car = Truck(brand: NewCar(parameter: Parameters.brand), mark: NewCar(parameter: Parameters.mark), yearIssue: Int(NewCar(parameter: Parameters.yearIssue))!, luggageCapacity: Double(NewCar(parameter: Parameters.luggageCapacity))!, loadСapacity: Double(NewCar(parameter: Parameters.loadСapacity))!, cargo: NewCar(parameter: Parameters.cargo))
    var koint = true
    while koint {
        print("Для указания дополнительных параметров нажмите 1, для продолжения любую другую цыфру")
        let cout = readLine()
        if cout == "1" {
            koint = true
            while koint {
                print("Для изменеия статуса окон 1, для изменения статуса двигателя 2, для изменения статуса багажника 3, для изменения статуса груза 4, для продолжения нажмите любую другую цыфру")
                var Cout = readLine()
                if Cout == "1" {
                    print(Parameters.openWindows.rawValue)
                    Cout = readLine()
                    if Cout == "1" { print("Окна открыты"); car.openWindows = true}
                    else if Cout == "2" { print("Окна закрыты"); car.openWindows = false}
                } else if Cout == "2" {
                    print(Parameters.engineRunning.rawValue)
                    Cout = readLine()
                    if Cout == "1" { print("Двигатель запущен"); car.engineRunning = true}
                    else if Cout == "2" { print("Двигатель остановлен"); car.engineRunning = false}
                } else if Cout == "3" {
                    while koint {
                        print(Parameters.luggageStatus.rawValue)
                        car.luggageStatus = Double(NewCar(parameter: Parameters.luggageStatus))!
                        if car.luggageStatus > 0 && car.luggageStatus <= 100 {
                            koint = false
                        }
                    }
                    koint = true
                } else if Cout == "4" {
                    print(Parameters.availabilityCargo.rawValue)
                    Cout = readLine()
                    if Cout == "1" { print("Есть груз"); car.availabilityCargo = true}
                    else if Cout == "2" { print("Нет груза"); car.availabilityCargo = false}
                } else { koint = false }
            }
        } else { koint = false }
    }
    print("Грузовой автомобиль ", car.fullPrice())
    return ("Грузовой автомобиль ", car.fullPrice())
}
// Созданем новые автомобил на парковке
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
    let instance = Truck(brand: NewCar(parameter: Parameters.brand), mark: NewCar(parameter: Parameters.mark), yearIssue: Int(NewCar(parameter: Parameters.yearIssue))!, luggageCapacity: Double(NewCar(parameter: Parameters.luggageCapacity))!, loadСapacity: Double(NewCar(parameter: Parameters.loadСapacity))!, cargo: NewCar(parameter: Parameters.cargo))
    var koint = true
    while koint {
        print("Для указания дополнительных параметров нажмите 1, для продолжения любую другую цыфру")
        let cout = readLine()
        if cout == "1" {
            koint = true
            while koint {
                print("Для изменеия статуса окон 1, для изменения статуса двигателя 2, для изменения статуса багажника 3, для изменения статуса груза 4, для продолжения нажмите любую другую цыфру")
                var Cout = readLine()
                if Cout == "1" {
                    print(Parameters.openWindows.rawValue)
                    Cout = readLine()
                    if Cout == "1" { print("Окна открыты"); instance.openWindows = true}
                    else if Cout == "2" { print("Окна закрыты"); instance.openWindows = false}
                } else if Cout == "2" {
                    print(Parameters.engineRunning.rawValue)
                    Cout = readLine()
                    if Cout == "1" { print("Двигатель запущен"); instance.engineRunning = true}
                    else if Cout == "2" { print("Двигатель остановлен"); instance.engineRunning = false}
                } else if Cout == "3" {
                    while koint {
                        print(Parameters.luggageStatus.rawValue)
                        instance.luggageStatus = Double(NewCar(parameter: Parameters.luggageStatus))!
                        if instance.luggageStatus > 0 && instance.luggageStatus <= 100 {
                            koint = false
                        }
                    }
                    koint = true
                } else if Cout == "4" {
                    print(Parameters.availabilityCargo.rawValue)
                    Cout = readLine()
                    if Cout == "1" { print("Есть груз"); instance.availabilityCargo = true}
                    else if Cout == "2" { print("Нет груза"); instance.availabilityCargo = false}
                } else { koint = false }
            }
        } else { koint = false }
    }
    print("Грузовой автомобиль ", instance.fullPrice())
    
    print("Потом создадим легковой автомобиль")
    
    let copy = LightCar(brand: NewCar(parameter: Parameters.brand), mark: NewCar(parameter: Parameters.mark), yearIssue: Int(NewCar(parameter: Parameters.yearIssue))!, luggageCapacity: Double(NewCar(parameter: Parameters.luggageCapacity))!, power: Double(NewCar(parameter: Parameters.power))!, numberOfDoors: Int(NewCar(parameter: Parameters.numberOfDoors))!)
    koint = true
    while koint {
        print("Для указания дополнительных параметров нажмите 1, для продолжения любую другую цыфру")
        let Cout = readLine()
        if Cout == "1" {
            koint = true
            while koint {
                print("Для изменеия статуса окон 1, для изменения статуса двигателя 2, для изменения статуса багажника 3, для изменения статуса дверей 4, для продолжения нажмите любую другую цыфру")
                var Cout = readLine()
                if Cout == "1" {
                    print(Parameters.openWindows.rawValue)
                    Cout = readLine()
                    if Cout == "1" { print("Окна открыты"); copy.openWindows = true}
                    else if Cout == "2" { print("Окна закрыты"); copy.openWindows = false}
                } else if Cout == "2" {
                    print(Parameters.engineRunning.rawValue)
                    Cout = readLine()
                    if Cout == "1" { print("Двигатель запущен"); copy.engineRunning = true}
                    else if Cout == "2" { print("Двигатель остановлен"); copy.engineRunning = false}
                } else if Cout == "3" {
                    while koint {
                        print(Parameters.luggageStatus.rawValue)
                        copy.luggageStatus = Double(NewCar(parameter: Parameters.luggageStatus))!
                        if copy.luggageStatus > 0 && copy.luggageStatus <= 100 {
                            koint = false
                        }
                    }
                    koint = true
                } else if Cout == "4" {
                    print(Parameters.statusDoors.rawValue)
                    Cout = readLine()
                    if Cout == "1" { print("Двери открыты"); copy.statusDoors = false}
                    else if Cout == "2" { print("Двери закрыты"); copy.statusDoors = true}
                } else { koint = false }
            }
        } else { koint = false }
    }
    print("Легковой автомобиль ", copy.fullPrice())

    print("Созданы 2 автомобиля, давайте изменим некоторые параметры 2 автомобиля?")
    koint = true
    while koint {
        print("Для изменеия статуса окон 1, для изменения статуса двигателя 2, для изменения статуса багажника 3, для продолжения нажмите любую другую цыфру")
        var cout = readLine()
        if cout == "1" {
            print("Для открытия окон 1, для закрытия 2")
            cout = readLine()
            if cout == "1" { print("Окна открыты"); copy.openWindows = true}
            else if cout == "2" { print("Окна закрыты"); copy.openWindows = false}
        } else if cout == "2" {
            print("Для запуска двигателя 1, для остановки двигателя 2")
            cout = readLine()
            if cout == "1" { print("Двигатель запущен"); copy.engineRunning = true}
            else if cout == "2" { print("Двигатель остановлен"); copy.engineRunning = false}
        } else if cout == "3" {
            while koint {
                print("Укажите насколько % загружен багажник (только цыфрами c 1 до 100) ")
                copy.luggageStatus = Double(NewCar(parameter: Parameters.luggageStatus))!
                if copy.luggageStatus > 0 && copy.luggageStatus <= 100 {
                    koint = false
                }
            }
            koint = true
        } else { koint = false }
    }
    
    if instance.openWindows != copy.openWindows { print("У копии изменились параметр openWindows") }
    if instance.engineRunning != copy.engineRunning { print("У копии изменились параметр engineRunning") }
    if instance.luggageStatus != copy.luggageStatus { print("У копии изменились параметр luggageStatus") }
    
    //6. Вывести значения свойств экземпляров в консоль.
    print("Старая машина \(instance.fullPrice()) \n Новая машина \(copy.fullPrice())")
}


