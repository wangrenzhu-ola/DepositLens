import SwiftUI

@main struct DepositLensApp: App {
    @StateObject private var store = InspectionStore()
    var body: some Scene { WindowGroup { RootView().environmentObject(store) } }
}
