
import SwiftUI

// MARK: - Main View
struct ContentView: View {

    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var eventType = "Technical Workshop"
    @State private var receiveUpdates = false

    @State private var showReview = false
    @State private var showSuccess = false
    @State private var errorMessage = ""

    let eventOptions = [
        "Technical Workshop",
        "Hackathon",
        "Coding Competition",
        "Tech Seminar"
    ]

    // MARK: - Validation
    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        isValidEmail(email) &&
        phone.filter { $0.isNumber }.count == 10
    }

    func isValidEmail(_ value: String) -> Bool {
        let parts = value.split(separator: "@")
        return parts.count == 2 &&
        parts[1].contains(".") &&
        !value.contains(" ")
    }

    var body: some View {
        NavigationStack {
            Form {

                // MARK: - Personal Information
                Section("Personal Information") {

                    TextField("Full Name", text: $name)
                        .textContentType(.name)
                        .textInputAutocapitalization(.words)

                    TextField("Email Address", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                    TextField("Phone Number", text: $phone)
                        .keyboardType(.phonePad)

                    if !email.isEmpty && !isValidEmail(email) {
                        Text("Please enter a valid email address.")
                            .foregroundColor(.red)
                            .font(.caption)
                    }

                    if !phone.isEmpty &&
                        phone.filter({ $0.isNumber }).count != 10 {
                        Text("Phone number must contain 10 digits.")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }

                // MARK: - Event Details
                Section("Event Details") {

                    Picker("Select Event", selection: $eventType) {
                        ForEach(eventOptions, id: \.self) { event in
                            Text(event).tag(event)
                        }
                    }

                    Toggle("Receive Event Updates",
                           isOn: $receiveUpdates)
                }

                // MARK: - Terms
                Section("Confirmation") {
                    Text("Please check your details before submitting your registration.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // MARK: - Submit Button
                Section {
                    Button {
                        if isFormValid {
                            showReview = true
                        } else {
                            errorMessage = "Please complete all fields correctly."
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text("Review Registration")
                                .fontWeight(.bold)
                            Spacer()
                        }
                    }
                    .disabled(!isFormValid)
                }

                if !errorMessage.isEmpty {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Event Registration")
            .navigationBarTitleDisplayMode(.inline)

            // MARK: - Review Screen
            .navigationDestination(isPresented: $showReview) {
                ReviewView(
                    name: name,
                    email: email,
                    phone: phone,
                    eventType: eventType,
                    receiveUpdates: receiveUpdates
                ) {
                    showReview = false
                    showSuccess = true
                }
            }

            // MARK: - Success Alert
            .alert("Registration Successful!",
                   isPresented: $showSuccess) {
                Button("OK", role: .cancel) {
                    name = ""
                    email = ""
                    phone = ""
                    eventType = "Technical Workshop"
                    receiveUpdates = false
                    errorMessage = ""
                }
            } message: {
                Text("Your event registration has been submitted successfully.")
            }
        }
    }
}

// MARK: - Review Screen
struct ReviewView: View {

    let name: String
    let email: String
    let phone: String
    let eventType: String
    let receiveUpdates: Bool
    let onConfirm: () -> Void

    var body: some View {
        Form {

            Section("Personal Information") {
                LabeledContent("Name", value: name)
                LabeledContent("Email", value: email)
                LabeledContent("Phone", value: phone)
            }

            Section("Event Information") {
                LabeledContent("Event", value: eventType)
                LabeledContent(
                    "Updates",
                    value: receiveUpdates ? "Yes" : "No"
                )
            }

            Section {
                Button(action: onConfirm) {
                    HStack {
                        Spacer()
                        Text("Confirm Registration")
                            .fontWeight(.bold)
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Review Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
