//
//  NoteCard.swift
//  AI Notes
//
//  Created by mucayid on 2025-04-12.
//

import SwiftUI
import SwiftData

struct NoteCard: View {
    let note: Note

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(note.title)
                .font(.headline)

            Text(note.summary)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .truncationMode(.tail)

            HStack {
                let tagColor: Color = {
                    switch note.tag.lowercased() {
                    case "iş": return .purple
                    case "kişisel": return .blue
                    case "okul": return .green
                    case "fikirler": return .orange
                    case "eğitim": return .teal
                    default: return .gray
                    }
                }()

                Text(note.tag)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(tagColor)
                    .cornerRadius(10)

                Spacer()

                let displayDate = note.updatedDate ?? note.createdDate
                let label = note.updatedDate == nil ? "Oluşturuldu:" : "Güncellendi:"
                Text("\(label) \(displayDate.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    NoteCard(note: Note(
        title: "Örnek Not",
        summary: "Bu bir özet örneğidir.",
        content: "Not içeriği buraya gelir...",
        tag: "Kişisel"
    ))
}
