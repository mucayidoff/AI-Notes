import SwiftUI

public extension View {
    /// Dismisses the keyboard when the user taps outside editable fields.
    /// Attach this to a container view (e.g., VStack/ScrollView) to enable tap-to-dismiss.
    /// This is used in note creation and editing screens.
    func dismissKeyboardOnTap() -> some View {
        self.gesture(
            TapGesture().onEnded { _ in
                #if canImport(UIKit)
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                #else
                // No-op on platforms without UIKit
                #endif
            }
        )
    }
}
