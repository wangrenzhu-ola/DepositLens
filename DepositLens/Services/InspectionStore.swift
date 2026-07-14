import Foundation
import UIKit

final class InspectionStore: ObservableObject {
    @Published var record: PropertyRecord { didSet { save() } }
    @Published var analysisAvailable = true
    private let url: URL

    init(fileURL: URL? = nil) {
        url = fileURL ?? FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("depositlens.json")
        if let data = try? Data(contentsOf: url), let value = try? JSONDecoder().decode(PropertyRecord.self, from: data) { record = value }
        else { record = Self.seed }
    }

    static let seed = PropertyRecord(address: "My rental", sweep: .moveIn, rooms: [
        RoomRecord(name: "Kitchen", surfaces: [SurfaceRecord(id: "walls", name: "Walls"), SurfaceRecord(id: "floor", name: "Floor"), SurfaceRecord(id: "counter", name: "Counters"), SurfaceRecord(id: "under-sink", name: "Below kitchen sink")]),
        RoomRecord(name: "Bedroom", surfaces: [SurfaceRecord(id: "walls", name: "Walls"), SurfaceRecord(id: "floor", name: "Floor"), SurfaceRecord(id: "windows", name: "Windows")])
    ], proposals: [ConditionProposal(room: "Bedroom", surface: "Wall", wording: "Possible new wall mark", beforeMediaID: "MOVEIN-001", afterMediaID: "MOVEOUT-014")])

    func set(_ state: SurfaceState, roomID: UUID, surfaceID: String) {
        guard let room = record.rooms.firstIndex(where: { $0.id == roomID }), let surface = record.rooms[room].surfaces.firstIndex(where: { $0.id == surfaceID }) else { return }
        record.rooms[room].surfaces[surface].state = state
        if state == .captured { record.rooms[room].surfaces[surface].mediaID = "DL-\(Int(Date().timeIntervalSince1970))" }
    }
    func decide(_ decision: ProposalDecision, proposalID: UUID, wording: String? = nil) {
        guard let index = record.proposals.firstIndex(where: { $0.id == proposalID }) else { return }
        if let wording = wording { record.proposals[index].wording = wording }
        record.proposals[index].decision = decision
    }
    func reset() { record = Self.seed }
    private func save() { if let data = try? JSONEncoder().encode(record) { try? data.write(to: url, options: .atomic) } }
}
