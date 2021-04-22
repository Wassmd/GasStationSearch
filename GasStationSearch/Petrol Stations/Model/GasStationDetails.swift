import Foundation

struct GasStationDetails: Codable {
    var name: String
    var openingHoursToday: [OpeningHours]?
    var location: Location
    var pricesPerLiter: [Prices]
}

struct OpeningHours: Codable {
     let opensInMinutesOfDay: Int
     let closesInMinutesOfDay: Int
}

struct Location: Codable {
     let coordinate: Coordinate
     let address: Address
}

struct Address: Codable {
    let street: String?
    let houseNumber: String?
    let postalCode: String?
    let city: String?
}

internal struct Prices: Codable {
    let pricePerLiter: Double
    let petrolType: GasType
}

enum GasType: String, Codable {
    case superE5 = "SuperE5"
    case superE10 = "SuperE10"
    case diesel = "Diesel"
}
