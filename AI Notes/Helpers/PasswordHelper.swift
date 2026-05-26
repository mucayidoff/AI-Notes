//
//  PasswordHelper.swift
//  AI Notes
//
//  Created by mucayid on 2025-09-11.
//

import Foundation
import CryptoKit

struct PasswordHelper {
    /// Şifreyi hash'ler
    static func hash(_ password: String) -> String {
        let data = Data(password.utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    /// Şifreyi doğrular
    static func verify(_ password: String, hashedPassword: String) -> Bool {
        return hash(password) == hashedPassword
    }
}
