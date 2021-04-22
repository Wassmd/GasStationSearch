import SwiftUI
import MapKit

struct GasStationMapView: UIViewRepresentable {
    
    @EnvironmentObject var viewModel: GasStationViewModel
    @Binding var showCheapest: Bool
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
                
        registerAnnotations(for: mapView)

        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {

        if viewModel.shouldUpdateRegion {
            mapView.setRegion(viewModel.coordinateRegion, animated: true)
        }

        if viewModel.shouldUpdateMapView {
            addAnnotation(to: mapView)

            viewModel.shouldUpdateMapView = false
        }

        if showCheapest {
            selectTheCheapest(mapView: mapView)
            showCheapest = false
        }
    }

    private func addAnnotation(to mapView: MKMapView) {
        let annotations = viewModel.petrolStations.map { petrolStationHeader -> GasStationAnnotation in
            return GasStationAnnotation(petrolStation: petrolStationHeader)
        }

        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }

    private func registerAnnotations(for mapView: MKMapView) {
        mapView.register(GasStationAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }

    private func selectTheCheapest(mapView: MKMapView) {
        let annotations = viewModel.petrolStations.map {
             GasStationAnnotation(petrolStation: $0, isCheap: $0.pricePerLiter == 1.489)
        }

        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        let parent: GasStationMapView

        init(_ parent: GasStationMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotationView = view as? GasStationAnnotationView,
               let annotation = annotationView.annotation as? GasStationAnnotation {
                showDetails(mapView, for: annotation)
            }
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? GasStationAnnotation else { return nil }

                return GasStationAnnotationView(annotation: annotation, reuseIdentifier: GasStationAnnotationView.ReuseID)
            
        }

        private func showDetails(_ mapView: MKMapView, for annotation: GasStationAnnotation) {
            parent.viewModel.annotationSelected = annotation
            
            mapView.deselectAnnotation(annotation, animated: false)
        }
    }
}
