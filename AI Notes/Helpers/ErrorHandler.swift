//
//  ErrorHandler.swift
//  AI Notes
//
//  Created by mucayid on 2025-09-11.
//

import Foundation
import SwiftUI

struct ErrorHandler {
    /// Kullanıcıya hata mesajı gösterir
    static func showError(_ message: String, in view: some View) {
        // Bu fonksiyon gelecekte toast veya alert göstermek için kullanılabilir
        print("❌ Hata: \(message)")
    }
    
    /// Genel hata mesajlarını döndürür
    static func getErrorMessage(for error: Error) -> String {
        if let nsError = error as NSError? {
            switch nsError.code {
            case 1:
                return "E-posta zaten kayıtlı"
            case 2:
                return "Geçersiz e-posta adresi"
            case 3:
                return "Şifre çok kısa"
            default:
                return nsError.localizedDescription
            }
        }
        return error.localizedDescription
    }
}
