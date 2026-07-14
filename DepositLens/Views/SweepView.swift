import SwiftUI

struct SweepView: View {
    @EnvironmentObject private var store: InspectionStore
    var body: some View {
        List {
            Section { TextField("Property label", text: $store.record.address); Picker("Snapshot", selection: $store.record.sweep) { ForEach(SweepKind.allCases) { Text($0.rawValue).tag($0) } } }
            ForEach(store.record.rooms) { room in RoomCoverageSection(room: room) }
        }.navigationTitle("Evidence sweep").listStyle(InsetGroupedListStyle())
    }
}

private struct RoomCoverageSection: View {
    @EnvironmentObject private var store: InspectionStore
    let room: RoomRecord
    private var missing: [String] { InspectionLogic.missingNames(room.surfaces) }
    var body: some View {
        Section(header: Text(room.name), footer: Text(missing.isEmpty ? "Coverage resolved" : "Still needed: \(missing.joined(separator: ", "))")) {
            ForEach(room.surfaces) { surface in
                HStack { VStack(alignment: .leading) { Text(surface.name); if let id = surface.mediaID { Text(id).font(.caption).foregroundColor(.secondary) } }; Spacer(); Menu { Button("Capture evidence") { store.set(.captured, roomID: room.id, surfaceID: surface.id) }; Button("Not applicable") { store.set(.notApplicable, roomID: room.id, surfaceID: surface.id) }; Button("Mark missing") { store.set(.missing, roomID: room.id, surfaceID: surface.id) } } label: { Label(surface.state == .missing ? "Missing" : surface.state == .captured ? "Captured" : "N/A", systemImage: surface.state == .missing ? "circle.dashed" : "checkmark.circle.fill") } }
            }
        }
    }
}
