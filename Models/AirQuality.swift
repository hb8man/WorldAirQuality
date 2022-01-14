//
//  AirQuality.swift
//  WorldAirQualityAPI
//
//  Created by William Bateman on 8/5/21.
//

import Foundation

struct Country: Codable {

    let data: [Data]

    struct Data: Codable {
        let countryName: String
        
        enum CodingKeys: String, CodingKey {
            case countryName = "country"
        }
    } // End of Struct

} // End of Struct


struct State: Codable {
    let data: [Data]
    
    struct Data: Codable {
        let stateName: String
        
        enum CodingKeys: String, CodingKey {
            case stateName = "state"
        }
    } // End of Struct
    
} // End of Struct


struct City: Codable {
    let data: [Data]
    
    struct Data: Codable {
        let cityName: String
    
    
        enum CodingKeys: String, CodingKey {
            case cityName = "city"
        }
    } // End of Struct
    
} // End of Struct


struct CityData: Codable {
    let data: Data
    
    struct Data: Codable {
        let city: String
        let state: String
        let country: String
        
        let location: Location
        struct Location: Codable {
            let coordinates: [Double]
        } // End of Struct

        
        let current: Current
        struct Current: Codable {
            let weather: Weather
            struct Weather: Codable {
                let tp: Int
                let hu: Int
                let ws: Double
            }
            
            let pollution: Pollution
            struct Pollution: Codable {
                let aqius: Int
            }
        } // End of Struct

        
    }

} // End of Struct

