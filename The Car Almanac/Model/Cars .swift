//
//  Cars .swift
//  The Car Almanac
//
//  Created by user246073 on 9/26/24.
//

import Foundation

struct Car: Decodable {
    let name: String?
    let milesPerGallon: Int?
    let cylinders: Double?
    let displacement: Double?
    let horsepower: Double?
    let weightInLbs: Int?
    let acceleration: Double?
    let year: String?
    let origin: String?

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case milesPerGallon = "Miles_per_Gallon"
        case cylinders = "Cylinders"
        case displacement = "Displacement"
        case horsepower = "Horsepower"
        case weightInLbs = "Weight_in_lbs"
        case acceleration = "Acceleration"
        case year = "Year"
        case origin = "Origin"
    }
}
