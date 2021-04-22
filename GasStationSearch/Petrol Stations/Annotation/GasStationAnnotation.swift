import MapKit

class GasStationAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let petrolStation: GasStation
    let isCheap: Bool
   
    init(petrolStation: GasStation, isCheap: Bool = false) {
        self.petrolStation = petrolStation
        self.isCheap = isCheap
        self.coordinate = CLLocationCoordinate2D(latitude: petrolStation.coordinate.latitude, longitude: petrolStation.coordinate.longitude)
        
        super.init()
    }
}
