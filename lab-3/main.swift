import SwiftUI
import UIKit

// MARK: - Main App Screen

struct ContentView: View {

    @State private var selectedScreen = 0

    var body: some View {

        NavigationStack {

            VStack {

                Picker("Select UI", selection: $selectedScreen) {

                    Text("SwiftUI").tag(0)
                    Text("UIKit").tag(1)

                }
                .pickerStyle(.segmented)
                .padding()

                if selectedScreen == 0 {

                    SwiftUIScreen()

                } else {

                    UIKitScreenRepresentable()
                }

                Spacer()
            }
            .navigationTitle("UI Comparison")
        }
    }
}


// MARK: - SwiftUI Implementation

struct SwiftUIScreen: View {

    @State private var studentName = ""
    @State private var result = "Your result will appear here"

    var body: some View {

        VStack(spacing: 20) {

            Text("Student Greeting App")
                .font(.largeTitle)
                .bold()

            TextField("Enter your name", text: $studentName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            Button("Submit") {

                if studentName.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ).isEmpty {

                    result = "Please enter your name"

                } else {

                    result = "Welcome, \(studentName)!"
                }
            }
            .buttonStyle(.borderedProminent)

            Text(result)
                .font(.headline)
                .foregroundColor(.blue)
        }
        .padding()
    }
}


// MARK: - UIKit Implementation

class UIKitScreen: UIViewController {

    let titleLabel = UILabel()
    let nameTextField = UITextField()
    let submitButton = UIButton(type: .system)
    let resultLabel = UILabel()

    override func viewDidLoad() {

        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        setupUI()
    }

    func setupUI() {

        titleLabel.text = "Student Greeting App"
        titleLabel.font = .boldSystemFont(ofSize: 26)
        titleLabel.textAlignment = .center

        nameTextField.placeholder = "Enter your name"
        nameTextField.borderStyle = .roundedRect

        submitButton.setTitle("Submit", for: .normal)
        submitButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        submitButton.backgroundColor = .systemBlue
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 8

        resultLabel.text = "Your result will appear here"
        resultLabel.textAlignment = .center
        resultLabel.font = .systemFont(ofSize: 18)
        resultLabel.textColor = .systemBlue
        resultLabel.numberOfLines = 0

        let elements = [
            titleLabel,
            nameTextField,
            submitButton,
            resultLabel
        ]

        elements.forEach {

            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([

            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 100
            ),

            titleLabel.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),

            nameTextField.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 30
            ),

            nameTextField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 30
            ),

            nameTextField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -30
            ),

            submitButton.topAnchor.constraint(
                equalTo: nameTextField.bottomAnchor,
                constant: 25
            ),

            submitButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),

            submitButton.widthAnchor.constraint(
                equalToConstant: 120
            ),

            submitButton.heightAnchor.constraint(
                equalToConstant: 45
            ),

            resultLabel.topAnchor.constraint(
                equalTo: submitButton.bottomAnchor,
                constant: 25
            ),

            resultLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),

            resultLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            )
        ])

        submitButton.addTarget(
            self,
            action: #selector(submitAction),
            for: .touchUpInside
        )
    }

    @objc func submitAction() {

        let name = nameTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if name.isEmpty {

            resultLabel.text = "Please enter your name"

        } else {

            resultLabel.text = "Welcome, \(name)!"
        }
    }
}


// MARK: - UIKit and SwiftUI Integration

struct UIKitScreenRepresentable: UIViewControllerRepresentable {

    func makeUIViewController(
        context: Context
    ) -> UIKitScreen {

        return UIKitScreen()
    }

    func updateUIViewController(
        _ uiViewController: UIKitScreen,
        context: Context
    ) {
        // No update required
    }
}


// MARK: - SwiftUI Inside UIKit (Optional)

class SwiftUIInUIKitViewController: UIViewController {

    override func viewDidLoad() {

        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        let swiftUIView = SwiftUIScreen()

        let hostingController = UIHostingController(
            rootView: swiftUIView
        )

        addChild(hostingController)

        view.addSubview(hostingController.view)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            hostingController.view.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),

            hostingController.view.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),

            hostingController.view.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),

            hostingController.view.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])

        hostingController.didMove(toParent: self)
    }
}
