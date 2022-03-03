//
//  StorageManager.swift
//  Tasks
//
//  Created by AnnaEvgen on 17.02.2022.
//

import RealmSwift

let realm1 = try! Realm() // создается экземляр реалм - точка входа в БД

class StorageManager {
    
    static func saveObject(_ movie: Movie) {
        try! realm1.write {
        realm1.add(movie)
        }
    }
    
    static func deleteObject (_ movie: Movie) { //функция удаления объекта из БД
        try! realm1.write { //запись в БД
            realm1.delete(movie) //добавить запись в бд
        }
    }
}
