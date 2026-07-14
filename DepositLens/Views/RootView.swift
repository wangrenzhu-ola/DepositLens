import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            NavigationView { SweepView() }.tabItem { Label("Sweep", systemImage: "viewfinder") }
            NavigationView { ReviewView() }.tabItem { Label("Review", systemImage: "square.stack.3d.up") }
            NavigationView { SettingsView() }.tabItem { Label("Privacy", systemImage: "hand.raised") }
        }.accentColor(Color(red: 0.08, green: 0.42, blue: 0.33))
    }
}
