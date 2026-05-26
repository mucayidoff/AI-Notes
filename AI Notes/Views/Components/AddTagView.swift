//
//  AddTagView.swift
//  AI Notes
//
//  Created by mucayid on 2025-06-30.
//

import SwiftUI

struct AddTagView: View {
    @Environment(\.dismiss) var dismiss
    @State private var newTagText = ""
    @State private var selectedColor: Color? = nil
    var onAdd: (String) -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Yeni etiket adı", text: $newTagText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Renk Seç")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    let palette: [Color] = [.purple, .blue, .green, .orange, .teal, .pink, .indigo, .brown, .red, .yellow]
                    LazyVGrid(columns: Array(repeating: GridItem(.fixed(28), spacing: 10), count: 10), spacing: 10) {
                        ForEach(palette.indices, id: \.self) { i in
                            Circle()
                                .fill(palette[i])
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Circle().stroke(Color.white, lineWidth: selectedColor == palette[i] ? 3 : 0)
                                )
                                .onTapGesture { selectedColor = palette[i] }
                        }
                    }

                    ColorPicker("Daha fazla renk", selection: Binding(get: { selectedColor ?? Color.suggestedColor(for: newTagText) }, set: { selectedColor = $0 }))
                }
                .padding(.horizontal)

                Button("Ekle") {
                    let trimmed = newTagText.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !trimmed.isEmpty {
                        onAdd(trimmed)
                        let colorToSave = selectedColor ?? Color.suggestedColor(for: trimmed)
                        Color.setUserColor(colorToSave, for: trimmed)
                    }
                }
                .disabled(newTagText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(12)

                Spacer()
            }
            .padding()
            .navigationTitle("Yeni Etiket Ekle")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") {
                        dismiss()
                    }
                }
            }
        }
    }
}
