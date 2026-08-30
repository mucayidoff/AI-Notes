//
//  NewNoteView.swift
//  AI Notes
//
import SwiftUI
import SwiftData
import NaturalLanguage
import Speech
import AVFoundation
import UIKit

struct NewNoteView: View {
    var existingNote: Note? = nil

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var errorState: ErrorState

    @State private var title = ""
    @State private var content = ""
    @State private var summary = ""
    @State private var speechBaseContent = ""
    @State private var isSummarizing = false
    @State private var detectedLanguage: String = ""
    @State private var keywords: [String] = []
    @State private var isRecording = false
    @State private var suggestedTag: String = ""
    @State private var showAddTagSheet = false
    @State private var summaryLimit: Int = 120
    @State private var hasMicPermission: Bool = false
    @State private var hasSpeechPermission: Bool = false
    @AppStorage("appLanguage") private var appLanguage: String = "system"
    @State private var selectedLocale: String = "tr-TR"

    @ObservedObject var tagStore: TagStore

    private let audioEngine = AVAudioEngine()
    @State private var speechRequest: SFSpeechAudioBufferRecognitionRequest? = nil
    @State private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "tr-TR"))
    @State private var recognitionTask: SFSpeechRecognitionTask?
    @FocusState private var titleIsFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                TextField("note_title_placeholder", text: $title)
                    .font(.body)
                    .textInputAutocapitalization(.sentences)
                    .focused($titleIsFocused)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 15)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                ZStack(alignment: .topLeading) {
                    if content.isEmpty {
                        Text("note_content_placeholder")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 22)
                    }
                    TextEditor(text: $content)
                        .frame(height: 200)
                        .padding()
                        .accessibilityLabel(String(localized: "note content placeholder"))
                        .textInputAutocapitalization(.sentences)
                        .autocorrectionDisabled(false)
                }
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke((title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) ? Color.red.opacity(0.4) : Color.clear, lineWidth: 1)
                )

                Button(action: detectSuggestedTag) {
                    HStack {
                        Image(systemName: "wand.and.stars")
                        Text("predict_tag")
                    }
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray5)))
                    .contentShape(Rectangle())
                }

                if !suggestedTag.isEmpty {
                    let localizedTag = String(localized: String.LocalizationValue(suggestedTag))

                    Text(
                        String(
                            format: String(localized: "predicted_tag_format"),
                            localizedTag
                        )
                    )
                    .font(.footnote)
                    .foregroundColor(.gray)
                }

                HStack(alignment: .top, spacing: 8) {
                    Button {
                        showAddTagSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                            
                    }

                    TagSelectorView(tags: $tagStore.tags, selectedTag: $tagStore.selectedTag)
                        .padding(.vertical, 4)
                }

                Text("ai_summary_title")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 6) {
                    TextField("summary_placeholder", text: $summary)
                        .onChange(of: summary) { _, newValue in
                            if newValue.count > summaryLimit {
                                summary = String(newValue.prefix(summaryLimit))
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(summary.isEmpty ? Color.clear : Color.purple.opacity(0.3), lineWidth: 1)
                        )

                    HStack {
                        Spacer()
                        Text("\(summary.count)/\(summaryLimit)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Button {
                    autoSummarize()
                } label: {
                    Label("auto_summarize", systemImage: "wand.and.stars")
                }
                .buttonStyle(.borderedProminent)
                .tint(.purple)

                // Diğer NLP / Mic butonların (özetle, dil algıla, konuşmayı başlat/durdur, anahtar kelime çıkar) burada kalabilir

                HStack(spacing: 12) {
                    Button {
                        requestMicPermissionIfNeeded()
                        requestSpeechPermissionIfNeeded()
                    } label: {
                        Label(
                            "permission_check",
                            systemImage: hasMicPermission && hasSpeechPermission ? "checkmark.shield" : "shield"
                        )
                    }
                    .buttonStyle(.bordered)
                    .accessibilityLabel(String(localized: "permission_check"))

                    Button {
                        startRecordingFlow()
                    } label: {
                        Label {
                            if isRecording {
                                Text("recording_in_progress")
                            } else {
                                Text("start")
                            }
                        } icon: {
                            Image(systemName: isRecording ? "waveform" : "mic")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.purple)
                    .disabled(isRecording)
                    .accessibilityLabel(
                        isRecording
                        ? String(localized: "recording_in_progress")
                        : String(localized: "start")
                    )

                    Button {
                        stopSpeechRecognition()
                    } label: {
                        Label("stop", systemImage: "stop.fill")
                    }
                    .buttonStyle(.bordered)
                    .disabled(!isRecording)
                    .accessibilityLabel(String(localized: "stop"))
                }

                Spacer()

                Button(action: saveNote) {
                    Label("save", systemImage: "square.and.arrow.down")
                }
                .buttonStyle(.borderedProminent)
                .tint(.purple)
                .controlSize(.large)
                .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .accessibilityLabel(String(localized: "save"))
            }
            .padding()
            .navigationTitle(
                existingNote == nil
                ? LocalizedStringKey("new_note_title")
                : LocalizedStringKey("edit_note_title")
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .accessibilityLabel(String(localized: "close"))
                }
            }
            .onDisappear { stopSpeechRecognition() }
            .onAppear {
                preloadIfEditing()
                checkInitialMicPermission()
                
                // App dil ayarına göre speech recognition locale'ini ayarla
                let localeIdentifier = appLanguage == "system" ? Locale.current.identifier : (appLanguage == "tr" ? "tr-TR" : (appLanguage == "en" ? "en-US" : (appLanguage == "ru" ? "ru-RU" : "tr-TR")))
                self.selectedLocale = localeIdentifier
                self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: localeIdentifier))

                self.titleIsFocused = true
            }
        }
        .alert(String(localized: "alert_title"), isPresented: .constant(errorState.message != nil), actions: {
            Button(String(localized: "go_to_settings")) {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
                errorState.clear()
            }
            Button(String(localized: "ok")) { errorState.clear() }
        }, message: {
            Text(errorState.message ?? "")
        })
        .sheet(isPresented: $showAddTagSheet) {
            AddTagView { newTag in
                tagStore.addTag(newTag)
                showAddTagSheet = false
            }
        }
    }

    private func saveNote() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedTitle.isEmpty || trimmedContent.isEmpty {
            errorState.show(String(localized: "title_content_required"))
            return
        }
        let defaultSummary = String(trimmedContent.prefix(120))

        if let note = existingNote {
            note.title = trimmedTitle
            note.content = trimmedContent
            note.summary = summary.isEmpty ? defaultSummary : summary
            note.tag = suggestedTag.isEmpty ? tagStore.selectedTag : suggestedTag
            note.updatedDate = .now
        } else {
            let note = Note(
                title: trimmedTitle,
                summary: summary.isEmpty ? defaultSummary : summary,
                content: trimmedContent,
                tag: suggestedTag.isEmpty ? tagStore.selectedTag : suggestedTag,
                updatedDate: .now
            )
            modelContext.insert(note)
        }

        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("💥 Not kaydedilemedi: \(error.localizedDescription)")
            errorState.show(String(format: NSLocalizedString("note_save_failed_format", comment: "Note save failed"), error.localizedDescription))
        }
    }

    private func preloadIfEditing() {
        guard let note = existingNote else { return }
        self.title = note.title
        self.content = note.content
        self.summary = note.summary
        tagStore.selectedTag = note.tag
    }

    // MARK: - NLP (örnekler)
    private func detectSuggestedTag() {
        let lower = content.lowercased()

        if lower.contains("toplantı") ||
            lower.contains("meeting") ||
            lower.contains("работа") {
            suggestedTag = "work_tag"

        } else if lower.contains("kitap") ||
                    lower.contains("book") ||
                    lower.contains("книга") {
            suggestedTag = "personal_tag"

        } else if lower.contains("ders") ||
                    lower.contains("lesson") ||
                    lower.contains("урок") {
            suggestedTag = "school_tag"

        } else {
            suggestedTag = "ideas_tag"
        }
    }

    private func stopSpeechRecognition() {
        if audioEngine.isRunning {
            audioEngine.stop()
            speechRequest?.endAudio()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        recognitionTask?.cancel()
        recognitionTask = nil
        speechRequest = nil
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        isRecording = false
    }

    private func requestMicPermissionIfNeeded() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                self.hasMicPermission = granted
                if !granted {
                    self.errorState.show(String(localized: "mic_permission_denied"))
                }
            }
        }
    }

    private func requestSpeechPermissionIfNeeded() {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    hasSpeechPermission = true
                case .denied, .restricted:
                    hasSpeechPermission = false
                    errorState.show(String(localized: "speech_permission_denied"))
                case .notDetermined:
                    hasSpeechPermission = false
                @unknown default:
                    hasSpeechPermission = false
                }
            }
        }
    }
    
    private func startRecordingFlow() {
        AVAudioSession.sharedInstance().requestRecordPermission { micGranted in
            DispatchQueue.main.async {
                self.hasMicPermission = micGranted

                guard micGranted else {
                    self.errorState.show(
                        String(localized: "mic_permission_denied")
                    )
                    return
                }

                SFSpeechRecognizer.requestAuthorization { status in
                    DispatchQueue.main.async {
                        self.hasSpeechPermission = status == .authorized

                        guard status == .authorized else {
                            self.errorState.show(
                                String(localized: "speech_permission_denied")
                            )
                            return
                        }

                        self.startSpeechRecognition()
                    }
                }
            }
        }
    }
    
    

    private func startSpeechRecognition() {

        guard hasMicPermission else {
            errorState.show(String(localized: "mic_required"))
            return
        }

        guard hasSpeechPermission else {
            errorState.show(String(localized: "speech_required"))
            return
        }

        guard speechRecognizer?.isAvailable == true else {
            errorState.show(String(localized: "speech_unavailable"))
            return
        }

        guard !audioEngine.isRunning else { return }

        speechBaseContent = content

        recognitionTask?.cancel()
        recognitionTask = nil

        speechRequest = SFSpeechAudioBufferRecognitionRequest()
        speechRequest?.shouldReportPartialResults = true

        do {
            let audioSession = AVAudioSession.sharedInstance()

            try audioSession.setCategory(
                .record,
                mode: .measurement,
                options: .duckOthers
            )

            try audioSession.setActive(
                true,
                options: .notifyOthersOnDeactivation
            )

            let inputNode = audioEngine.inputNode

            inputNode.removeTap(onBus: 0)

            let recordingFormat = inputNode.outputFormat(forBus: 0)

            inputNode.installTap(
                onBus: 0,
                bufferSize: 1024,
                format: recordingFormat
            ) { buffer, _ in
                speechRequest?.append(buffer)
            }

            audioEngine.prepare()
            try audioEngine.start()

            isRecording = true

            recognitionTask = speechRecognizer?.recognitionTask(
                with: speechRequest!
            ) { result, error in

                if let result = result {
                    let transcript = result.bestTranscription.formattedString

                    DispatchQueue.main.async {
                        if self.speechBaseContent.isEmpty {
                            self.content = transcript
                        } else {
                            self.content =
                                self.speechBaseContent + " " + transcript
                        }
                    }
                }

                if error != nil || (result?.isFinal ?? false) {
                    DispatchQueue.main.async {
                        self.stopSpeechRecognition()
                    }
                }
            }

        } catch {
            isRecording = false

            errorState.show(
                String(
                    format: NSLocalizedString(
                        "speech_start_failed_format",
                        comment: "Speech start failed"
                    ),
                    error.localizedDescription
                )
            )
        }
    }


    private func checkInitialMicPermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            hasMicPermission = true
        case .denied:
            hasMicPermission = false
        case .undetermined:
            hasMicPermission = false
        @unknown default:
            hasMicPermission = false
        }
        switch SFSpeechRecognizer.authorizationStatus() {
        case .authorized:
            hasSpeechPermission = true
        case .denied, .restricted, .notDetermined:
            hasSpeechPermission = false
        @unknown default:
            hasSpeechPermission = false
        }
    }

    private func autoSummarize() {
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedContent.isEmpty {
            errorState.show(String(localized: "summary_content_required"))
            return
        }
        // Basit kural: ilk 2 cümleden 120 karakter
        let sentences = trimmedContent.split(separator: ".")
        let pick = sentences.prefix(2).joined(separator: ". ")
        let candidate = pick.isEmpty ? trimmedContent : pick
        let result = String(candidate.prefix(summaryLimit))
        self.summary = result
    }
}

#Preview("Edit Mode") {
    let tagStore = TagStore()
    let errorState = ErrorState()
    
    let sampleNote = Note(
        title: "Test Başlık",
        summary: "Test özet",
        content: "Bu bir test notudur.",
        tag: "İş",
        updatedDate: .now
    )
    
    return NewNoteView(existingNote: sampleNote, tagStore: tagStore)
        .environmentObject(errorState)
        .modelContainer(for: Note.self, inMemory: true)
}
