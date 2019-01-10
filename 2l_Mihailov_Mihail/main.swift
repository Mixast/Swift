import Foundation

var Array_one : [Int] = []
var Koint = true
func Keyboard_array() {     // Вводим массив с клавиатуры
    while Koint {
        print("Введите массив")
        let InputKey = readLine()
        let Output_Key = InputKey!.components(separatedBy: " ")
        for i in 0 ..< Output_Key.count {
            let Int_Key = (Int(Output_Key[i]))!
            Array_one.append(Int_Key) }
        if Array_one.isEmpty {
            print("Массив пустой, попробуйте еще раз")
        } else {
            print("Ваш массиве: \(Array_one).")
            Koint = false
        }
    }
    Koint = true
}

func Keyboard_input() {     // Проверяем составленный массива в на правильность, изменяем и редактируем если надо
    Keyboard_array()
    func Print_Lb()
    {
    print("Для дополнения массива нажмите 1, для ввода заново 2, для продолжения любую другую цыфру")
    }
    Print_Lb()
    while Koint {
        let Cout = readLine()
        if Cout == "1" {
            Keyboard_array()
            Print_Lb()
        } else if Cout == "2" {
            Array_one.removeAll()
            Keyboard_array()
            Print_Lb()
        } else {
            Koint = false
        }
    }
}

func Parity(Par: Int) {     // 1. Написать функцию, которая определяет, четное число или нет.
        switch Par {
        case _ where Par % 2 == 0:
            Koint = false
            break
        case _ where Par % 2 != 0:
            break
        default:
            print("Ошибка")
        }
}

func Division(Div: Int) {       // 2. Написать функцию, которая определяет, делится ли число без остатка на 3.
        switch Div {
        case _ where Div % 3 == 0:
            Koint = false
            break
        case _ where Div % 3 != 0:
            break
        default:
            print("Ошибка")
        }
}

func Delete () {        // Функция для удаления из массива всех четных чисел и все чисел, которые не делятся на 3.
    var Point : Int = 0
    while Point < Array_one.count {
        Koint = true
        Parity(Par: Int(Array_one[Point]))
        Division(Div: Int(Array_one[Point]))
        if Koint == false {
            Array_one.remove(at: Point)
            Point = Point - 1
        }
        Point = Point + 1
    }
    print("Ваш обработанный массив: \(Array_one)")
}

func Fibonacci(n: Int) { // Функция добавляет числа Фибоначчи
    if (n<3) {
        Array_one.append(1)
    } else {
        var F1 : Int = 1, F2 : Int = 1, Fn : Int = 0
                for _ in 3...n {
                Fn = F1 + F2
                F1 = F2
                F2 = Fn
            }
        Array_one.append(F2)
    }
}

//6. * Заполнить массив из 100 элементов различными простыми числами. Натуральное число, большее единицы, называется простым, если оно делится только на себя и на единицу. Для нахождения всех простых чисел не больше заданного числа n, следуя методу Эратосфена, нужно выполнить следующие шаги:
//
//a. Выписать подряд все целые числа от двух до n (2, 3, 4, ..., n).
//b. Пусть переменная p изначально равна двум — первому простому числу.
//c. Зачеркнуть в списке числа от 2p до n, считая шагами по p (это будут числа, кратные p: 2p, 3p, 4p, ...).
//d. Найти первое не зачёркнутое число в списке, большее, чем p, и присвоить значению переменной p это число.
//e. Повторять шаги c и d, пока возможно.

func Division(Ress: Int) -> Bool { // Функция проверяет делится ли сило на предыдущие числа перед неюц
    if Ress < 2 {
        return false
    }
    for i in 2..<Ress {
        if Ress % i == 0 {
            return false
        }
    }
    return true
}

func NaturalArray () -> [Int] {
    var i = 2
    while Array_one.count < 100 {
        if Division(Ress: i) {
            Array_one.append(i)
        }
        i += 1
    }
    
    return Array_one
}

// 3. Создать возрастающий массив из 100 чисел.
print("Для ввода массива с клавиатуры введите 1.\nДля автоматическоого заполнения массива введите 2.\nДля заполнения массива простыми числами нажмите 3.")
var Cout = readLine()
while Koint {
    if Cout == "1" {
        Keyboard_input()
        Koint = false
    }
        
    else if Cout == "2" {
        Array_one = [Int](1...100)
        print("Ваш массиве: \(Array_one).")
        Koint = false
    }
    else if Cout == "3" {
        print("Ваш массиве: \(NaturalArray()).")
        Koint = false
    }
    else {
        print("Указано неверное значение")
        print("Для ввода массива с клавиатуры введите 1, для автоматическоого заполнения массива введите 2.")
        Cout = readLine()
    }
}

//4. Удалить из этого массива все четные числа и все числа, которые не делятся на 3.
func Reform_array()
{
    print("Для удаления из массива (четных и делящихся на 3 элементов) введите 1, для продолжения любую другую цыфру.")
    Cout = readLine()
    Koint = true
    while Koint {
        if Cout == "1" {
            Delete()
        }
        else {
            print("Ваш массив остался прежний: \(Array_one)")
        }
        Koint = false
    }
}

//5. * Добавляем числа Фибоначчи, до 100 элементов.
print("Для для добавления чисел Фибоначчи введите 1, для продолжения любую другую цыфру.")
Cout = readLine()
Koint = true
while Koint {
    if Cout == "1" {
        if (100 - Array_one.count) == 0 {
            print("Массив полон, число Фибоначчи не добавлено")
        }
        else if (100 - Array_one.count) < 90 {
            Array_one.append(0)
            for i in 1...(100 - Array_one.count) {
                Fibonacci(n: i)
            }
        }
        else {
            Array_one.append(0)
            for i in 1...90 {
                Fibonacci(n: i)
            }
        }
        print("Массив с числами Фибоначчи: \(Array_one)")
    }
    else {
        print("Ваш массив остался прежний: \(Array_one)")
    }
    Koint = false
}
Reform_array()

