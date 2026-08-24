import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    let subject: String
    let body: String
    let recipients: [String]
    let attachments: [UIImage]
    @Environment(\.dismiss) private var dismiss

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView
        init(_ parent: MailView) { self.parent = parent }
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
            parent.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.setSubject(subject)
        vc.setToRecipients(recipients)
        vc.setMessageBody(body, isHTML: false)
        for (index, image) in attachments.enumerated() {
            if let data = image.jpegData(compressionQuality: 0.85) {
                vc.addAttachmentData(data, mimeType: "image/jpeg", fileName: "screenshot_\(index + 1).jpg")
            }
        }
        vc.mailComposeDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}

struct ProfileView: View {
    @ObservedObject var authVM: AuthViewModel
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("isGuestUser") private var isGuestUser = false
    @State private var showEditProfile = false

    @State private var showFeedback = false
    @State private var feedbackText: String = ""
    @State private var selectedImages: [UIImage] = []
    @State private var showImagePicker = false
    @State private var showMailComposer = false

    private let developerEmail = "mucayidofficial@gmail.com"
   // private let developerPhone = "+996551909247"
   // private let developerWebsite = "https://maigroup.com"

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    if isGuestUser {
                        
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                            .padding(.top, 24)
                        
                        Text("guest_user")
                            .font(.title)
                            .fontWeight(.bold)

                        Text("guest_mode")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 8)
                        
                        NavigationLink(destination: LanguageSettingsView()) {
                            HStack {
                                Image(systemName: "globe")
                                Text("language")
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray5))
                            )
                            .contentShape(Rectangle())
                        }
                        NavigationLink(destination: ReminderView()) {
                            HStack {
                                Image(systemName: "bell")
                                Text("reminders_title")

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray5))
                            )
                            .contentShape(Rectangle())
                        }
                        
                        Button("logout") {
                            logout()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        .controlSize(.large)
                        
                    } else if let user = authVM.currentUser {
                        
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.purple)
                            .padding(.top, 24)

                        Text(user.name)
                            .font(.title)
                            .fontWeight(.bold)

                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 8)

                        Spacer()

                        Button("edit_profile") {
                            showEditProfile = true
                        }
                        .accessibilityLabel("edit_profile")
                        .buttonStyle(.borderedProminent)
                        .tint(.purple)
                        .controlSize(.large)
                        .frame(maxWidth: .infinity, alignment: .center)

                        NavigationLink(destination: LanguageSettingsView()) {
                            HStack {
                                Image(systemName: "globe")
                                Text("language")

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray5))
                            )
                            .contentShape(Rectangle())
                        }

                        Button(action: {
                            showFeedback = true
                        }) {
                            HStack {
                                Image(systemName: "bubble.left.and.exclamationmark")
                                Text("send_feedback")

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray5))
                            )
                            .contentShape(Rectangle())
                        }

                        Button("Çıkış Yap") {
                            logout()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        .controlSize(.large)
                        .frame(maxWidth: .infinity, alignment: .center)

                        Spacer()

                    } else {

                        Text("user_not_found")
                            .foregroundColor(.gray)
                            .italic()
                    }
                }
                .padding(.horizontal)
                .padding(.top, 24)
            }
            .navigationTitle("profile_title")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !isGuestUser {
                        Button {
                            showEditProfile = true
                        } label: {
                            Image(systemName: "gearshape")
                        }
                        .accessibilityLabel("Profili Düzenle")
                    }
                }
            }
            .sheet(isPresented: $showEditProfile) {
                EditProfileView(authVM: authVM, showEdit: $showEditProfile)
            }
            .sheet(isPresented: $showFeedback) {
                FeedbackSheet
            }
        }
    }

    func logout() {
        authVM.logout()
        isGuestUser = false
        isLoggedIn = false
    }

    @ViewBuilder
    private var FeedbackSheet: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Group {
                        Text("feedback_your_feedback")
                            .font(.headline)
                        TextEditor(text: $feedbackText)
                            .frame(minHeight: 120)
                            .padding(8)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .textInputAutocapitalization(.sentences)
                            .disableAutocorrection(false)
                    }

                    Group {
                        HStack {
                            Text("feedback_images")
                                .font(.headline)
                            Spacer()
                            Button(action: { showImagePicker = true }) {
                                Label("add", systemImage: "plus")
                            }
                            .accessibilityLabel("add_image")
                        }

                        if selectedImages.isEmpty {
                            Text("no_images_added")
                                .foregroundColor(.secondary)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(Array(selectedImages.enumerated()), id: \.offset) { index, image in
                                        ZStack(alignment: .topTrailing) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .clipped()
                                                .cornerRadius(8)
                                            Button(action: { selectedImages.remove(at: index) }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.white)
                                                    .background(Color.black.opacity(0.6))
                                                    .clipShape(Circle())
                                                    .padding(4)
                                            }
                                            .offset(x: -6, y: 6)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Group {
                        Text("developer_contact")
                            .font(.headline)
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 4) {
                                Text("email_label")
                                Text(developerEmail)
                            }
                            //Text("Telefon: \(developerPhone)")
                           // Text("Web: \(developerWebsite)")
                                .foregroundColor(.blue)
                        }
                    }

                    Button(action: {
                        if MFMailComposeViewController.canSendMail() {
                            showMailComposer = true
                        } else {
                            // Fallback: copy to clipboard and open mailto
                            let paste = UIPasteboard.general
                            paste.string = feedbackText
                            if let url = URL(string: "mailto:\(developerEmail)?subject=Geri%20Bildirim&body=") {
                                UIApplication.shared.open(url)
                            }
                        }
                    }) {
                        Text("send")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.purple)
                    .controlSize(.large)
                    .disabled(feedbackText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()
                .padding(.bottom, 8)
            }
            .navigationTitle("feedback_title")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("close") {
                        showFeedback = false
                    }
                    .accessibilityLabel("close")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("send") {
                        if MFMailComposeViewController.canSendMail() {
                            showMailComposer = true
                        } else {
                            let paste = UIPasteboard.general
                            paste.string = feedbackText
                            if let url = URL(string: "mailto:\(developerEmail)?subject=Geri%20Bildirim&body=") {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                    .disabled(feedbackText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .sheet(isPresented: $showMailComposer) {
                MailView(
                    subject: String(localized: "feedback_mail_subject"),
                    body: feedbackText,
                    recipients: [developerEmail],
                    attachments: selectedImages
                )
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(images: $selectedImages)
            }
        }
    }
}

import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var images: [UIImage]

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 0 // unlimited
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            let providers = results.map { $0.itemProvider }
            for provider in providers where provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { object, _ in
                    if let image = object as? UIImage {
                        DispatchQueue.main.async {
                            self.parent.images.append(image)
                        }
                    }
                }
            }
        }
    }
}

