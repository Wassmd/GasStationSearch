import Foundation
import Combine

protocol GasStationServicable {
    func fetchGasStations() -> AnyPublisher<[GasStation], NetworkError>
    func gasStationDetails() -> AnyPublisher<GasStationDetails, NetworkError>
}

final class GasStationService: GasStationServicable {
    private let jsonDecoder: JSONDecoder
    
    init(jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.jsonDecoder = jsonDecoder
    }
    
    func fetchGasStations() -> AnyPublisher<[GasStation], NetworkError> {
        let data = localData(fileName: "GasStation")
        return Just(data)
            .decode(type: [GasStation].self, decoder: jsonDecoder)
            .print()
            .mapError {_ in .decodingError}
            .eraseToAnyPublisher()
        
    }
    
    func gasStationDetails() -> AnyPublisher<GasStationDetails, NetworkError> {
        let data = localData(fileName: "GasDetails")
        return  Just(data)
            .decode(type: GasStationDetails.self, decoder: jsonDecoder)
            .print()
            .mapError {_ in .decodingError}
            .eraseToAnyPublisher()
    }
    
    func localData(fileName: String) -> Data {
        let path = Bundle(for: GasStationService.self).path(forResource: fileName, ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        
        return data!
    }
}
