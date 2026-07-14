import XCTest
#if canImport(DepositLens)
@testable import DepositLens
#else
@testable import DepositLensCore
#endif

final class InspectionLogicTests: XCTestCase {
    func testUnderSinkGapKeepsKitchenIncomplete() {
        let records = [SurfaceRecord(id: "counter", name: "Counters", state: .captured), SurfaceRecord(id: "under-sink", name: "Below kitchen sink")]
        XCTAssertFalse(InspectionLogic.isComplete(records))
        XCTAssertEqual(InspectionLogic.missingNames(records), ["Below kitchen sink"])
    }
    func testNotApplicableResolvesGap() {
        XCTAssertTrue(InspectionLogic.isComplete([SurfaceRecord(id: "x", name: "Optional", state: .notApplicable)]))
    }
    func testRejectedProposalNeverEntersReport() {
        let rejected = ConditionProposal(room: "Bedroom", surface: "Wall", wording: "Possible new mark", beforeMediaID: "M1", afterMediaID: "M2", decision: .rejected)
        XCTAssertTrue(InspectionLogic.reportable([rejected]).isEmpty)
    }
    func testEditedAndAcceptedProposalsEnterReport() {
        var edited = ConditionProposal(room: "Bedroom", surface: "Wall", wording: "Small mark", beforeMediaID: "M1", afterMediaID: "M2")
        edited.decision = .edited
        XCTAssertEqual(InspectionLogic.reportable([edited]).count, 1)
    }
}
