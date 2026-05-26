//
//  NotesHomeView.swift
//  AI Notes
//

import SwiftUI
import SwiftData

enum AppTab { case list, tasks, mic, profile }

struct NotesHomeView: View {
    @StateObject private var tagStore = TagStore()
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var authVM: AuthViewModel

    @Query(sort: \Note.createdDate, order: .reverse)
    private var allNotes: [Note]

    @State private var searchText = ""
    @State private var selectedTab: AppTab = .list

    @State private var showNewNoteView = false

    private static let allTagKey = "all_tag"

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    ScrollView {
                        VStack(spacing: 0) {
                            StickyHeader(
                                searchText: $searchText,
                                selectedTag: $tagStore.selectedTag,
                                userName: authVM.currentUser?.name ?? String(localized: "user_fallback_name"),
                                tags: tagStore.tags
                            )
                            NotesListView(notes: filteredNotes())
                                .padding(.top, 12)
                        }
                    }
                    .tag(AppTab.list)

                    TaskView().tag(AppTab.tasks)
                    Text(String(localized: "mic view title")).tag(AppTab.mic)
                    ProfileView(authVM: authVM).tag(AppTab.profile)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                BottomBarWithFABView(
                    selectedTab: $selectedTab,
                    onPlusTap: { showNewNoteView = true },
                    onMicTap: { selectedTab = .mic },
                    onListTap: { selectedTab = .list; tagStore.selectedTag = Self.allTagKey },
                    onProfileTap: { withAnimation { selectedTab = .profile } }
                )
                .padding(.bottom, 10)
            }
            .sheet(isPresented: $showNewNoteView) {
                NewNoteView(tagStore: tagStore)
            }
            .onAppear {
                authVM.autoLoadUser(modelContext: modelContext)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        authVM.logout()
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private func filteredNotes() -> [Note] {
        allNotes.filter {
            (tagStore.selectedTag == Self.allTagKey || $0.tag == tagStore.selectedTag) &&
            (searchText.isEmpty || $0.title.localizedCaseInsensitiveContains(searchText))
        }
    }
}

