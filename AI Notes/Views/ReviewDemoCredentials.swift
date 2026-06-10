import Foundation

/// App Store incelemesi için demo hesap bilgileri ve yardımcı araçlar
/// Güvenlik notu: Bu bilgiler yalnızca inceleme/demonstrasyon amacıyla kullanılmalıdır.
/// Üretimde otomatik giriş yapmayın ve hassas veriler saklamayın.
public enum ReviewDemoCredentials {
    /// Demo e-posta
    public static let email: String = "review@ainotes.local"
    /// Demo şifre
    public static let password: String = "Review123"

    /// Demo modu açık mı?
    /// - Öncelik sırası: Process env > Info.plist (ReviewDemoEnabled) > false
    public static var isEnabled: Bool {
        // 1) Process env ile aç/kapat (ör. UI_TEST_REVIEW=1)
        if let env = ProcessInfo.processInfo.environment["UI_TEST_REVIEW"], env == "1" { return true }
        // 2) Info.plist anahtarı ile aç/kapat
        if let flag = Bundle.main.object(forInfoDictionaryKey: "ReviewDemoEnabled") as? Bool { return flag }
        return false
    }
}
