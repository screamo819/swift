//
//  CustomTableViewCell.swift
//  Tasks
//
//  Created by AnnaEvgen on 14.02.2022.
//

import UIKit
import Cosmos

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var imageOfMovies: UIImageView! {
        didSet {
            //        cell.imageOfMovies.image = UIImage(data: movie.imageData!)
                    imageOfMovies.layer.cornerRadius = imageOfMovies.frame.size.height / 2
                    imageOfMovies.clipsToBounds = true
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView! {
        didSet {
            cosmosView.settings.updateOnTouch = false // отключаем возможность изменения рейтинга на главном экране
        }
    }
    

//    @IBOutlet weak var cosmosView: CosmosView!
    
   
}
