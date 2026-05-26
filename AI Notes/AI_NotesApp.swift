//
//  AI_NotesApp.swift
//  AI Notes
//
//  Created by mucayid on 2025-04-10.
//

import SwiftUI
import SwiftData

@main

struct AI_NotesApp: App {
    @AppStorage("hasSeenWelcome") var hasSeenWelcome: Bool = false
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("appLanguage") var appLanguage: String = "system"
    @StateObject private var authViewModel = AuthViewModel()
    
    @State private var showRegister = false
    @State private var showLogin = false

    @StateObject private var errorState = ErrorState()
    var body: some Scene {
        WindowGroup {
            Group {
                if !hasSeenWelcome {
                    WelcomeView(showLogin: $showLogin)
                } else if !isLoggedIn {
                    UserLoginView(
                        authVM: authViewModel,
                        onLoginSuccess: {
                            isLoggedIn = true
                        },
                        onRegisterRequest: {
                            showRegister = true
                        }
                    )
                    .sheet(isPresented: $showRegister) {
                        UserRegisterView(authVM: authViewModel)
                    }
                } else {
                    NotesHomeView()
                        .environmentObject(authViewModel)
                        .environmentObject(errorState)
                }
            }
            .environment(\.locale, Locale(identifier: appLanguage == "system" ? Locale.current.identifier : (appLanguage == "tr" ? "tr_TR" : (appLanguage == "en" ? "en_US" : (appLanguage == "ru" ? "ru_RU" : appLanguage)))))
            .id(appLanguage)
        }
        .modelContainer(ModelContainer.shared)
    }
}

