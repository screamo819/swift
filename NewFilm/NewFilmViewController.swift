//
//  NewFilmViewController.swift
//  Tasks
//
//  Created by AnnaEvgen on 26.02.2022.
//

import UIKit
import SnapKit

struct NewFileModel {
    var rating: Int = 0
    var description: String = ""
    var name: String = ""
}

final class NewFilmViewController: UIViewController {
    
    struct Cells {
        static let imageCell = "image_cell"
        static let nameCell = "name_cell"
        static let genreCell = "genre_cell"
        static let yearCell = "year_cell"
        static let ratingCell = "rating_cell"
    }
     
    var currentMovie: Movie!
    var imageIsChanged = false
    
    private var model = NewFileModel()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ImageCell.self, forCellReuseIdentifier: Cells.imageCell)
        tableView.register(NameCell.self, forCellReuseIdentifier: Cells.nameCell)
        tableView.register(GenreCell.self, forCellReuseIdentifier: Cells.genreCell)
        tableView.register(YearCell.self, forCellReuseIdentifier: Cells.yearCell)
        tableView.register(RatingCell.self, forCellReuseIdentifier: Cells.ratingCell)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupView()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "My New Movie"
        navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.leftBarButtonItem = .init(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(onCancelTap)
        )
        navigationItem.rightBarButtonItem = .init(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(onSaveTap)
        )
    }
    
    func setupView() {
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    @objc
    private func onCancelTap() {
        dismiss(animated: true)
    }
    
    @objc
    private func onSaveTap() {
        
//        var image: UIImage?
//
//        if imageIsChanged {
//            image = UIImage(data: movie.imageData!)
//        } else {
//            image = UIImage(named: "PhotoDefault")
//        }
//
//        let imageData = image?.pngData() //конвертировать типа данных UIImage в Data дл использования в БД реалм
//        let newMovie = Movie(name: NameCell.textField.text!, // объект для редактирования новой записи
//                             genre: GenreCell.textField.text,
//                             year: YearCell.textField.text,
//                             rating: RatingCell.textField.text,
//                             imageData: imageData)
//
//        if currentMovie != nil { // объект для редактирования текущей записи
//            try! realm1.write { //обращение к объекту реалм
//                currentMovie?.name = newMovie.name
//                currentMovie?.genre = newMovie.genre
//                currentMovie?.year = newMovie.year
//                currentMovie?.imageData = newMovie.imageData
//                currentMovie?.rating = newMovie.rating
//            }
//        } else {
//                StorageManager.saveObject(newMovie) //сохранить наш объект в базе данных
//            }
//        }
    }
}

extension NewFilmViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.imageCell, for: indexPath) as! ImageCell
            cell.configure()
            cell.setImage(image: ImageCellModel)
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.nameCell, for: indexPath) as! NameCell
            cell.configure(text: "Ввод названия фильма"){ [weak self] name in
                guard let name = name else { return }
                self?.model.name = name
            }
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.genreCell, for: indexPath) as! GenreCell
            cell.configure(text: "Жанр фильма") { [weak self] name in
                guard let name = name else { return }
                self?.model.name = name
            }
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.yearCell, for: indexPath) as! YearCell
            cell.configure(text: "Год выхода фильма") { [weak self] name in
                guard let name = name else { return }
                self?.model.name = name
            }
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.ratingCell, for: indexPath) as! RatingCell
            cell.configure(text: "Рейтинг фильма") 
            return cell
            
        default:
            return .init()
        }
        
    }
}

//extension NewFilmViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        <#code#>
//    }
//}


