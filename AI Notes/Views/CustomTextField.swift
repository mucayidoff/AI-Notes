//
//  CustomTextField.swift
//  AI Notes
//
//  Created by mucayid on 2025-05-11.
//

import SwiftUI

struct CustomTextField: View {
    var title: String
    @Binding var text: String
    var contentType: UITextContentType? = nil
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        TextField(title, text: $text)
            .keyboardType(keyboardType)
            .textContentType(contentType)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
    }
}

struct CustomSecureField: View {
    var title: String
    @Binding var text: String
    @State private var isSecure: Bool = true

    var body: some View {
        HStack(spacing: 8) {
            Group {
                if isSecure {
                    SecureField(title, text: $text)
                        .textContentType(.password)
                } else {
                    TextField(title, text: $text)
                        .textContentType(.password)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                }
            }

            Button(action: { isSecure.toggle() }) {
                Image(systemName: isSecure ? "eye.slash" : "eye")
                    .foregroundColor(.secondary)
            }
            .accessibilityLabel(isSecure ? "Şifreyi göster" : "Şifreyi gizle")
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
