//
//  AuthViewModel.swift
//  AI Notes
//
//  Created by mucayid on 2025-09-11.
//

import SwiftUI
import SwiftData

final class AuthViewModel: ObservableObject {
    @Published var showRegister: Bool = false
    @Published var currentUser: AppUser? = nil

    func login(email: String, password: String, modelContext: ModelContext) -> Bool {
        do {
            let descriptor = FetchDescriptor<AppUser>(
                predicate: #Predicate { $0.email == email }
            )
            let users = try modelContext.fetch(descriptor)
            if let found = users.first,
               PasswordHelper.verify(password, hashedPassword: found.password) {
                currentUser = found
                UserDefaults.standard.set(found.id.uuidString, forKey: "loggedInUserID")
                return true
            }
        } catch {
            print("❌ Giriş hatası: \(error.localizedDescription)")
        }
        return false
    }

    func autoLoadUser(modelContext: ModelContext) {
        guard
            let idStr = UserDefaults.standard.string(forKey: "loggedInUserID"),
            let uuid = UUID(uuidString: idStr)
        else { return }

        do {
            let descriptor = FetchDescriptor<AppUser>(
                predicate: #Predicate { $0.id == uuid }
            )
            let users = try modelContext.fetch(descriptor)
            if let found = users.first {
                currentUser = found
            }
        } catch {
            print("❌ Kullanıcı yükleme hatası: \(error.localizedDescription)")
        }
    }

    func logout() {
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: "loggedInUserID")
    }

    func register(name: String, email: String, password: String, modelContext: ModelContext) throws {
        // e-posta benzersiz olsun
        let existsDesc = FetchDescriptor<AppUser>(
            predicate: #Predicate { $0.email == email }
        )
        let exists = try modelContext.fetch(existsDesc).isEmpty == false
        if exists { throw NSError(domain: "Auth", code: 1, userInfo: [NSLocalizedDescriptionKey: "E-posta zaten kayıtlı"]) }

        let hashedPassword = PasswordHelper.hash(password)
        let user = AppUser(name: name, email: email, password: hashedPassword)
        modelContext.insert(user)
        try modelContext.save()

        currentUser = user
        UserDefaults.standard.set(user.id.uuidString, forKey: "loggedInUserID")
    }
}
