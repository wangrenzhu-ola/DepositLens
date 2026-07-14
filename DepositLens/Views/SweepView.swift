import SwiftUI

struct SweepView: View {
    @EnvironmentObject private var store: InspectionStore
    var body: some View {
        List {
            Section(header: Text("Inspection"), footer: Text("Resolve every view before calling a room complete.")) { TextField("Property label", text: $store.record.address); Picker("Snapshot", selection: $store.record.sweep) { ForEach(SweepKind.allCases) { Text($0.rawValue).tag($0) } } }
            ForEach(store.record.rooms) { room in RoomCoverageSection(room: room) }
        }.navigationTitle("Evidence sweep").listStyle(InsetGroupedListStyle())
    }
}

private struct RoomCoverageSection: View {
    @EnvironmentObject private var store: InspectionStore
    let room: RoomRecord
    @State private var selectedSurface: SurfaceRecord?
    private var missing: [String] { InspectionLogic.missingNames(room.surfaces) }
    var body: some View {
        Section(header: Text(room.name), footer: Text(missing.isEmpty ? "Coverage resolved" : "Still needed: \(missing.joined(separator: ", "))")) {
            ForEach(room.surfaces) { surface in
                HStack { VStack(alignment: .leading, spacing: 3) { Text(surface.name); if !surface.observation.isEmpty { Text(surface.observation).font(.caption).foregroundColor(.secondary) }; if let id = surface.mediaID { Text(id).font(.caption2).foregroundColor(.secondary) } }; Spacer(); Menu { Button("Capture & label") { selectedSurface = surface }; Button("Not applicable") { store.set(.notApplicable, roomID: room.id, surfaceID: surface.id) }; Button("Mark missing") { store.set(.missing, roomID: room.id, surfaceID: surface.id) } } label: { Label(surface.state == .missing ? "Missing" : surface.state == .captured ? "Captured" : "N/A", systemImage: surface.state == .missing ? "circle.dashed" : "checkmark.circle.fill") }.accessibilityLabel("\(surface.name), \(surface.state.rawValue)") }
            }
        }
        .sheet(item: $selectedSurface) { surface in CaptureObservationView(surface: surface) { observation in store.set(.captured, roomID: room.id, surfaceID: surface.id, observation: observation) } }
    }
}

private struct CaptureObservationView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State private var observation: String
    let surface: SurfaceRecord
    let onSave: (String) -> Void

    init(surface: SurfaceRecord, onSave: @escaping (String) -> Void) { self.surface = surface; self.onSave = onSave; _observation = State(initialValue: surface.observation) }
    var body: some View { NavigationView { Form { Section(header: Text(surface.name), footer: Text("Add a neutral note, or leave blank when the image is sufficient.")) { TextField("Observation (optional)", text: $observation) } } .navigationTitle("Capture evidence").toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { presentationMode.wrappedValue.dismiss() } }; ToolbarItem(placement: .confirmationAction) { Button("Save capture") { onSave(observation); presentationMode.wrappedValue.dismiss() } } } } }
}
