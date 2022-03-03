//
//  GenreCell.swift
//  Tasks
//
//  Created by AnnaEvgen on 03.03.2022.
//

import UIKit
import SnapKit

final class GenreCell: UITableViewCell {
    
    private var handler: ((String?) -> Void)?
    private let title = UILabel()
    private let textField = UITextField()
    
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

    private extension GenreCell {
        
        func setup() {
            selectionStyle = .none
            
            title.text = "Жанр фильма"
            
            textField.addTarget(self, action: #selector(onTextChange), for: .editingChanged)
            
            contentView.addSubview(title)
            title.snp.makeConstraints {
                $0.leading.trailing.top.equalToSuperview().inset(8)
            }
            contentView.addSubview(textField)
            textField.snp.makeConstraints {
                $0.top.equalTo(title.snp.bottom).inset(16)
                $0.leading.trailing.bottom.equalToSuperview().inset(16)
            }
        }
        
        @objc
        func onTextChange() {
            handler?(textField.text)
        }
    }
