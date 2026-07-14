import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: InspectionStore
    var body: some View {
        Form {
            Section(header: Text("Cloud analysis"), footer: Text("Only selected property photos leave this device. Suggestions stay provisional. The complete checklist and export work without analysis.")) { Toggle("Allow selected-photo analysis", isOn: $store.record.cloudConsent); Toggle("Simulate analysis available", isOn: $store.analysisAvailable); if !store.analysisAvailable { Label("Analysis unavailable — manual mode remains active", systemImage: "wifi.slash").foregroundColor(.orange) } }
            Section(header: Text("Before sharing")) { Label("Exclude faces, identity documents, mail, and sensitive belongings.", systemImage: "eye.slash"); Text("Your inspection record is stored locally on this device.") }
            Section(header: Text("Your data")) { Button("Delete local inspection") { store.reset() }.foregroundColor(.red) }
            Section { Text("DepositLens documents renter-confirmed observations. It does not provide legal advice, determine liability, estimate repair costs, or promise deposit recovery.").font(.footnote) }
        }.navigationTitle("Privacy & control")
    }
}
