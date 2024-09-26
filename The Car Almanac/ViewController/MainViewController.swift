//
//  MainViewController.swift
//  The Car Almanac
//
//  Created by user246073 on 9/26/24.
//

import UIKit

final class MainViewController: UITableViewController, UISearchResultsUpdating {
    
    //MARK: - IBOutlet
    private var cars: [Car] = []
    private var filteredCars: [Car] = []
    private let networkManager = NetworkManager.shared
    private let linkCars: URL = URL(string: "https://raw.githubusercontent.com/vega/vega/main/docs/data/cars.json")!
    
    private var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "showDetal")
        fetchCars()
        searchCar()
        configureSearchBar()
    }

    //MARK: - UISearchBar
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased(), !searchText.isEmpty else {
            filteredCars = cars
            tableView.reloadData()
            return
        }
        
        filteredCars = cars.filter { car in
            return car.name?.lowercased().contains(searchText) ?? false
        }
        
        tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailSegue", sender: self)
    }
}
    //MARK: UICollectionViewDataSource
extension MainViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredCars.count : cars.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showDetal", for: indexPath)
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
    
    //MARK: - Networking
    private func fetchCars() {
        networkManager.fetch([Car].self, from: linkCars) { [weak self] result in
            switch result {
            case .success(let fetchedCars):
                self?.cars.append(contentsOf: fetchedCars)
                print(fetchedCars)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Error fetching cars: \(error)")
            }
        }
    }
    
    private func searchCar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cars"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func configureSearchBar() {
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.searchTextField.textColor = .black
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.tintColor = .black
    }
}
