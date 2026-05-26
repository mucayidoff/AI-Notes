//
//  TagSelectorView.swift
//  AI Notes
//
//  Created by mucayid on 2025-04-29.
//
import SwiftUI

struct TagSelectorView: View {
    @Binding var tags: [String]
    @Binding var selectedTag: String
    @State private var deletingTag: String? = nil
    @State private var showDeleteConfirm: Bool = false
    @State private var pendingDeleteTag: String? = nil

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(tags, id: \.self) { tag in
                    ZStack(alignment: .topTrailing) {
                        Text(verbatim: tag)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(selectedTag == tag ? Color.selectedForTag(tag) : Color.unselectedBackgroundForTag(tag))
                            .foregroundColor(selectedTag == tag ? .white : Color.forTag(tag))
                            .cornerRadius(16)
                            .onTapGesture { selectedTag = tag }
                            .onLongPressGesture {
                                withAnimation { deletingTag = tag }
                            }
                            .contextMenu {
                                Button {
                                    // Trigger color change sheet via notification
                                    NotificationCenter.default.post(name: Notification.Name("TagSelectorChangeColor"), object: tag)
                                } label: {
                                    Label(String(localized: "change_color"), systemImage: "paintpalette")
                                }
                            }

                        if deletingTag == tag {
                            Button(action: {
                                pendingDeleteTag = tag
                                showDeleteConfirm = true
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                    .background(Color.clear)
                            }
                            .padding(2)
                        }
                    }
                }
            }
        }
        .alert(String(localized: "delete_tag_confirm"), isPresented: $showDeleteConfirm) {
            Button(String(localized: "delete"), role: .destructive) {
                guard let tag = pendingDeleteTag else { return }
                if let index = tags.firstIndex(of: tag) {
                    tags.remove(at: index)
                    var saved = UserDefaults.standard.stringArray(forKey: "userTags") ?? []
                    saved.removeAll { $0 == tag }
                    UserDefaults.standard.set(saved, forKey: "userTags")
                    if selectedTag == tag { selectedTag = tags.first ?? "" }
                }
                withAnimation { deletingTag = nil }
                pendingDeleteTag = nil
            }
            Button(String(localized: "cancel"), role: .cancel) {
                pendingDeleteTag = nil
            }
        } message: {
            Text(String(localized: "delete_tag_message"))
        }
    }
}
