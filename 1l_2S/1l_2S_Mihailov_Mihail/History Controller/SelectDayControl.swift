import UIKit

enum Day: Int, CaseIterable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    var title: String {
        switch self {
        case .monday: return "ПН"
        case .tuesday: return "ВТ"
        case .wednesday: return "СР"
        case .thursday: return "ЧТ"
        case .friday: return "ПТ"
        case .saturday: return "СБ"
        case .sunday: return "ВС"
        }
    }
}

class SelectDayControl: UIControl {
    
    
    var selectedDay: Day? {
        didSet {
            updateSelectedDay()
        }
    }

    
    
    var buttons: [UIButton] = []
    private var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
        
        
        // По умолчанию ставим текущую дату
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        if let weekday = getDayOfWeek(result) {
            var count = 0
            if weekday == Day.monday.title {
                count = 0
            } else if weekday == Day.tuesday.title {
                count = 1
            } else if weekday == Day.wednesday.title {
                count = 2
            } else if weekday == Day.thursday.title {
                count = 3
            } else if weekday == Day.friday.title {
                count = 4
            } else if weekday == Day.saturday.title {
                count = 5
            } else if weekday == Day.sunday.title {
                count = 6
            } else {
                return
            }
            
            guard let index = buttons.index(of: buttons[count]),
                let day = Day(rawValue: index)
                else {
                    return
            }
            self.selectedDay = day
            self.buttons[count].isSelected = day == self.selectedDay
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .clear
        stackView.frame = bounds
    }
    
    private func setupView() {
        for day in Day.allCases {
            let button = UIButton(type: .system)
            button.setTitle(day.title, for: .normal)
            button.setTitleColor(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.addTarget(self, action: #selector(selectDay(_:)), for: .touchUpInside)
            buttons.append(button)
        }
        stackView = UIStackView(arrangedSubviews: self.buttons)
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        addSubview(stackView)
    }
    
    private func updateSelectedDay() {
        for (index, button) in buttons.enumerated() {
            guard let day = Day(rawValue: index) else {
                continue
            }
            button.isSelected = day == self.selectedDay
        }
    }

    @objc func selectDay(_ sender: UIButton) {
        guard let index = buttons.index(of: sender),
              let day = Day(rawValue: index)
        else {
            return
        }
        self.selectedDay = day
    }
    
    
}
