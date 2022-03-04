//
//  NameCell.swift
//  Tasks
//
//  Created by AnnaEvgen on 03.03.2022.
//

import UIKit
import SnapKit

final class NameCell: UITableViewCell {
    
    private var handler: ((String?) -> Void)?
    private let title = UILabel()
    let textField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String, handler: @escaping (String?) -> Void) {
        textField.text = text
        self.handler = handler
    }
}

    private extension NameCell {
        
        func setup() {
            selectionStyle = .none
            
            title.text = "Название фильма"
            title.textAlignment = .center
            title.backgroundColor = .gray
            title.layer.cornerRadius = title.frame.size.width / 2
            title.clipsToBounds = true
            title.font = .boldSystemFont(ofSize: 36)
            
            textField.addTarget(self, action: #selector(onTextChange), for: .editingChanged)
            textField.backgroundColor = .red
            
            contentView.addSubview(title)
            title.snp.makeConstraints {
                $0.leading.trailing.top.equalToSuperview().inset(8)
            }
            contentView.addSubview(textField)
            textField.snp.makeConstraints {
                $0.top.equalTo(title.snp.bottom).offset(8)
                $0.leading.trailing.bottom.equalToSuperview().inset(8)
            }
        }
        
        @objc
        func onTextChange() {
            handler?(textField.text)
        }
    }
