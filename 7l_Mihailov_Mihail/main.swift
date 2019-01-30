import Foundation

enum Parameters: String {
    case data = "Укажите полученные данные"
    case status = "Укажите статус соединения"
}

enum NetWorkErrors: Error {
    enum DataError: Error {
        case noData
        case dataIsEmpty
    }
    case noConnect
}

//
//2. Придумать класс, методы которого могут завершаться неудачей. Реализовать их с использованием Error.

class JsonTask {
    
    var terminalArray = [String]()
    var status:  String?
    var data: String?
    func Connect() throws {
        guard status != nil else {
            throw NetWorkErrors.noConnect
        }
        return terminalArray.append(status!)
    }
    
    func Data() throws {
        guard data != nil else {
            throw NetWorkErrors.DataError.noData
        }
        guard data != "" else {
            throw NetWorkErrors.DataError.dataIsEmpty
        }
        return  terminalArray.append(data!)
    }
    
    subscript (idx: Int) -> Any? {        //Сабскрипт для доступа по индексу
        guard idx < terminalArray.count else {
            return nil }
        return terminalArray[idx]
    }
}


var asoop = JsonTask()
var koint = true
while koint {
    print("Для указания статуса соединения нажмите 1, для указания полученных данных нажмите 2")
    let Cout = readLine()
    if Cout == "1" {
        print(Parameters.status.rawValue)
        asoop.status = readLine()
    } else if Cout == "2" {
        print(Parameters.data.rawValue)
        asoop.data = readLine()
    } else { koint = false }
}

//1. Придумать класс, методы которого могут создавать непоправимые ошибки. Реализовать их с помощью try/catch.

do {
    try asoop.Connect()
    try asoop.Data()
} catch let error {
    print("Ошибка = \(error)")
}

print("Данные в массиве: \(asoop.terminalArray)")
