import SwiftUI


struct BottomBarWithFABView: View {
    @Binding var selectedTab: AppTab // 🔸 Şu anda aktif olan sekme

    var onPlusTap: () -> Void
    var onMicTap: () -> Void
    var onListTap: () -> Void
    var onProfileTap: () -> Void

    var body: some View {
        HStack(spacing: 50) {
            // Liste butonu
            Button(action: onListTap) {
                Image(systemName: "list.bullet")
                    .font(.title2)
                    .foregroundColor(selectedTab == .list ? .purple : .primary)
            }
            .accessibilityLabel("notes_tab")

            // Mikrofon butonu
            Button(action: onMicTap) {
                Image(systemName: "mic.fill")
                    .font(.title2)
                    .foregroundColor(selectedTab == .mic ? .purple : .primary)
            }
            .accessibilityLabel("microphone_tab")

            // Ortadaki büyük + butonu
            Button(action: onPlusTap) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 44))
                    .foregroundColor(.purple)
            }
            .accessibilityLabel("new_note_button")

            // Profil butonu
            Button(action: onProfileTap) {
                Image(systemName: "person.crop.circle")
                    .font(.title2)
                    .foregroundColor(selectedTab == .profile ? .purple : .primary)
            }
            .accessibilityLabel("profile_tab")
        }
        .padding()
        .background(Color(.systemBackground).opacity(0.95))
        .cornerRadius(20)
        .shadow(radius: 4)
    }
}

#Preview {
    BottomBarWithFABView(
        selectedTab: .constant(.list),
        onPlusTap: { print("➕ Buton basıldı") },
        onMicTap: { print("🎤 Mikrofon basıldı") },
        onListTap: { print("📋 Liste basıldı") },
        onProfileTap: { print("👤 Profil tıklandı") }
    )
}
