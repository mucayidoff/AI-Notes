//
//  NoteDetailView.swift
//  AI Notes
//
//  Created by mucayid on 2025-04-10.
//

import SwiftUI
import SwiftData
import UIKit

struct NoteDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var errorState: ErrorState
    let note: Note

    @State private var title: String
    @State private var content: String
    @State private var showAIResult: Bool = false
    @State private var aiSummary: String = ""

    init(note: Note) {
        self.note = note
        _title = State(initialValue: note.title)
        _content = State(initialValue: note.content)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                TextField(String(localized: "note_title_placeholder"), text: $title)
                    .font(.title2)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)

                TextEditor(text: $content)
                    .frame(minHeight: 200)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)

                if showAIResult {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(String(localized: "ai_summary_title")).font(.headline)
                        Text(aiSummary).font(.subheadline).foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(12)
                }

                HStack(spacing: 12) {
                    Button(action: generateAISummary) {
                        Label(String(localized: "ai_summarize"), systemImage: "sparkles")
                            .padding()
                            .background(Color.purple.opacity(0.2))
                            .cornerRadius(12)
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle(String(localized: "note_detail_title"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(String(localized: "save")) {
                    note.title = title
                    note.content = content
                    if note.summary.isEmpty { note.summary = String(content.prefix(80)) }
                    note.updatedDate = .now
                    do {
                        try modelContext.save()
                    } catch {
                        print("❌ " + String(localized: "error_saving_log") + ": \(error.localizedDescription)")
                        errorState.show(String(localized: "error_save_failed") + ": \(error.localizedDescription)")
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(role: .destructive) {
                    modelContext.delete(note)
                    do {
                        try modelContext.save()
                        dismiss()
                    } catch {
                        print("❌ " + String(localized: "error_deleting_log") + ": \(error.localizedDescription)")
                        errorState.show(String(localized: "error_delete_failed") + ": \(error.localizedDescription)")
                    }
                } label: {
                    Label(String(localized: "delete"), systemImage: "trash")
                        .foregroundColor(.red)
                }
            }
        }
    }

    private func generateAISummary() {
        withAnimation {
            aiSummary = "Bu notun özeti: \(content.prefix(80))..."
            showAIResult = true
        }
    }
}
