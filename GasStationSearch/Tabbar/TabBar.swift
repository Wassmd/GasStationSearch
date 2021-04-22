import SwiftUI

struct TabBar: View {
    private enum Tab: Hashable {
        case gasStation
        case settings
    }
    
    @State private var selectedTab: Tab = .gasStation
    
    var body: some View {
        TabView(selection: $selectedTab) {
            GasStationView()
                .tag(0)
                .tabItem {
                    Text("Home")
                    Image(systemName: "bolt.car")
                }
            SettingsView()
                .tag(1)
                .tabItem {
                    Text("Settings")
                    Image(systemName: "gear")
                }
        }
    }
}

struct HostingTabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}

