//
//  UserProfileView.swift
//  AI Notes
//
//  Created by mucayid on 2025-05-02.
//

import SwiftUI
import SwiftData

struct UserProfileView: View {
    @ObservedObject var authVM: AuthViewModel

    var body: some View {
        VStack(spacing: 20) {
            if let user = authVM.currentUser {
                VStack(spacing: 8) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.purple)

                    Text(user.name)
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text(user.email)
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
                .padding()

                Divider()

                NavigationLink(destination: ProfileView(authVM: authVM)) {
                    Label("Profili Düzenle", systemImage: "pencil")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray5))
                        .cornerRadius(12)
                }
                .padding(.horizontal)

                Spacer()
            } else {
                Text("Kullanıcı bilgisi yüklenemedi.")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .navigationTitle("Profilim")
        .navigationBarTitleDisplayMode(.inline)
    }
}


