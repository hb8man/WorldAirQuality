//
//  CityDataViewController.swift
//  WorldAirQualityAPI
//
//  Created by William Bateman on 8/5/21.
//

import UIKit

class CityDataViewController: UIViewController {

// MARK: Outlets
    
    @IBOutlet weak var cityStateCountryLabel: UILabel!
    @IBOutlet weak var AQILabel: UILabel!
    @IBOutlet weak var airSpeedLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var latLongLabel: UILabel!
    
    
// MARK: Properties
    var city: String?
    var state: String?
    var country: String?
    
// MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCityData()
    }
    
// MARK: Helper Methods
    func fetchCityData() {
        guard let city = city, let state = state, let country = country else { return }
        AirQualityController.fetchData(forCity: city, inState: state, inCountry: country) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let cityData):
                    self.updateViews(with: cityData)
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")

                }
            }
        }
    }
    
    func updateViews(with cityData: CityData) {
        cityStateCountryLabel.text = "\(cityData.data.city), \(cityData.data.state), \(cityData.data.country)"
        AQILabel.text = "AQI: \(cityData.data.current.pollution.aqius)"
        airSpeedLabel.text = "Windspeed: \(cityData.data.current.weather.ws)"
        temperatureLabel.text = "Temp: \(cityData.data.current.weather.tp)"
        humidityLabel.text = "Humidity: \(cityData.data.current.weather.hu)"
        
        let coordinates = cityData.data.location.coordinates
        if coordinates.count == 2 {
            latLongLabel.text = "Latitude: \(coordinates[1]) \nLong: \(coordinates[0])"
        } else {
            latLongLabel.text = "Unknown Coordinates"
        }
    }
    

} // End of Class

