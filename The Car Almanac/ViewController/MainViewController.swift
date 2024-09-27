//
//  MainViewController.swift
//  The Car Almanac
//
//  Created by user246073 on 9/26/24.
//

import UIKit

final class MainViewController: UITableViewController {
    
    //MARK: - Properties
    private var cars: [Car] = []
    private var filteredCars: [Car] = []
    private let networkManager = NetworkManager.shared
    private let linkCars: URL = URL(string: "https://raw.githubusercontent.com/vega/vega/main/docs/data/cars.json")!
    private var searchController: UISearchController!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        fetchCars()
        setupSearchController()
        configureSearchBarAppearance()
    }
    
    // MARK: - Setup Methods
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cars"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func configureSearchBarAppearance() {
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.searchTextField.textColor = .black
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.tintColor = .black
    }
    
    //MARK: - Networking
    private func fetchCars() {
        networkManager.fetchCars(from: linkCars) { [weak self] result in
            switch result {
            case .success(let fetchedCars):
                self?.cars.append(contentsOf: fetchedCars)
                print(fetchedCars)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Ошибка при получении автомобилей: \(error)")
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let selectedCar = searchController.isActive ? filteredCars[indexPath.row] : cars[indexPath.row]
            let detailsVC = segue.destination as? DetailsViewController
            detailsVC?.car = selectedCar
        }
    }
}

//MARK: UITableViewDataSource
extension MainViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchController.isActive ? filteredCars.count : cars.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showDetailSegue", for: indexPath)
        let car = searchController.isActive ? filteredCars[indexPath.row] : cars[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = car.name?.capitalized ?? "Unknown Car"
        content.secondaryText = "Country of manufacture: \(car.origin ?? "Unknown")"
        if let carName = car.name {
            content.image = UIImage(named: carName)
        } else {
            content.image = UIImage(named: "defaultImage")
        }
        content.imageProperties.cornerRadius = tableView.rowHeight / 2
        content.imageProperties.maximumSize = CGSize(width: 80, height: 80)
        content.imageToTextPadding = 5
        cell.contentConfiguration = content
        return cell
    }
}
// MARK: - UISearchResultsUpdating
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased(), !searchText.isEmpty else {
            filteredCars = cars
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            return
        }
        
        filteredCars = cars.filter { car in
            return car.name?.lowercased().contains(searchText) ?? false
        }
        
        tableView.reloadData()
    }
}

