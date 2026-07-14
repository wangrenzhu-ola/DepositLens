import Foundation

enum SweepKind: String, Codable, CaseIterable, Identifiable { case moveIn = "Move-in", moveOut = "Move-out"; var id: String { rawValue } }
struct RoomRecord: Codable, Identifiable { var id = UUID(); var name: String; var surfaces: [SurfaceRecord] }
struct PropertyRecord: Codable { var address: String; var sweep: SweepKind; var rooms: [RoomRecord]; var proposals: [ConditionProposal]; var cloudConsent = false }
