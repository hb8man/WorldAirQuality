//
//  AirQualityController.swift
//  WorldAirQualityAPI
//
//  Created by William Bateman on 8/5/21.
//

import Foundation

class AirQualityController {
    
    // MARK: String Constants
    static let baseURL = URL(string: "https://api.airvisual.com/")
    static let versionComponent = "v2"
    static let countriesComponent = "countries"
    static let statesComponent = "states"
    static let citiesComponent = "cities"
    static let cityDataComponent = "city"
    
    
    static let countryKey = "country"
    static let stateKey = "state"
    static let cityKey = "city"
    
    static let apiKeyKey = "key"
    static let apiKeyValue = "92cf8da5-9f00-4b9b-916c-be4409c86b2b"
    
    
    
    // http://api.airvisual.com/v2/countries?key={{YOUR_API_KEY}}
    static func fetchCountries(completion: @escaping (Result<[String], NetworkError>) -> Void) {
        
        // Build the URL
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        print("BaseURL: \(baseURL)")
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        print("VersionURL: \(versionURL)")
        let countriesURL = versionURL.appendingPathComponent(countriesComponent)
        print("CountriesURL: \(countriesURL)")
        
        // Add the queryItems to the url into -> FinalURL
        var components = URLComponents(url: countriesURL, resolvingAgainstBaseURL: true)
        print("Components: \(components)")
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        print(apiQuery)
        components?.queryItems = [apiQuery]
        print("Components: \(components)")
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print("FinalURL: \(finalURL)")
        
        // Get that D A T A
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            
            // check for error
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            // check for data
            guard let data = data else { return completion(.failure(.noData)) }
            
            // Attempting to decode URL
            do {
                let topLevelObject = try JSONDecoder().decode(Country.self, from: data)
                let countryDicts = topLevelObject.data
                
                var listOfCountryNames: [String] = []
                
                for country in countryDicts {
                    let countryName = country.countryName
                    listOfCountryNames.append(countryName)
                }
                //If successful, we complete by returning the listOfCountryNames
                return completion(.success(listOfCountryNames))
            
            } catch {
                // Otherwise we complete by throwing an error
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    
    // http://api.airvisual.com/v2/states?country={{COUNTRY_NAME}}&key={{YOUR_API_KEY}}
    static func fetchStates(forCountry: String, completion: @escaping (Result<[String], NetworkError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let statesURL = versionURL.appendingPathComponent(statesComponent)
        
        var components = URLComponents(url: statesURL, resolvingAgainstBaseURL: true)
        let countryQuery = URLQueryItem(name: countryKey, value: forCountry)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        components?.queryItems = [countryQuery, apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("Error decoding data: \(error.localizedDescription) -- \(error)")
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let topLevelObject = try JSONDecoder().decode(State.self, from: data)
                let stateDicts = topLevelObject.data
                
                var listOfStateNames: [String] = []
                
                for state in stateDicts {
                    let stateName = state.stateName
                    listOfStateNames.append(stateName)
                }
                return completion(.success(listOfStateNames))
                
            } catch {
                return completion(.failure(.thrownError(error)))
            }
            
        }.resume()
    }
    
    
    // http://api.airvisual.com/v2/cities?state={{STATE_NAME}}&country={{COUNTRY_NAME}}&key={{YOUR_API_KEY}}
    static func fetchCities(forState: String, inCountry: String, completion: @escaping (Result<[String], NetworkError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let citiesURL = versionURL.appendingPathComponent(citiesComponent)
        
        var components = URLComponents(url: citiesURL, resolvingAgainstBaseURL: true)
        let stateQuery = URLQueryItem(name: stateKey, value: forState)
        let countryQuery = URLQueryItem(name: countryKey, value: inCountry)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        components?.queryItems = [stateQuery, countryQuery, apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let topLevelObject = try JSONDecoder().decode(City.self, from: data)
                let citiesDict = topLevelObject.data
                
                var listOfCityNames: [String] = []
                
                for city in citiesDict {
                    let cityName = city.cityName
                    listOfCityNames.append(cityName)
                }
                
                return completion(.success(listOfCityNames))
                
            } catch {
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    // http://api.airvisual.com/v2/city?city=Los Angeles&state=California&country=USA&key={{YOUR_API_KEY}}
    static func fetchData(forCity: String, inState: String, inCountry: String, completion: @escaping (Result<CityData, NetworkError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let cityDataURL = versionURL.appendingPathComponent(cityDataComponent)
        
        var components = URLComponents(url: cityDataURL, resolvingAgainstBaseURL: true)
        
        let cityQuery = URLQueryItem(name: cityKey, value: forCity)
        let stateQuery = URLQueryItem(name: stateKey, value: inState)
        let countryQuery = URLQueryItem(name: countryKey, value: inCountry)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        components?.queryItems = [cityQuery, stateQuery, countryQuery, apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let cityData = try JSONDecoder().decode(CityData.self, from: data)
                return completion(.success(cityData))
            
            } catch {
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    

} // End of Class

