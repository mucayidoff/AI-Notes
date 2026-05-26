//
//  TagSuggester.swift
//  AI Notes
//
//  Created by mucayid on 2025-06-28.
//

// Helpers/TagSuggester.swift

import Foundation
import NaturalLanguage

struct TagSuggester {
    static func suggestTag(for text: String) -> String {
        let tagKeywords: [String: [String]] = [
            "İş": ["toplantı", "sunum", "proje", "müşteri", "iş", "rapor"],
            "Okul": ["ders", "sınav", "okul", "ödev", "eğitim"],
            "Kişisel": ["günlük", "duygu", "kişisel", "hayat", "anı"],
            "Fikirler": ["fikir", "öneri", "plan", "düşünce", "not"]
        ]
        
        let tagScores = tagKeywords.mapValues { keywords in
            keywords.reduce(0) { count, keyword in
                count + (text.localizedCaseInsensitiveContains(keyword) ? 1 : 0)
            }
        }

        if let bestTag = tagScores.max(by: { $0.value < $1.value })?.key, tagScores[bestTag]! > 0 {
            return bestTag
        }

        return "Tümü"
    }
}

