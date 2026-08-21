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
                Text("register_title")
                    .font(.largeTitle).bold()
                
                TextField("name_placeholder", text: $name)
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
                    .onChange(of: email) { _ in
                        if errorMessage != nil {
                            errorMessage = nil
                        }
                    }
                
                HStack {
                    Group {
                        if isPasswordVisible {
                            TextField("password_placeholder", text: $password)
                        } else {
                            SecureField("password_placeholder", text: $password)
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
                        errorMessage = "error_name_required"
                        return
                    }
                    
                    guard !trimmedEmail.isEmpty else {
                        errorMessage = "error_email_required"
                        return
                    }
                    
                    // E-posta format kontrolü
                    guard trimmedEmail.contains("@") && trimmedEmail.contains(".") else {
                        errorMessage = "error_invalid_email"
                        return
                    }
                    
                    guard !password.isEmpty else {
                        errorMessage = "error_password_required"
                        return
                    }
                    
                    guard password.count >= 6 else {
                        errorMessage = "error_password_min_6"
                        return
                    }
                    
                    // Şifre gücü kontrolü
                    guard password.count >= 8 || (password.rangeOfCharacter(from: .decimalDigits) != nil && password.rangeOfCharacter(from: .letters) != nil) else {
                        errorMessage = "error_password_strength"
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
                    Text("register_submit")
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
            .navigationTitle("register_navigation_title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Button("cancel") { dismiss() } }
            }
        }
    }
    
}
