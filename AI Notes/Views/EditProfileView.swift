import SwiftUI
import SwiftData

struct EditProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var authVM: AuthViewModel
    @Binding var showEdit: Bool

    @State private var name = ""
    @State private var email = ""
    @State private var showChangePassword = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if authVM.currentUser != nil {
                        Text("profile_info")
                            .font(.headline)

                        TextField("name_placeholder", text: $name)
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled(false)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)

                        TextField("email_placeholder", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)

                        
                        
                        NavigationLink {
                            ChangePasswordView(
                                authVM: authVM,
                            )
                        } label: {
                            HStack {
                                Image(systemName: "lock.rotation")
                                Text("change_password_title")

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray5))
                            )
                            .contentShape(Rectangle())
                        }
                        

                        HStack(spacing: 12) {
                            Button("save") { saveChanges() }
                                .buttonStyle(.borderedProminent)
                                .tint(.purple)
                                .controlSize(.large)
                            Button("cancel") { showEdit = false }
                                .buttonStyle(.bordered)
                                .tint(.secondary)
                        }
                    } else {
                        Text("profile_user_load_failed")
                            .foregroundColor(.red)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 24)
            }
            .navigationTitle("edit_profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("cancel") { showEdit = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("save") { saveChanges() }
                        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                if let user = authVM.currentUser {
                    name = user.name
                    email = user.email
                                    }
            }
        }
    }

    func saveChanges() {
        guard let user = authVM.currentUser else { return }

        user.name = name
        user.email = email
        
        
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
