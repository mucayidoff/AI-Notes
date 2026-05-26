import SwiftUI
import SwiftData

struct EditProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var authVM: AuthViewModel
    @Binding var showEdit: Bool

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if authVM.currentUser != nil {
                        Text("Bilgiler")
                            .font(.headline)

                        TextField("Ad", text: $name)
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled(false)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)

                        TextField("E-posta", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)

                        SecureField("Şifre", text: $password)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)

                        HStack(spacing: 12) {
                            Button("Kaydet") { saveChanges() }
                                .buttonStyle(.borderedProminent)
                                .tint(.purple)
                                .controlSize(.large)
                            Button("İptal") { showEdit = false }
                                .buttonStyle(.bordered)
                                .tint(.secondary)
                        }
                    } else {
                        Text("⚠️ Kullanıcı bilgisi yüklenemedi.")
                            .foregroundColor(.red)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 24)
            }
            .navigationTitle("Profili Düzenle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") { showEdit = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") { saveChanges() }
                        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                if let user = authVM.currentUser {
                    name = user.name
                    email = user.email
                    password = user.password
                }
            }
        }
    }

    func saveChanges() {
        guard let user = authVM.currentUser else { return }

        user.name = name
        user.email = email
        if !password.isEmpty {
            user.password = PasswordHelper.hash(password)
        }
        
        do {
            try modelContext.save()
            showEdit = false
        } catch {
            print("Profil güncellenemedi: \(error.localizedDescription)")
        }
    }
}

#Preview {
    EditProfileView(
        authVM: AuthViewModel(),
        showEdit: .constant(true)
    )
}
