//
//  ChangePasswordView.swift
//  AI Notes
//
//  Created by mucayid on 2025-05-11.
//

import SwiftUI
import SwiftData

struct ChangePasswordView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var authVM: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var oldPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: LocalizedStringKey? = nil

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("current_password_section")) {
                    SecureField("old_password_placeholder", text: $oldPassword)
                }

                Section(header: Text("new_password_section")) {
                    SecureField("new_password_placeholder", text: $newPassword)
                    SecureField("confirm_new_password_placeholder", text: $confirmPassword)
                }

                if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                }

                Section {
                    Button("update_password") {
                        updatePassword()
                    }

                    Button("cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .navigationTitle("change_password_title")
        }
    }

    func updatePassword() {
        guard let user = authVM.currentUser else {
            errorMessage = "user_not_found"
            return
        }

        // Eski şifreyi doğrula (hash'lenmiş şifre ile karşılaştır)
        guard PasswordHelper.verify(oldPassword, hashedPassword: user.password) else {
            errorMessage = "error_old_password_wrong"
            return
        }

        guard !newPassword.isEmpty else {
            errorMessage = "error_new_password_empty"
            return
        }

        guard newPassword.count >= 6 else {
            errorMessage = "error_new_password_min_6"
            return
        }

        guard newPassword == confirmPassword else {
            errorMessage = "error_passwords_do_not_match"
            return
        }

        // Yeni şifreyi hash'le ve kaydet
        user.password = PasswordHelper.hash(newPassword)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = LocalizedStringKey(
                String(
                    format: String(localized: "error_password_update_failed_format"),
                    error.localizedDescription
                )
            )
        }
    }
}

