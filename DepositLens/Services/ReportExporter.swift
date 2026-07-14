import UIKit

enum ReportExporter {
    static func makePDF(record: PropertyRecord) -> Data {
        let format = UIGraphicsPDFRendererFormat(); let page = CGRect(x: 0, y: 0, width: 612, height: 792)
        return UIGraphicsPDFRenderer(bounds: page, format: format).pdfData { context in
            context.beginPage(); var y: CGFloat = 44
            func line(_ text: String, size: CGFloat = 12) { (text as NSString).draw(at: CGPoint(x: 44, y: y), withAttributes: [.font: UIFont.systemFont(ofSize: size)]); y += size + 9 }
            let formatter = DateFormatter(); formatter.dateStyle = .medium; formatter.timeStyle = .short
            line("DepositLens Condition Comparison", size: 22); line(record.address); line("Sweep started: \(formatter.string(from: record.startedAt))"); line("Exported: \(formatter.string(from: Date()))")
            for room in record.rooms {
                let documented = InspectionLogic.documented(room.surfaces)
                guard !documented.isEmpty else { continue }
                y += 10; line(room.name, size: 16)
                for surface in documented {
                    line("\(surface.name): \(surface.observation.isEmpty ? "No issue noted" : surface.observation)")
                    line("Captured \(formatter.string(from: surface.capturedAt ?? record.startedAt)) · Source \(surface.mediaID ?? "Unavailable")", size: 10)
                }
            }
            y += 10; line("Confirmed comparison changes", size: 16)
            for proposal in InspectionLogic.reportable(record.proposals) { line("\(proposal.room) · \(proposal.surface): \(proposal.wording)"); line("Sources: \(proposal.beforeMediaID) ↔ \(proposal.afterMediaID)", size: 10) }
            y += 16; line("This record is for documentation only. It is not legal advice and does not promise deposit recovery.", size: 10)
        }
    }
}
