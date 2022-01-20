import SnapKit
import UIKit

//анимация нажатия кнопки

extension UIButton {
    
    func startAnimatingPressActions() {
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }
    
    @objc private func animateDown(sender: UIButton) {
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.90, y: 0.90))
    }
    
    @objc private func animateUp(sender: UIButton) {
        animate(sender, transform: .identity)
    }
    
    private func animate(_ button: UIButton, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut],
                       animations: {
                        button.transform = transform
            }, completion: nil)
    }
}

//создание главного экрана

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        UIApplication.shared.windows.first?.rootViewController = FirstViewController()

        window?.makeKeyAndVisible()

        return true
    }
}


final class FirstViewController: UIViewController {
    let label2 = UILabel()
    var firstNumber = 0
    var secondNumber = 0
    var result = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .darkGray
    
//верхняя панель № 1 с текстом
        
        let label = UILabel()
        label.backgroundColor = .orange
        label.numberOfLines = 0
        label.text = "Калькулятор"
        label.textColor = .systemBlue
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        label.textAlignment = .center
        
//расположение панель № 1 с текстом на экране
        
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

//верхняя панель № 2 с текстом результата
        
        label2.backgroundColor = .black
        label2.numberOfLines = 0
        label2.text = "\(firstNumber)"
        label2.textColor = .white
        label2.font = UIFont.boldSystemFont(ofSize: 48)
        label2.layer.cornerRadius = 16
        label2.layer.masksToBounds = true
        label2.textAlignment = .right


// расположение панели № 2 с текстом на экране
        
        view.addSubview(label2)
        label2.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

// кнопки операций и стереть все
        
        let minus = UIButton(type: .system)
        let plus = UIButton(type: .system)
        let mult = UIButton(type: .system)
        let equal = UIButton(type: .system)
        let divide = UIButton(type: .system)
        let clearAll = UIButton(type: .system)
        let clearLast = UIButton(type: .system)
        
        minus.setTitle("-", for: .normal)
        plus.setTitle("+", for: .normal)
        mult.setTitle("x", for: .normal)
        equal.setTitle("=", for: .normal)
        divide.setTitle("/", for: .normal)
        clearAll.setTitle("AC", for: .normal)
        clearLast.setTitle("CE", for: .normal)

// внешний вид кнопок плюс минус деление равно
        
        [equal, plus, minus, mult, divide].enumerated().forEach { index, button in
            button.titleLabel?.font = .systemFont(ofSize: 64)
            button.backgroundColor = .orange
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1
            button.layer.masksToBounds = true
            button.startAnimatingPressActions()
            button.tag = index + 1
            button.layer.cornerRadius = 36
            button.snp.makeConstraints {
                $0.height.equalTo(100)
            }
            button.addTarget(self, action: #selector(operationTap(_:)), for: .touchUpInside)
        }
        
        divide.snp.makeConstraints {
            $0.width.equalTo(90)
             $0.height.equalTo(100)
         }
// действие нажатия кнопок стереть
        
        clearAll.addTarget(self, action: #selector(onTapClearAll), for: .touchUpInside)
        
//        clearLast.addTarget(self, action: #selector(onTapClearLast), for: .touchUpInside)


//внешний вид кнопки стереть
        
        [clearAll, clearLast].forEach {
            $0.titleLabel?.font = .systemFont(ofSize: 64)
            $0.backgroundColor = .orange
            $0.layer.borderColor = UIColor.black.cgColor
            $0.layer.borderWidth = 1
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 36
            $0.startAnimatingPressActions()
            $0.snp.makeConstraints {
                $0.height.equalTo(100)
            }
        }
        
//расположение кнопки стереть и разделить
        
        let stackView0 = UIStackView(arrangedSubviews: [clearAll, clearLast, divide])
        stackView0.axis = .horizontal
            stackView0.distribution = .fill
        
        view.addSubview(stackView0)
        stackView0.snp.makeConstraints {
            $0.top.equalTo(label2.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
// кнопки цифр 123

        let one = UIButton(type: .custom)
        let two = UIButton(type: .custom)
        let three = UIButton(type: .custom)

// внешний вид кнопок
        
        [one, two, three].enumerated().forEach { index, button in
            button.setTitle(String(index + 1), for: .normal)
            button.titleLabel?.textColor = .white
            button.titleLabel?.font = .systemFont(ofSize: 72)
            button.backgroundColor = .gray
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 36
            button.startAnimatingPressActions()
            button.tag = index + 2
            button.layer.masksToBounds = true
            button.snp.makeConstraints {
                $0.height.equalTo(100)
            }
        }

//расположение стека кнопок цифр 123 и минуса на экране
        
        let stackView = UIStackView(arrangedSubviews: [one, two, three, minus])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually

        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(stackView0.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
// кнопки цифр 456
        
        let four = UIButton(type: .custom)
        let five = UIButton(type: .custom)
        let six = UIButton(type: .custom)

// внешний вид кнопок
        
        [four, five, six].enumerated().forEach { index, button in
            button.setTitle(String(index + 4), for: .normal)
            button.titleLabel?.textColor = .white
            button.titleLabel?.font = .systemFont(ofSize: 72)
            button.backgroundColor = .gray
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 36
            button.startAnimatingPressActions()
            button.tag = index + 5
            button.layer.masksToBounds = true
            button.snp.makeConstraints {
                $0.height.equalTo(100)
            }
        }

// расположение стека кнопок цифр 456 и плюса на экране
        
        let stackView2 = UIStackView(arrangedSubviews: [four, five, six, plus])
        stackView2.axis = .horizontal
        stackView2.distribution = .fillEqually

        view.addSubview(stackView2)
        stackView2.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

    
// кнопки 789
    
    let seven = UIButton(type: .custom)
    let eight = UIButton(type: .custom)
    let nine = UIButton(type: .custom)
    
// внешний вид кнопок
            
            [seven, eight, nine].enumerated().forEach { index, button in
                button.setTitle(String(index + 7), for: .normal)
                button.titleLabel?.textColor = .white
                button.titleLabel?.font = .systemFont(ofSize: 72)
                button.backgroundColor = .gray
                button.layer.borderColor = UIColor.black.cgColor
                button.layer.borderWidth = 1
                button.layer.cornerRadius = 36
                button.startAnimatingPressActions()
                button.tag = index + 8
                button.layer.masksToBounds = true
                button.snp.makeConstraints {
                    $0.height.equalTo(100)
                }
            }
    
// расположение стека кнопок цифр 789 и умнож на экране
            
            let stackView3 = UIStackView(arrangedSubviews: [seven, eight, nine, mult])
            stackView3.axis = .horizontal
            stackView3.distribution = .fillEqually

            view.addSubview(stackView3)
            stackView3.snp.makeConstraints {
                $0.top.equalTo(stackView2.snp.bottom)
                $0.leading.trailing.equalToSuperview().inset(16)
            }

// кнопки 0 запятая
        
//        let buttonSize: CGFloat = view.frame.size.width/4
//        let zero = UIButton(frame: CGRect (x: 0, y: view.frame.size.height-buttonSize, width: buttonSize*3, height: buttonSize))
        let zero = UIButton(type: .custom)
        let point = UIButton(type: .custom)
    
        zero.setTitle("0", for: .normal)
        point.setTitle(",", for: .normal)
        
    [zero].forEach {
           $0.titleLabel?.textColor = .white
           $0.titleLabel?.font = .systemFont(ofSize: 72)
           $0.backgroundColor = .gray
           $0.layer.borderColor = UIColor.black.cgColor
           $0.layer.borderWidth = 1
           $0.layer.cornerRadius = 36
           $0.tag = 1
           $0.layer.masksToBounds = true
           $0.startAnimatingPressActions()
           $0.snp.makeConstraints {
               $0.width.equalTo(185)
                $0.height.equalTo(100)
            }
        }

    [point].forEach {
       $0.titleLabel?.textColor = .white
       $0.titleLabel?.font = .systemFont(ofSize: 72)
       $0.backgroundColor = .gray
       $0.layer.borderColor = UIColor.black.cgColor
       $0.layer.borderWidth = 1
       $0.layer.cornerRadius = 36
       $0.layer.masksToBounds = true
       $0.startAnimatingPressActions()
       $0.snp.makeConstraints {
            $0.height.equalTo(100)
        }
    }
        
// расположение стека кнопок цифр 0 , = на экране
    
    let stackView4 = UIStackView(arrangedSubviews: [zero, point, equal])
    stackView4.axis = .horizontal
        stackView4.distribution = .fillProportionally

    view.addSubview(stackView4)
    stackView4.snp.makeConstraints {
        $0.top.equalTo(stackView3.snp.bottom)
        $0.leading.trailing.equalToSuperview().inset(16)
    }
        
// действие нажатия кнопок цифр
    zero.addTarget(self, action: #selector(onTapZero), for: .touchUpInside)
        
    [one, two, three, four, five, six, seven, eight, nine].forEach {
    $0.addTarget(self, action: #selector(onTapNumber(_:)), for: .touchUpInside)
    }
}
    
//действие кнопки ноль
        
        @objc func onTapZero() {
            if label2.text != "0" {
                if let text = label2.text {
                    label2.text = "\(text)\(0)"
            }
        }
    }
    
// перечисление операций для последующего выбора
    
    var currentOperation: Operation?
    enum Operation {
        case plus, minus, mult, divide
    }
    
//действие кнопок операций
    
    @objc func operationTap(_ sender: UIButton) {
        
        let tag = sender.tag
        
        if let text = label2.text, let value = Int(text), firstNumber == 0 {
                    firstNumber = value
                    label2.text = "0"
                }
            
        if tag == 1 {
            if let operation = currentOperation {
                var secondNumber: Int? = nil
            if let text = label2.text, let value = Int(text) {
                secondNumber = value
                }
        
        switch operation {
        case .minus:
    //действие кнопки минуса
            
                    firstNumber = firstNumber - secondNumber!
                    secondNumber = 0
                    label2.text = "\(firstNumber)"
                    currentOperation = nil
                    firstNumber = 0
                    
            break
            
        case .plus:
            
    //действие кнопки плюса
            
                    firstNumber = firstNumber + secondNumber!
                    secondNumber = 0
                    label2.text = "\(firstNumber)"
                    currentOperation = nil
                    firstNumber = 0
                    
            break
            
        case .mult:
    //действие кнопки умножения
            
                    firstNumber = firstNumber * secondNumber!
                    secondNumber = 0
                    label2.text = "\(firstNumber)"
                    currentOperation = nil
                    firstNumber = 0
                    
            break
            
        case .divide:
    //действие кнопки деления
            
            if secondNumber == 0 {
                label2.textColor = .red
                label2.text = "Ошибка деления на 0"
            }
            else {
                    firstNumber = firstNumber / secondNumber!
                    secondNumber = 0
                    label2.text = "\(firstNumber)"
                    currentOperation = nil
                    firstNumber = 0
                    label2.textColor = .white
                }
            break
            }
        }
    }
        else if tag == 2 {currentOperation = .plus}
        else if tag == 3 {currentOperation = .minus}
        else if tag == 4 {currentOperation = .mult}
        else if tag == 5 {currentOperation = .divide}
}
    
//действие кнопок цифр

        @objc func onTapNumber(_ sender: UIButton) {
            let tag = sender.tag - 1
                    
                    if label2.text == "0" {
                        label2.text = "\(tag)"
                        }
                    else if let text = label2.text {
                        label2.text = "\(text)\(tag)"
                        }
            }
    
//действие кнопок стереть
    
            @objc func onTapClearAll() {
                label2.text = "0"
                currentOperation = nil
                firstNumber = 0
            }

    // кнопка "СЕ" стереть последнее  - не работает !!!
         
//            @objc func onTapClearLast() {
//                if label2.text == "0" {
//                    label2.text = "\(0)"
//                    }
//                else if label2.text != nil {
//                var newNumber = String(firstNumber)
//                    newNumber.removeLast()
//                    firstNumber = Int(newNumber)
//                label2.text = "\(firstNumber)"
//                }
//        }
}

