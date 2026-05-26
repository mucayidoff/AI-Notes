import SwiftUI

struct FeedbackView: View {
    @State private var feedbackText = ""
    @State private var showSuccess = false

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Geri Bildirim")
                .font(.title)
                .bold()
                .padding(.top)

            Text("Uygulama hakkındaki görüşlerinizi bizimle paylaşın.")
                .foregroundColor(.secondary)

            TextEditor(text: $feedbackText)
                .frame(height: 180)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.systemGray4)))

            Button(action: sendFeedback) {
                HStack {
                    Image(systemName: "paperplane.fill")
                    Text("Gönder")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(feedbackText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray : Color.purple)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(feedbackText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

            if showSuccess {
                Label("Geri bildiriminiz alındı!", systemImage: "checkmark.seal.fill")
                    .foregroundColor(.green)
                    .transition(.opacity)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Geri Bildirim")
        .navigationBarTitleDisplayMode(.inline)
    }

    func sendFeedback() {
        withAnimation {
            showSuccess = true
        }
        feedbackText = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                showSuccess = false
            }
        }
    }
}

#Preview {
    NavigationView {
        FeedbackView()
    }
}
