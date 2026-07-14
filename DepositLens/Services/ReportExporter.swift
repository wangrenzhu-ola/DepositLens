import UIKit

enum ReportExporter {
    static func makePDF(record: PropertyRecord) -> Data {
        let format = UIGraphicsPDFRendererFormat(); let page = CGRect(x: 0, y: 0, width: 612, height: 792)
        return UIGraphicsPDFRenderer(bounds: page, format: format).pdfData { context in
            context.beginPage(); var y: CGFloat = 44
            func line(_ text: String, size: CGFloat = 12) { (text as NSString).draw(at: CGPoint(x: 44, y: y), withAttributes: [.font: UIFont.systemFont(ofSize: size)]); y += size + 9 }
            let formatter = DateFormatter(); formatter.dateStyle = .medium; formatter.timeStyle = .short
            line("DepositLens Condition Comparison", size: 22); line(record.address); line("Generated \(formatter.string(from: Date()))")
            for proposal in InspectionLogic.reportable(record.proposals) { line("\(proposal.room) · \(proposal.surface): \(proposal.wording)"); line("Sources: \(proposal.beforeMediaID) ↔ \(proposal.afterMediaID)", size: 10) }
            y += 16; line("This record is for documentation only and is not legal advice.", size: 10)
        }
    }
}
