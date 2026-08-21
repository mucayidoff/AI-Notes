import SwiftUI

struct LanguageSettingsView: View {
    @AppStorage("appLanguage") private var appLanguage: String = "system"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("language_picker_title")
                    .font(.headline)
                    .padding(.top, 4)

                Picker("language_picker_title", selection: $appLanguage) {
                                    
                                    Text("Sistem Dili")
                                        .tag("system")
                                    
                                    Text("Türkçe")
                                        .tag("tr")
                                    
                                    Text("English")
                                        .tag("en")
                                    
                                    Text("Русский")
                                        .tag("ru")
                                }
                .pickerStyle(.segmented)

                Text("Değişiklikler anında uygulanır. Bazı metinler için uygulamayı yeniden başlatmanız gerekebilir.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
            }
            .padding(.horizontal)
            .padding(.top, 24)
        }
        .navigationTitle("language_picker_title")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        LanguageSettingsView()
    }
}
