
import UIKit

class ViewController: UIViewController {

    let titleLabel = UILabel()
    let resultLabel = UILabel()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    let startButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        setupUI()
        print("Main Thread:", Thread.isMainThread)
        print("App Loaded")
    }

    // MARK: - UI SETUP

    func setupUI() {

        titleLabel.text = "GCD and Queues Demo"
        titleLabel.font = .boldSystemFont(ofSize: 25)
        titleLabel.textAlignment = .center

        resultLabel.text = "Press Start to begin"
        resultLabel.textAlignment = .center
        resultLabel.font = .systemFont(ofSize: 18)
        resultLabel.numberOfLines = 0

        activityIndicator.hidesWhenStopped = true

        startButton.setTitle("Start Operation", for: .normal)
        startButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        startButton.addTarget(
            self,
            action: #selector(startOperation),
            for: .touchUpInside
        )

        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            resultLabel,
            activityIndicator,
            startButton
        ])

        stack.axis = .vertical
        stack.spacing = 30
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(
                greaterThanOrEqualTo: view.leadingAnchor,
                constant: 20
            ),
            stack.trailingAnchor.constraint(
                lessThanOrEqualTo: view.trailingAnchor,
                constant: -20
            )
        ])
    }

    // MARK: - START OPERATION

    @objc func startOperation() {

        startButton.isEnabled = false
        resultLabel.text = "Loading..."
        activityIndicator.startAnimating()

        print("Operation Started - Main:",
              Thread.isMainThread)

        // Background queue
        DispatchQueue.global(qos: .userInitiated).async {

            print("Background Work - Main:",
                  Thread.isMainThread)

            // Simulate slow operation
            Thread.sleep(forTimeInterval: 3)

            let result = "Operation Completed Successfully!"

            // Simulate delayed response
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 1
            ) {

                print("UI Update - Main:",
                      Thread.isMainThread)

                self.resultLabel.text = result
                self.activityIndicator.stopAnimating()
                self.startButton.isEnabled = true

                print("Operation Finished")
            }
        }
    }
}
