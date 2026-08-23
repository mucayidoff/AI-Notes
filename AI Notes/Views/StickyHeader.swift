//  StickyHeaderView.swift
//  AI Notes

import SwiftUI

struct StickyHeader: View {
    @Binding var searchText: String
    @Binding var selectedTag: String
    var userName: String
    let tags: [String]

    var body: some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("welcome_prefix") + Text(" \(userName)!")

                Text("manage_today_notes")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // Arama kutusu
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("search_notes", text: $searchText)
                    .autocapitalization(.none)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(.systemGray6))
            .cornerRadius(14)

            // Etiketler
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(tags, id: \.self) { tag in
                        Text(LocalizedStringKey(tag))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(
                                selectedTag == tag
                                ? Color.selectedForTag(tag)
                                : Color.unselectedBackgroundForTag(tag)
                            )
                            .foregroundColor(
                                selectedTag == tag
                                ? .white
                                : Color.forTag(tag)
                            )
                            .cornerRadius(16)
                            .onTapGesture {
                                selectedTag = tag
                            }
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .background(Color(.systemBackground).opacity(0.97))
        .overlay(Divider(), alignment: .bottom)
    }
}

#Preview {
    StickyHeader(
        searchText: .constant(""),
        selectedTag: .constant("Tümü"),
        userName: "Mucayid",
        tags: ["Tümü", "İş", "Kişisel", "Okul"]
    )
}

