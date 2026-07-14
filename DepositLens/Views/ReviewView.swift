import SwiftUI

struct ReviewView: View {
    @EnvironmentObject private var store: InspectionStore
    @State private var editing: ConditionProposal?
    @State private var shareURL: URL?
    var body: some View {
        List {
            Section(header: Text("Provisional changes"), footer: Text("Nothing enters your report until you confirm it.")) {
                ForEach(store.record.proposals) { ProposalRow(proposal: $0, onAccept: { store.decide(.accepted, proposalID: $0.id) }, onEdit: { editing = $0 }, onReject: { store.decide(.rejected, proposalID: $0.id) }) }
            }
            Section { Button(action: export) { Label("Export confirmed PDF", systemImage: "doc.richtext") }.disabled(InspectionLogic.reportable(store.record.proposals).isEmpty); if let url = shareURL { ShareLinkView(url: url) } }
        }.navigationTitle("Compare & confirm").sheet(item: $editing) { proposal in EditProposalView(proposal: proposal) { text in store.decide(.edited, proposalID: proposal.id, wording: text) } }
    }
    private func export() { let url = FileManager.default.temporaryDirectory.appendingPathComponent("DepositLens-Report.pdf"); try? ReportExporter.makePDF(record: store.record).write(to: url); shareURL = url }
}

private struct ProposalRow: View {
    let proposal: ConditionProposal; let onAccept: (ConditionProposal) -> Void; let onEdit: (ConditionProposal) -> Void; let onReject: (ConditionProposal) -> Void
    var body: some View { VStack(alignment: .leading, spacing: 10) { Text("\(proposal.room) · \(proposal.surface)").font(.headline); Text(proposal.wording); HStack { Label(proposal.beforeMediaID, systemImage: "photo"); Image(systemName: "arrow.right"); Label(proposal.afterMediaID, systemImage: "photo") }.font(.caption).foregroundColor(.secondary); Text(proposal.decision.rawValue.capitalized).font(.caption).foregroundColor(.secondary); HStack { Button("Accept") { onAccept(proposal) }; Button("Edit") { onEdit(proposal) }; Button("Reject") { onReject(proposal) }.foregroundColor(.red) }.buttonStyle(BorderlessButtonStyle()) } }
}

private struct EditProposalView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State private var text: String; let onSave: (String) -> Void
    init(proposal: ConditionProposal, onSave: @escaping (String) -> Void) { _text = State(initialValue: proposal.wording); self.onSave = onSave }
    var body: some View { NavigationView { Form { TextField("Neutral condition wording", text: $text) } .navigationTitle("Edit observation").toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { presentationMode.wrappedValue.dismiss() } }; ToolbarItem(placement: .confirmationAction) { Button("Confirm") { onSave(text); presentationMode.wrappedValue.dismiss() }.disabled(text.trimmingCharacters(in: .whitespaces).isEmpty) } } } }
}

private struct ShareLinkView: View { let url: URL; var body: some View { ShareSheetButton(url: url) } }
private struct ShareSheetButton: View { let url: URL; @State private var showing = false; var body: some View { Button("Share report") { showing = true }.sheet(isPresented: $showing) { ActivityView(items: [url]) } } }
private struct ActivityView: UIViewControllerRepresentable { let items: [Any]; func makeUIViewController(context: Context) -> UIActivityViewController { UIActivityViewController(activityItems: items, applicationActivities: nil) }; func updateUIViewController(_ controller: UIActivityViewController, context: Context) {} }
