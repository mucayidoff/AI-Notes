//
//  NotesListView.swift
//  AI Notes
//
//  Created by mucayid on 2025-04-29.
//
import SwiftUI
import SwiftData

struct NotesListView: View {
    let notes: [Note]

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 12) {
            ForEach(notes.sorted { ($0.updatedDate ?? $0.createdDate) > ($1.updatedDate ?? $1.createdDate) }, id: \.id) { note in
                NavigationLink(destination: NoteDetailView(note: note)) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(note.title)
                            .font(.headline)
                        if !note.summary.isEmpty {
                            Text(note.summary)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Text(note.tag)
                                .font(.caption)
                                .foregroundColor(Color.forTag(note.tag))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.forTag(note.tag).opacity(0.25))
                                .cornerRadius(8)
                            Spacer()
                            let displayDate = note.updatedDate ?? note.createdDate
                            let label = note.updatedDate == nil ? "Oluşturuldu:" : "Güncellendi:"
                            Text("\(label) \(displayDate.formatted(date: .abbreviated, time: .shortened))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

//#Preview {
 //   NotesListView(notes: [])
//}

