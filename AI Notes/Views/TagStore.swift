import SwiftUI

/// Merkezi etiket ve seçili etiket yönetimi — UserDefaults ile otomatik senkronizasyon içerir
final class TagStore: ObservableObject {
    @Published var tags: [String] = [] {
        didSet { saveTags() }
    }
    @Published var selectedTag: String = ""

    private let userDefaultsKey = "userTags"
    private let defaultTags = ["work_tag", "personal_tag", "school_tag", "ideas_tag", "education_tag"]

    init() {
        loadTags()
        if tags.isEmpty {
            tags = defaultTags
            saveTags()
        }
        // Seçili etiketi varsayılan olarak ilk etikete ayarla veya boş bırak
        selectedTag = tags.first ?? ""
    }

    func addTag(_ tag: String) {
        guard !tags.contains(tag) else { return }
        tags.append(tag)
        saveTags()
        selectedTag = tag // ekleyince otomatik seç
    }

    func removeTag(_ tag: String) {
        tags.removeAll { $0 == tag }
        saveTags()
        if selectedTag == tag {
            selectedTag = tags.first ?? ""
        }
    }
    
    private func saveTags() {
        UserDefaults.standard.set(tags, forKey: userDefaultsKey)
    }

    private func loadTags() {
        tags = UserDefaults.standard.stringArray(forKey: userDefaultsKey) ?? defaultTags
    }
    
    // Opsiyonel: Herkese açık tag reset fonksiyonu
    func resetToDefaults() {
        tags = defaultTags
        saveTags()
    }
}
