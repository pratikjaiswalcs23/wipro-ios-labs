
import SwiftUI
import XCTest

// MARK: - Grade Calculator

struct GradeCalculator {

    func calculateGrade(marks: Double) -> String {
        guard (0...100).contains(marks) else {
            return "Invalid"
        }

        switch marks {
        case 90...100: return "A"
        case 80..<90: return "B"
        case 70..<80: return "C"
        case 60..<70: return "D"
        default: return "F"
        }
    }

    func calculatePercentage(obtained: Double, total: Double) -> Double? {
        guard total > 0,
              obtained >= 0,
              obtained <= total else {
            return nil
        }

        return (obtained / total) * 100
    }
}

// MARK: - Form Validation

struct FormValidator {

    func isValidName(_ name: String) -> Bool {
        name.trimmingCharacters(in: .whitespacesAndNewlines).count >= 2
    }

    func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }

    func isValidForm(name: String, email: String) -> Bool {
        isValidName(name) && isValidEmail(email)
    }
}

// MARK: - Course Model

struct Course: Identifiable, Equatable {
    let id: Int
    let name: String
}

// MARK: - Service Protocol

protocol CourseService {
    func fetchCourses() async throws -> [Course]
}

// MARK: - Fake Service

struct FakeCourseService: CourseService {
    let courses: [Course]

    func fetchCourses() async throws -> [Course] {
        courses
    }
}

// MARK: - View Model

@MainActor
final class CourseViewModel: ObservableObject {

    @Published private(set) var courses: [Course] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let service: CourseService

    init(service: CourseService) {
        self.service = service
    }

    func loadCourses() async {
        isLoading = true
        errorMessage = nil

        do {
            courses = try await service.fetchCourses()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func addCourse(_ course: Course) {
        guard !courses.contains(where: { $0.id == course.id }) else {
            return
        }

        courses.append(course)
    }
}

// MARK: - Main App UI

struct ContentView: View {

    @State private var marks = "85"
    @State private var name = ""
    @State private var email = ""

    @State private var courses = [
        Course(id: 1, name: "Swift Programming"),
        Course(id: 2, name: "iOS Development")
    ]

    private let calculator = GradeCalculator()
    private let validator = FormValidator()

    var body: some View {
        NavigationStack {
            Form {

                Section("Grade Calculator") {
                    TextField("Enter marks", text: $marks)
                        .keyboardType(.decimalPad)

                    Text("Grade: \(grade)")
                        .font(.headline)

                    if let value = Double(marks),
                       let percentage = calculator.calculatePercentage(
                        obtained: value,
                        total: 100
                       ) {
                        Text("Percentage: \(percentage, specifier: "%.1f")%")
                    }
                }

                Section("Form Validation") {
                    TextField("Enter Name", text: $name)

                    TextField("Enter Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)

                    Text(
                        validator.isValidForm(name: name, email: email)
                        ? "Form is Valid"
                        : "Please enter valid details"
                    )
                    .foregroundStyle(
                        validator.isValidForm(name: name, email: email)
                        ? .green : .red
                    )
                }

                Section("Course List") {
                    ForEach(courses) { course in
                        Text(course.name)
                    }

                    Button("Add New Course") {
                        let newCourse = Course(
                            id: (courses.map(\.id).max() ?? 0) + 1,
                            name: "New Swift Course"
                        )

                        courses.append(newCourse)
                    }
                }
            }
            .navigationTitle("Lab 10A - XCTest")
        }
    }

    private var grade: String {
        guard let value = Double(marks) else {
            return "Invalid"
        }

        return calculator.calculateGrade(marks: value)
    }
}

// MARK: - XCTest Unit Tests
// Keep these tests in the separate XCTest target file.
// This section is included here for reference only.

final class GradeCalculatorTests: XCTestCase {

    let calculator = GradeCalculator()

    func testGradeA() {
        XCTAssertEqual(calculator.calculateGrade(marks: 95), "A")
    }

    func testGradeB() {
        XCTAssertEqual(calculator.calculateGrade(marks: 85), "B")
    }

    func testGradeC() {
        XCTAssertEqual(calculator.calculateGrade(marks: 75), "C")
    }

    func testGradeD() {
        XCTAssertEqual(calculator.calculateGrade(marks: 65), "D")
    }

    func testGradeF() {
        XCTAssertEqual(calculator.calculateGrade(marks: 35), "F")
    }

    func testZeroMarks() {
        XCTAssertEqual(calculator.calculateGrade(marks: 0), "F")
    }

    func testMaximumMarks() {
        XCTAssertEqual(calculator.calculateGrade(marks: 100), "A")
    }

    func testInvalidMarks() {
        XCTAssertEqual(calculator.calculateGrade(marks: 110), "Invalid")
    }
}

final class FormValidatorTests: XCTestCase {

    let validator = FormValidator()

    func testValidName() {
        XCTAssertTrue(validator.isValidName("Pratik"))
    }

    func testInvalidName() {
        XCTAssertFalse(validator.isValidName("A"))
    }

    func testValidEmail() {
        XCTAssertTrue(validator.isValidEmail("test@example.com"))
    }

    func testInvalidEmail() {
        XCTAssertFalse(validator.isValidEmail("wrong-email"))
    }

    func testValidForm() {
        XCTAssertTrue(validator.isValidForm(
            name: "Pratik",
            email: "pratik@example.com"
        ))
    }
}

final class CourseViewModelTests: XCTestCase {

    @MainActor
    func testAddCourse() async {
        let service = FakeCourseService(courses: [])
        let viewModel = CourseViewModel(service: service)

        viewModel.addCourse(Course(id: 1, name: "Swift"))

        XCTAssertEqual(viewModel.courses.count, 1)
    }

    @MainActor
    func testDuplicateCourseNotAdded() async {
        let service = FakeCourseService(courses: [])
        let viewModel = CourseViewModel(service: service)

        let course = Course(id: 1, name: "Swift")

        viewModel.addCourse(course)
        viewModel.addCourse(course)

        XCTAssertEqual(viewModel.courses.count, 1)
    }

    @MainActor
    func testAsyncFakeService() async {
        let sample = [
            Course(id: 1, name: "Swift"),
            Course(id: 2, name: "iOS")
        ]

        let service = FakeCourseService(courses: sample)
        let viewModel = CourseViewModel(service: service)

        await viewModel.loadCourses()

        XCTAssertEqual(viewModel.courses.count, 2)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
}
