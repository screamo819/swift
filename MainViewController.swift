//
//  MainTableViewController.swift
//  Tasks
//
//  Created by AnnaEvgen on 14.02.2022.
//

import UIKit
import RealmSwift


class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // private свойства доступные только в этом классе
    private let searchController = UISearchController(searchResultsController: nil) // отображаться результаты поиска будут на том же вью контроллере
   
    private var filtredMovies: Results<Movie>! // отфильтрованная коллекция
    
    private var movies: Results<Movie>! //резалтс это автообновляемый тип контейнера который отображает реальное состояние объекта, это аналог массива/ объект резалтс позволяет работать с объектом в реальном времени
    
    private var ascSorting = true // сортировка по умолчанию по возрастанию
    
    private var searchBarIsEmpty: Bool { // возвращает true  если строка поиска пустая
        guard let text = searchController.searchBar.text else {return false} // если значение опционала не извлекается то прекращается выполнение
        return text.isEmpty
    }
    
    private var isFiltering: Bool { // свойство для отслеживания активации поискового запроса
        return searchController.isActive && !searchBarIsEmpty // когда поисковый запрос активирован и строка поиска не является пустой
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reverseSortButton: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movies = realm1.objects(Movie.self) // в параметр() идет тип данных
        
        // настройка поискового контроллера
        searchController.searchResultsUpdater = self // получателем инф об изменении текста должен быть наш класс
        searchController.obscuresBackgroundDuringPresentation = false // отключая этот параметр позволяет нам взаимодействовать с контроллером чтобы исправлять детали записей
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController // строка поиска интегрирована в навига бар
        
        definesPresentationContext = true // свойство позволяет отпустить строку поиска при переходе на другой экран
        
    }

    // MARK: - Table view data source

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // этот метод настраивает количество строк в каждой из секций в UITableView
         if isFiltering { //  имеет значение true
             return filtredMovies.count // возвращает кол-во элементов отфильтрованного массива
         }
    
        return movies.count 
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // этот метод настраивает непосредственно саму ячейку, которая будет отображаться в UITableView)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

         let movie = isFiltering ? filtredMovies[indexPath.row] : movies[indexPath.row]

//        var movie = Movie()
//
//         if isFiltering{ // если поисковый запрос активирован
//             movie = filtredMovies[indexPath.row] // то присвается значение из отфильтрованного массива
//         } else {
//             movie = movies[indexPath.row]
//         }
         
        cell.nameLabel.text = movie.name
        cell.genreLabel.text = movie.genre
        cell.yearLabel.text = movie.year
        cell.cosmosView.rating = Double(movie.rating)

        if movie.imageData == nil {
            cell.imageOfMovies.image = UIImage(named: "PhotoDefault")
        } else {
            cell.imageOfMovies.image = UIImage(data: movie.imageData!)
        }

        return cell
    }
    
    //MARK: Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // отмена выбора ячейки
        tableView.deselectRow(at: indexPath, animated: true)
        let nc = UINavigationController(rootViewController: NewFilmViewController())
        navigationController?.present(nc, animated: true, completion: nil)
    }
    
     func tableView (_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let movie = movies[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {_,_  in
            StorageManager.deleteObject(movie)
            tableView.deleteRows(at: [indexPath], with: .automatic)}
         
        return [deleteAction]
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {  // метод передачи данных на  detailViewController
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            
            let movie = isFiltering ? filtredMovies[indexPath.row] : movies[indexPath.row]
            
//            let movie: Movie
//            if isFiltering {
//                movie = filtredMovies[indexPath.row]
//            } else {
//                movie = movies[indexPath.row] // по индексу текущей строки
//            }
            
            let newMovieVC = segue.destination as! NewMovieViewController
            newMovieVC.currentMovie = movie // передали объект из одного вью контроллера в другой 
        }
    }

    @IBAction func unwindSegue (_ segue: UIStoryboardSegue) {
        guard let newMovieVC = segue.source as? NewMovieViewController else {return} // вызвать свойство соурс чтобы выполнить возврат, далее приводим к классу
        
        newMovieVC.saveMovie()
        tableView.reloadData() // обновить интерфейс с новыми данными
    }
    
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
      sorting()
    }
    
    @IBAction func reversedSorting(_ sender: Any) {
        ascSorting.toggle() // меняет значение на противоположное
        
        if ascSorting { // выбор изображения кнопки сортировки
            reverseSortButton.image = UIImage (named: "ZA")
        } else {
            reverseSortButton.image = UIImage (named: "AZ")
        }
        sorting()
    }
    
    private func sorting() { // сортировка
        if segmentedControl.selectedSegmentIndex == 0 {
            movies = movies.sorted(byKeyPath: "date", ascending: ascSorting)
        } else {
            movies = movies.sorted(byKeyPath: "name", ascending: ascSorting)
        }
        tableView.reloadData() // обновление таблицы
    }
    
}

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!) // если строка поиска пустая то она не будет nil
    }
    
    private func filterContentForSearchText (_ searchText: String) {
        filtredMovies = movies.filter("name CONTAINS[c] %@ OR year CONTAINS[c] %@", searchText, searchText) // поиск по полю name и year из параметра searchText без учета регистра
        
        tableView.reloadData()
    }
}
