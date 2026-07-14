import Foundation

public enum SurfaceState: String, Codable, CaseIterable { case missing, captured, notApplicable }
public enum ProposalDecision: String, Codable { case pending, accepted, edited, rejected }

public struct SurfaceRecord: Codable, Equatable, Identifiable {
    public var id: String
    public var name: String
    public var state: SurfaceState
    public var mediaID: String?
    public var observation: String
    public var capturedAt: Date?
    public init(id: String, name: String, state: SurfaceState = .missing, mediaID: String? = nil, observation: String = "", capturedAt: Date? = nil) {
        self.id = id; self.name = name; self.state = state; self.mediaID = mediaID; self.observation = observation; self.capturedAt = capturedAt
    }
}

public struct ConditionProposal: Codable, Equatable, Identifiable {
    public var id: UUID
    public var room: String
    public var surface: String
    public var wording: String
    public var beforeMediaID: String
    public var afterMediaID: String
    public var decision: ProposalDecision
    public init(id: UUID = UUID(), room: String, surface: String, wording: String, beforeMediaID: String, afterMediaID: String, decision: ProposalDecision = .pending) {
        self.id = id; self.room = room; self.surface = surface; self.wording = wording; self.beforeMediaID = beforeMediaID; self.afterMediaID = afterMediaID; self.decision = decision
    }
}

public enum InspectionLogic {
    public static func isComplete(_ surfaces: [SurfaceRecord]) -> Bool { surfaces.allSatisfy { $0.state != .missing } }
    public static func missingNames(_ surfaces: [SurfaceRecord]) -> [String] { surfaces.filter { $0.state == .missing }.map(\.name) }
    public static func reportable(_ proposals: [ConditionProposal]) -> [ConditionProposal] { proposals.filter { $0.decision == .accepted || $0.decision == .edited } }
    public static func documented(_ surfaces: [SurfaceRecord]) -> [SurfaceRecord] { surfaces.filter { $0.state == .captured } }
}
