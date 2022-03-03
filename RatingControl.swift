//
//  RatingControl.swift
//  Tasks
//
//  Created by AnnaEvgen on 22.02.2022.
//

import UIKit

@IBDesignable class RatingControl: UIStackView { // @IBDesignable позволит отобразить контент в интерфейс билдере, изменения в коде будут отображать в реальном времени в интерфейс билдере
    
    //MARK: Properties
    var rating = 0 {
        didSet{
            updateButtonSelectionState()
        }
    }
    
    private var ratingButtons = [UIButton]() // массив кнопок рейтинга
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) { // @IBInspectable - для отображения настроек в интерфейс билдере
        didSet { // наблюдатель отслеживает добавление кнопок
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5 { // кол-во кнопок
        didSet {
            setupButtons()
        }
    }
    
    //MARK: Initialization
    
    override init (frame: CGRect) {
        super.init (frame: frame)
        setupButtons()
    }
    required init (coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Button Action
    
    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.firstIndex(of: button) else { return } // метод firstIndex возвращает индекс первого выбранного элемента  из массива ratingButtons
        
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    
    //MARK: Private Methods
    
    private func setupButtons () {
        
        for button in ratingButtons { // убираем созданные старые кнопки прежде чем помещать новые
            removeArrangedSubview(button) // удаляем кнопки из списка сабвью
            button.removeFromSuperview()
        }
        ratingButtons.removeAll() // очищаем массив кнопок
        
        // Load button image
        let bundle = Bundle(for: type(of: self)) // класс определяет местоположение ресурсов которые хранятся в assets проекта
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection) //traitColection проверяет загружен ли правильный вариант изображения
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for _ in 0..<starCount {
        
            // create button
            let button = UIButton()
            //button.backgroundColor = .red
            // set button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
        
            //setup button action
            button.addTarget(self, action: #selector(ratingButtonTapped(button:)), for: .touchUpInside)
            
            //add button in stackview
            addArrangedSubview(button)

            //add new button in rating buttons array
            ratingButtons.append(button)
        }
        updateButtonSelectionState()
    }
    
    private func updateButtonSelectionState() { //
        for (index, button) in ratingButtons.enumerated() { // устанавливается состояние каждой кнопки в соответствии с индексом и рейтингом
            button.isSelected = index < rating // isSelected = true  ->  тогда звезда становится заполненной
        }
    }
    
}
