import Foundation
import SwiftUI

final class LocalizationManager: ObservableObject {
    @AppStorage("appLanguage") var language: String = "system" {
        didSet { objectWillChange.send() }
    }

    /// Returns the best language code to use ("en", "tr", "ru"), or system language code if set to system.
    private var resolvedCode: String {
        if language == "system" {
            if let code = Locale.current.language.languageCode?.identifier {
                return code
            }
            return "en"
        }
        return language
    }

    /// Manual localization lookup using the selected bundle. Falls back to English if missing.
    func localized(_ key: String) -> String {
        let code = resolvedCode
        // Try selected language bundle
        if let path = Bundle.main.path(forResource: code, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return NSLocalizedString(key, tableName: nil, bundle: bundle, value: key, comment: "")
        }
        // Fallback to English
        if let path = Bundle.main.path(forResource: "en", ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return NSLocalizedString(key, tableName: nil, bundle: bundle, value: key, comment: "")
        }
        // Ultimate fallback: return key
        return key
    }
}
