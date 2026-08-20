import SwiftUI
import SwiftData

struct UserLoginView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("isGuestUser") private var isGuestUser = false

    @ObservedObject var authVM: AuthViewModel
    var onLoginSuccess: () -> Void
    var onRegisterRequest: () -> Void

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: LocalizedStringKey? = nil
    @State private var isPasswordVisible = false

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Giriş Yap")
                    .font(.largeTitle).bold()
                    .padding(.top)

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
                    let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    guard !trimmedEmail.isEmpty else {
                        errorMessage = "E-posta adresi gerekli"
                        return
                    }
                    
                    guard !password.isEmpty else {
                        errorMessage = "Şifre gerekli"
                        return
                    }
                    
                    // E-posta format kontrolü
                    guard trimmedEmail.contains("@") && trimmedEmail.contains(".") else {
                        errorMessage = "Geçerli bir e-posta adresi girin"
                        return
                    }
                    
                    let ok = authVM.login(
                        email: trimmedEmail,
                        password: password,
                        modelContext: modelContext
                    )
                    if ok {
                        isGuestUser = false
                        isLoggedIn = true
                        onLoginSuccess()
                    } else {
                        errorMessage = "E-posta veya şifre hatalı."
                    }
                } label: {
                    Text("Giriş Yap")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }

                Button { onRegisterRequest() } label: {
                    Text("Kayıt Ol")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
                Button {
                    isGuestUser = true
                    isLoggedIn = true
                    onLoginSuccess()
                } label: {
                    Text("Guest Mode")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5))
                        .foregroundColor(.primary)
                        .cornerRadius(12)
                    
                }

                Spacer()
            }
            .padding()
            .onAppear { authVM.autoLoadUser(modelContext: modelContext) }
            .navigationTitle("AI Notes")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

