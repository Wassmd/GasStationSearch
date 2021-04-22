import Combine
import MapKit

final class GasStationViewModel: ObservableObject {
    
    private let service: GasStationServicable
    
    @Published var coordinateRegion = MKCoordinateRegion(center:
                                                            CLLocationCoordinate2D(latitude: 53.06, longitude: 8.81),
                                                         span: MKCoordinateSpan(latitudeDelta: 0.11, longitudeDelta: 0.11))
    
    @Published private(set) var isLoading = false
    
    var shouldUpdateRegion = true
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var petrolStations = [GasStation]()
    var minimumPetrolPrice = 0.0
    
    @Published var annotationSelected: GasStationAnnotation?
    @Published var stationDetails: GasStationDetails?
    @Published var isStationLoading = false
    
    var shouldUpdateMapView = false
    @Published var showDetails = false
    
    init(service: GasStationServicable = GasStationService()) {
        self.service = service
        setupObserver()
    }
    
    private func setupObserver() {
        $annotationSelected
            .dropFirst()
            .sink { [weak self] annotation in
                guard let annotation = annotation else { return }
                
                self?.showDetails = true
                self?.getPetrolStationDetail(for: annotation.petrolStation.name)
            }
            .store(in: &subscriptions)
    }
    
    func getGasStations() {
        service.fetchGasStations()
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .finished:
                    self.isLoading = false
                case .failure(let error):
                    self.isLoading = false
                    print("Error:\(error)")
                }
            } receiveValue: { [weak self] petrolStations in
                guard let self = self else { return }
                self.shouldUpdateMapView = true
                
                self.petrolStations = petrolStations
            }
            .store(in: &subscriptions)
    }
    
    private func getPetrolStationDetail(for name: String) {
        isStationLoading = true
        
        service.gasStationDetails()
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard self != nil else { return }
                
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print("Petrol Station error:", error)
                }
            } receiveValue: { [weak self] stationDetails in
                guard let self = self else { return }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.isStationLoading = false
                    self.stationDetails = stationDetails
                })
            }
            .store(in: &subscriptions)
    }
}
