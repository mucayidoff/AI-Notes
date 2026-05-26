//
//  ReminderView.swift
//  AI Notes
//
//  Created by mucayid on 2025-04-12.
//

// Views/ReminderView.swift

import SwiftUI

struct ReminderView: View {
    @State private var reminders: [String] = []
    @State private var newReminder: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                HStack {
                    TextField("Yeni hatırlatma...", text: $newReminder)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: addReminder) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.purple)
                    }
                }
                .padding(.horizontal)

                if reminders.isEmpty {
                    Text("Henüz hatırlatma yok.")
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    List {
                        ForEach(reminders, id: \.self) { reminder in
                            Text(reminder)
                        }
                        .onDelete(perform: deleteReminder)
                    }
                }

                Spacer()
            }
            .navigationTitle("Hatırlatıcılar")
        }
    }

    func addReminder() {
        guard !newReminder.isEmpty else { return }
        reminders.append(newReminder)
        newReminder = ""
    }

    func deleteReminder(at offsets: IndexSet) {
        reminders.remove(atOffsets: offsets)
    }
}
#Preview {
    ReminderView()
}
