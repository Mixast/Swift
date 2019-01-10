import UIKit

//Выполняю первое задание. Решаем квадратное уравнение ax^2+bx+c=0. Где переменные a, b, c  вводятся с клавиатуры.
print("Первое задание")
func First_task()
{
var a : Double?, b : Double?, c : Double?, X_positiv : Double?, X_negativ : Double?, D :Double?
// X_positiv - положительный X, X_negativ - отрицательный X, D - дискриминант
a = 5
b = 3.5
c = 25
D = (pow(b!, 2)) - (4 * a! * c!)

if let d = D {
    print("Дискриминант = ", d)
    }
else {
    print("Error")
    }

if D! > 0 {
    print("Корни вещественные")
    X_positiv = ((-b!) + (sqrt(abs(pow(b!, 2) - 4 * Double(a!) * c!))))/(2 * Double(a!))
    if let X = X_positiv {
        print("X+ = ", X)
        }
    X_negativ = ((-b!) - (sqrt(abs(pow(b!, 2) - 4 * Double(a!) * c!))))/(2 * Double(a!))
    if let X = X_negativ {
        print("X- = ", X)
        }
    }
else if D! < 0 {
    print("Корни не вещественные")
    X_positiv = ((-b!) + (sqrt(abs(pow(b!, 2) - 4 * Double(a!) * c!))))/(2 * Double(a!))
    if let X = X_positiv {
        print("X+ = ", X)
        }
    X_negativ = ((-b!) - (sqrt(abs(pow(b!, 2) - 4 * Double(a!) * c!))))/(2 * Double(a!))
    if let X = X_negativ {
        print("X- = ", X)
        }
    }
else if D! == 0 {
    print("Корени вещественные")
    X_positiv = ((-b!) + (sqrt(abs(pow(b!, 2) - 4 * Double(a!) * c!))))/(2 * Double(a!))
    if let X = X_positiv {
        print("X = ", X)
        }
    }
}
First_task()
//Выполняю второе задание. Даны катеты прямоугольного треугольника (a, b). Найти площадь (S), периметр (P) и гипотенузу (c) треугольника.
print("Второе задание")
func Second_task()
{
    var a : Double?, b : Double?, c : Double?, S : Double?, P : Double?
    a = 4
    b = 6
    c = sqrt(pow(a!, 2) + pow(b!, 2))
    S = 1/2 * a! * b!
    if S == 0
    {
        print("Ошибка площадь равняется 0")
    }
    else if let s = S {
        print("Площадь треугольника = ", s, "см.")
    }
    if c == 0
    {
        print("Ошибка гипотенуза  равняется 0")
    }
    else
    {
        if let C = c {
            print("Гипотенуза треугольника = ", C, "см.")
        }
        let r : Double = (a! * b!)/(a! + b! + c!), R : Double = c!/2    // Вычисление вписанного и описанного радиусов окружности
        P = 2 * r + 4 * R
        if let p = P {
            print("Периметр треугольника = ", p, "см.")
        }
    }
}
Second_task()
//Выполняю третье задание. Пользователь вводит сумму вклада в банк и годовой процент. Найти сумму вклада через 5 лет.
print("Третье задание")
func Third_task()
{
    var Contribution : Double?, Interest : Double?, Time : Int?, K : Int?
    //Contribution - сумма квлада, Interest - годовой процент, Time - количестиво дней от вклада до снятия, K - количество дней в году
    Contribution = 600_000
    Interest = 25
    Time = 1000
    K = 366
    if Contribution! > 1_400_000 || Interest! < 0.01
    {
        print("Сумма вклада превышает 1 400 000 рублей, или процентная ставка ниже 0.01 %")
    }
    else
    {
        let Year = Double(Time!)/Double(K!)
        if Year >= 5
        {
            let Money = Contribution! + ((Contribution! * Interest! * Double(Time!))/(Double(K!) * 100))
            print("Ваша прибыль = ", Money, "рублей")
        }
        else
        {
            let Money = Contribution! + ((Contribution! * 19.1 * Double(Time!))/(Double(K!) * 100))
            print("Вы сняли вклад ранее 5 лет, ваша процентная ставка снижена до 19.1%. Ваша прибыль = ", Money, "рублей")
        }
    }
}
Third_task()
