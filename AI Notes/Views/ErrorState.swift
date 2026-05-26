import Foundation
import SwiftUI

final class ErrorState: ObservableObject {
    @Published var message: String? = nil

    func show(_ text: String) {
        message = text
    }

    func clear() {
        message = nil
    }
}
