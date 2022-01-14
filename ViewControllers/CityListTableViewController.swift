//
//  CityListTableViewController.swift
//  WorldAirQualityAPI
//
//  Created by William Bateman on 8/5/21.
//

import UIKit

class CityListTableViewController: UITableViewController {

// MARK: Properties
    var state: String?
    var country: String?
    var cities: [String] = []
    
    
// MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCities()
    }
    
// MARK: Helper Methods
    func fetchCities() {
        guard let state = state, let country = country else { return }
        AirQualityController.fetchCities(forState: state, inCountry: country) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let cities):
                    self.cities = cities
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")

                }
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)

        let city = cities[indexPath.row]
        
        cell.textLabel?.text = city
        
        return cell
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCityDataVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let state = state,
                  let country = country,
                  let destination = segue.destination as? CityDataViewController else { return }
            
            let selectedCity = cities[indexPath.row]
            destination.city = selectedCity
            destination.state = state
            destination.country = country
        }
    }
} // End of Class

