//
//  NewMovieViewController.swift
//  Tasks
//
//  Created by AnnaEvgen on 14.02.2022.
//

import UIKit
import RealmSwift


class NewMovieViewController: UITableViewController {
    
    var currentMovie: Movie!
    var imageIsChanged = false
    var currentRating = 0.0
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var movieName: UITextField!
    @IBOutlet weak var movieGenre: UITextField!
    @IBOutlet weak var movieYear: UITextField!
 
    @IBOutlet weak var ratingControl: RatingControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        DispatchQueue.main.async {
//            self.newMovie.saveMovies()
//        } // запись в базу проходит в фоновом потоке, а чтение БД не блокирует основной поток

        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        saveButton.isEnabled = false // по умолчанию кнопка сейв отключена
        movieName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        // если поле заполнено то кнопка сейв будет доступна
        // при редактировании поля будет срабатывать метод
        setupEditScreen()
    }
    
   //MARK: table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let cameraIcon = UIImage(named: "camera") //добавить картинку по названию
            
            let photoIcon = UIImage (named: "photo")
            
            let actionSheet = UIAlertController(title: nil,
                                                 message: nil,
                                                 preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Camera", style: .default) {_ in
                self.choseImagePicker(source: .camera)
            }
            
            camera.setValue(cameraIcon, forKey: "image") // использовать добавленную картинку 
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photo = UIAlertAction(title: "Photo", style: .default) {_ in
                self.choseImagePicker(source: .photoLibrary )
            }
            
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
            
         //скрытие клавиатуры по нажатию вне клавиатуры
        } else {
            view.endEditing(true)
        }
    }
    
    func saveMovie() { //сохранение введеных данных в модель
        
        var image: UIImage?
    
        if imageIsChanged {
            image = movieImage.image
        } else {
            image = UIImage(named: "PhotoDefault")
        }
        
        let imageData = image?.pngData() //конвертировать типа данных UIImage в Data дл использования в БД реалм
        let newMovie = Movie(name: movieName.text!, // объект для редактирования новой записи
                             genre: movieGenre.text,
                             year: movieYear.text,
                             rating: ratingControl.rating,
                             imageData: imageData)
        
        if currentMovie != nil { // объект для редактирования текущей записи
            try! realm1.write { //обращение к объекту реалм
                currentMovie?.name = newMovie.name
                currentMovie?.genre = newMovie.genre
                currentMovie?.year = newMovie.year
                currentMovie?.imageData = newMovie.imageData
                currentMovie?.rating = newMovie.rating
            }
        } else {
                StorageManager.saveObject(newMovie) //сохранить наш объект в базе данных
            }
        }
    
    private func setupEditScreen() {
        if currentMovie != nil {
            
            setupNavigationBar()
            imageIsChanged = true // изображение не будет меняться на фоновое если редактируется запись
            
            guard let data = currentMovie?.imageData, let image = UIImage(data: data) else {return}

            movieImage.image = image
            movieImage.contentMode = .scaleAspectFill
            movieName.text = currentMovie?.name
            movieGenre.text = currentMovie?.genre
            movieYear.text = currentMovie?.year
            ratingControl.rating = currentMovie.rating
        }
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil) //убрать название кнопки назад
        }
        navigationItem.leftBarButtonItem = nil
        title = currentMovie?.name
        saveButton.isEnabled = true
    }
     
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

// MARK: text field delegate

extension NewMovieViewController: UITextFieldDelegate, UINavigationControllerDelegate {
    
    // скрываем клавиатуру по нажатию на кнопку done
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged() {
        if movieName.text?.isEmpty == false { //если поле не пустое то кнопка доступна
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}

//MARK: Work With Image
extension NewMovieViewController: UIImagePickerControllerDelegate {
    func choseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true // разрешается редактировать выбранное изображение
            imagePicker.sourceType = source
            present(imagePicker, animated: true) // imagePicker - это viewController
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        movieImage.image = info[.editedImage] as? UIImage // присваиваем отредактированному значению свойство
        movieImage.contentMode = .scaleAspectFill
        movieImage.clipsToBounds = true
        
        imageIsChanged = true
        dismiss(animated: true)
    }
}
