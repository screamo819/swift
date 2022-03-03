//
//  MovieModel.swift
//  Tasks
//
//  Created by AnnaEvgen on 14.02.2022.
//

import RealmSwift

class Movie: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var genre: String?
    @objc dynamic var year: String?
    @objc dynamic var imageData: Data?
    @objc dynamic var date = Date() // свойство для сортировки по дате добавления
    @objc dynamic var rating = 0
    
    convenience init (name: String,
                      genre: String?,
                      year: String?,
                      rating: Int,
                      imageData: Data?) {
        self.init()
        self.name = name
        self.genre = genre
        self.year = year
        self.rating = rating
        self.imageData = imageData
    }
}
