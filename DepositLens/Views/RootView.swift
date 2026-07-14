import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            NavigationView { SweepView() }.tabItem { Label("Sweep", systemImage: "viewfinder") }
            NavigationView { ReviewView() }.tabItem { Label("Review", systemImage: "rectangle.on.rectangle.angled") }
            NavigationView { SettingsView() }.tabItem { Label("Privacy", systemImage: "hand.raised.fill") }
        }.accentColor(Color(red: 0.08, green: 0.42, blue: 0.33))
    }
}
