
import SwiftUI
import XCTest

// MARK: - APP UI

struct ContentView: View {

    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    @State private var isSuccess = false

    private var isFormValid: Bool {
        let validName = name.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).count >= 2

        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#

        let validEmail = email.range(
            of: pattern,
            options: .regularExpression
        ) != nil

        return validName && validEmail
    }

    var body: some View {
        NavigationStack {
            Form {

                Section("Personal Details") {

                    TextField("Enter your name", text: $name)
                        .accessibilityIdentifier("nameField")

                    TextField("Enter your email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .accessibilityIdentifier("emailField")
                }

                Section {

                    Button("Submit") {
                        if isFormValid {
                            message = "Registration successful!"
                            isSuccess = true
                        } else {
                            message = "Please enter a valid name and email."
                            isSuccess = false
                        }
                    }
                    .accessibilityIdentifier("submitButton")
                }

                if !message.isEmpty {
                    Section("Result") {
                        Text(message)
                            .accessibilityIdentifier("resultMessage")
                            .foregroundStyle(
                                isSuccess ? .green : .red
                            )
                    }
                }
            }
            .navigationTitle("Registration Form")
        }
    }
}

// MARK: - UI TESTS
// XCTest code must be added to a UI Testing target.
// It is included here to keep the example in one place.

final class RegistrationUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }

    // Test 1: App launches

    func testAppLaunches() {
        XCTAssertTrue(
            app.navigationBars["Registration Form"]
                .waitForExistence(timeout: 5)
        )

        XCTAssertTrue(app.textFields["nameField"].exists)
        XCTAssertTrue(app.textFields["emailField"].exists)
        XCTAssertTrue(app.buttons["submitButton"].exists)
    }

    // Test 2: Successful form submission

    func testValidFormSubmission() {
        let name = app.textFields["nameField"]
        let email = app.textFields["emailField"]

        XCTAssertTrue(name.waitForExistence(timeout: 5))

        name.tap()
        name.typeText("Pratik")

        email.tap()
        email.typeText("pratik@example.com")

        app.buttons["submitButton"].tap()

        let result = app.staticTexts["resultMessage"]

        XCTAssertTrue(result.waitForExistence(timeout: 5))
        XCTAssertEqual(result.label, "Registration successful!")
    }

    // Test 3: Empty form validation

    func testEmptyFormValidation() {
        app.buttons["submitButton"].tap()

        let result = app.staticTexts["resultMessage"]

        XCTAssertTrue(result.waitForExistence(timeout: 5))

        XCTAssertEqual(
            result.label,
            "Please enter a valid name and email."
        )
    }

    // Test 4: Invalid email validation

    func testInvalidEmailValidation() {
        let name = app.textFields["nameField"]
        let email = app.textFields["emailField"]

        name.tap()
        name.typeText("Pratik")

        email.tap()
        email.typeText("wrong-email")

        app.buttons["submitButton"].tap()

        let result = app.staticTexts["resultMessage"]

        XCTAssertTrue(result.waitForExistence(timeout: 5))

        XCTAssertEqual(
            result.label,
            "Please enter a valid name and email."
        )
    }

    // Test 5: Valid email and name

    func testSuccessMessageIsVisible() {
        let name = app.textFields["nameField"]
        let email = app.textFields["emailField"]

        name.tap()
        name.typeText("Rahul")

        email.tap()
        email.typeText("rahul@gmail.com")

        app.buttons["submitButton"].tap()

        XCTAssertTrue(
            app.staticTexts["Registration successful!"]
                .waitForExistence(timeout: 5)
        )
    }
}
