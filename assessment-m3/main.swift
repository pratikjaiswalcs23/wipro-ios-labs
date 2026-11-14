
import UIKit

// MARK: - MODEL (CODABLE)

struct User: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String
    let website: String
}

// MARK: - APP DELEGATE

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession:
        UISceneSession,
        options: UISceneSession.ConnectionOptions
    ) -> UISceneConfiguration {

        let config = UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )

        config.delegateClass = SceneDelegate.self
        return config
    }
}

// MARK: - SCENE DELEGATE

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {

        guard let windowScene = scene as? UIWindowScene else {
            return
        }

        let window = UIWindow(windowScene: windowScene)

        let listVC = UserListViewController()

        let navigationController = UINavigationController(
            rootViewController: listVC
        )

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        self.window = window
    }
}

// MARK: - SCREEN 1: PROFILE FORM

class ProfileFormViewController:
    UIViewController,
    UITextFieldDelegate {

    private let nameField = UITextField()
    private let emailField = UITextField()
    private let courseField = UITextField()

    private let errorLabel = UILabel()

    private let submitButton = UIButton(type: .system)

    private let scrollView = UIScrollView()
    private let formStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile Form"
        view.backgroundColor = .systemBackground

        setupFields()
        setupLayout()
        setupKeyboard()
    }

    // MARK: Setup Fields

    private func setupFields() {

        configureField(
            nameField,
            placeholder: "Enter your name"
        )

        configureField(
            emailField,
            placeholder: "Enter your email"
        )

        configureField(
            courseField,
            placeholder: "Enter your course"
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

        nameField.accessibilityLabel = "Full name"
        emailField.accessibilityLabel = "Email address"
        courseField.accessibilityLabel = "Course name"

        nameField.delegate = self
        emailField.delegate = self
        courseField.delegate = self

        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 0
        errorLabel.font = .systemFont(ofSize: 14)

        submitButton.setTitle(
            "Submit Profile",
            for: .normal
        )

        submitButton.backgroundColor = .systemBlue
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 10
        submitButton.heightAnchor.constraint(
            greaterThanOrEqualToConstant: 50
        ).isActive = true

        submitButton.addTarget(
            self,
            action: #selector(submitForm),
            for: .touchUpInside
        )
    }

    private func configureField(
        _ field: UITextField,
        placeholder: String
    ) {

        field.placeholder = placeholder
        field.borderStyle = .roundedRect
        field.font = .systemFont(ofSize: 16)
        field.clearButtonMode = .whileEditing
        field.heightAnchor.constraint(
            greaterThanOrEqualToConstant: 48
        ).isActive = true
    }

    // MARK: Auto Layout

    private func setupLayout() {

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        formStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(formStack)

        formStack.axis = .vertical
        formStack.spacing = 18
        formStack.alignment = .fill

        let heading = UILabel()
        heading.text = "Create Your Profile"
        heading.font = .boldSystemFont(ofSize: 27)
        heading.textAlignment = .center

        let nameTitle = makeLabel("Full Name")
        let emailTitle = makeLabel("Email")
        let courseTitle = makeLabel("Course")

        formStack.addArrangedSubview(heading)
        formStack.addArrangedSubview(nameTitle)
        formStack.addArrangedSubview(nameField)
        formStack.addArrangedSubview(emailTitle)
        formStack.addArrangedSubview(emailField)
        formStack.addArrangedSubview(courseTitle)
        formStack.addArrangedSubview(courseField)
        formStack.addArrangedSubview(errorLabel)
        formStack.addArrangedSubview(submitButton)

        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),

            scrollView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),

            scrollView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),

            scrollView.bottomAnchor.constraint(
                equalTo: view.keyboardLayoutGuide.topAnchor
            ),

            formStack.topAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.topAnchor,
                constant: 30
            ),

            formStack.leadingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.leadingAnchor,
                constant: 25
            ),

            formStack.trailingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.trailingAnchor,
                constant: -25
            ),

            formStack.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor,
                constant: -30
            ),

            formStack.widthAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.widthAnchor,
                constant: -50
            )
        ])

        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func makeLabel(_ text: String) -> UILabel {

        let label = UILabel()
        label.text = text
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }

    // MARK: Keyboard

    private func setupKeyboard() {

        scrollView.keyboardDismissMode = .interactive
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

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

    // MARK: Validation

    @objc private func submitForm() {

        dismissKeyboard()

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
            showError("Please enter a valid email.")
            emailField.becomeFirstResponder()
            return
        }

        if course.isEmpty {
            showError("Please enter your course.")
            courseField.becomeFirstResponder()
            return
        }

        errorLabel.text = ""

        let alert = UIAlertController(
            title: "Success",
            message: """
            Profile submitted successfully!

            Name: \(name)
            Email: \(email)
            Course: \(course)
            """,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "OK", style: .default)
        )

        present(alert, animated: true)
    }

    private func isValidEmail(_ email: String) -> Bool {

        let pattern =
        #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#

        return email.range(
            of: pattern,
            options: .regularExpression
        ) != nil
    }

    private func showError(_ message: String) {

        errorLabel.text = message
    }
}

// MARK: - SCREEN 2: USER LIST / NETWORKING

class UserListViewController:
    UIViewController,
    UITableViewDataSource,
    UITableViewDelegate {

    private var users: [User] = []

    private let endpoint =
        "https://jsonplaceholder.typicode.com/users"

    private let tableView = UITableView(
        frame: .zero,
        style: .insetGrouped
    )

    private let activityIndicator = UIActivityIndicatorView(
        style: .large
    )

    private let messageLabel = UILabel()

    private let retryButton = UIButton(type: .system)

    private let stateStack = UIStackView()

    private var fetchTask: Task<Void, Never>?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "User Directory"
        view.backgroundColor = .systemBackground

        setupTableView()
        setupStateView()
        setupNavigation()

        fetchUsers()
    }

    // MARK: Setup Navigation

    private func setupNavigation() {

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Profile Form",
            style: .plain,
            target: self,
            action: #selector(openForm)
        )
    }

    @objc private func openForm() {

        let formVC = ProfileFormViewController()

        navigationController?.pushViewController(
            formVC,
            animated: true
        )
    }

    // MARK: Table View

    private func setupTableView() {

        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "UserCell"
        )

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 75

        view.addSubview(tableView)

        NSLayoutConstraint.activate([

            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),

            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),

            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),

            tableView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            )
        ])
    }

    // MARK: Loading / Empty / Error State

    private func setupStateView() {

        stateStack.axis = .vertical
        stateStack.spacing = 15
        stateStack.alignment = .center
        stateStack.translatesAutoresizingMaskIntoConstraints = false

        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 16)

        retryButton.setTitle("Retry", for: .normal)

        retryButton.addTarget(
            self,
            action: #selector(retryFetch),
            for: .touchUpInside
        )

        stateStack.addArrangedSubview(activityIndicator)
        stateStack.addArrangedSubview(messageLabel)
        stateStack.addArrangedSubview(retryButton)

        view.addSubview(stateStack)

        NSLayoutConstraint.activate([

            stateStack.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),

            stateStack.centerYAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerYAnchor
            ),

            stateStack.leadingAnchor.constraint(
                greaterThanOrEqualTo: view.leadingAnchor,
                constant: 25
            ),

            stateStack.trailingAnchor.constraint(
                lessThanOrEqualTo: view.trailingAnchor,
                constant: -25
            )
        ])
    }

    private func showLoading() {

        tableView.isHidden = true
        stateStack.isHidden = false

        activityIndicator.startAnimating()

        messageLabel.text = "Loading users..."

        retryButton.isHidden = true
    }

    private func showEmpty() {

        activityIndicator.stopAnimating()

        tableView.isHidden = true
        stateStack.isHidden = false

        messageLabel.text = "No users found."

        retryButton.isHidden = false
    }

    private func showFailure(_ message: String) {

        activityIndicator.stopAnimating()

        tableView.isHidden = true
        stateStack.isHidden = false

        messageLabel.text = message

        retryButton.isHidden = false
    }

    private func showUsers() {

        activityIndicator.stopAnimating()

        stateStack.isHidden = true
        tableView.isHidden = false

        tableView.reloadData()
    }

    // MARK: API Networking

    private func fetchUsers() {

        fetchTask?.cancel()

        guard let url = URL(string: endpoint) else {
            showFailure("Invalid API URL.")
            return
        }

        showLoading()

        fetchTask = Task {

            do {

                let (data, response) =
                    try await URLSession.shared.data(from: url)

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode)
                else {
                    throw URLError(.badServerResponse)
                }

                let decodedUsers = try JSONDecoder().decode(
                    [User].self,
                    from: data
                )

                guard !Task.isCancelled else {
                    return
                }

                await MainActor.run {

                    self.users = decodedUsers

                    if decodedUsers.isEmpty {
                        self.showEmpty()
                    } else {
                        self.showUsers()
                    }
                }

            } catch {

                guard !Task.isCancelled else {
                    return
                }

                await MainActor.run {

                    self.showFailure(
                        "Unable to load users.\nPlease check your internet connection."
                    )
                }
            }
        }
    }

    @objc private func retryFetch() {
        fetchUsers()
    }

    deinit {
        fetchTask?.cancel()
    }

    // MARK: Table Data Source

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        return users.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "UserCell",
            for: indexPath
        )

        let user = users[indexPath.row]

        var content = cell.defaultContentConfiguration()

        content.text = user.name
        content.secondaryText = user.email

        content.textProperties.font = .boldSystemFont(ofSize: 17)
        content.secondaryTextProperties.color = .secondaryLabel

        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    // MARK: Navigation to Detail

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

        tableView.deselectRow(at: indexPath, animated: true)

        guard users.indices.contains(indexPath.row) else {
            return
        }

        let selectedUser = users[indexPath.row]

        let detailVC = UserDetailViewController(
            user: selectedUser
        )

        navigationController?.pushViewController(
            detailVC,
            animated: true
        )
    }
}

// MARK: - SCREEN 3: USER DETAIL

class UserDetailViewController: UIViewController {

    private let user: User

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "User Details"
        view.backgroundColor = .systemBackground

        setupDetails()
    }

    private func setupDetails() {

        let nameLabel = makeLabel(
            "Name: \(user.name)",
            bold: true
        )

        let usernameLabel = makeLabel(
            "Username: \(user.username)"
        )

        let emailLabel = makeLabel(
            "Email: \(user.email)"
        )

        let phoneLabel = makeLabel(
            "Phone: \(user.phone)"
        )

        let websiteLabel = makeLabel(
            "Website: \(user.website)"
        )

        let stack = UIStackView(
            arrangedSubviews: [
                nameLabel,
                usernameLabel,
                emailLabel,
                phoneLabel,
                websiteLabel
            ]
        )

        stack.axis = .vertical
        stack.spacing = 22
        stack.alignment = .fill

        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([

            stack.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 35
            ),

            stack.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 25
            ),

            stack.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -25
            )
        ])
    }

    private func makeLabel(
        _ text: String,
        bold: Bool = false
    ) -> UILabel {

        let label = UILabel()

        label.text = text
        label.numberOfLines = 0

        label.font = bold
            ? .boldSystemFont(ofSize: 22)
            : .systemFont(ofSize: 17)

        label.textColor = .label

        return label
    }
}
