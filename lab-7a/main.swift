
import UIKit

class ProfileViewController: UIViewController {

    // MARK: - UI Elements

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Your Profile"
        label.font = .boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        label.textColor = .systemBlue
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter your details below"
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()

    private let nameField = UITextField()
    private let emailField = UITextField()
    private let courseField = UITextField()

    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit Profile", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = 10
        return button
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    private let successLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let formStack = UIStackView()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Profile Form"

        setupTextFields()
        setupLayout()
        setupKeyboard()
    }

    // MARK: - Text Field Setup

    private func setupTextFields() {

        configureField(
            nameField,
            placeholder: "Enter your full name",
            icon: "person"
        )

        configureField(
            emailField,
            placeholder: "Enter your email",
            icon: "envelope"
        )

        configureField(
            courseField,
            placeholder: "Enter your course",
            icon: "book"
        )

        nameField.textContentType = .name
        nameField.autocapitalizationType = .words
        nameField.returnKeyType = .next

        emailField.keyboardType = .emailAddress
        emailField.textContentType = .emailAddress
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.returnKeyType = .next

        courseField.autocapitalizationType = .words
        courseField.returnKeyType = .done

        nameField.accessibilityLabel = "Full Name"
        emailField.accessibilityLabel = "Email Address"
        courseField.accessibilityLabel = "Course Name"

        nameField.delegate = self
        emailField.delegate = self
        courseField.delegate = self
    }

    private func configureField(
        _ field: UITextField,
        placeholder: String,
        icon: String
    ) {
        field.placeholder = placeholder
        field.borderStyle = .roundedRect
        field.font = .systemFont(ofSize: 16)
        field.clearButtonMode = .whileEditing
        field.heightAnchor.constraint(
            greaterThanOrEqualToConstant: 48
        ).isActive = true
        field.accessibilityHint = "Required field"
    }

    // MARK: - Auto Layout

    private func setupLayout() {

        formStack.axis = .vertical
        formStack.spacing = 18
        formStack.alignment = .fill
        formStack.translatesAutoresizingMaskIntoConstraints = false

        let headerStack = UIStackView(
            arrangedSubviews: [titleLabel, subtitleLabel]
        )
        headerStack.axis = .vertical
        headerStack.spacing = 8
        headerStack.alignment = .fill

        formStack.addArrangedSubview(headerStack)
        formStack.addArrangedSubview(nameField)
        formStack.addArrangedSubview(emailField)
        formStack.addArrangedSubview(courseField)
        formStack.addArrangedSubview(errorLabel)
        formStack.addArrangedSubview(submitButton)
        formStack.addArrangedSubview(successLabel)

        submitButton.heightAnchor.constraint(
            greaterThanOrEqualToConstant: 50
        ).isActive = true

        view.addSubview(formStack)

        NSLayoutConstraint.activate([

            formStack.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 24
            ),

            formStack.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -24
            ),

            formStack.centerYAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerYAnchor
            ),

            formStack.topAnchor.constraint(
                greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 20
            ),

            formStack.bottomAnchor.constraint(
                lessThanOrEqualTo: view.keyboardLayoutGuide.topAnchor,
                constant: -20
            )
        ])

        submitButton.addTarget(
            self,
            action: #selector(submitTapped),
            for: .touchUpInside
        )

        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )

        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    // MARK: - Keyboard

    private func setupKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(dismissKeyboard)
        )

        toolbar.items = [doneButton]

        nameField.inputAccessoryView = toolbar
        emailField.inputAccessoryView = toolbar
        courseField.inputAccessoryView = toolbar
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Validation

    @objc private func submitTapped() {

        view.endEditing(true)

        errorLabel.isHidden = true
        successLabel.text = ""

        let name = nameField.text?.trimmingCharacters(
            in: .whitespacesAndNewlines
        ) ?? ""

        let email = emailField.text?.trimmingCharacters(
            in: .whitespacesAndNewlines
        ) ?? ""

        let course = courseField.text?.trimmingCharacters(
            in: .whitespacesAndNewlines
        ) ?? ""

        if name.isEmpty {
            showError("Please enter your name.")
            nameField.becomeFirstResponder()
            return
        }

        if !isValidEmail(email) {
            showError("Please enter a valid email address.")
            emailField.becomeFirstResponder()
            return
        }

        if course.isEmpty {
            showError("Please enter your course.")
            courseField.becomeFirstResponder()
            return
        }

        successLabel.text = """
        Profile Submitted Successfully!

        Name: \(name)
        Email: \(email)
        Course: \(course)
        """

        errorLabel.isHidden = true
    }

    private func isValidEmail(_ email: String) -> Bool {

        let emailRegex =
        #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#

        return email.range(
            of: emailRegex,
            options: .regularExpression
        ) != nil
    }

    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        successLabel.text = ""
    }
}

// MARK: - Text Field Delegate

extension ProfileViewController: UITextFieldDelegate {

    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {

        if textField == nameField {
            emailField.becomeFirstResponder()
        } else if textField == emailField {
            courseField.becomeFirstResponder()
        } else {
            dismissKeyboard()
        }

        return true
    }
}

// MARK: - App Entry Point

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        window?.rootViewController = UINavigationController(
            rootViewController: ProfileViewController()
        )

        window?.makeKeyAndVisible()

        return true
    }
}
