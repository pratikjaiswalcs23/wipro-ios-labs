
import UIKit

// MARK: - Student Model

struct Student {
    let name: String
    let rollNumber: String
    let course: String
    let email: String
    let year: String

    static let sampleStudents = [
        Student(
            name: "Pratik Jaiswal",
            rollNumber: "101",
            course: "B.Tech Computer Science",
            email: "pratik@example.com",
            year: "3rd Year"
        ),
        Student(
            name: "Rahul Sharma",
            rollNumber: "102",
            course: "B.Tech Information Technology",
            email: "rahul@example.com",
            year: "2nd Year"
        ),
        Student(
            name: "Aman Verma",
            rollNumber: "103",
            course: "B.Tech Computer Science",
            email: "aman@example.com",
            year: "3rd Year"
        ),
        Student(
            name: "Priya Singh",
            rollNumber: "104",
            course: "BCA",
            email: "priya@example.com",
            year: "1st Year"
        )
    ]
}

// MARK: - Custom Table View Cell

class StudentCell: UITableViewCell {

    static let identifier = "StudentCell"

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        accessoryType = .disclosureIndicator
        textLabel?.font = .boldSystemFont(ofSize: 17)
        detailTextLabel?.font = .systemFont(ofSize: 14)
        detailTextLabel?.textColor = .secondaryLabel

        accessibilityHint = "Double tap to view student details"
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure(with student: Student) {
        textLabel?.text = student.name
        detailTextLabel?.text =
            "\(student.course) • Roll No: \(student.rollNumber)"
    }
}

// MARK: - Screen 1: Student List

class StudentListViewController:
    UIViewController,
    UITableViewDataSource,
    UITableViewDelegate {

    private let students = Student.sampleStudents

    private let tableView = UITableView(
        frame: .zero,
        style: .insetGrouped
    )

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No students available"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Student Directory"
        view.backgroundColor = .systemBackground

        setupTableView()
    }

    private func setupTableView() {

        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(
            StudentCell.self,
            forCellReuseIdentifier: StudentCell.identifier
        )

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70

        tableView.backgroundView = emptyLabel
        emptyLabel.isHidden = !students.isEmpty

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
                equalTo: view.bottomAnchor
            )
        ])
    }

    // Number of rows

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return students.count
    }

    // Display student data

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StudentCell.identifier,
            for: indexPath
        ) as? StudentCell else {
            return UITableViewCell()
        }

        let student = students[indexPath.row]
        cell.configure(with: student)

        return cell
    }

    // Navigate to detail screen

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

        tableView.deselectRow(at: indexPath, animated: true)

        guard students.indices.contains(indexPath.row) else {
            return
        }

        let selectedStudent = students[indexPath.row]

        let detailVC = StudentDetailViewController(
            student: selectedStudent
        )

        navigationController?.pushViewController(
            detailVC,
            animated: true
        )
    }
}

// MARK: - Screen 2: Student Details

class StudentDetailViewController: UIViewController {

    private let student: Student

    init(student: Student) {
        self.student = student
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    private let nameLabel = UILabel()
    private let rollLabel = UILabel()
    private let courseLabel = UILabel()
    private let emailLabel = UILabel()
    private let yearLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Student Details"
        view.backgroundColor = .systemBackground

        setupLabels()
        setupLayout()
        displayStudentDetails()
    }

    // Configure labels

    private func setupLabels() {

        nameLabel.font = .boldSystemFont(ofSize: 26)
        nameLabel.textColor = .systemBlue
        nameLabel.numberOfLines = 0

        let labels = [
            rollLabel,
            courseLabel,
            emailLabel,
            yearLabel
        ]

        for label in labels {
            label.font = .systemFont(ofSize: 17)
            label.numberOfLines = 0
            label.textColor = .label
        }
    }

    // Display selected student

    private func displayStudentDetails() {

        nameLabel.text = "👤 \(student.name)"
        rollLabel.text = "Roll Number: \(student.rollNumber)"
        courseLabel.text = "Course: \(student.course)"
        emailLabel.text = "Email: \(student.email)"
        yearLabel.text = "Academic Year: \(student.year)"
    }

    // Auto Layout

    private func setupLayout() {

        let stackView = UIStackView(
            arrangedSubviews: [
                nameLabel,
                rollLabel,
                courseLabel,
                emailLabel,
                yearLabel
            ]
        )

        stackView.axis = .vertical
        stackView.spacing = 25
        stackView.alignment = .fill
        stackView.distribution = .fill

        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([

            stackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 40
            ),

            stackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 25
            ),

            stackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -25
            )
        ])
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

        let listVC = StudentListViewController()

        let navigationController = UINavigationController(
            rootViewController: listVC
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
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {

        let configuration = UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )

        configuration.delegateClass = SceneDelegate.self

        return configuration
    }
}
