
import SwiftUI

// MARK: - MODEL

struct Course: Identifiable {
    let id = UUID()
    let name: String
}

// MARK: - VIEW MODEL

@MainActor
class CourseViewModel: ObservableObject {

    @Published var courses: [Course] = []
    @Published var status = "Press Fetch to load courses"
    @Published var isLoading = false
    @Published var isEmpty = false
    @Published var errorMessage: String?

    private var fetchTask: Task<Void, Never>?

    // Async function to fetch courses
    func fetchCourses(shouldFail: Bool = false,
                      shouldReturnEmpty: Bool = false) async throws -> [Course] {

        try Task.checkCancellation()

        // Simulate network delay
        try await Task.sleep(for: .seconds(3))

        try Task.checkCancellation()

        if shouldFail {
            throw URLError(.badServerResponse)
        }

        if shouldReturnEmpty {
            return []
        }

        return [
            Course(name: "Swift Programming"),
            Course(name: "iOS Development"),
            Course(name: "Data Structures"),
            Course(name: "Machine Learning")
        ]
    }

    // MARK: - START TASK

    func loadCourses(fail: Bool = false,
                     empty: Bool = false) {

        fetchTask?.cancel()

        fetchTask = Task {
            isLoading = true
            isEmpty = false
            errorMessage = nil
            courses = []
            status = "Loading courses..."

            do {
                let result = try await fetchCourses(
                    shouldFail: fail,
                    shouldReturnEmpty: empty
                )

                try Task.checkCancellation()

                courses = result
                isEmpty = result.isEmpty

                status = result.isEmpty
                    ? "No courses available"
                    : "Courses loaded successfully!"

            } catch is CancellationError {
                status = "Operation cancelled"
                print("Task Cancelled")

            } catch {
                errorMessage = error.localizedDescription
                status = "Failed to load courses"
            }

            isLoading = false
            fetchTask = nil
        }
    }

    // MARK: - CANCEL

    func cancelTask() {
        fetchTask?.cancel()
    }
}

// MARK: - MAIN VIEW

struct ContentView: View {

    @StateObject private var viewModel = CourseViewModel()

    var body: some View {

        VStack(spacing: 20) {

            Text("Async/Await Demo")
                .font(.largeTitle.bold())

            Image(systemName: "cloud.download")
                .font(.system(size: 65))
                .foregroundColor(.blue)

            Text(viewModel.status)
                .font(.headline)
                .multilineTextAlignment(.center)

            if viewModel.isLoading {
                ProgressView("Fetching courses...")
            }

            if viewModel.isEmpty {
                Text("No courses found!")
                    .foregroundColor(.orange)
            }

            if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }

            List(viewModel.courses) { course in
                HStack {
                    Image(systemName: "book.fill")
                        .foregroundColor(.blue)

                    Text(course.name)
                }
            }
            .listStyle(.plain)

            VStack(spacing: 12) {

                Button("Fetch Courses") {
                    viewModel.loadCourses()
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isLoading)

                Button("Test Empty State") {
                    viewModel.loadCourses(empty: true)
                }
                .buttonStyle(.bordered)
                .disabled(viewModel.isLoading)

                Button("Test Failure") {
                    viewModel.loadCourses(fail: true)
                }
                .buttonStyle(.bordered)
                .disabled(viewModel.isLoading)

                Button("Cancel Operation") {
                    viewModel.cancelTask()
                }
                .buttonStyle(.bordered)
                .disabled(!viewModel.isLoading)

                Button("Retry") {
                    viewModel.loadCourses()
                }
                .foregroundColor(.green)
                .disabled(viewModel.isLoading)
            }
        }
        .padding()
    }
}

// MARK: - APP

@main
struct Lab5BApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
