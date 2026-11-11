
import SwiftUI

// MARK: - MODEL

struct CourseDetail: Identifiable, Sendable {
    let id: Int
    let name: String
    let duration: Double
}

struct FetchResult: Sendable {
    let id: Int
    let detail: CourseDetail?
    let error: String?
}

// MARK: - VIEW MODEL

@MainActor
class CourseViewModel: ObservableObject {

    @Published var courses: [CourseDetail] = []
    @Published var output = "Choose an operation"
    @Published var elapsedTime = 0.0
    @Published var isLoading = false

    private var currentTask: Task<Void, Never>?

    let courseIDs = [101, 102, 103, 104, 105]

    // MARK: - FETCH ONE COURSE

    nonisolated static func fetchCourse(
        id: Int
    ) async throws -> CourseDetail {

        let delay = [1.0, 1.4, 0.8, 1.2, 1.1][(id - 101)]

        print("Fetching course \(id)")

        try await Task.sleep(
            nanoseconds: UInt64(delay * 1_000_000_000)
        )

        try Task.checkCancellation()

        // Simulate one request failing
        if id == 103 {
            throw URLError(.badServerResponse)
        }

        return CourseDetail(
            id: id,
            name: "Course \(id)",
            duration: delay
        )
    }

    // MARK: - SEQUENTIAL EXECUTION

    func runSequential() {

        currentTask?.cancel()

        currentTask = Task {

            isLoading = true
            courses = []
            output = "Running sequential requests..."
            let start = DispatchTime.now().uptimeNanoseconds

            var results: [CourseDetail] = []
            var errors: [String] = []

            for id in courseIDs {

                if Task.isCancelled { break }

                do {
                    let course = try await Self.fetchCourse(id: id)
                    results.append(course)
                } catch is CancellationError {
                    break
                } catch {
                    errors.append("Course \(id): Failed")
                }
            }

            let end = DispatchTime.now().uptimeNanoseconds
            elapsedTime = Double(end - start) / 1_000_000_000

            courses = results

            if Task.isCancelled {
                output = "Sequential operation cancelled"
            } else {
                output = """
                Sequential Completed
                Successful: \(results.count)
                Failed: \(errors.count)
                \(errors.joined(separator: "\n"))
                """
            }

            isLoading = false
            currentTask = nil
        }
    }

    // MARK: - CONCURRENT EXECUTION

    func runConcurrent() {

        currentTask?.cancel()

        currentTask = Task {

            isLoading = true
            courses = []
            output = "Running concurrent requests..."

            let start = DispatchTime.now().uptimeNanoseconds

            let results = await withTaskGroup(
                of: FetchResult.self
            ) { group in

                // Launch independent child tasks
                for id in courseIDs {
                    group.addTask {
                        do {
                            let course = try await Self.fetchCourse(id: id)

                            return FetchResult(
                                id: id,
                                detail: course,
                                error: nil
                            )

                        } catch is CancellationError {

                            return FetchResult(
                                id: id,
                                detail: nil,
                                error: "Cancelled"
                            )

                        } catch {

                            return FetchResult(
                                id: id,
                                detail: nil,
                                error: "Failed"
                            )
                        }
                    }
                }

                // Collect results as tasks finish
                var collected: [FetchResult] = []

                for await result in group {
                    collected.append(result)
                }

                return collected
            }

            let end = DispatchTime.now().uptimeNanoseconds
            elapsedTime = Double(end - start) / 1_000_000_000

            courses = results.compactMap { $0.detail }
                .sorted { $0.id < $1.id }

            let failures = results.filter { $0.error == "Failed" }.count

            if Task.isCancelled {
                output = "Concurrent operation cancelled"
            } else {
                output = """
                Concurrent Completed
                Successful: \(courses.count)
                Failed: \(failures)
                Policy: Partial results retained
                """
            }

            isLoading = false
            currentTask = nil
        }
    }

    // MARK: - CANCELLATION

    func cancelOperation() {
        currentTask?.cancel()
        output = "Cancellation requested..."
    }
}

// MARK: - MAIN VIEW

struct ContentView: View {

    @StateObject private var viewModel = CourseViewModel()

    var body: some View {

        VStack(spacing: 18) {

            Text("Task Groups Demo")
                .font(.largeTitle.bold())

            Image(systemName: "arrow.trianglehead.branch")
                .font(.system(size: 60))
                .foregroundColor(.blue)

            Text("Sequential vs Concurrent")
                .font(.headline)

            HStack(spacing: 12) {

                Button("Sequential") {
                    viewModel.runSequential()
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isLoading)

                Button("Concurrent") {
                    viewModel.runConcurrent()
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isLoading)
            }

            Button("Cancel Operation") {
                viewModel.cancelOperation()
            }
            .buttonStyle(.bordered)
            .disabled(!viewModel.isLoading)

            if viewModel.isLoading {
                ProgressView("Processing courses...")
            }

            Text(viewModel.output)
                .font(.subheadline)
                .multilineTextAlignment(.center)

            Text(
                String(
                    format: "Execution Time: %.2f seconds",
                    viewModel.elapsedTime
                )
            )
            .font(.headline)
            .foregroundColor(.green)

            List(viewModel.courses) { course in
                HStack {
                    Text(course.name)
                    Spacer()
                    Text("#\(course.id)")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
    }
}

// MARK: - APP

@main
struct Lab5CApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
