//
//  CountryListTableViewController.swift
//  WorldAirQualityAPI
//
//  Created by William Bateman on 8/5/21.
//

import UIKit

class CountryListTableViewController: UITableViewController {

// MARK: Properties
    var countries: [String] = []
    

// MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCountries()
    }
    
// MARK: Helper Methods
    func fetchCountries() {
        AirQualityController.fetchCountries { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let countries):
                    self.countries = countries
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }

// MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)

        let country = countries[indexPath.row]
        
        cell.textLabel?.text = country
        
        return cell
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStatesVC" {
            //IIDOO
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? StateListTableViewController else { return }
            
            let selectedCountry = countries[indexPath.row]
            destination.country = selectedCountry
        }
    }
    

} // End of Class

