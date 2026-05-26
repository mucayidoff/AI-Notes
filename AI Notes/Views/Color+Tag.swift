import SwiftUI

private let tagColorsKey = "tagColors"

extension Color {
    // Base mapping fallback
    private static func defaultMapping(_ tag: String) -> Color {
        switch tag.lowercased() {
        case "iş": return .purple
        case "kişisel": return .blue
        case "okul": return .green
        case "fikirler": return .orange
        case "eğitim": return .teal
        default: return .gray
        }
    }

    // User-defined color storage
    static func userColor(for tag: String) -> Color? {
        guard let data = UserDefaults.standard.dictionary(forKey: tagColorsKey) as? [String: String],
              let hex = data[tag] else { return nil }
        return Color(hex: hex)
    }

    static func setUserColor(_ color: Color, for tag: String) {
        var dict = (UserDefaults.standard.dictionary(forKey: tagColorsKey) as? [String: String]) ?? [:]
        dict[tag] = color.toHex()
        UserDefaults.standard.set(dict, forKey: tagColorsKey)
    }

    // Suggested color based on tag hash
    static func suggestedColor(for tag: String) -> Color {
        let palette: [Color] = [.purple, .blue, .green, .orange, .teal, .pink, .indigo, .brown]
        let hash = abs(tag.lowercased().hashValue)
        return palette[hash % palette.count]
    }

    // Public API used by views
    static func forTag(_ tag: String) -> Color {
        if let user = userColor(for: tag) { return user }
        return defaultMapping(tag)
    }

    static func selectedForTag(_ tag: String) -> Color {
        // Slightly stronger/darker variant of the base color
        return Color.forTag(tag).opacity(0.85)
    }

    static func unselectedBackgroundForTag(_ tag: String) -> Color {
        // Light tint for unselected chips
        return Color.forTag(tag).opacity(0.25)
    }
}

// MARK: - Color <-> Hex helpers
extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&int) else { return nil }
        let a, r, g, b: UInt64
        switch hexSanitized.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        self = Color(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    func toHex() -> String {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgba: Int = (Int(a * 255) << 24) | (Int(r * 255) << 16) | (Int(g * 255) << 8) | Int(b * 255)
        return String(format: "%08X", rgba)
        #else
        return "FF7F7F7F" // fallback gray
        #endif
    }
}
