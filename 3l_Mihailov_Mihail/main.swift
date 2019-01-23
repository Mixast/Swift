
import Foundation

enum Parameters: String {       // enum для заполнения
    case brand = "Введите марку автомобиля: "
    case mark = "Введите модель автомобиля: "
    case yearIssue = "Введите год производства автомобиля: "
    case luggageCapacity = "Введите объем багажника: "
    case luggageStatus = "Введите на сколько % заполнен объем багажника: "
    case engineRunning = "Запущен ли двигатель? "
    case openWindows = "Открыты окна? "
}

func NewCar(parameter: Parameters) -> String {      // функция для ввода данных
    var key = String()
    switch  parameter {
    case Parameters.brand : print(Parameters.brand.rawValue); key = readLine()!
    case Parameters.mark : print(Parameters.mark.rawValue); key = readLine()!
    case Parameters.yearIssue : print(Parameters.yearIssue.rawValue); key = readLine()!
    if (Int(key)) != nil {}
    else { key = "0"
        print("Ошибка вы ввели не число!!!")
        }
    case Parameters.luggageCapacity : print(Parameters.luggageCapacity.rawValue); key = readLine()!
    if (Double(key)) != nil {}
    else { key = "0.0"
        print("Ошибка вы ввели не число!!!")
        }
    case Parameters.luggageStatus : print(Parameters.luggageStatus.rawValue); key = readLine()!
    if (Double(key)) != nil {}
    else { key = "0.0"
        print("Ошибка вы ввели не число!!!")
        }
    default: break
    }
    
    return key
}

//1. Описать несколько структур – любой легковой автомобиль и любой грузовик.

//2. Структуры должны содержать марку авто (brand), год выпуска (yearIssue), объем багажника/кузова (luggageCapacity), запущен ли двигатель (engineRunning), открыты ли окна (openWindows), заполненный объем багажника (luggageStatus).

struct LightCar {          // структара для легковоло автомобиля
    let brand: String, mark: String ,yearIssue: Int, luggageCapacity: Double
    var luggageStatus: Double
    var engineRunning: Bool
    var openWindows: Bool
    var statusOpenWindows: String {
        if self.openWindows == true {
            return "Окна открыты"}
        else { return "Окна закрыты"}
    }
    var statusLuggageStatus: String {
        if luggageStatus > 0 && luggageStatus <= 100 {
            return "Багажник заполнен на \(luggageStatus) %"
        } else { return "Багажник пустой"}
    }
    var statusEngineRunning: String {
        if self.engineRunning == true {
            return "Двигатель запущен"}
        else { return "Двигатель не запущен"}
    }
    
    var fullPrice : Any {
        return "Бренд: \(brand), Марка: \(mark), Год производства: \(yearIssue), Объем багажника: \(luggageCapacity), Статус багажника: \(statusLuggageStatus), Статус окон: \(statusOpenWindows), , Статус зажигания: \(statusEngineRunning)"
    }
    init(brand: String, mark: String ,yearIssue: Int, luggageCapacity: Double) {
        print("Вы записали данные о новом легковом автомобиле \n")
        //4. Добавить в структуры метод с одним аргументом типа перечисления, который будет менять свойства структуры в зависимости от действия.
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

struct Truck {          // структара для грузового автомобиля
    let brand: String, mark: String ,yearIssue: Int, luggageCapacity: Double
    var luggageStatus: Double
    var engineRunning: Bool
    var openWindows: Bool
    var statusOpenWindows: String {
        if self.openWindows == true {
            return "Окна открыты"}
        else { return "Окна закрыты"}
    }
    var statusLuggageStatus: String {
        if luggageStatus > 0 && luggageStatus <= 100 {
            return "Багажник заполнен на \(luggageStatus) %"
        } else { return "Багажник пустой"}
    }
    var statusEngineRunning: String {
        if self.engineRunning == true {
            return "Двигатель запущен"}
        else { return "Двигатель не запущен"}
    }
    
    var fullPrice : Any {
        return "Бренд: \(brand), Марка: \(mark), Год производства: \(yearIssue), Объем багажника: \(luggageCapacity), Статус багажника: \(statusLuggageStatus), Статус окон: \(statusOpenWindows), , Статус зажигания: \(statusEngineRunning)"
    }
    init(brand: String, mark: String ,yearIssue: Int, luggageCapacity: Double) {
        print("Вы записали данные о новом легковом автомобиле \n")
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

// Создаем массив и добавляем в него новые машины
var array = [Any]()

func NewLightCar() -> Any { // Функция добавляет новый автомобиль
    var car = LightCar(brand: NewCar(parameter: Parameters.brand), mark: NewCar(parameter: Parameters.mark), yearIssue: Int(NewCar(parameter: Parameters.yearIssue))!, luggageCapacity: Double(NewCar(parameter: Parameters.luggageCapacity))!)
    var koint = true
    while koint {
        print("Для указания дополнительных параметров нажмите и изменения 1, для продолжения любую другую цыфру")
        let Cout = readLine()
        if Cout == "1" {
            koint = true
            while koint {
                print("Для изменеия статуса окон 1, для изменения статуса двигателя 2, для изменения статуса багажника 3, для продолжения нажмите любую другую цыфру")
                var Cout = readLine()
                if Cout == "1" {
                    print("Для открытия окон 1, для закрытия 2")
                    Cout = readLine()
                    if Cout == "1" { print("Окна открыты"); car.openWindows = true}
                    else if Cout == "2" { print("Окна закрыты"); car.openWindows = false}
                } else if Cout == "2" {
                    print("Для запуска двигателя 1, для остановки двигателя 2")
                    Cout = readLine()
                    if Cout == "1" { print("Двигатель запущен"); car.engineRunning = true}
                    else if Cout == "2" { print("Двигатель остановлен"); car.engineRunning = false}
                } else if Cout == "3" {
                    while koint {
                        print("Укажите насколько % загружен багажник (только цыфрами c 1 до 100) ")
                        car.luggageStatus = Double(NewCar(parameter: Parameters.luggageStatus))!
                        if car.luggageStatus > 0 && car.luggageStatus <= 100 {
                            koint = false
                        }
                    }
                    koint = true
                } else { koint = false }
            }
        } else { koint = false }
    }
    return ("Легковой автомобиль ", car.fullPrice)
}

func NewTruckCar() -> Any { // Функция добавляет новый автомобиль
    var car = Truck(brand: NewCar(parameter: Parameters.brand), mark: NewCar(parameter: Parameters.mark), yearIssue: Int(NewCar(parameter: Parameters.yearIssue))!, luggageCapacity: Double(NewCar(parameter: Parameters.luggageCapacity))!)
    var koint = true
    //3. Описать перечисление с возможными действиями с автомобилем: запустить/заглушить двигатель, открыть/закрыть окна, погрузить/выгрузить из кузова/багажника груз определенного объема.
    while koint {
        print("Для указания дополнительных параметров нажмите и изменения 1, для продолжения любую другую цыфру")
        let cout = readLine()
        if cout == "1" {
            koint = true
            while koint {
                print("Для изменеия статуса окон 1, для изменения статуса двигателя 2, для изменения статуса багажника 3, для продолжения нажмите любую другую цыфру")
                var cout = readLine()
                if cout == "1" {
                    print("Для открытия окон 1, для закрытия 2")
                    cout = readLine()
                    if cout == "1" { print("Окна открыты"); car.openWindows = true}
                    else if cout == "2" { print("Окна закрыты"); car.openWindows = false}
                } else if cout == "2" {
                    print("Для запуска двигателя 1, для остановки двигателя 2")
                    cout = readLine()
                    if cout == "1" { print("Двигатель запущен"); car.engineRunning = true}
                    else if cout == "2" { print("Двигатель остановлен"); car.engineRunning = false}
                } else if cout == "3" {
                    while koint {
                        print("Укажите насколько % загружен багажник (только цыфрами c 1 до 100) ")
                        car.luggageStatus = Double(NewCar(parameter: Parameters.luggageStatus))!
                        if car.luggageStatus > 0 && car.luggageStatus <= 100 {
                            koint = false
                        }
                    }
                    koint = true
                } else { koint = false }
            }
        } else { koint = false }
    }
    return ("Грузовой автомобиль ", car.fullPrice)
}

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


//5. Инициализировать несколько экземпляров структур. Применить к ним различные действия.
print("Введите 1 для бонуса , для финала любую другую цыфру")
let cout = readLine()
if cout == "1" {
    var instance = Truck(brand: NewCar(parameter: Parameters.brand), mark: NewCar(parameter: Parameters.mark), yearIssue: Int(NewCar(parameter: Parameters.yearIssue))!, luggageCapacity: Double(NewCar(parameter: Parameters.luggageCapacity))!)
    var koint = true
    while koint {
        print("Для указания дополнительных параметров нажмите и изменения 1, для продолжения любую другую цыфру")
        let cout = readLine()
        if cout == "1" {
            koint = true
            while koint {
                print("Для изменеия статуса окон 1, для изменения статуса двигателя 2, для изменения статуса багажника 3, для продолжения нажмите любую другую цыфру")
                var cout = readLine()
                if cout == "1" {
                    print("Для открытия окон 1, для закрытия 2")
                    cout = readLine()
                    if cout == "1" { print("Окна открыты"); instance.openWindows = true}
                    else if cout == "2" { print("Окна закрыты"); instance.openWindows = false}
                } else if cout == "2" {
                    print("Для запуска двигателя 1, для остановки двигателя 2")
                    cout = readLine()
                    if cout == "1" { print("Двигатель запущен"); instance.engineRunning = true}
                    else if cout == "2" { print("Двигатель остановлен"); instance.engineRunning = false}
                } else if cout == "3" {
                    while koint {
                        print("Укажите насколько % загружен багажник (только цыфрами c 1 до 100) ")
                        instance.luggageStatus = Double(NewCar(parameter: Parameters.luggageStatus))!
                        if instance.luggageStatus > 0 && instance.luggageStatus <= 100 {
                            koint = false
                        }
                    }
                    koint = true
                } else { koint = false }
            }
        } else { koint = false }
    }
    
    var copy = instance
    print("Создана копия предыдущего автомобиля, давайте изменим некоторые её пораметры?")
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
    print("Старая машина \(instance.fullPrice) \n Новая машина \(copy.fullPrice)")
}





