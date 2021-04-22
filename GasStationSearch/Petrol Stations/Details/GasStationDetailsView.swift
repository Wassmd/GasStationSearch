import SwiftUI

struct GasStationDetailsView: View {

    let stationDetails: GasStationDetails?
    @Binding var isLoading: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Price: \(stationDetails?.pricesPerLiter[0].pricePerLiter ?? 0.0)")
                    .font(.headline)
                    .padding()
                Text("Location: Some Location")
                    .padding()
                Text("Name: \(stationDetails?.name ?? "      ")")
                    .padding()
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Petrol Details")
            .redacted(reason: isLoading ? .placeholder : [])
        }
    }
}
