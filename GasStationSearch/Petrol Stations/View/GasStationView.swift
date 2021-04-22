import SwiftUI

struct GasStationView: View {
    //@ObservedObject - should not be used as it will recreate viewModel on every view refresh.
    // State will be changed. Hence @StateObject
    @StateObject private var viewModel = GasStationViewModel()
    @State private var showCheapest = false

    var body: some View {
        NavigationView {
            GasStationMapView(showCheapest: $showCheapest)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitle("Gas Stations")
                .navigationBarItems(
                    trailing:
                        Button(action: {
                            showCheapest = true
                        }) {
                            Text("Cheapest")
                        }
                )
                .environmentObject(viewModel)
                .sheet(isPresented: $viewModel.showDetails) { 
                    GasStationDetailsView(stationDetails: viewModel.stationDetails, isLoading: $viewModel.isStationLoading)
                }
        }
        .onAppear {
            viewModel.getGasStations()
        }
    }
}

struct GasStationView_Previews: PreviewProvider {
    static var previews: some View {
        GasStationView()
    }
}
