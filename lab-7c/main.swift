
import UIKit

// MARK: - Main View Controller

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: UI Controls

    private let nameField = UITextField()
    private let notificationSwitch = UISwitch()

    private let courseSegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: [
            "CSE", "IT", "ECE"
        ])
        segment.selectedSegmentIndex = 0
        return segment
    }()

    private let progressSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 50
        return slider
    }()

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        return picker
    }()

    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit Settings", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = 10
        return button
    }()

    private let previewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Open Preview Screen", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        return button
    }()

    // MARK: Summary Panel

    private let summaryLabel: UILabel = {
        let label = UILabel()
        label.text = "Your settings will appear here."
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        label.numberOfLines = 0
        label.accessibilityLabel = "Settings summary"
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.font = .boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let mainStack = UIStackView()

    // MARK: Lifecycle - 1

    override func viewDidLoad() {
        super.viewDidLoad()

        print("ViewController: viewDidLoad")

        title = "UI Controls Lab"
        view.backgroundColor = .systemBackground

        setupControls()
        setupLayout()
        addActions()
        updateSummary()
    }

    // MARK: Lifecycle - 2

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("ViewController: viewWillAppear")

        updateSummary()
    }

    // MARK: Lifecycle - 3

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        print("ViewController: viewDidAppear")
    }

    // MARK: Lifecycle - 4

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        print("ViewController: viewWillDisappear")
    }

    // MARK: Lifecycle - 5

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        print("ViewController: viewDidDisappear")
    }

    // MARK: Configure Controls

    private func setupControls() {

        nameField.placeholder = "Enter your name"
        nameField.borderStyle = .roundedRect
        nameField.font = .systemFont(ofSize: 16)
        nameField.autocapitalizationType = .words
        nameField.returnKeyType = .done
        nameField.textContentType = .name
        nameField.accessibilityLabel = "Your name"
        nameField.accessibilityHint = "Enter your full name"
        nameField.delegate = self

        notificationSwitch.isOn = true
        notificationSwitch.accessibilityLabel = "Notifications"

        courseSegment.accessibilityLabel = "Select course"

        progressSlider.accessibilityLabel = "Progress percentage"

        datePicker.accessibilityLabel = "Select date"

        let labels = [
            nameField,
            notificationSwitch
        ]

        labels.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        nameField.heightAnchor.constraint(
            greaterThanOrEqualToConstant: 48
        ).isActive = true
    }

    // MARK: Layout

    private func setupLayout() {

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(mainStack)

        scrollView.keyboardDismissMode = .interactive

        mainStack.axis = .vertical
        mainStack.spacing = 18
        mainStack.alignment = .fill

        let heading = makeLabel(
            "Interactive Profile Settings",
            size: 25,
            bold: true
        )

        let nameTitle = makeLabel("Full Name", size: 16)
        let notificationTitle = makeLabel(
            "Enable Notifications",
            size: 16
        )
        let courseTitle = makeLabel("Select Course", size: 16)
        let progressTitle = makeLabel(
            "Course Progress",
            size: 16
        )
        let dateTitle = makeLabel(
            "Select Date",
            size: 16
        )
        let summaryTitle = makeLabel(
            "Live Summary",
            size: 20,
            bold: true
        )

        let notificationRow = UIStackView(
            arrangedSubviews: [
                notificationTitle,
                notificationSwitch
            ]
        )

        notificationRow.axis = .horizontal
        notificationRow.alignment = .center
        notificationRow.distribution = .equalSpacing

        let summaryBox = UIView()
        summaryBox.backgroundColor = .secondarySystemBackground
        summaryBox.layer.cornerRadius = 12
        summaryBox.addSubview(summaryLabel)
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            summaryLabel.topAnchor.constraint(
                equalTo: summaryBox.topAnchor,
                constant: 15
            ),
            summaryLabel.leadingAnchor.constraint(
                equalTo: summaryBox.leadingAnchor,
                constant: 15
            ),
            summaryLabel.trailingAnchor.constraint(
                equalTo: summaryBox.trailingAnchor,
                constant: -15
            ),
            summaryLabel.bottomAnchor.constraint(
                equalTo: summaryBox.bottomAnchor,
                constant: -15
            )
        ])

        mainStack.addArrangedSubview(heading)
        mainStack.addArrangedSubview(nameTitle)
        mainStack.addArrangedSubview(nameField)
        mainStack.addArrangedSubview(notificationRow)
        mainStack.addArrangedSubview(courseTitle)
        mainStack.addArrangedSubview(courseSegment)
        mainStack.addArrangedSubview(progressTitle)
        mainStack.addArrangedSubview(progressSlider)
        mainStack.addArrangedSubview(dateTitle)
        mainStack.addArrangedSubview(datePicker)
        mainStack.addArrangedSubview(summaryTitle)
        mainStack.addArrangedSubview(summaryBox)
        mainStack.addArrangedSubview(statusLabel)
        mainStack.addArrangedSubview(submitButton)
        mainStack.addArrangedSubview(previewButton)

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

            contentView.topAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.topAnchor
            ),
            contentView.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor
            ),
            contentView.leadingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.leadingAnchor
            ),
            contentView.trailingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.trailingAnchor
            ),
            contentView.widthAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.widthAnchor
            ),

            mainStack.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 25
            ),
            mainStack.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 22
            ),
            mainStack.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -22
            ),
            mainStack.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -25
            )
        ])

        submitButton.heightAnchor.constraint(
            greaterThanOrEqualToConstant: 50
        ).isActive = true

        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    // MARK: Helper Label

    private func makeLabel(
        _ text: String,
        size: CGFloat,
        bold: Bool = false
    ) -> UILabel {

        let label = UILabel()
        label.text = text
        label.font = bold
            ? .boldSystemFont(ofSize: size)
            : .systemFont(ofSize: size)
        label.textColor = .label
        label.numberOfLines = 0

        return label
    }

    // MARK: Control Actions

    private func addActions() {

        nameField.addTarget(
            self,
            action: #selector(controlsChanged),
            for: .editingChanged
        )

        notificationSwitch.addTarget(
            self,
            action: #selector(controlsChanged),
            for: .valueChanged
        )

        courseSegment.addTarget(
            self,
            action: #selector(controlsChanged),
            for: .valueChanged
        )

        progressSlider.addTarget(
            self,
            action: #selector(controlsChanged),
            for: .valueChanged
        )

        datePicker.addTarget(
            self,
            action: #selector(controlsChanged),
            for: .valueChanged
        )

        submitButton.addTarget(
            self,
            action: #selector(submitSettings),
            for: .touchUpInside
        )

        previewButton.addTarget(
            self,
            action: #selector(openPreview),
            for: .touchUpInside
        )
    }

    // MARK: Update Summary

    @objc private func controlsChanged() {
        updateSummary()
    }

    private func updateSummary() {

        let name = nameField.text?.isEmpty == false
            ? nameField.text!
            : "Not entered"

        let courses = ["CSE", "IT", "ECE"]

        let selectedCourse = courses[
            courseSegment.selectedSegmentIndex
        ]

        let notification = notificationSwitch.isOn
            ? "Enabled"
            : "Disabled"

        let progress = Int(progressSlider.value)

        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        let date = formatter.string(from: datePicker.date)

        summaryLabel.text = """
        Name: \(name)

        Course: \(selectedCourse)

        Notifications: \(notification)

        Progress: \(progress)%

        Selected Date: \(date)
        """
    }

    // MARK: Submit Button

    @objc private func submitSettings() {

        view.endEditing(true)
        updateSummary()

        let name = nameField.text?.trimmingCharacters(
            in: .whitespacesAndNewlines
        ) ?? ""

        guard !name.isEmpty else {
            statusLabel.textColor = .systemRed
            statusLabel.text = "Please enter your name."
            return
        }

        statusLabel.textColor = .systemGreen
        statusLabel.text = "Settings submitted successfully!"
    }

    // MARK: Navigation

    @objc private func openPreview() {

        view.endEditing(true)

        let preview = PreviewViewController(
            summary: summaryLabel.text ?? ""
        )

        navigationController?.pushViewController(
            preview,
            animated: true
        )
    }

    // MARK: Keyboard

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {

        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Second Screen

class PreviewViewController: UIViewController {

    private let summary: String

    init(summary: String) {
        self.summary = summary
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        print("Preview: viewDidLoad")

        title = "Settings Preview"
        view.backgroundColor = .systemBackground

        let label = UILabel()
        label.text = summary
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        label.accessibilityLabel = "Submitted settings preview"

        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 40
            ),
            label.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 25
            ),
            label.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -25
            )
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Preview: viewWillAppear")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Preview: viewDidAppear")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Preview: viewWillDisappear")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Preview: viewDidDisappear")
    }
}

// MARK: - Scene Delegate

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

        let rootVC = ViewController()

        let navigationController = UINavigationController(
            rootViewController: rootVC
        )

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        self.window = window
    }
}

// MARK: - App Delegate

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
