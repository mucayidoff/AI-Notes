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
    @Binding var showChangePassword: Bool

    @State private var oldPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: LocalizedStringKey? = nil

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Mevcut Şifre")) {
                    SecureField("Eski Şifre", text: $oldPassword)
                }

                Section(header: Text("Yeni Şifre")) {
                    SecureField("Yeni Şifre", text: $newPassword)
                    SecureField("Yeni Şifre (Tekrar)", text: $confirmPassword)
                }

                if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                }

                Section {
                    Button("Şifreyi Güncelle") {
                        updatePassword()
                    }

                    Button("İptal", role: .cancel) {
                        showChangePassword = false
                    }
                }
            }
            .navigationTitle("Şifre Değiştir")
        }
    }

    func updatePassword() {
        guard let user = authVM.currentUser else {
            errorMessage = "Kullanıcı bulunamadı."
            return
        }

        // Eski şifreyi doğrula (hash'lenmiş şifre ile karşılaştır)
        guard PasswordHelper.verify(oldPassword, hashedPassword: user.password) else {
            errorMessage = "Eski şifre yanlış."
            return
        }

        guard !newPassword.isEmpty else {
            errorMessage = "Yeni şifre boş olamaz."
            return
        }

        guard newPassword.count >= 6 else {
            errorMessage = "Yeni şifre en az 6 karakter olmalı."
            return
        }

        guard newPassword == confirmPassword else {
            errorMessage = "Yeni şifreler eşleşmiyor."
            return
        }

        // Yeni şifreyi hash'le ve kaydet
        user.password = PasswordHelper.hash(newPassword)
        
        do {
            try modelContext.save()
            showChangePassword = false
        } catch {
            errorMessage = LocalizedStringKey(String(format: NSLocalizedString("Şifre güncellenemedi: %@", comment: ""), error.localizedDescription))
        }
    }
}

