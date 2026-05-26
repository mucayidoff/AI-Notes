import SwiftUI
import SwiftData

struct UserRegisterView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    @ObservedObject var authVM: AuthViewModel
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: LocalizedStringKey? = nil
    @State private var isPasswordVisible = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Kayıt Ol")
                    .font(.largeTitle).bold()
                
                TextField("İsim", text: $name)
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
                    .onChange(of: email) { _ in
                        if errorMessage != nil {
                            errorMessage = nil
                        }
                    }
                
                HStack {
                    Group {
                        if isPasswordVisible {
                            TextField("Şifre", text: $password)
                        } else {
                            SecureField("Şifre", text: $password)
                        }
                    }
                    Button(action: { isPasswordVisible.toggle() }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
                
                Button {
                    let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
                    let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    guard !trimmedName.isEmpty else {
                        errorMessage = "İsim gerekli"
                        return
                    }
                    
                    guard !trimmedEmail.isEmpty else {
                        errorMessage = "E-posta adresi gerekli"
                        return
                    }
                    
                    // E-posta format kontrolü
                    guard trimmedEmail.contains("@") && trimmedEmail.contains(".") else {
                        errorMessage = "Geçerli bir e-posta adresi girin"
                        return
                    }
                    
                    guard !password.isEmpty else {
                        errorMessage = "Şifre gerekli"
                        return
                    }
                    
                    guard password.count >= 6 else {
                        errorMessage = "Şifre en az 6 karakter olmalı"
                        return
                    }
                    
                    // Şifre gücü kontrolü
                    guard password.count >= 8 || (password.rangeOfCharacter(from: .decimalDigits) != nil && password.rangeOfCharacter(from: .letters) != nil) else {
                        errorMessage = "Şifre en az 8 karakter veya harf+rakam içermeli"
                        return
                    }
                    
                    do {
                        try authVM.register(
                            name: trimmedName,
                            email: trimmedEmail,
                            password: password,
                            modelContext: modelContext
                        )
                        isLoggedIn = true
                        dismiss()
                    } catch {
                        errorMessage = LocalizedStringKey(ErrorHandler.getErrorMessage(for: error))
                    }
                } label: {
                    Text("Kaydol")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Kayıt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Button("İptal") { dismiss() } }
            }
        }
    }
    
}
