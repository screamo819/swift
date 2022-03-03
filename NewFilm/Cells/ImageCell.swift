//
//  ImageCell.swift
//  Tasks
//
//  Created by AnnaEvgen on 26.02.2022.
//

import UIKit
import SnapKit
import RealmSwift

struct ImageCellModel {
    var image: String
}

final class ImageCell: UITableViewCell {
    
    private var movies: Results<Movie>!
    private var image = UIImageView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage (image: ImageCellModel){
        let movie = Movie()
        if movie.imageData == nil {
            self.image.image = UIImage(named: "PhotoDefault")
        } else {
            self.image.image = UIImage(data: movie.imageData!)
        }
    }
    
    func configure() {
       
//         let image = UIImage(named: "PhotoDefault")
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        
    }
}

private extension ImageCell {
    func setup() {
        selectionStyle = .none
        
        contentView.addSubview(image)
    
        image.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
}
